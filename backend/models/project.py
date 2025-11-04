"""
Project models.

Projects group related campaigns together (e.g., a specific M&A deal or market study).
"""

from typing import Optional
from pydantic import BaseModel, Field
from datetime import date
from .common import UUIDIdentifier, TimestampMixin


class ProjectBase(BaseModel):
    """Base project fields shared between create/update."""
    project_name: str = Field(..., min_length=1, max_length=255, description="Project name")
    project_code: Optional[str] = Field(None, max_length=50, description="Project code (e.g., 'DEAL-2025-001')")
    client_name: Optional[str] = Field(None, max_length=255, description="Client name")
    start_date: Optional[date] = Field(None, description="Project start date")
    end_date: Optional[date] = Field(None, description="Project end date")
    description: Optional[str] = Field(None, description="Project description")


class ProjectCreate(ProjectBase):
    """Request model for creating a new project."""
    pass

    class Config:
        json_schema_extra = {
            "example": {
                "project_name": "TechCo Acquisition Due Diligence",
                "project_code": "DEAL-2025-001",
                "client_name": "Private Equity Firm XYZ",
                "start_date": "2025-01-15",
                "end_date": "2025-03-15",
                "description": "Commercial due diligence for healthcare tech acquisition"
            }
        }


class ProjectUpdate(BaseModel):
    """Request model for updating a project (all fields optional)."""
    project_name: Optional[str] = Field(None, min_length=1, max_length=255)
    project_code: Optional[str] = Field(None, max_length=50)
    client_name: Optional[str] = Field(None, max_length=255)
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    description: Optional[str] = None


class ProjectResponse(UUIDIdentifier, ProjectBase, TimestampMixin):
    """Response model for project details."""
    user_id: str = Field(..., description="Owner user ID")
    display_order: int = Field(..., description="Display order in UI")
    campaign_count: Optional[int] = Field(None, description="Number of campaigns in project")

    class Config:
        json_schema_extra = {
            "example": {
                "id": "123e4567-e89b-12d3-a456-426614174000",
                "user_id": "user_123",
                "project_name": "TechCo Acquisition Due Diligence",
                "project_code": "DEAL-2025-001",
                "client_name": "Private Equity Firm XYZ",
                "start_date": "2025-01-15",
                "end_date": "2025-03-15",
                "description": "Commercial due diligence for healthcare tech acquisition",
                "display_order": 1,
                "campaign_count": 3,
                "created_at": "2025-01-10T10:00:00Z",
                "updated_at": "2025-01-10T10:00:00Z"
            }
        }
