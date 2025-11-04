"""
Interview API endpoints.

Interviews represent scheduled calls with experts, including notes,
transcripts, and status tracking.
"""

from typing import List, Optional
from fastapi import APIRouter, HTTPException, Depends, Query
from auth.better_auth import get_current_user, User
from models.interview import (
    InterviewCreate,
    InterviewUpdate,
    InterviewResponse,
    InterviewListResponse,
)
from models.common import SuccessResponse, ErrorResponse
from db import insert_and_return, execute_query, get_db

router = APIRouter(prefix="/api/interviews", tags=["Interviews"])


@router.get(
    "",
    response_model=InterviewListResponse,
    summary="List interviews",
    description="Get all interviews for a campaign with optional status filtering."
)
async def list_interviews(
    campaign_id: str = Query(..., description="Campaign UUID to filter interviews"),
    status: Optional[str] = Query(None, description="Filter by interview status"),
    user: User = Depends(get_current_user)
):
    """
    List interviews for a campaign.

    Returns interviews with expert and vendor details.

    Args:
        campaign_id: UUID of the campaign
        status: Optional status filter (scheduled, completed, cancelled, no_show)

    Returns:
        List of interviews

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

        # Build query with optional status filter
        where_clause = "i.campaign_id = $1"
        params = [campaign_id]

        if status:
            where_clause += " AND i.status = $2"
            params.append(status)

        # Query interviews with expert and vendor details
        interviews = await execute_query(
            f"""
            SELECT
                i.*,
                e.expert_name,
                e.current_company as expert_company,
                e.current_title as expert_title,
                e.vendor_platform_id,
                v.name as vendor_name
            FROM expert_network.interviews i
            JOIN expert_network.experts e ON i.expert_id = e.id
            JOIN expert_network.vendor_platforms v ON e.vendor_platform_id = v.id
            WHERE {where_clause}
            ORDER BY i.scheduled_date DESC
            """,
            *params,
            fetch_all=True
        )

        return InterviewListResponse(interviews=interviews, total=len(interviews))
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch interviews: {str(e)}")


@router.get(
    "/{interview_id}",
    response_model=InterviewResponse,
    summary="Get interview details",
    description="Get detailed information about a specific interview.",
    responses={404: {"description": "Interview not found", "model": ErrorResponse}}
)
async def get_interview(interview_id: str, user: User = Depends(get_current_user)):
    """
    Get details for a specific interview.

    Includes expert details, notes, transcript, and recording URL.

    Args:
        interview_id: UUID of the interview

    Returns:
        Interview details

    Raises:
        404: Interview not found or campaign not owned by user
    """
    try:
        # Query interview with campaign ownership check
        interview = await execute_query(
            """
            SELECT
                i.*,
                e.expert_name,
                e.current_company as expert_company,
                e.current_title as expert_title,
                e.vendor_platform_id,
                v.name as vendor_name
            FROM expert_network.interviews i
            JOIN expert_network.experts e ON i.expert_id = e.id
            JOIN expert_network.vendor_platforms v ON e.vendor_platform_id = v.id
            JOIN expert_network.campaigns c ON i.campaign_id = c.id
            WHERE i.id = $1 AND c.user_id = $2
            """,
            interview_id,
            user.user_id,
            fetch_one=True
        )

        if not interview:
            raise HTTPException(status_code=404, detail="Interview not found")

        return interview
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch interview: {str(e)}")


@router.post(
    "",
    response_model=InterviewResponse,
    status_code=201,
    summary="Schedule a new interview",
    description="Create/schedule a new interview with an expert."
)
async def create_interview(
    interview_data: InterviewCreate,
    user: User = Depends(get_current_user)
):
    """
    Schedule a new interview.

    Args:
        interview_data: Interview creation data

    Returns:
        Created interview details

    Raises:
        400: Invalid interview data
        404: Campaign or expert not found
    """
    try:
        # Verify campaign ownership
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            interview_data.campaign_id,
            user.user_id,
            fetch_one=True
        )

        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")

        # Verify expert exists and belongs to campaign
        expert = await execute_query(
            """
            SELECT e.id, e.expert_name, e.current_company, e.current_title, e.vendor_platform_id, v.name as vendor_name
            FROM expert_network.experts e
            JOIN expert_network.vendor_platforms v ON e.vendor_platform_id = v.id
            WHERE e.id = $1 AND e.campaign_id = $2
            """,
            interview_data.expert_id,
            interview_data.campaign_id,
            fetch_one=True
        )

        if not expert:
            raise HTTPException(status_code=404, detail="Expert not found in this campaign")

        # Create interview
        interview = await insert_and_return(
            "interviews",
            {
                "campaign_id": interview_data.campaign_id,
                "expert_id": interview_data.expert_id,
                "user_id": user.user_id,
                "scheduled_date": interview_data.scheduled_date,
                "duration_minutes": interview_data.duration_minutes,
                "status": interview_data.status,
                "interview_notes": interview_data.interview_notes,
                "key_insights": interview_data.key_insights,
                "recording_url": str(interview_data.recording_url) if interview_data.recording_url else None,
                "transcript_text": interview_data.transcript_text,
                "interviewer_name": interview_data.interviewer_name,
            }
        )

        # Add expert details
        interview["expert_name"] = expert["expert_name"]
        interview["expert_company"] = expert["current_company"]
        interview["expert_title"] = expert["current_title"]
        interview["vendor_platform_id"] = expert["vendor_platform_id"]
        interview["vendor_name"] = expert["vendor_name"]

        return interview
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to create interview: {str(e)}")


@router.patch(
    "/{interview_id}",
    response_model=InterviewResponse,
    summary="Update an interview",
    description="Update interview details, status, or add notes/transcript.",
    responses={404: {"description": "Interview not found", "model": ErrorResponse}}
)
async def update_interview(
    interview_id: str,
    interview_data: InterviewUpdate,
    user: User = Depends(get_current_user)
):
    """
    Update an interview.

    Commonly used to:
    - Update status (e.g., from 'scheduled' to 'completed')
    - Add interview notes and key insights
    - Add transcript and recording URL

    Args:
        interview_id: UUID of the interview to update
        interview_data: Fields to update (all optional)

    Returns:
        Updated interview details

    Raises:
        404: Interview not found or campaign not owned by user
        400: Invalid update data
    """
    try:
        # Build update dict from non-None fields
        update_fields = {
            k: v for k, v in interview_data.model_dump(exclude_unset=True).items()
            if v is not None
        }

        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")

        # Convert HttpUrl to string if present
        if "recording_url" in update_fields:
            update_fields["recording_url"] = str(update_fields["recording_url"])

        # Update interview with campaign ownership check
        async with get_db() as conn:
            async with conn.transaction():
                # Verify campaign ownership
                campaign_check = await conn.fetchrow(
                    """
                    SELECT c.id
                    FROM expert_network.interviews i
                    JOIN expert_network.campaigns c ON i.campaign_id = c.id
                    WHERE i.id = $1 AND c.user_id = $2
                    """,
                    interview_id,
                    user.user_id
                )

                if not campaign_check:
                    raise HTTPException(status_code=404, detail="Interview not found")

                # Build SET clause
                set_parts = []
                values = []
                param_num = 1

                for col, val in update_fields.items():
                    set_parts.append(f"{col} = ${param_num}")
                    values.append(val)
                    param_num += 1

                set_clause = ', '.join(set_parts)

                # Update interview
                query = f"""
                    UPDATE expert_network.interviews
                    SET {set_clause}, updated_at = NOW()
                    WHERE id = ${param_num}
                    RETURNING *
                """
                values.append(interview_id)

                updated = await conn.fetchrow(query, *values)

                if not updated:
                    raise HTTPException(status_code=404, detail="Interview not found")

        # Fetch full interview details
        return await get_interview(interview_id, user)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to update interview: {str(e)}")


@router.delete(
    "/{interview_id}",
    response_model=SuccessResponse,
    summary="Delete an interview",
    description="Delete an interview record.",
    responses={404: {"description": "Interview not found", "model": ErrorResponse}}
)
async def delete_interview(interview_id: str, user: User = Depends(get_current_user)):
    """
    Delete an interview.

    Args:
        interview_id: UUID of the interview to delete

    Returns:
        Success message

    Raises:
        404: Interview not found or campaign not owned by user
    """
    try:
        async with get_db() as conn:
            async with conn.transaction():
                # Verify campaign ownership
                interview = await conn.fetchrow(
                    """
                    SELECT i.id
                    FROM expert_network.interviews i
                    JOIN expert_network.campaigns c ON i.campaign_id = c.id
                    WHERE i.id = $1 AND c.user_id = $2
                    """,
                    interview_id,
                    user.user_id
                )

                if not interview:
                    raise HTTPException(status_code=404, detail="Interview not found")

                # Delete interview
                await conn.execute(
                    "DELETE FROM expert_network.interviews WHERE id = $1",
                    interview_id
                )

        return SuccessResponse(
            success=True,
            message="Interview deleted successfully"
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete interview: {str(e)}")
