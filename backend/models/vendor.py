"""
Vendor platform models.

Models for expert network vendor platforms (GLG, AlphaSights, etc.).
"""

from typing import List, Optional
from pydantic import BaseModel, Field
from .common import UUIDIdentifier, TimestampMixin


class VendorPlatformResponse(UUIDIdentifier, TimestampMixin):
    """Vendor platform details."""
    name: str = Field(..., description="Vendor platform name (e.g., 'GLG', 'AlphaSights')")
    logo_url: Optional[str] = Field(None, description="URL to vendor logo image")
    location: str = Field(..., description="Primary location (e.g., 'New York, USA')")
    overall_score: float = Field(..., ge=0, le=5, description="Overall rating (0-5)")
    avg_cost_per_call_min: int = Field(..., ge=0, description="Minimum cost per call (USD)")
    avg_cost_per_call_max: int = Field(..., ge=0, description="Maximum cost per call (USD)")
    description: Optional[str] = Field(None, description="Platform description")
    tags: List[str] = Field(default_factory=list, description="Platform tags/capabilities")
    is_active: bool = Field(True, description="Whether platform is active")

    class Config:
        json_schema_extra = {
            "example": {
                "id": "e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b",
                "name": "GLG",
                "logo_url": "/images/vendor-logos/GLG.png",
                "location": "New York, USA",
                "overall_score": 4.8,
                "avg_cost_per_call_min": 800,
                "avg_cost_per_call_max": 1500,
                "description": "One of the world's largest expert networks...",
                "tags": ["Global Coverage", "Life Sciences", "Technology"],
                "is_active": True,
                "created_at": "2025-01-15T10:00:00Z",
                "updated_at": "2025-01-15T10:00:00Z"
            }
        }
