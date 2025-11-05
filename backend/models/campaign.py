"""
Campaign models.

Campaigns represent a single expert research project with specific goals,
target experts, and vendor enrollments.
"""

from typing import Optional, List
from pydantic import BaseModel, Field
from datetime import date
from .common import UUIDIdentifier, TimestampMixin


class CampaignBase(BaseModel):
    """Base campaign fields shared between create/update."""
    campaign_name: str = Field(..., min_length=1, max_length=255, description="Campaign name")
    industry_vertical: str = Field(..., description="Industry focus (e.g., 'Healthcare Technology')")
    custom_industry: Optional[str] = Field(None, description="Custom industry specification when 'Other' is selected")
    brief_description: Optional[str] = Field(None, description="Brief campaign description")
    start_date: date = Field(..., description="Campaign start date")
    target_completion_date: date = Field(..., description="Target completion date")
    target_regions: List[str] = Field(default_factory=list, description="Target geographic regions")
    custom_regions: Optional[str] = Field(None, description="Custom region specification when 'Other' is selected")
    min_calls: Optional[int] = Field(None, ge=0, description="Minimum number of expert calls")
    max_calls: Optional[int] = Field(None, ge=0, description="Maximum number of expert calls")


class CampaignCreate(CampaignBase):
    """Request model for creating a new campaign."""
    project_id: Optional[str] = Field(None, description="Optional parent project ID")

    class Config:
        json_schema_extra = {
            "example": {
                "project_id": "123e4567-e89b-12d3-a456-426614174000",
                "campaign_name": "Healthcare AI Market Assessment",
                "industry_vertical": "Healthcare Technology",
                "brief_description": "Understanding AI adoption in clinical workflows",
                "start_date": "2025-02-01",
                "target_completion_date": "2025-03-15",
                "target_regions": ["North America", "Europe"],
                "min_calls": 15,
                "max_calls": 20
            }
        }


class CampaignUpdate(BaseModel):
    """Request model for updating a campaign (all fields optional)."""
    project_id: Optional[str] = None
    campaign_name: Optional[str] = Field(None, min_length=1, max_length=255)
    industry_vertical: Optional[str] = None
    custom_industry: Optional[str] = None
    brief_description: Optional[str] = None
    start_date: Optional[date] = None
    target_completion_date: Optional[date] = None
    target_regions: Optional[List[str]] = None
    custom_regions: Optional[str] = None
    min_calls: Optional[int] = Field(None, ge=0)
    max_calls: Optional[int] = Field(None, ge=0)


class VendorEnrollmentCreate(BaseModel):
    """Request model for enrolling a vendor in a campaign."""
    vendor_platform_id: str = Field(..., description="Vendor platform UUID")

    class Config:
        json_schema_extra = {
            "example": {
                "vendor_platform_id": "e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b"
            }
        }


class VendorEnrollmentResponse(UUIDIdentifier, TimestampMixin):
    """Response model for vendor enrollment."""
    campaign_id: str = Field(..., description="Campaign UUID")
    vendor_platform_id: str = Field(..., description="Vendor platform UUID")
    vendor_name: Optional[str] = Field(None, description="Vendor platform name")
    vendor_logo_url: Optional[str] = Field(None, description="Vendor logo URL")
    status: str = Field(..., description="Enrollment status (pending, active, paused, completed)")
    experts_proposed_count: int = Field(0, description="Number of experts proposed by vendor")
    experts_reviewed_count: int = Field(0, description="Number of experts reviewed")
    interviews_scheduled_count: int = Field(0, description="Number of interviews scheduled")

    class Config:
        json_schema_extra = {
            "example": {
                "id": "abc123-enrollment-uuid",
                "campaign_id": "campaign-uuid",
                "vendor_platform_id": "e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b",
                "vendor_name": "GLG",
                "vendor_logo_url": "/images/vendor-logos/GLG.png",
                "status": "active",
                "experts_proposed_count": 12,
                "experts_reviewed_count": 8,
                "interviews_scheduled_count": 3,
                "created_at": "2025-02-01T10:00:00Z",
                "updated_at": "2025-02-05T14:30:00Z"
            }
        }


class CampaignResponse(UUIDIdentifier, CampaignBase, TimestampMixin):
    """Response model for campaign details."""
    user_id: str = Field(..., description="Owner user ID")
    project_id: Optional[str] = Field(None, description="Parent project ID")
    project_name: Optional[str] = Field(None, description="Parent project name")
    project_code: Optional[str] = Field(None, description="Parent project code")
    display_order: int = Field(..., description="Display order in UI")

    # Aggregated counts (populated from joined queries)
    expert_count: Optional[int] = Field(None, description="Total number of experts")
    interview_count: Optional[int] = Field(None, description="Total number of interviews")
    vendor_enrollment_count: Optional[int] = Field(None, description="Number of enrolled vendors")

    class Config:
        json_schema_extra = {
            "example": {
                "id": "campaign-uuid-123",
                "user_id": "user_123",
                "project_id": "123e4567-e89b-12d3-a456-426614174000",
                "project_name": "TechCo Acquisition Due Diligence",
                "project_code": "DEAL-2025-001",
                "campaign_name": "Healthcare AI Market Assessment",
                "industry_vertical": "Healthcare Technology",
                "brief_description": "Understanding AI adoption in clinical workflows",
                "start_date": "2025-02-01",
                "target_completion_date": "2025-03-15",
                "target_regions": ["North America", "Europe"],
                "min_calls": 15,
                "max_calls": 20,
                "display_order": 1,
                "expert_count": 24,
                "interview_count": 8,
                "vendor_enrollment_count": 3,
                "created_at": "2025-01-15T10:00:00Z",
                "updated_at": "2025-02-05T14:30:00Z"
            }
        }


class CampaignListResponse(BaseModel):
    """Response model for list of campaigns."""
    campaigns: List[CampaignResponse]
    total: int = Field(..., description="Total number of campaigns")
