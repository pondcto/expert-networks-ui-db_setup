"""
Interview models.

Interviews represent scheduled calls with experts, including notes and transcripts.
"""

from typing import Optional, List
from pydantic import BaseModel, Field, HttpUrl
from datetime import datetime
from .common import UUIDIdentifier, TimestampMixin


class InterviewBase(BaseModel):
    """Base interview fields shared between create/update."""
    scheduled_date: datetime = Field(..., description="Interview scheduled date/time")
    duration_minutes: int = Field(60, ge=15, le=240, description="Interview duration in minutes")
    status: str = Field(
        "scheduled",
        description="Interview status (scheduled, completed, cancelled, no_show)"
    )
    interview_notes: Optional[str] = Field(None, description="Interview notes/summary")
    key_insights: Optional[str] = Field(None, description="Key insights from interview")
    recording_url: Optional[HttpUrl] = Field(None, description="URL to interview recording")
    transcript_text: Optional[str] = Field(None, description="Full interview transcript")


class InterviewCreate(InterviewBase):
    """Request model for creating/scheduling a new interview."""
    campaign_id: str = Field(..., description="Campaign UUID")
    expert_id: str = Field(..., description="Expert UUID")
    interviewer_name: Optional[str] = Field(None, description="Name of interviewer")

    class Config:
        json_schema_extra = {
            "example": {
                "campaign_id": "campaign-uuid-123",
                "expert_id": "expert-uuid-123",
                "scheduled_date": "2025-02-15T14:00:00Z",
                "duration_minutes": 60,
                "status": "scheduled",
                "interviewer_name": "John Smith"
            }
        }


class InterviewUpdate(BaseModel):
    """Request model for updating an interview (all fields optional)."""
    scheduled_date: Optional[datetime] = None
    duration_minutes: Optional[int] = Field(None, ge=15, le=240)
    status: Optional[str] = None
    interview_notes: Optional[str] = None
    key_insights: Optional[str] = None
    recording_url: Optional[HttpUrl] = None
    transcript_text: Optional[str] = None
    interviewer_name: Optional[str] = None


class InterviewResponse(UUIDIdentifier, InterviewBase, TimestampMixin):
    """Response model for interview details."""
    campaign_id: str
    expert_id: str
    user_id: str = Field(..., description="User who owns the campaign")

    # Expert details (joined from experts table)
    expert_name: Optional[str] = Field(None, description="Expert's name")
    expert_company: Optional[str] = Field(None, description="Expert's company")
    expert_title: Optional[str] = Field(None, description="Expert's job title")

    # Vendor details
    vendor_platform_id: Optional[str] = Field(None, description="Vendor platform UUID")
    vendor_name: Optional[str] = Field(None, description="Vendor platform name")

    interviewer_name: Optional[str] = None

    class Config:
        json_schema_extra = {
            "example": {
                "id": "interview-uuid-123",
                "campaign_id": "campaign-uuid-123",
                "expert_id": "expert-uuid-123",
                "user_id": "user_123",
                "expert_name": "Dr. Sarah Johnson",
                "expert_company": "Memorial Sloan Kettering Cancer Center",
                "expert_title": "Director of Clinical AI",
                "vendor_platform_id": "e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b",
                "vendor_name": "GLG",
                "scheduled_date": "2025-02-15T14:00:00Z",
                "duration_minutes": 60,
                "status": "completed",
                "interview_notes": "Discussed AI implementation challenges in radiology...",
                "key_insights": "1. Data quality is the biggest barrier\n2. Need strong physician buy-in\n3. Integration with existing systems is critical",
                "recording_url": "https://example.com/recordings/abc123",
                "transcript_text": "[Full transcript...]",
                "interviewer_name": "John Smith",
                "created_at": "2025-02-10T10:00:00Z",
                "updated_at": "2025-02-15T15:30:00Z"
            }
        }


class InterviewListResponse(BaseModel):
    """Response model for list of interviews."""
    interviews: List[InterviewResponse]
    total: int = Field(..., description="Total number of interviews")
