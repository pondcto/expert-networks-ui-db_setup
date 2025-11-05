"""
Project API endpoints.

Projects group related campaigns together (e.g., a specific M&A deal or market study).
All operations require authentication and are scoped to the logged-in user.
"""

from typing import List
from fastapi import APIRouter, HTTPException, Depends
from auth.better_auth import get_current_user, User
from models.project import ProjectCreate, ProjectUpdate, ProjectResponse
from models.common import SuccessResponse, ErrorResponse
from db import insert_and_return, update_and_return, execute_query

router = APIRouter(prefix="/api/projects", tags=["Projects"])


@router.get(
    "",
    response_model=List[ProjectResponse],
    summary="List user's projects",
    description="Get all projects for the authenticated user, ordered by display_order and creation date."
)
async def list_projects(user: User = Depends(get_current_user)):
    """
    List all projects for the authenticated user.

    Returns projects with campaign counts, sorted by display order.
    """
    try:
        projects = await execute_query(
            """
            SELECT
                p.*,
                COUNT(c.id) as campaign_count
            FROM expert_network.projects p
            LEFT JOIN expert_network.campaigns c ON p.id = c.project_id
            WHERE p.user_id = $1
            GROUP BY p.id
            ORDER BY p.display_order, p.created_at DESC
            """,
            user.user_id,
            fetch_all=True
        )
        return projects
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch projects: {str(e)}")


@router.get(
    "/{project_id}",
    response_model=ProjectResponse,
    summary="Get project details",
    description="Get detailed information about a specific project.",
    responses={404: {"description": "Project not found", "model": ErrorResponse}}
)
async def get_project(project_id: str, user: User = Depends(get_current_user)):
    """
    Get details for a specific project.

    Args:
        project_id: UUID of the project

    Returns:
        Project details with campaign count

    Raises:
        404: Project not found or not owned by user
    """
    try:
        project = await execute_query(
            """
            SELECT
                p.*,
                COUNT(c.id) as campaign_count
            FROM expert_network.projects p
            LEFT JOIN expert_network.campaigns c ON p.id = c.project_id
            WHERE p.id = $1 AND p.user_id = $2
            GROUP BY p.id
            """,
            project_id,
            user.user_id,
            fetch_one=True
        )

        if not project:
            raise HTTPException(status_code=404, detail="Project not found")

        return project
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch project: {str(e)}")


@router.post(
    "",
    response_model=ProjectResponse,
    status_code=201,
    summary="Create a new project",
    description="Create a new project for organizing campaigns."
)
async def create_project(
    project_data: ProjectCreate,
    user: User = Depends(get_current_user)
):
    """
    Create a new project.

    Args:
        project_data: Project creation data

    Returns:
        Created project details

    Raises:
        400: Invalid project data
    """
    try:
        # Get current max display order
        max_order = await execute_query(
            "SELECT COALESCE(MAX(display_order), 0) as max_order FROM expert_network.projects WHERE user_id = $1",
            user.user_id,
            fetch_one=True
        )

        # Create project
        project = await insert_and_return(
            "projects",
            {
                "user_id": user.user_id,
                "project_name": project_data.project_name,
                "project_code": project_data.project_code,
                "client_name": project_data.client_name,
                "start_date": project_data.start_date,
                "end_date": project_data.end_date,
                "description": project_data.description,
                "display_order": max_order["max_order"] + 1
            }
        )

        # Add campaign_count field
        project["campaign_count"] = 0
        return project
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to create project: {str(e)}")


@router.patch(
    "/{project_id}",
    response_model=ProjectResponse,
    summary="Update a project",
    description="Update an existing project's details.",
    responses={404: {"description": "Project not found", "model": ErrorResponse}}
)
async def update_project(
    project_id: str,
    project_data: ProjectUpdate,
    user: User = Depends(get_current_user)
):
    """
    Update a project.

    Args:
        project_id: UUID of the project to update
        project_data: Fields to update (all optional)

    Returns:
        Updated project details

    Raises:
        404: Project not found or not owned by user
        400: Invalid update data
    """
    try:
        # Build update dict from non-None fields
        update_fields = {
            k: v for k, v in project_data.model_dump(exclude_unset=True).items()
            if v is not None
        }

        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")

        # Update project
        # Cast project_id to UUID in WHERE clause, user_id is TEXT
        updated = await update_and_return(
            "projects",
            update_fields,
            where="id = $1::uuid AND user_id = $2::text",
            where_params=[project_id, user.user_id]
        )

        if not updated:
            raise HTTPException(status_code=404, detail="Project not found")

        # Add campaign count
        count_result = await execute_query(
            "SELECT COUNT(*) as campaign_count FROM expert_network.campaigns WHERE project_id = $1",
            project_id,
            fetch_one=True
        )
        updated["campaign_count"] = count_result["campaign_count"]

        return updated
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to update project: {str(e)}")


@router.delete(
    "/{project_id}",
    response_model=SuccessResponse,
    summary="Delete a project",
    description="Delete a project. Note: This will also remove the project_id from associated campaigns.",
    responses={404: {"description": "Project not found", "model": ErrorResponse}}
)
async def delete_project(project_id: str, user: User = Depends(get_current_user)):
    """
    Delete a project.

    This sets project_id to NULL for all associated campaigns.
    The project itself is permanently deleted.

    Args:
        project_id: UUID of the project to delete

    Returns:
        Success message

    Raises:
        404: Project not found or not owned by user
    """
    try:
        from db import get_db

        async with get_db() as conn:
            async with conn.transaction():
                # First, check if project exists and belongs to user
                project = await conn.fetchrow(
                    "SELECT id FROM expert_network.projects WHERE id = $1 AND user_id = $2",
                    project_id,
                    user.user_id
                )

                if not project:
                    raise HTTPException(status_code=404, detail="Project not found")

                # Remove project_id from campaigns (set to NULL)
                await conn.execute(
                    "UPDATE expert_network.campaigns SET project_id = NULL WHERE project_id = $1",
                    project_id
                )

                # Delete project
                await conn.execute(
                    "DELETE FROM expert_network.projects WHERE id = $1",
                    project_id
                )

        return SuccessResponse(
            success=True,
            message="Project deleted successfully"
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete project: {str(e)}")
