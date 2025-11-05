"""
Team member models.

Team members are users or profiles that can be assigned to campaigns.
They belong to a user's pool and can be assigned to multiple campaigns.
"""

from typing import Optional
from datetime import datetime
from pydantic import BaseModel, Field
from .common import UUIDIdentifier


class TeamMemberBase(BaseModel):
    """Base team member fields."""
    name: str = Field(..., min_length=1, description="Team member name")
    email: Optional[str] = Field(None, description="Email address")
    designation: str = Field(..., min_length=1, description="Job title or role")
    avatar_url: Optional[str] = Field(None, description="URL to avatar image")


class TeamMemberCreate(TeamMemberBase):
    """Request model for creating a team member."""
    
    class Config:
        json_schema_extra = {
            "example": {
                "name": "John Doe",
                "email": "john.doe@example.com",
                "designation": "Research Lead",
                "avatar_url": "/images/team-members/John Doe.png"
            }
        }


class TeamMemberUpdate(BaseModel):
    """Request model for updating a team member (all fields optional)."""
    name: Optional[str] = Field(None, min_length=1)
    email: Optional[str] = None
    designation: Optional[str] = Field(None, min_length=1)
    avatar_url: Optional[str] = None


class TeamMemberResponse(UUIDIdentifier, TeamMemberBase):
    """Response model for team member."""
    user_id: str = Field(..., description="Owner user ID")
    created_at: datetime = Field(..., description="Creation timestamp")
    # Note: team_members table doesn't have updated_at column
    
    class Config:
        json_schema_extra = {
            "example": {
                "id": "member-uuid-123",
                "user_id": "user-123",
                "name": "John Doe",
                "email": "john.doe@example.com",
                "designation": "Research Lead",
                "avatar_url": "/images/team-members/John Doe.png",
                "created_at": "2025-02-01T10:00:00Z"
            }
        }

