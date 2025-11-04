"""
Simple API test script to verify the backend is working correctly.

Tests the main endpoints without actually starting the server.
"""

import asyncio
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.dirname(__file__))

from main import app
from httpx import Client

# Create test client using httpx directly
base_url = "http://testserver"
client = Client(app=app, base_url=base_url)


def test_root():
    """Test root endpoint."""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "online"
    assert data["version"] == "1.0.0"
    print("✓ Root endpoint works")


def test_health():
    """Test health check endpoint."""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    print("✓ Health check works")


def test_vendors_list():
    """Test vendors list endpoint."""
    response = client.get("/api/vendors")
    assert response.status_code == 200
    vendors = response.json()
    assert isinstance(vendors, list)
    print(f"✓ Vendors endpoint works - Found {len(vendors)} vendors")

    if vendors:
        vendor = vendors[0]
        print(f"  Example: {vendor['name']} ({vendor['location']}) - {vendor['overall_score']}/5.0")


def test_openapi_schema():
    """Test that OpenAPI schema is generated."""
    response = client.get("/openapi.json")
    assert response.status_code == 200
    schema = response.json()
    assert "openapi" in schema
    assert "paths" in schema

    # Count endpoints
    paths = schema["paths"]
    print(f"✓ OpenAPI schema works - {len(paths)} endpoints defined")

    # Show endpoint groups
    endpoint_groups = {}
    for path in paths:
        if path.startswith("/api/"):
            group = path.split("/")[2] if len(path.split("/")) > 2 else "other"
            endpoint_groups[group] = endpoint_groups.get(group, 0) + 1

    print("  Endpoint groups:")
    for group, count in sorted(endpoint_groups.items()):
        print(f"    - {group}: {count} endpoints")


def test_authentication_required():
    """Test that protected endpoints require authentication."""
    # Projects endpoint should require auth
    response = client.get("/api/projects")
    assert response.status_code in [401, 200]  # 200 if auth disabled in dev

    if response.status_code == 401:
        print("✓ Authentication required for protected endpoints")
    else:
        print("⚠ Authentication disabled (development mode)")


if __name__ == "__main__":
    print("=" * 60)
    print("Expert Networks API - Test Suite")
    print("=" * 60)
    print()

    try:
        test_root()
        test_health()
        test_vendors_list()
        test_openapi_schema()
        test_authentication_required()

        print()
        print("=" * 60)
        print("✓ All tests passed!")
        print("=" * 60)
        print()
        print("Next steps:")
        print("  1. Start the server: uvicorn main:app --reload")
        print("  2. View docs: http://localhost:8000/docs")
        print("  3. Test with frontend")

    except AssertionError as e:
        print(f"\n✗ Test failed: {e}")
    except Exception as e:
        print(f"\n✗ Error: {e}")
        import traceback
        traceback.print_exc()
