"""
Pydantic models for request/response validation.

This package contains all data models used in the API endpoints,
organized by domain (campaigns, experts, vendors, etc.).
"""

from .common import SuccessResponse, ErrorResponse, PaginationParams, PaginatedResponse
from .campaign import (
    CampaignCreate,
    CampaignUpdate,
    CampaignResponse,
    CampaignListResponse,
    VendorEnrollmentCreate,
    VendorEnrollmentResponse,
)
from .expert import (
    ExpertCreate,
    ExpertUpdate,
    ExpertResponse,
    ExpertListResponse,
    ScreeningResponseCreate,
    ScreeningResponseResponse,
)
from .vendor import VendorPlatformResponse
from .interview import (
    InterviewCreate,
    InterviewUpdate,
    InterviewResponse,
    InterviewListResponse,
)
from .project import ProjectCreate, ProjectUpdate, ProjectResponse

__all__ = [
    # Common
    "SuccessResponse",
    "ErrorResponse",
    "PaginationParams",
    "PaginatedResponse",
    # Campaign
    "CampaignCreate",
    "CampaignUpdate",
    "CampaignResponse",
    "CampaignListResponse",
    "VendorEnrollmentCreate",
    "VendorEnrollmentResponse",
    # Expert
    "ExpertCreate",
    "ExpertUpdate",
    "ExpertResponse",
    "ExpertListResponse",
    "ScreeningResponseCreate",
    "ScreeningResponseResponse",
    # Vendor
    "VendorPlatformResponse",
    # Interview
    "InterviewCreate",
    "InterviewUpdate",
    "InterviewResponse",
    "InterviewListResponse",
    # Project
    "ProjectCreate",
    "ProjectUpdate",
    "ProjectResponse",
]
