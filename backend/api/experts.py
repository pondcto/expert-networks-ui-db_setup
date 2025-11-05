"""
Expert API endpoints.

Experts are individuals proposed by vendor platforms for interview.
Includes expert management, screening, and filtering.
"""

from typing import List, Optional
from fastapi import APIRouter, HTTPException, Depends, Query
from auth.better_auth import get_current_user, User
from models.expert import (
    ExpertCreate,
    ExpertUpdate,
    ExpertResponse,
    ExpertListResponse,
    ScreeningResponseCreate,
    ScreeningResponseResponse,
)
from models.common import SuccessResponse, ErrorResponse
from db import get_campaign_experts, insert_and_return, update_and_return, execute_query, get_db

router = APIRouter(prefix="/api/experts", tags=["Experts"])


@router.get(
    "",
    response_model=ExpertListResponse,
    summary="List experts for campaign",
    description="Get all experts for a specific campaign with optional filtering by status or vendor."
)
async def list_experts(
    campaign_id: str = Query(..., description="Campaign UUID to filter experts"),
    status: Optional[str] = Query(None, description="Filter by expert status"),
    vendor_id: Optional[str] = Query(None, description="Filter by vendor platform ID"),
    user: User = Depends(get_current_user)
):
    """
    List experts for a campaign.

    Returns experts with vendor details and screening response counts.

    Args:
        campaign_id: UUID of the campaign
        status: Optional status filter (proposed, reviewed, approved, rejected, scheduled)
        vendor_id: Optional vendor platform filter

    Returns:
        List of experts

    Raises:
        404: Campaign not found or not owned by user
    """
    try:
        # Verify campaign ownership
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            campaign_id,
            user.user_id,
            fetch_one=True
        )

        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")

        # Build query with optional filters
        where_clauses = ["e.campaign_id = $1"]
        params = [campaign_id]
        param_num = 2

        if status:
            where_clauses.append(f"e.status = ${param_num}")
            params.append(status)
            param_num += 1

        if vendor_id:
            where_clauses.append(f"e.vendor_platform_id = ${param_num}")
            params.append(vendor_id)
            param_num += 1

        where_clause = " AND ".join(where_clauses)

        # Query experts with aggregated data
        # Map database columns (name, title, company) to model fields (expert_name, current_title, current_company)
        experts = await execute_query(
            f"""
            SELECT
                e.id,
                e.campaign_id,
                e.vendor_platform_id,
                e.name as expert_name,
                e.title as current_title,
                e.company as current_company,
                e.avatar_url,
                e.description as bio,
                e.work_history,
                e.skills as expertise_areas,
                e.rating,
                e.ai_fit_score as relevance_score,
                e.status,
                e.is_new,
                e.created_at,
                e.updated_at,
                e.reviewed_at,
                NULL as location,
                NULL as linkedin_url,
                NULL as email,
                NULL as phone,
                NULL as years_experience,
                NULL as hourly_rate,
                NULL as vendor_expert_id,
                NULL as internal_notes,
                v.name as vendor_name,
                v.logo_url as vendor_logo_url,
                COUNT(DISTINCT i.id) as interview_count
            FROM expert_network.experts e
            JOIN expert_network.vendor_platforms v ON e.vendor_platform_id = v.id
            LEFT JOIN expert_network.interviews i ON e.id = i.expert_id
            WHERE {where_clause}
            GROUP BY e.id, e.campaign_id, e.vendor_platform_id, e.name, e.title, e.company, e.avatar_url, 
                     e.description, e.work_history, e.skills, e.rating, e.ai_fit_score, e.status, 
                     e.is_new, e.created_at, e.updated_at, e.reviewed_at, v.name, v.logo_url
            ORDER BY e.created_at DESC
            """,
            *params,
            fetch_all=True
        )

        return ExpertListResponse(experts=experts, total=len(experts))
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch experts: {str(e)}")


@router.get(
    "/{expert_id}",
    response_model=ExpertResponse,
    summary="Get expert details",
    description="Get detailed information about a specific expert including screening responses.",
    responses={404: {"description": "Expert not found", "model": ErrorResponse}}
)
async def get_expert(expert_id: str, user: User = Depends(get_current_user)):
    """
    Get details for a specific expert.

    Includes screening question responses and interview count.

    Args:
        expert_id: UUID of the expert

    Returns:
        Expert details with screening responses

    Raises:
        404: Expert not found or campaign not owned by user
    """
    try:
        # Query expert with campaign ownership check
        # Map database columns (name, title, company) to model fields (expert_name, current_title, current_company)
        expert = await execute_query(
            """
            SELECT
                e.id,
                e.campaign_id,
                e.vendor_platform_id,
                e.name as expert_name,
                e.title as current_title,
                e.company as current_company,
                e.avatar_url,
                e.description as bio,
                e.work_history,
                e.skills as expertise_areas,
                e.rating,
                e.ai_fit_score as relevance_score,
                e.status,
                e.is_new,
                e.created_at,
                e.updated_at,
                e.reviewed_at,
                NULL as location,
                NULL as linkedin_url,
                NULL as email,
                NULL as phone,
                NULL as years_experience,
                NULL as hourly_rate,
                NULL as vendor_expert_id,
                NULL as internal_notes,
                v.name as vendor_name,
                v.logo_url as vendor_logo_url,
                COUNT(DISTINCT i.id) as interview_count
            FROM expert_network.experts e
            JOIN expert_network.vendor_platforms v ON e.vendor_platform_id = v.id
            JOIN expert_network.campaigns c ON e.campaign_id = c.id
            LEFT JOIN expert_network.interviews i ON e.id = i.expert_id
            WHERE e.id = $1 AND c.user_id = $2
            GROUP BY e.id, e.campaign_id, e.vendor_platform_id, e.name, e.title, e.company, e.avatar_url, 
                     e.description, e.work_history, e.skills, e.rating, e.ai_fit_score, e.status, 
                     e.is_new, e.created_at, e.updated_at, e.reviewed_at, v.name, v.logo_url
            """,
            expert_id,
            user.user_id,
            fetch_one=True
        )

        if not expert:
            raise HTTPException(status_code=404, detail="Expert not found")

        # Get screening responses
        responses = await execute_query(
            """
            SELECT
                esr.*,
                sq.question_text
            FROM expert_network.expert_screening_responses esr
            JOIN expert_network.screening_questions sq ON esr.question_id = sq.id
            WHERE esr.expert_id = $1
            ORDER BY esr.created_at ASC
            """,
            expert_id,
            fetch_all=True
        )

        expert["screening_responses"] = responses
        return expert
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch expert: {str(e)}")


@router.post(
    "",
    response_model=ExpertResponse,
    status_code=201,
    summary="Create a new expert",
    description="Add a new expert proposal to a campaign."
)
async def create_expert(
    expert_data: ExpertCreate,
    user: User = Depends(get_current_user)
):
    """
    Create a new expert.

    Typically called by LLM mock backend or when manually adding experts.

    Args:
        expert_data: Expert creation data

    Returns:
        Created expert details

    Raises:
        400: Invalid expert data
        404: Campaign or vendor not found
    """
    try:
        # Verify campaign ownership
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            expert_data.campaign_id,
            user.user_id,
            fetch_one=True
        )

        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")

        # Verify vendor exists
        vendor = await execute_query(
            "SELECT id, name, logo_url FROM expert_network.vendor_platforms WHERE id = $1",
            expert_data.vendor_platform_id,
            fetch_one=True
        )

        if not vendor:
            raise HTTPException(status_code=404, detail="Vendor platform not found")

        # Create expert
        expert = await insert_and_return(
            "experts",
            {
                "campaign_id": expert_data.campaign_id,
                "vendor_platform_id": expert_data.vendor_platform_id,
                "vendor_expert_id": expert_data.vendor_expert_id,
                "expert_name": expert_data.expert_name,
                "current_company": expert_data.current_company,
                "current_title": expert_data.current_title,
                "location": expert_data.location,
                "linkedin_url": expert_data.linkedin_url,
                "email": expert_data.email,
                "phone": expert_data.phone,
                "years_experience": expert_data.years_experience,
                "expertise_areas": expert_data.expertise_areas,
                "bio": expert_data.bio,
                "hourly_rate": expert_data.hourly_rate,
                "status": expert_data.status,
            }
        )

        # Add vendor details
        expert["vendor_name"] = vendor["name"]
        expert["vendor_logo_url"] = vendor["logo_url"]
        expert["interview_count"] = 0
        expert["screening_responses"] = []

        return expert
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to create expert: {str(e)}")


@router.patch(
    "/{expert_id}",
    response_model=ExpertResponse,
    summary="Update an expert",
    description="Update an expert's details or status.",
    responses={404: {"description": "Expert not found", "model": ErrorResponse}}
)
async def update_expert(
    expert_id: str,
    expert_data: ExpertUpdate,
    user: User = Depends(get_current_user)
):
    """
    Update an expert.

    Commonly used to update status (e.g., from 'proposed' to 'approved')
    or add internal notes.

    Args:
        expert_id: UUID of the expert to update
        expert_data: Fields to update (all optional)

    Returns:
        Updated expert details

    Raises:
        404: Expert not found or campaign not owned by user
        400: Invalid update data
    """
    try:
        # Build update dict from non-None fields
        update_fields = {
            k: v for k, v in expert_data.model_dump(exclude_unset=True).items()
            if v is not None
        }

        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")

        # Update expert with campaign ownership check
        async with get_db() as conn:
            async with conn.transaction():
                # Verify campaign ownership
                campaign_check = await conn.fetchrow(
                    """
                    SELECT c.id
                    FROM expert_network.experts e
                    JOIN expert_network.campaigns c ON e.campaign_id = c.id
                    WHERE e.id = $1 AND c.user_id = $2
                    """,
                    expert_id,
                    user.user_id
                )

                if not campaign_check:
                    raise HTTPException(status_code=404, detail="Expert not found")

                # Build SET clause
                set_parts = []
                values = []
                param_num = 1

                for col, val in update_fields.items():
                    set_parts.append(f"{col} = ${param_num}")
                    values.append(val)
                    param_num += 1

                set_clause = ', '.join(set_parts)

                # Update expert
                query = f"""
                    UPDATE expert_network.experts
                    SET {set_clause}, updated_at = NOW()
                    WHERE id = ${param_num}
                    RETURNING *
                """
                values.append(expert_id)

                updated = await conn.fetchrow(query, *values)

                if not updated:
                    raise HTTPException(status_code=404, detail="Expert not found")

        # Fetch full expert details
        return await get_expert(expert_id, user)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to update expert: {str(e)}")


@router.delete(
    "/{expert_id}",
    response_model=SuccessResponse,
    summary="Delete an expert",
    description="Delete an expert proposal (also deletes associated interviews and screening responses).",
    responses={404: {"description": "Expert not found", "model": ErrorResponse}}
)
async def delete_expert(expert_id: str, user: User = Depends(get_current_user)):
    """
    Delete an expert.

    This cascades to delete associated interviews and screening responses.

    Args:
        expert_id: UUID of the expert to delete

    Returns:
        Success message

    Raises:
        404: Expert not found or campaign not owned by user
    """
    try:
        async with get_db() as conn:
            async with conn.transaction():
                # Verify campaign ownership
                expert = await conn.fetchrow(
                    """
                    SELECT e.id
                    FROM expert_network.experts e
                    JOIN expert_network.campaigns c ON e.campaign_id = c.id
                    WHERE e.id = $1 AND c.user_id = $2
                    """,
                    expert_id,
                    user.user_id
                )

                if not expert:
                    raise HTTPException(status_code=404, detail="Expert not found")

                # Delete expert (cascades via FK constraints)
                await conn.execute(
                    "DELETE FROM expert_network.experts WHERE id = $1",
                    expert_id
                )

        return SuccessResponse(
            success=True,
            message="Expert deleted successfully"
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete expert: {str(e)}")


# ============================================================================
# Screening Response Endpoints
# ============================================================================

@router.post(
    "/{expert_id}/screening",
    response_model=ScreeningResponseResponse,
    status_code=201,
    summary="Add screening response",
    description="Record an expert's response to a screening question."
)
async def create_screening_response(
    expert_id: str,
    response_data: ScreeningResponseCreate,
    user: User = Depends(get_current_user)
):
    """
    Add a screening question response for an expert.

    Args:
        expert_id: UUID of the expert
        response_data: Screening response data

    Returns:
        Created screening response

    Raises:
        404: Expert or question not found
        400: Invalid response data
    """
    try:
        # Verify expert exists and campaign ownership
        expert = await execute_query(
            """
            SELECT e.id
            FROM expert_network.experts e
            JOIN expert_network.campaigns c ON e.campaign_id = c.id
            WHERE e.id = $1 AND c.user_id = $2
            """,
            expert_id,
            user.user_id,
            fetch_one=True
        )

        if not expert:
            raise HTTPException(status_code=404, detail="Expert not found")

        # Verify expert_id in request matches path parameter
        if response_data.expert_id != expert_id:
            raise HTTPException(status_code=400, detail="Expert ID mismatch")

        # Verify question exists
        question = await execute_query(
            "SELECT id, question_text FROM expert_network.screening_questions WHERE id = $1",
            response_data.question_id,
            fetch_one=True
        )

        if not question:
            raise HTTPException(status_code=404, detail="Screening question not found")

        # Create response
        response = await insert_and_return(
            "expert_screening_responses",
            {
                "expert_id": expert_id,
                "question_id": response_data.question_id,
                "response_text": response_data.response_text,
                "rating": response_data.rating,
            }
        )

        response["question_text"] = question["question_text"]
        return response
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to create screening response: {str(e)}")


@router.get(
    "/{expert_id}/screening",
    response_model=List[ScreeningResponseResponse],
    summary="Get expert screening responses",
    description="Get all screening question responses for an expert."
)
async def list_expert_screening_responses(
    expert_id: str,
    user: User = Depends(get_current_user)
):
    """
    Get all screening responses for an expert.

    Args:
        expert_id: UUID of the expert

    Returns:
        List of screening responses

    Raises:
        404: Expert not found or campaign not owned by user
    """
    try:
        # Verify expert exists and campaign ownership
        expert = await execute_query(
            """
            SELECT e.id
            FROM expert_network.experts e
            JOIN expert_network.campaigns c ON e.campaign_id = c.id
            WHERE e.id = $1 AND c.user_id = $2
            """,
            expert_id,
            user.user_id,
            fetch_one=True
        )

        if not expert:
            raise HTTPException(status_code=404, detail="Expert not found")

        # Get screening responses
        responses = await execute_query(
            """
            SELECT
                esr.*,
                sq.question_text
            FROM expert_network.expert_screening_responses esr
            JOIN expert_network.screening_questions sq ON esr.question_id = sq.id
            WHERE esr.expert_id = $1
            ORDER BY esr.created_at ASC
            """,
            expert_id,
            fetch_all=True
        )

        return responses
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch screening responses: {str(e)}")
