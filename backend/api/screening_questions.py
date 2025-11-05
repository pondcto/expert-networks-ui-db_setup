"""
Screening Questions API endpoints.

Manages screening questions for campaigns, supporting hierarchical sub-questions.
"""

from typing import List
from fastapi import APIRouter, HTTPException, Depends
from auth.better_auth import get_current_user, User
from models.screening_question import (
    ScreeningQuestionCreate,
    ScreeningQuestionUpdate,
    ScreeningQuestionResponse,
    ScreeningQuestionTreeResponse
)
from models.common import ErrorResponse
from db import execute_query, insert_and_return, update_and_return, get_db
import asyncpg
import json

router = APIRouter(prefix="/api/campaigns/{campaign_id}/screening-questions", tags=["Screening Questions"])


@router.get(
    "",
    response_model=List[ScreeningQuestionTreeResponse],
    summary="List screening questions for a campaign",
    description="Get all screening questions for a campaign, organized hierarchically with sub-questions."
)
async def list_screening_questions(
    campaign_id: str,
    user: User = Depends(get_current_user)
):
    """
    List all screening questions for a campaign.
    
    Returns questions organized hierarchically with sub-questions nested.
    """
    try:
        # Verify campaign belongs to user
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            campaign_id,
            user.user_id,
            fetch_one=True
        )
        
        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")
        
        # Fetch all questions for the campaign
        questions = await execute_query(
            """
            SELECT * FROM expert_network.screening_questions
            WHERE campaign_id = $1
            ORDER BY display_order, created_at
            """,
            campaign_id,
            fetch_all=True
        )
        
        # Build hierarchical structure
        question_map: dict[str, ScreeningQuestionTreeResponse] = {}
        root_questions: List[ScreeningQuestionTreeResponse] = []
        
        # First pass: create all question objects
        for q in questions:
            # Parse options if it's a string (JSONB can sometimes be returned as string)
            options = q.get("options")
            if options is not None:
                if isinstance(options, str):
                    try:
                        options = json.loads(options)
                    except (json.JSONDecodeError, TypeError):
                        options = None
                elif not isinstance(options, dict):
                    options = None
            
            question = ScreeningQuestionTreeResponse(
                id=q["id"],
                campaign_id=q["campaign_id"],
                parent_question_id=q.get("parent_question_id"),
                question_text=q["question_text"],
                question_type=q.get("question_type", "text"),
                options=options,
                display_order=q.get("display_order", 0),
                created_at=q["created_at"],
                updated_at=q["updated_at"],
                sub_questions=[]
            )
            question_map[q["id"]] = question
        
        # Second pass: build hierarchy
        for q in questions:
            question = question_map[q["id"]]
            if q.get("parent_question_id"):
                # It's a sub-question
                parent = question_map.get(q["parent_question_id"])
                if parent:
                    parent.sub_questions.append(question)
            else:
                # It's a root question
                root_questions.append(question)
        
        return root_questions
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch screening questions: {str(e)}")


@router.post(
    "",
    response_model=ScreeningQuestionResponse,
    status_code=201,
    summary="Create a screening question",
    description="Create a new screening question for a campaign."
)
async def create_screening_question(
    campaign_id: str,
    question_data: ScreeningQuestionCreate,
    user: User = Depends(get_current_user)
):
    """
    Create a new screening question.
    
    Args:
        campaign_id: Campaign UUID
        question_data: Question data (campaign_id in body will be overridden by path param)
    
    Returns:
        Created question details
    """
    try:
        # Verify campaign belongs to user
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            campaign_id,
            user.user_id,
            fetch_one=True
        )
        
        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")
        
        # If parent_question_id is provided, verify it exists and belongs to same campaign
        if question_data.parent_question_id:
            parent = await execute_query(
                "SELECT id FROM expert_network.screening_questions WHERE id = $1 AND campaign_id = $2",
                question_data.parent_question_id,
                campaign_id,
                fetch_one=True
            )
            if not parent:
                raise HTTPException(status_code=404, detail="Parent question not found")
        
        # Get max display_order for this level
        if question_data.parent_question_id:
            max_order_result = await execute_query(
                """
                SELECT COALESCE(MAX(display_order), 0) as max_order 
                FROM expert_network.screening_questions 
                WHERE campaign_id = $1 AND parent_question_id = $2
                """,
                campaign_id,
                question_data.parent_question_id,
                fetch_one=True
            )
        else:
            max_order_result = await execute_query(
                """
                SELECT COALESCE(MAX(display_order), 0) as max_order 
                FROM expert_network.screening_questions 
                WHERE campaign_id = $1 AND parent_question_id IS NULL
                """,
                campaign_id,
                fetch_one=True
            )
        
        max_order = max_order_result.get("max_order", 0) if max_order_result else 0
        display_order = question_data.display_order if question_data.display_order > 0 else max_order + 1
        
        # Create question
        question = await insert_and_return(
            "screening_questions",
            {
                "campaign_id": campaign_id,
                "parent_question_id": question_data.parent_question_id,
                "question_text": question_data.question_text,
                "question_type": question_data.question_type,
                "options": question_data.options,
                "display_order": display_order
            }
        )
        
        # Parse options if it's a string
        options = question.get("options")
        if options is not None:
            if isinstance(options, str):
                try:
                    options = json.loads(options)
                except (json.JSONDecodeError, TypeError):
                    options = None
            elif not isinstance(options, dict):
                options = None
        
        return ScreeningQuestionResponse(
            id=question["id"],
            campaign_id=question["campaign_id"],
            parent_question_id=question.get("parent_question_id"),
            question_text=question["question_text"],
            question_type=question.get("question_type", "text"),
            options=options,
            display_order=question.get("display_order", 0),
            created_at=question["created_at"],
            updated_at=question["updated_at"]
        )
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to create screening question: {str(e)}")


@router.patch(
    "/{question_id}",
    response_model=ScreeningQuestionResponse,
    summary="Update a screening question",
    description="Update an existing screening question."
)
async def update_screening_question(
    campaign_id: str,
    question_id: str,
    question_data: ScreeningQuestionUpdate,
    user: User = Depends(get_current_user)
):
    """
    Update a screening question.
    
    Args:
        campaign_id: Campaign UUID
        question_id: Question UUID
        question_data: Fields to update
    
    Returns:
        Updated question details
    """
    try:
        # Verify campaign belongs to user
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            campaign_id,
            user.user_id,
            fetch_one=True
        )
        
        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")
        
        # Verify question exists and belongs to campaign
        question = await execute_query(
            "SELECT * FROM expert_network.screening_questions WHERE id = $1 AND campaign_id = $2",
            question_id,
            campaign_id,
            fetch_one=True
        )
        
        if not question:
            raise HTTPException(status_code=404, detail="Question not found")
        
        # Build update dict
        update_fields = {
            k: v for k, v in question_data.model_dump(exclude_unset=True).items()
            if v is not None
        }
        
        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        # Update question
        updated = await update_and_return(
            "screening_questions",
            update_fields,
            where="id = $1",
            where_params=[question_id]
        )
        
        # Parse options if it's a string
        options = updated.get("options")
        if options is not None:
            if isinstance(options, str):
                try:
                    options = json.loads(options)
                except (json.JSONDecodeError, TypeError):
                    options = None
            elif not isinstance(options, dict):
                options = None
        
        return ScreeningQuestionResponse(
            id=updated["id"],
            campaign_id=updated["campaign_id"],
            parent_question_id=updated.get("parent_question_id"),
            question_text=updated["question_text"],
            question_type=updated.get("question_type", "text"),
            options=options,
            display_order=updated.get("display_order", 0),
            created_at=updated["created_at"],
            updated_at=updated["updated_at"]
        )
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to update screening question: {str(e)}")


@router.delete(
    "/{question_id}",
    status_code=204,
    summary="Delete a screening question",
    description="Delete a screening question. Sub-questions will be deleted via CASCADE."
)
async def delete_screening_question(
    campaign_id: str,
    question_id: str,
    user: User = Depends(get_current_user)
):
    """
    Delete a screening question.
    
    This will also delete all sub-questions due to CASCADE constraint.
    
    Args:
        campaign_id: Campaign UUID
        question_id: Question UUID
    """
    try:
        # Verify campaign belongs to user
        campaign = await execute_query(
            "SELECT id FROM expert_network.campaigns WHERE id = $1 AND user_id = $2",
            campaign_id,
            user.user_id,
            fetch_one=True
        )
        
        if not campaign:
            raise HTTPException(status_code=404, detail="Campaign not found")
        
        # Verify question exists and belongs to campaign
        question = await execute_query(
            "SELECT id FROM expert_network.screening_questions WHERE id = $1 AND campaign_id = $2",
            question_id,
            campaign_id,
            fetch_one=True
        )
        
        if not question:
            raise HTTPException(status_code=404, detail="Question not found")
        
        # Delete question (CASCADE will handle sub-questions)
        async with get_db() as conn:
            await conn.execute(
                "DELETE FROM expert_network.screening_questions WHERE id = $1",
                question_id
            )
        
        return None
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete screening question: {str(e)}")

