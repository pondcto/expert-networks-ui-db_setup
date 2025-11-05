"""
Team Members API endpoints.

Manages team members that can be assigned to campaigns.
Team members belong to a user's pool and can be assigned to multiple campaigns.
"""

from typing import List
from fastapi import APIRouter, HTTPException, Depends
from auth.better_auth import get_current_user, User
from models.team_member import (
    TeamMemberCreate,
    TeamMemberUpdate,
    TeamMemberResponse
)
from models.common import ErrorResponse
from db import execute_query, insert_and_return, update_and_return, get_db
import asyncpg

router = APIRouter(prefix="/api/team-members", tags=["Team Members"])


@router.get(
    "",
    response_model=List[TeamMemberResponse],
    summary="List user's team members",
    description="Get all team members in the authenticated user's pool."
)
async def list_team_members(user: User = Depends(get_current_user)):
    """
    List all team members for the authenticated user.
    
    Returns team members sorted by name.
    """
    try:
        members = await execute_query(
            """
            SELECT * FROM expert_network.team_members
            WHERE user_id = $1
            ORDER BY name
            """,
            user.user_id,
            fetch_all=True
        )
        return members
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch team members: {str(e)}")


@router.get(
    "/{member_id}",
    response_model=TeamMemberResponse,
    summary="Get team member details",
    description="Get detailed information about a specific team member.",
    responses={404: {"description": "Team member not found", "model": ErrorResponse}}
)
async def get_team_member(member_id: str, user: User = Depends(get_current_user)):
    """
    Get details for a specific team member.
    
    Args:
        member_id: UUID of the team member
    
    Returns:
        Team member details
    
    Raises:
        404: Team member not found or not owned by user
    """
    try:
        member = await execute_query(
            "SELECT * FROM expert_network.team_members WHERE id = $1 AND user_id = $2",
            member_id,
            user.user_id,
            fetch_one=True
        )
        
        if not member:
            raise HTTPException(status_code=404, detail="Team member not found")
        
        return member
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch team member: {str(e)}")


@router.post(
    "",
    response_model=TeamMemberResponse,
    status_code=201,
    summary="Create a new team member",
    description="Add a new team member to the user's pool."
)
async def create_team_member(
    member_data: TeamMemberCreate,
    user: User = Depends(get_current_user)
):
    """
    Create a new team member.
    
    Args:
        member_data: Team member creation data
    
    Returns:
        Created team member details
    """
    try:
        member = await insert_and_return(
            "team_members",
            {
                "user_id": user.user_id,
                "name": member_data.name,
                "email": member_data.email,
                "designation": member_data.designation,
                "avatar_url": member_data.avatar_url
            }
        )
        return member
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to create team member: {str(e)}")


@router.patch(
    "/{member_id}",
    response_model=TeamMemberResponse,
    summary="Update a team member",
    description="Update an existing team member's details.",
    responses={404: {"description": "Team member not found", "model": ErrorResponse}}
)
async def update_team_member(
    member_id: str,
    member_data: TeamMemberUpdate,
    user: User = Depends(get_current_user)
):
    """
    Update a team member.
    
    Args:
        member_id: UUID of the team member to update
        member_data: Fields to update (all optional)
    
    Returns:
        Updated team member details
    
    Raises:
        404: Team member not found or not owned by user
    """
    try:
        # Verify team member exists and belongs to user
        member = await execute_query(
            "SELECT id FROM expert_network.team_members WHERE id = $1 AND user_id = $2",
            member_id,
            user.user_id,
            fetch_one=True
        )
        
        if not member:
            raise HTTPException(status_code=404, detail="Team member not found")
        
        # Build update dict
        update_fields = {
            k: v for k, v in member_data.model_dump(exclude_unset=True).items()
            if v is not None
        }
        
        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        # Update team member
        updated = await update_and_return(
            "team_members",
            update_fields,
            where="id = $1",
            where_params=[member_id]
        )
        
        return updated
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to update team member: {str(e)}")


@router.delete(
    "/{member_id}",
    status_code=204,
    summary="Delete a team member",
    description="Delete a team member. This will also remove them from all campaign assignments.",
    responses={404: {"description": "Team member not found", "model": ErrorResponse}}
)
async def delete_team_member(member_id: str, user: User = Depends(get_current_user)):
    """
    Delete a team member.
    
    This will also remove the member from all campaign assignments via CASCADE.
    
    Args:
        member_id: UUID of the team member to delete
    """
    try:
        # Verify team member exists and belongs to user
        member = await execute_query(
            "SELECT id FROM expert_network.team_members WHERE id = $1 AND user_id = $2",
            member_id,
            user.user_id,
            fetch_one=True
        )
        
        if not member:
            raise HTTPException(status_code=404, detail="Team member not found")
        
        # Delete team member (CASCADE will handle campaign assignments)
        async with get_db() as conn:
            await conn.execute(
                "DELETE FROM expert_network.team_members WHERE id = $1",
                member_id
            )
        
        return None
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete team member: {str(e)}")


# ============================================================================
# CAMPAIGN TEAM ASSIGNMENTS
# ============================================================================

@router.get(
    "/campaigns/{campaign_id}",
    response_model=List[TeamMemberResponse],
    summary="Get team members assigned to a campaign",
    description="Get all team members assigned to a specific campaign."
)
async def get_campaign_team_members(
    campaign_id: str,
    user: User = Depends(get_current_user)
):
    """
    Get all team members assigned to a campaign.
    
    Args:
        campaign_id: Campaign UUID
    
    Returns:
        List of team members assigned to the campaign
    """
    try:
        # Verify campaign belongs to user
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            campaign_id,
            user.user_id,
            fetch_one=True
        )
        
        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")
        
        # Get assigned team members
        members = await execute_query(
            """
            SELECT tm.*
            FROM expert_network.team_members tm
            JOIN expert_network.campaign_team_assignments cta ON tm.id = cta.team_member_id
            WHERE cta.campaign_id = $1 AND tm.user_id = $2
            ORDER BY tm.name
            """,
            campaign_id,
            user.user_id,
            fetch_all=True
        )
        
        return members
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch campaign team members: {str(e)}")


@router.post(
    "/campaigns/{campaign_id}/assign/{member_id}",
    status_code=204,
    summary="Assign team member to campaign",
    description="Assign a team member to a campaign."
)
async def assign_team_member_to_campaign(
    campaign_id: str,
    member_id: str,
    user: User = Depends(get_current_user)
):
    """
    Assign a team member to a campaign.
    
    Args:
        campaign_id: Campaign UUID
        member_id: Team member UUID
    """
    try:
        # Verify campaign belongs to user
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            campaign_id,
            user.user_id,
            fetch_one=True
        )
        
        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")
        
        # Verify team member belongs to user
        member = await execute_query(
            "SELECT id FROM expert_network.team_members WHERE id = $1 AND user_id = $2",
            member_id,
            user.user_id,
            fetch_one=True
        )
        
        if not member:
            raise HTTPException(status_code=404, detail="Team member not found")
        
        # Assign team member (use INSERT ... ON CONFLICT to handle duplicates)
        async with get_db() as conn:
            await conn.execute(
                """
                INSERT INTO expert_network.campaign_team_assignments (campaign_id, team_member_id)
                VALUES ($1, $2)
                ON CONFLICT (campaign_id, team_member_id) DO NOTHING
                """,
                campaign_id,
                member_id
            )
        
        return None
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to assign team member: {str(e)}")


@router.delete(
    "/campaigns/{campaign_id}/assign/{member_id}",
    status_code=204,
    summary="Unassign team member from campaign",
    description="Remove a team member from a campaign."
)
async def unassign_team_member_from_campaign(
    campaign_id: str,
    member_id: str,
    user: User = Depends(get_current_user)
):
    """
    Unassign a team member from a campaign.
    
    Args:
        campaign_id: Campaign UUID
        member_id: Team member UUID
    """
    try:
        # Verify campaign belongs to user
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            campaign_id,
            user.user_id,
            fetch_one=True
        )
        
        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")
        
        # Remove assignment
        async with get_db() as conn:
            result = await conn.execute(
                """
                DELETE FROM expert_network.campaign_team_assignments
                WHERE campaign_id = $1 AND team_member_id = $2
                """,
                campaign_id,
                member_id
            )
            
            if result == "DELETE 0":
                raise HTTPException(status_code=404, detail="Team member not assigned to campaign")
        
        return None
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to unassign team member: {str(e)}")

