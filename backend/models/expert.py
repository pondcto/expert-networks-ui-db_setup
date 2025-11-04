"""
Expert models.

Experts are individuals proposed by vendor platforms for interview.
"""

from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field, EmailStr
from .common import UUIDIdentifier, TimestampMixin


class ExpertBase(BaseModel):
    """Base expert fields shared between create/update."""
    expert_name: str = Field(..., min_length=1, max_length=255, description="Expert full name")
    current_company: Optional[str] = Field(None, max_length=255, description="Current employer")
    current_title: Optional[str] = Field(None, max_length=255, description="Current job title")
    location: Optional[str] = Field(None, max_length=255, description="Geographic location")
    linkedin_url: Optional[str] = Field(None, description="LinkedIn profile URL")
    email: Optional[EmailStr] = Field(None, description="Expert email address")
    phone: Optional[str] = Field(None, max_length=50, description="Phone number")
    years_experience: Optional[int] = Field(None, ge=0, le=100, description="Years of relevant experience")
    expertise_areas: List[str] = Field(default_factory=list, description="Areas of expertise/keywords")
    bio: Optional[str] = Field(None, description="Expert biography/summary")
    hourly_rate: Optional[int] = Field(None, ge=0, description="Hourly rate in USD")


class ExpertCreate(ExpertBase):
    """Request model for creating a new expert."""
    campaign_id: str = Field(..., description="Campaign UUID this expert belongs to")
    vendor_platform_id: str = Field(..., description="Vendor platform UUID that proposed this expert")
    vendor_expert_id: Optional[str] = Field(None, description="Vendor's internal expert ID")
    status: str = Field("proposed", description="Expert status (proposed, reviewed, approved, rejected, scheduled)")

    class Config:
        json_schema_extra = {
            "example": {
                "campaign_id": "campaign-uuid-123",
                "vendor_platform_id": "e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b",
                "vendor_expert_id": "GLG-EXP-12345",
                "expert_name": "Dr. Sarah Johnson",
                "current_company": "Memorial Sloan Kettering Cancer Center",
                "current_title": "Director of Clinical AI",
                "location": "New York, NY",
                "linkedin_url": "https://linkedin.com/in/sarahjohnson",
                "email": "sjohnson@example.com",
                "years_experience": 15,
                "expertise_areas": ["Clinical AI", "Healthcare IT", "EHR Integration"],
                "bio": "15+ years experience implementing AI in clinical settings...",
                "hourly_rate": 800,
                "status": "proposed"
            }
        }


class ExpertUpdate(BaseModel):
    """Request model for updating an expert (all fields optional)."""
    expert_name: Optional[str] = Field(None, min_length=1, max_length=255)
    current_company: Optional[str] = Field(None, max_length=255)
    current_title: Optional[str] = Field(None, max_length=255)
    location: Optional[str] = Field(None, max_length=255)
    linkedin_url: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = Field(None, max_length=50)
    years_experience: Optional[int] = Field(None, ge=0, le=100)
    expertise_areas: Optional[List[str]] = None
    bio: Optional[str] = None
    hourly_rate: Optional[int] = Field(None, ge=0)
    status: Optional[str] = Field(None, description="Update expert status")
    internal_notes: Optional[str] = Field(None, description="Internal notes (visible only to user)")


class ScreeningResponseCreate(BaseModel):
    """Request model for recording a screening question response."""
    expert_id: str = Field(..., description="Expert UUID")
    question_id: str = Field(..., description="Screening question UUID")
    response_text: str = Field(..., min_length=1, description="Expert's response text")
    rating: Optional[int] = Field(None, ge=1, le=5, description="Rating of response (1-5)")

    class Config:
        json_schema_extra = {
            "example": {
                "expert_id": "expert-uuid-123",
                "question_id": "question-uuid-456",
                "response_text": "I have implemented AI diagnostic tools in radiology and pathology...",
                "rating": 5
            }
        }


class ScreeningResponseResponse(UUIDIdentifier, TimestampMixin):
    """Response model for screening question response."""
    expert_id: str
    question_id: str
    question_text: Optional[str] = Field(None, description="The question that was asked")
    response_text: str
    rating: Optional[int] = None

    class Config:
        json_schema_extra = {
            "example": {
                "id": "response-uuid",
                "expert_id": "expert-uuid-123",
                "question_id": "question-uuid-456",
                "question_text": "What experience do you have with AI in clinical settings?",
                "response_text": "I have implemented AI diagnostic tools in radiology and pathology...",
                "rating": 5,
                "created_at": "2025-02-01T10:00:00Z",
                "updated_at": "2025-02-01T10:00:00Z"
            }
        }


class ExpertResponse(UUIDIdentifier, ExpertBase, TimestampMixin):
    """Response model for expert details."""
    campaign_id: str
    vendor_platform_id: str
    vendor_name: Optional[str] = Field(None, description="Vendor platform name")
    vendor_logo_url: Optional[str] = Field(None, description="Vendor logo URL")
    vendor_expert_id: Optional[str] = None
    status: str = Field(..., description="Expert status in pipeline")
    internal_notes: Optional[str] = Field(None, description="Internal notes")
    relevance_score: Optional[float] = Field(None, ge=0, le=100, description="AI-calculated relevance score")

    # Aggregated data
    screening_responses: Optional[List[ScreeningResponseResponse]] = Field(
        None,
        description="Screening question responses"
    )
    interview_count: Optional[int] = Field(None, description="Number of interviews scheduled")

    class Config:
        json_schema_extra = {
            "example": {
                "id": "expert-uuid-123",
                "campaign_id": "campaign-uuid-123",
                "vendor_platform_id": "e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b",
                "vendor_name": "GLG",
                "vendor_logo_url": "/images/vendor-logos/GLG.png",
                "vendor_expert_id": "GLG-EXP-12345",
                "expert_name": "Dr. Sarah Johnson",
                "current_company": "Memorial Sloan Kettering Cancer Center",
                "current_title": "Director of Clinical AI",
                "location": "New York, NY",
                "linkedin_url": "https://linkedin.com/in/sarahjohnson",
                "email": "sjohnson@example.com",
                "years_experience": 15,
                "expertise_areas": ["Clinical AI", "Healthcare IT", "EHR Integration"],
                "bio": "15+ years experience implementing AI in clinical settings...",
                "hourly_rate": 800,
                "status": "approved",
                "internal_notes": "Strong candidate, prioritize for interview",
                "relevance_score": 92.5,
                "interview_count": 1,
                "created_at": "2025-02-01T10:00:00Z",
                "updated_at": "2025-02-05T14:30:00Z"
            }
        }


class ExpertListResponse(BaseModel):
    """Response model for list of experts."""
    experts: List[ExpertResponse]
    total: int = Field(..., description="Total number of experts")
