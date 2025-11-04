"""
Expert Networks API - Main Application

FastAPI backend for the Expert Networks commercial diligence application.
Provides REST API endpoints for campaign management, expert proposals,
interview scheduling, and vendor platform integration.

## Features
- Multi-tenant with BetterAuth SSO integration
- PostgreSQL with expert_network schema
- Async operations with asyncpg
- Comprehensive API documentation (OpenAPI/Swagger)
- CORS support for frontend integration

## Architecture
- **auth/**: BetterAuth session validation
- **models/**: Pydantic models for request/response validation
- **api/**: Domain-organized API routers
- **db.py**: Database connection pooling and utilities

## Running the Server
```bash
# Development
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Production
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
```

## Environment Variables
- DATABASE_URL: PostgreSQL connection string
- ALLOWED_ORIGINS: Comma-separated list of allowed CORS origins (default: localhost:3000)
"""

import os
from typing import List
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

# Import database lifecycle hooks
from db import startup_db, shutdown_db

# Import API routers
from api.vendors import router as vendors_router
from api.projects import router as projects_router
from api.campaigns import router as campaigns_router
from api.experts import router as experts_router
from api.interviews import router as interviews_router


# ============================================================================
# Application Configuration
# ============================================================================

# CORS configuration from environment
ALLOWED_ORIGINS = os.getenv("ALLOWED_ORIGINS", "http://localhost:3000").split(",")

# Application metadata
APP_TITLE = "Expert Networks API"
APP_DESCRIPTION = """
## Expert Networks Commercial Diligence API

RESTful API for managing expert network campaigns, expert proposals,
and interview scheduling for commercial due diligence projects.

### Key Features

* **Multi-tenant Architecture**: All data isolated per user via BetterAuth SSO
* **Campaign Management**: Organize expert research projects
* **Vendor Integration**: Manage multiple expert network vendors
* **Expert Pipeline**: Track experts from proposal through interview
* **Interview Scheduling**: Schedule and document expert calls

### Authentication

All endpoints (except `/api/vendors`) require authentication via BetterAuth.
Include the session token in the `Authorization` header:

```
Authorization: Bearer <your-session-token>
```

### Database Schema

Uses the `expert_network` schema in PostgreSQL, separate from the `public`
schema used by BetterAuth for authentication.

### Development

- **Documentation**: `/docs` (Swagger UI) or `/redoc` (ReDoc)
- **OpenAPI Schema**: `/openapi.json`
"""

APP_VERSION = "1.0.0"
APP_CONTACT = {
    "name": "Expert Networks Team",
    "email": "support@example.com",
}


# ============================================================================
# Application Instance
# ============================================================================

app = FastAPI(
    title=APP_TITLE,
    description=APP_DESCRIPTION,
    version=APP_VERSION,
    contact=APP_CONTACT,
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
)


# ============================================================================
# Middleware Configuration
# ============================================================================

# CORS middleware for frontend access
app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================================
# Lifecycle Events
# ============================================================================

@app.on_event("startup")
async def on_startup():
    """
    Application startup event.
    Initializes database connection pool.
    """
    print("=" * 60)
    print(f"{APP_TITLE} v{APP_VERSION}")
    print("=" * 60)
    print(f"Allowed CORS origins: {', '.join(ALLOWED_ORIGINS)}")
    print("Initializing database connection pool...")

    await startup_db()

    print("✓ Database connection pool initialized")
    print("✓ Application startup complete")
    print("=" * 60)
    print(f"📚 API Documentation: http://localhost:8000/docs")
    print(f"📖 Alternative Docs: http://localhost:8000/redoc")
    print("=" * 60)


@app.on_event("shutdown")
async def on_shutdown():
    """
    Application shutdown event.
    Closes database connection pool.
    """
    print("\nShutting down application...")
    await shutdown_db()
    print("✓ Application shutdown complete")


# ============================================================================
# Root Endpoint
# ============================================================================

@app.get(
    "/",
    tags=["Health"],
    summary="API root endpoint",
    description="Returns API status and available endpoints."
)
async def root():
    """
    Root endpoint providing API information.

    Returns:
        Basic API information and links to documentation
    """
    return {
        "name": APP_TITLE,
        "version": APP_VERSION,
        "status": "online",
        "docs": "/docs",
        "redoc": "/redoc",
        "openapi": "/openapi.json",
        "endpoints": {
            "vendors": "/api/vendors",
            "projects": "/api/projects",
            "campaigns": "/api/campaigns",
            "experts": "/api/experts",
            "interviews": "/api/interviews",
        }
    }


@app.get(
    "/health",
    tags=["Health"],
    summary="Health check endpoint",
    description="Returns application health status."
)
async def health():
    """
    Health check endpoint.

    Used by load balancers and monitoring systems to verify application is running.

    Returns:
        Health status
    """
    return {"status": "healthy"}


# ============================================================================
# Exception Handlers
# ============================================================================

@app.exception_handler(404)
async def not_found_handler(request, exc):
    """Custom 404 handler with helpful message."""
    return JSONResponse(
        status_code=404,
        content={
            "success": False,
            "error": "Not Found",
            "detail": f"The requested URL {request.url.path} was not found",
            "docs": "/docs"
        }
    )


@app.exception_handler(500)
async def internal_error_handler(request, exc):
    """Custom 500 handler."""
    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "error": "Internal Server Error",
            "detail": "An unexpected error occurred. Please try again later."
        }
    )


# ============================================================================
# Router Registration
# ============================================================================

# Register all API routers
app.include_router(vendors_router)
app.include_router(projects_router)
app.include_router(campaigns_router)
app.include_router(experts_router)
app.include_router(interviews_router)


# ============================================================================
# Development Server
# ============================================================================

if __name__ == "__main__":
    import uvicorn

    # Run with uvicorn for development
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,  # Auto-reload on code changes
        log_level="info"
    )
