"""
Common models shared across all API endpoints.

Includes standard responses, pagination, and shared data structures.
"""

from typing import Optional, Generic, TypeVar, List, Any
from pydantic import BaseModel, Field
from datetime import datetime


# Generic type for paginated responses
T = TypeVar('T')


class SuccessResponse(BaseModel):
    """Standard success response."""
    success: bool = True
    message: str
    data: Optional[Any] = None


class ErrorResponse(BaseModel):
    """Standard error response."""
    success: bool = False
    error: str
    detail: Optional[str] = None


class PaginationParams(BaseModel):
    """Query parameters for pagination."""
    page: int = Field(1, ge=1, description="Page number (1-indexed)")
    limit: int = Field(50, ge=1, le=100, description="Items per page")

    @property
    def offset(self) -> int:
        """Calculate offset for database query."""
        return (self.page - 1) * self.limit


class PaginatedResponse(BaseModel, Generic[T]):
    """Generic paginated response wrapper."""
    items: List[T]
    total: int
    page: int
    limit: int
    pages: int

    @classmethod
    def create(cls, items: List[T], total: int, params: PaginationParams):
        """Create paginated response from items and pagination params."""
        return cls(
            items=items,
            total=total,
            page=params.page,
            limit=params.limit,
            pages=(total + params.limit - 1) // params.limit if total > 0 else 0
        )


class TimestampMixin(BaseModel):
    """Mixin for models with created_at and updated_at timestamps."""
    created_at: datetime
    updated_at: datetime


class UUIDIdentifier(BaseModel):
    """Mixin for models with UUID primary key."""
    id: str = Field(..., description="UUID identifier")
