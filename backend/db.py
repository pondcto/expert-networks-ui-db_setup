"""
Database connection and utilities for expert_network schema.

This module provides async database connections using asyncpg,
and integrates with BetterAuth for user context.

Usage:
    from db import get_db, execute_query

    # In a FastAPI endpoint
    @app.get("/campaigns")
    async def get_campaigns(user = Depends(get_current_user)):
        async with get_db() as conn:
            campaigns = await conn.fetch(
                "SELECT * FROM expert_network.campaigns WHERE user_id = $1",
                user.user_id
            )
            return [dict(c) for c in campaigns]
"""

import os
from contextlib import asynccontextmanager
from typing import Optional, List, Dict, Any
from uuid import UUID
from decimal import Decimal
import asyncpg

# Database connection from environment
DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql+asyncpg://postgres:123456@localhost:5432/ragdb')

# Convert to pure asyncpg URL (remove +asyncpg suffix for psycopg2 compatibility if needed)
ASYNCPG_URL = DATABASE_URL.replace('postgresql+asyncpg://', 'postgresql://')

# Global connection pool
_pool: Optional[asyncpg.Pool] = None


async def init_db_pool():
    """Initialize the database connection pool."""
    global _pool
    if _pool is None:
        _pool = await asyncpg.create_pool(
            ASYNCPG_URL,
            min_size=2,
            max_size=10,
            command_timeout=60
        )
        print("[DB] Connection pool initialized")
    return _pool


async def close_db_pool():
    """Close the database connection pool."""
    global _pool
    if _pool is not None:
        await _pool.close()
        _pool = None
        print("[DB] Connection pool closed")


async def get_pool() -> asyncpg.Pool:
    """Get or create the database connection pool."""
    if _pool is None:
        await init_db_pool()
    return _pool


@asynccontextmanager
async def get_db():
    """
    Get a database connection from the pool.

    Usage:
        async with get_db() as conn:
            result = await conn.fetch("SELECT * FROM expert_network.campaigns")
    """
    pool = await get_pool()
    async with pool.acquire() as connection:
        yield connection


def convert_uuids_to_strings(data: Any) -> Any:
    """
    Recursively convert UUID objects to strings and Decimal to float in dictionaries and lists.
    
    Args:
        data: Dictionary, list, or other data structure
        
    Returns:
        Data with UUIDs converted to strings and Decimals converted to float
    """
    if isinstance(data, dict):
        return {key: convert_uuids_to_strings(value) for key, value in data.items()}
    elif isinstance(data, list):
        return [convert_uuids_to_strings(item) for item in data]
    elif isinstance(data, UUID):
        return str(data)
    elif isinstance(data, Decimal):
        return float(data)
    else:
        return data


async def execute_query(
    query: str,
    *args,
    fetch_one: bool = False,
    fetch_all: bool = True
) -> Optional[Any]:
    """
    Execute a query and return results.

    Args:
        query: SQL query to execute
        *args: Query parameters
        fetch_one: Return single row as dict
        fetch_all: Return all rows as list of dicts

    Returns:
        List of dicts, single dict, or None (with UUIDs converted to strings)
    """
    async with get_db() as conn:
        if fetch_one:
            row = await conn.fetchrow(query, *args)
            if row:
                result = dict(row)
                return convert_uuids_to_strings(result)
            return None
        elif fetch_all:
            rows = await conn.fetch(query, *args)
            results = [dict(row) for row in rows]
            return convert_uuids_to_strings(results)
        else:
            # Execute without fetching (INSERT, UPDATE, DELETE)
            await conn.execute(query, *args)
            return None


async def insert_and_return(
    table: str,
    data: Dict[str, Any],
    schema: str = "expert_network"
) -> Optional[Dict[str, Any]]:
    """
    Insert a row and return it.

    Args:
        table: Table name
        data: Dictionary of column: value pairs
        schema: Schema name (default: expert_network)

    Returns:
        Inserted row as dict (with UUIDs converted to strings)
    """
    columns = list(data.keys())
    values = list(data.values())
    placeholders = ', '.join(f'${i+1}' for i in range(len(values)))
    columns_str = ', '.join(columns)

    query = f"""
        INSERT INTO {schema}.{table} ({columns_str})
        VALUES ({placeholders})
        RETURNING *
    """

    return await execute_query(query, *values, fetch_one=True)


async def update_and_return(
    table: str,
    data: Dict[str, Any],
    where: str,
    where_params: List[Any],
    schema: str = "expert_network"
) -> Optional[Dict[str, Any]]:
    """
    Update a row and return it.

    Args:
        table: Table name
        data: Dictionary of column: value pairs to update
        where: WHERE clause (e.g., "id = $1 AND user_id = $2")
        where_params: Parameters for WHERE clause
        schema: Schema name (default: expert_network)

    Returns:
        Updated row as dict (with UUIDs converted to strings)
    """
    # Build SET clause
    set_parts = []
    values = []
    param_num = 1

    for col, val in data.items():
        # Check if this column is a UUID type and needs explicit casting
        # For campaigns table, project_id is UUID (can be NULL)
        if col == "project_id" and val is not None:
            set_parts.append(f"{col} = ${param_num}::uuid")
        else:
            set_parts.append(f"{col} = ${param_num}")
        values.append(val)
        param_num += 1

    set_clause = ', '.join(set_parts)

    # Adjust WHERE clause parameter numbers
    # Need to handle casts like $1::uuid and $2::text properly
    # Replace in reverse order (highest number first) to avoid partial matches
    adjusted_where = where
    where_param_start = param_num
    
    # Build replacement map
    replacements = []
    for i, param in enumerate(where_params):
        param_number = i + 1
        new_param_number = where_param_start + i
        # Check for various cast types
        for cast_type in ['::uuid', '::text', '::int', '::bigint']:
            old_with_cast = f'${param_number}{cast_type}'
            if old_with_cast in adjusted_where:
                new_with_cast = f'${new_param_number}{cast_type}'
                replacements.append((old_with_cast, new_with_cast))
                break
        else:
            # No cast found, replace plain $N
            old_without_cast = f'${param_number}'
            new_without_cast = f'${new_param_number}'
            replacements.append((old_without_cast, new_without_cast))
        values.append(param)
    
    # Apply replacements in reverse order to avoid breaking higher-numbered params
    for old, new in reversed(replacements):
        adjusted_where = adjusted_where.replace(old, new)

    query = f"""
        UPDATE {schema}.{table}
        SET {set_clause}, updated_at = NOW()
        WHERE {adjusted_where}
        RETURNING *
    """

    return await execute_query(query, *values, fetch_one=True)


# Helper functions for common operations

async def get_campaign(campaign_id: str, user_id: str) -> Optional[Dict[str, Any]]:
    """Get a campaign by ID for a specific user."""
    return await execute_query(
        """
        SELECT c.*, p.project_name, p.project_code
        FROM expert_network.campaigns c
        LEFT JOIN expert_network.projects p ON c.project_id = p.id
        WHERE c.id = $1 AND c.user_id = $2
        """,
        campaign_id, user_id,
        fetch_one=True
    )


async def get_user_campaigns(user_id: str) -> List[Dict[str, Any]]:
    """Get all campaigns for a user."""
    return await execute_query(
        """
        SELECT c.*, p.project_name, p.project_code
        FROM expert_network.campaigns c
        LEFT JOIN expert_network.projects p ON c.project_id = p.id
        WHERE c.user_id = $1
        ORDER BY c.display_order, c.created_at DESC
        """,
        user_id,
        fetch_all=True
    )


async def get_campaign_experts(campaign_id: str, user_id: str) -> List[Dict[str, Any]]:
    """Get all experts for a campaign."""
    return await execute_query(
        """
        SELECT e.*, v.name as vendor_name, v.logo_url as vendor_logo
        FROM expert_network.experts e
        JOIN expert_network.vendor_platforms v ON e.vendor_platform_id = v.id
        JOIN expert_network.campaigns c ON e.campaign_id = c.id
        WHERE e.campaign_id = $1 AND c.user_id = $2
        ORDER BY e.created_at DESC
        """,
        campaign_id, user_id,
        fetch_all=True
    )


async def get_vendor_platforms() -> List[Dict[str, Any]]:
    """Get all active vendor platforms."""
    return await execute_query(
        "SELECT * FROM expert_network.vendor_platforms WHERE is_active = true ORDER BY name",
        fetch_all=True
    )


async def enroll_vendor(campaign_id: str, vendor_id: str, user_id: str) -> Optional[Dict[str, Any]]:
    """
    Enroll a vendor for a campaign.
    Verifies campaign belongs to user before enrolling.
    """
    # First verify campaign ownership
    campaign = await get_campaign(campaign_id, user_id)
    if not campaign:
        return None

    # Insert or update enrollment
    async with get_db() as conn:
        result = await conn.fetchrow(
            """
            INSERT INTO expert_network.campaign_vendor_enrollments
                (campaign_id, vendor_platform_id, status)
            VALUES ($1, $2, 'pending')
            ON CONFLICT (campaign_id, vendor_platform_id)
            DO UPDATE SET status = 'pending', updated_at = NOW()
            RETURNING *
            """,
            campaign_id, vendor_id
        )
        if result:
            result_dict = dict(result)
            return convert_uuids_to_strings(result_dict)
        return None


# Startup and shutdown hooks for FastAPI

async def verify_schema():
    """Verify that required schema columns exist."""
    try:
        # Check for client_name column in projects table
        result = await execute_query(
            """
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_schema = 'expert_network' 
            AND table_name = 'projects' 
            AND column_name = 'client_name'
            """,
            fetch_one=True
        )
        if not result:
            print("[DB] WARNING: client_name column not found in projects table")
            print("[DB] WARNING: Make sure migration 005_add_project_fields.sql has been applied")
            return False
        print("[DB] ✓ Schema verification passed: required columns exist")
        return True
    except Exception as e:
        print(f"[DB] WARNING: Could not verify schema: {e}")
        return False


async def startup_db():
    """Initialize database pool on app startup."""
    await init_db_pool()
    # Verify critical schema elements
    await verify_schema()


async def shutdown_db():
    """Close database pool on app shutdown."""
    await close_db_pool()
