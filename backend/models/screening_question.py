"""
Screening question models.

Screening questions are used to vet experts before interviews.
They support hierarchical sub-questions.
"""

from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from .common import UUIDIdentifier, TimestampMixin


class ScreeningQuestionBase(BaseModel):
    """Base screening question fields."""
    question_text: str = Field(..., min_length=1, description="Question text")
    question_type: str = Field(default="text", description="Question type: text, multiple-choice, rating")
    options: Optional[Dict[str, Any]] = Field(None, description="Options for multiple-choice questions (JSON)")
    display_order: int = Field(default=0, ge=0, description="Display order within campaign")


class ScreeningQuestionCreate(ScreeningQuestionBase):
    """Request model for creating a screening question."""
    campaign_id: str = Field(..., description="Campaign UUID")
    parent_question_id: Optional[str] = Field(None, description="Parent question UUID (for sub-questions)")

    class Config:
        json_schema_extra = {
            "example": {
                "campaign_id": "campaign-uuid-123",
                "parent_question_id": None,
                "question_text": "Describe your experience with healthcare AI",
                "question_type": "text",
                "display_order": 0
            }
        }


class ScreeningQuestionUpdate(BaseModel):
    """Request model for updating a screening question (all fields optional)."""
    question_text: Optional[str] = Field(None, min_length=1)
    question_type: Optional[str] = None
    options: Optional[Dict[str, Any]] = None
    display_order: Optional[int] = Field(None, ge=0)


class ScreeningQuestionResponse(UUIDIdentifier, ScreeningQuestionBase, TimestampMixin):
    """Response model for screening question."""
    campaign_id: str = Field(..., description="Campaign UUID")
    parent_question_id: Optional[str] = Field(None, description="Parent question UUID")

    class Config:
        json_schema_extra = {
            "example": {
                "id": "question-uuid-123",
                "campaign_id": "campaign-uuid-123",
                "parent_question_id": None,
                "question_text": "Describe your experience with healthcare AI",
                "question_type": "text",
                "options": None,
                "display_order": 0,
                "created_at": "2025-02-01T10:00:00Z",
                "updated_at": "2025-02-01T10:00:00Z"
            }
        }


class ScreeningQuestionTreeResponse(ScreeningQuestionResponse):
    """Response model for screening question with nested sub-questions."""
    sub_questions: List['ScreeningQuestionTreeResponse'] = Field(default_factory=list, description="Nested sub-questions")


# For forward reference in nested type
ScreeningQuestionTreeResponse.model_rebuild()

