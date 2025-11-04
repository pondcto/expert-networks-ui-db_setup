"""
Campaign API endpoints.

Campaigns represent expert research projects with specific goals, target experts,
and vendor enrollments. All operations require authentication and are scoped to the user.
"""

from typing import List
from fastapi import APIRouter, HTTPException, Depends
from auth.better_auth import get_current_user, User
from models.campaign import (
    CampaignCreate,
    CampaignUpdate,
    CampaignResponse,
    CampaignListResponse,
    VendorEnrollmentCreate,
    VendorEnrollmentResponse,
)
from models.common import SuccessResponse, ErrorResponse
from db import (
    get_campaign,
    get_user_campaigns,
    insert_and_return,
    update_and_return,
    enroll_vendor,
    execute_query,
    get_db,
)

router = APIRouter(prefix="/api/campaigns", tags=["Campaigns"])


@router.get(
    "",
    response_model=CampaignListResponse,
    summary="List user's campaigns",
    description="Get all campaigns for the authenticated user with aggregated counts."
)
async def list_campaigns(user: User = Depends(get_current_user)):
    """
    List all campaigns for the authenticated user.

    Returns campaigns with expert counts, interview counts, and vendor enrollment
    counts, sorted by display order and creation date.
    """
    try:
        campaigns = await execute_query(
            """
            SELECT
                c.*,
                p.project_name,
                p.project_code,
                COUNT(DISTINCT e.id) as expert_count,
                COUNT(DISTINCT i.id) as interview_count,
                COUNT(DISTINCT cve.id) as vendor_enrollment_count
            FROM expert_network.campaigns c
            LEFT JOIN expert_network.projects p ON c.project_id = p.id
            LEFT JOIN expert_network.experts e ON c.id = e.campaign_id
            LEFT JOIN expert_network.interviews i ON c.id = i.campaign_id
            LEFT JOIN expert_network.campaign_vendor_enrollments cve ON c.id = cve.campaign_id
            WHERE c.user_id = $1
            GROUP BY c.id, p.project_name, p.project_code
            ORDER BY c.display_order, c.created_at DESC
            """,
            user.user_id,
            fetch_all=True
        )

        return CampaignListResponse(campaigns=campaigns, total=len(campaigns))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch campaigns: {str(e)}")


@router.get(
    "/{campaign_id}",
    response_model=CampaignResponse,
    summary="Get campaign details",
    description="Get detailed information about a specific campaign.",
    responses={404: {"description": "Campaign not found", "model": ErrorResponse}}
)
async def get_campaign_detail(campaign_id: str, user: User = Depends(get_current_user)):
    """
    Get details for a specific campaign.

    Args:
        campaign_id: UUID of the campaign

    Returns:
        Campaign details with aggregated counts

    Raises:
        404: Campaign not found or not owned by user
    """
    try:
        campaign = await execute_query(
            """
            SELECT
                c.*,
                p.project_name,
                p.project_code,
                COUNT(DISTINCT e.id) as expert_count,
                COUNT(DISTINCT i.id) as interview_count,
                COUNT(DISTINCT cve.id) as vendor_enrollment_count
            FROM expert_network.campaigns c
            LEFT JOIN expert_network.projects p ON c.project_id = p.id
            LEFT JOIN expert_network.experts e ON c.id = e.campaign_id
            LEFT JOIN expert_network.interviews i ON c.id = i.campaign_id
            LEFT JOIN expert_network.campaign_vendor_enrollments cve ON c.id = cve.campaign_id
            WHERE c.id = $1 AND c.user_id = $2
            GROUP BY c.id, p.project_name, p.project_code
            """,
            campaign_id,
            user.user_id,
            fetch_one=True
        )

        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")

        return campaign
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch campaign: {str(e)}")


@router.post(
    "",
    response_model=CampaignResponse,
    status_code=201,
    summary="Create a new campaign",
    description="Create a new campaign for expert research."
)
async def create_campaign(
    campaign_data: CampaignCreate,
    user: User = Depends(get_current_user)
):
    """
    Create a new campaign.

    Args:
        campaign_data: Campaign creation data

    Returns:
        Created campaign details

    Raises:
        400: Invalid campaign data
        404: Project not found (if project_id provided)
    """
    try:
        # Verify project exists if project_id provided
        if campaign_data.project_id:
            project = await execute_query(
                "SELECT id FROM expert_network.projects WHERE id = $1 AND user_id = $2",
                campaign_data.project_id,
                user.user_id,
                fetch_one=True
            )
            if not project:
                raise HTTPException(status_code=404, detail="Project not found")

        # Get current max display order
        max_order = await execute_query(
            "SELECT COALESCE(MAX(display_order), 0) as max_order FROM expert_network.campaigns WHERE user_id = $1",
            user.user_id,
            fetch_one=True
        )

        # Create campaign
        campaign = await insert_and_return(
            "campaigns",
            {
                "user_id": user.user_id,
                "project_id": campaign_data.project_id,
                "campaign_name": campaign_data.campaign_name,
                "industry_vertical": campaign_data.industry_vertical,
                "brief_description": campaign_data.brief_description,
                "start_date": campaign_data.start_date,
                "target_completion_date": campaign_data.target_completion_date,
                "target_regions": campaign_data.target_regions,
                "min_calls": campaign_data.min_calls,
                "max_calls": campaign_data.max_calls,
                "display_order": max_order["max_order"] + 1
            }
        )

        # Add zero counts for new campaign
        campaign["expert_count"] = 0
        campaign["interview_count"] = 0
        campaign["vendor_enrollment_count"] = 0
        campaign["project_name"] = None
        campaign["project_code"] = None

        return campaign
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to create campaign: {str(e)}")


@router.patch(
    "/{campaign_id}",
    response_model=CampaignResponse,
    summary="Update a campaign",
    description="Update an existing campaign's details.",
    responses={404: {"description": "Campaign not found", "model": ErrorResponse}}
)
async def update_campaign(
    campaign_id: str,
    campaign_data: CampaignUpdate,
    user: User = Depends(get_current_user)
):
    """
    Update a campaign.

    Args:
        campaign_id: UUID of the campaign to update
        campaign_data: Fields to update (all optional)

    Returns:
        Updated campaign details

    Raises:
        404: Campaign not found or not owned by user
        400: Invalid update data
    """
    try:
        # Build update dict from non-None fields
        update_fields = {
            k: v for k, v in campaign_data.model_dump(exclude_unset=True).items()
            if v is not None
        }

        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")

        # Verify project exists if project_id provided
        if "project_id" in update_fields and update_fields["project_id"]:
            project = await execute_query(
                "SELECT id FROM expert_network.projects WHERE id = $1 AND user_id = $2",
                update_fields["project_id"],
                user.user_id,
                fetch_one=True
            )
            if not project:
                raise HTTPException(status_code=404, detail="Project not found")

        # Update campaign
        updated = await update_and_return(
            "campaigns",
            update_fields,
            where="id = $1 AND user_id = $2",
            where_params=[campaign_id, user.user_id]
        )

        if not updated:
            raise HTTPException(status_code=404, detail="Campaign not found")

        # Fetch with aggregated counts
        campaign = await get_campaign_detail(campaign_id, user)
        return campaign
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to update campaign: {str(e)}")


@router.delete(
    "/{campaign_id}",
    response_model=SuccessResponse,
    summary="Delete a campaign",
    description="Delete a campaign and all associated data (experts, interviews, etc.).",
    responses={404: {"description": "Campaign not found", "model": ErrorResponse}}
)
async def delete_campaign(campaign_id: str, user: User = Depends(get_current_user)):
    """
    Delete a campaign.

    This cascades to delete all associated experts, interviews, vendor enrollments,
    screening responses, etc. This operation cannot be undone.

    Args:
        campaign_id: UUID of the campaign to delete

    Returns:
        Success message

    Raises:
        404: Campaign not found or not owned by user
    """
    try:
        async with get_db() as conn:
            async with conn.transaction():
                # Verify campaign exists and belongs to user
                campaign = await conn.fetchrow(
                    "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
                    campaign_id,
                    user.user_id
                )

                if not campaign:
                    raise HTTPException(status_code=404, detail="Campaign not found")

                # Delete campaign (cascades to related tables via FK constraints)
                await conn.execute(
                    "DELETE FROM expert_network.campaigns WHERE id = $1",
                    campaign_id
                )

        return SuccessResponse(
            success=True,
            message="Campaign deleted successfully"
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete campaign: {str(e)}")


# ============================================================================
# Vendor Enrollment Endpoints
# ============================================================================

@router.get(
    "/{campaign_id}/vendors",
    response_model=List[VendorEnrollmentResponse],
    summary="List enrolled vendors for campaign",
    description="Get all vendor platforms enrolled in a specific campaign."
)
async def list_campaign_vendors(campaign_id: str, user: User = Depends(get_current_user)):
    """
    List all vendor enrollments for a campaign.

    Returns vendor enrollments with aggregated expert and interview counts.

    Args:
        campaign_id: UUID of the campaign

    Returns:
        List of vendor enrollments

    Raises:
        404: Campaign not found or not owned by user
    """
    try:
        # Verify campaign ownership
        campaign = await get_campaign(campaign_id, user.user_id)
        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")

        # Get vendor enrollments with counts
        enrollments = await execute_query(
            """
            SELECT
                cve.*,
                vp.name as vendor_name,
                vp.logo_url as vendor_logo_url,
                COUNT(DISTINCT CASE WHEN e.status = 'proposed' THEN e.id END) as experts_proposed_count,
                COUNT(DISTINCT CASE WHEN e.status IN ('reviewed', 'approved') THEN e.id END) as experts_reviewed_count,
                COUNT(DISTINCT i.id) as interviews_scheduled_count
            FROM expert_network.campaign_vendor_enrollments cve
            JOIN expert_network.vendor_platforms vp ON cve.vendor_platform_id = vp.id
            LEFT JOIN expert_network.experts e ON cve.campaign_id = e.campaign_id AND cve.vendor_platform_id = e.vendor_platform_id
            LEFT JOIN expert_network.interviews i ON e.id = i.expert_id
            WHERE cve.campaign_id = $1
            GROUP BY cve.id, vp.name, vp.logo_url
            ORDER BY cve.created_at ASC
            """,
            campaign_id,
            fetch_all=True
        )

        return enrollments
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch vendor enrollments: {str(e)}")


@router.post(
    "/{campaign_id}/vendors",
    response_model=VendorEnrollmentResponse,
    status_code=201,
    summary="Enroll a vendor in campaign",
    description="Add a vendor platform to a campaign to start receiving expert proposals."
)
async def enroll_campaign_vendor(
    campaign_id: str,
    enrollment_data: VendorEnrollmentCreate,
    user: User = Depends(get_current_user)
):
    """
    Enroll a vendor platform in a campaign.

    This allows the vendor to start proposing experts for the campaign.

    Args:
        campaign_id: UUID of the campaign
        enrollment_data: Vendor enrollment data

    Returns:
        Created vendor enrollment

    Raises:
        404: Campaign or vendor not found
        409: Vendor already enrolled
    """
    try:
        # Use helper function to enroll vendor (verifies campaign ownership)
        enrollment = await enroll_vendor(campaign_id, enrollment_data.vendor_platform_id, user.user_id)

        if not enrollment:
            raise HTTPException(status_code=404, detail="Campaign not found")

        # Get vendor details
        vendor = await execute_query(
            "SELECT name, logo_url FROM expert_network.vendor_platforms WHERE id = $1",
            enrollment_data.vendor_platform_id,
            fetch_one=True
        )

        enrollment["vendor_name"] = vendor["name"] if vendor else None
        enrollment["vendor_logo_url"] = vendor["logo_url"] if vendor else None
        enrollment["experts_proposed_count"] = 0
        enrollment["experts_reviewed_count"] = 0
        enrollment["interviews_scheduled_count"] = 0

        return enrollment
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to enroll vendor: {str(e)}")


@router.delete(
    "/{campaign_id}/vendors/{vendor_id}",
    response_model=SuccessResponse,
    summary="Remove vendor from campaign",
    description="Remove a vendor platform from a campaign (also removes their proposed experts).",
    responses={404: {"description": "Campaign or enrollment not found", "model": ErrorResponse}}
)
async def unenroll_campaign_vendor(
    campaign_id: str,
    vendor_id: str,
    user: User = Depends(get_current_user)
):
    """
    Remove a vendor enrollment from a campaign.

    This will also remove all experts proposed by this vendor for this campaign.

    Args:
        campaign_id: UUID of the campaign
        vendor_id: UUID of the vendor platform to remove

    Returns:
        Success message

    Raises:
        404: Campaign or enrollment not found
    """
    try:
        async with get_db() as conn:
            async with conn.transaction():
                # Verify campaign ownership
                campaign = await conn.fetchrow(
                    "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
                    campaign_id,
                    user.user_id
                )

                if not campaign:
                    raise HTTPException(status_code=404, detail="Campaign not found")

                # Delete enrollment
                result = await conn.execute(
                    "DELETE FROM expert_network.campaign_vendor_enrollments WHERE campaign_id = $1 AND vendor_platform_id = $2",
                    campaign_id,
                    vendor_id
                )

                if result == "DELETE 0":
                    raise HTTPException(status_code=404, detail="Vendor enrollment not found")

        return SuccessResponse(
            success=True,
            message="Vendor removed from campaign successfully"
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to remove vendor: {str(e)}")
