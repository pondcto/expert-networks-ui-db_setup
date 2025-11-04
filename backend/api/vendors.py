"""
Vendor platform API endpoints.

Provides read-only access to expert network vendor platforms.
These are typically seeded during database setup and rarely change.
"""

from typing import List
from fastapi import APIRouter, HTTPException
from models.vendor import VendorPlatformResponse
from models.common import ErrorResponse
from db import get_vendor_platforms

router = APIRouter(prefix="/api/vendors", tags=["Vendors"])


@router.get(
    "",
    response_model=List[VendorPlatformResponse],
    summary="List all vendor platforms",
    description="""
    Get a list of all active expert network vendor platforms.

    Returns platforms like GLG, AlphaSights, Guidepoint, etc. with their
    ratings, cost ranges, locations, and capabilities.

    This endpoint does not require authentication as vendor data is public.
    """,
    responses={
        200: {
            "description": "List of vendor platforms",
            "content": {
                "application/json": {
                    "example": [
                        {
                            "id": "e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b",
                            "name": "GLG",
                            "logo_url": "/images/vendor-logos/GLG.png",
                            "location": "New York, USA",
                            "overall_score": 4.8,
                            "avg_cost_per_call_min": 800,
                            "avg_cost_per_call_max": 1500,
                            "description": "One of the world's largest expert networks...",
                            "tags": ["Global Coverage", "Life Sciences"],
                            "is_active": True
                        }
                    ]
                }
            }
        }
    }
)
async def list_vendors():
    """
    List all active vendor platforms.

    Returns all vendor platforms sorted alphabetically by name.
    Includes cost ranges, ratings, and capabilities for comparison.
    """
    try:
        vendors = await get_vendor_platforms()
        return vendors
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch vendors: {str(e)}")


@router.get(
    "/{vendor_id}",
    response_model=VendorPlatformResponse,
    summary="Get vendor platform details",
    description="Get detailed information about a specific vendor platform by ID.",
    responses={
        200: {"description": "Vendor platform details"},
        404: {"description": "Vendor not found", "model": ErrorResponse}
    }
)
async def get_vendor(vendor_id: str):
    """
    Get details for a specific vendor platform.

    Args:
        vendor_id: UUID of the vendor platform

    Returns:
        Vendor platform details

    Raises:
        404: Vendor not found
    """
    try:
        from db import execute_query

        vendor = await execute_query(
            "SELECT * FROM expert_network.vendor_platforms WHERE id = $1",
            vendor_id,
            fetch_one=True
        )

        if not vendor:
            raise HTTPException(status_code=404, detail="Vendor platform not found")

        return vendor
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch vendor: {str(e)}")
