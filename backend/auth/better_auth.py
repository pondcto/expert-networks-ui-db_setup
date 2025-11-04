"""
Simple Better Auth Integration for FastAPI

Validates session tokens from Better Auth and extracts user context.
Works with Better Auth's PostgreSQL session storage.

Usage:
    from auth.better_auth import get_current_user, optional_auth

    # Required auth
    @app.get("/protected")
    async def protected_route(user = Depends(get_current_user)):
        return {"user_id": user.user_id, "email": user.email}

    # Optional auth (works with or without token)
    @app.get("/public")
    async def public_route(user = Depends(optional_auth)):
        if user:
            return {"message": f"Hello {user.email}"}
        return {"message": "Hello anonymous"}
"""

import os
import psycopg2
from typing import Optional
from fastapi import Header, HTTPException, Depends
from pydantic import BaseModel
from datetime import datetime


class User(BaseModel):
    """User context from JWT token."""
    user_id: str
    email: Optional[str] = None
    name: Optional[str] = None
    role: Optional[str] = None


class BetterAuthConfig:
    """Configuration for Better Auth integration."""

    def __init__(self):
        # Database URL from env
        self.database_url = os.getenv('DATABASE_URL', 'postgresql://postgres:123456@localhost:5432/ragdb')

        # If no DATABASE_URL, auth is disabled
        self.enabled = self.database_url is not None

        print(f"[BetterAuth] Initialized: {'enabled' if self.enabled else 'disabled (no DATABASE_URL)'}")


# Singleton config
_config: Optional[BetterAuthConfig] = None
_db_conn: Optional[psycopg2.extensions.connection] = None


def get_auth_config() -> BetterAuthConfig:
    """Get Better Auth configuration."""
    global _config
    if _config is None:
        _config = BetterAuthConfig()
    return _config


def get_db_connection():
    """Get database connection for session validation."""
    global _db_conn
    config = get_auth_config()

    if not config.enabled:
        return None

    # Create connection if needed
    if _db_conn is None or _db_conn.closed:
        try:
            _db_conn = psycopg2.connect(config.database_url)
        except Exception as e:
            print(f"[BetterAuth] Database connection failed: {e}")
            return None

    return _db_conn


def validate_session(token: str) -> Optional[dict]:
    """
    Validate session token against Better Auth session table.

    Args:
        token: Session token from Better Auth

    Returns:
        User data if session is valid, None otherwise
    """
    config = get_auth_config()

    if not config.enabled:
        return None

    conn = get_db_connection()
    if not conn:
        return None

    try:
        cursor = conn.cursor()

        # Query session and user tables (Better Auth stores sessions with userId reference)
        cursor.execute("""
            SELECT u.id, u.email, u.name, s."expiresAt"
            FROM public.session s
            JOIN public."user" u ON s."userId" = u.id
            WHERE s.token = %s
        """, (token,))

        result = cursor.fetchone()
        cursor.close()

        if not result:
            return None

        user_id, email, name, expires_at = result

        # Check if session is expired
        if expires_at and expires_at < datetime.now():
            print(f"[BetterAuth] Session expired for user {user_id}")
            return None

        return {
            "id": user_id,
            "email": email,
            "name": name
        }

    except Exception as e:
        print(f"[BetterAuth] Session validation error: {e}")
        return None


async def get_current_user(authorization: Optional[str] = Header(None)) -> User:
    """
    FastAPI dependency to get current user from Better Auth session token.
    Raises 401 if token is missing or invalid.

    Use this for protected endpoints that require authentication.
    """
    config = get_auth_config()

    if not config.enabled:
        # Auth disabled - allow all requests with anonymous user
        print("[BetterAuth] Auth disabled - allowing request")
        return User(user_id="anonymous", email=None, name="Anonymous")

    if not authorization:
        raise HTTPException(
            status_code=401,
            detail="Missing authorization header"
        )

    # Extract token from "Bearer <token>"
    parts = authorization.split()
    if len(parts) != 2 or parts[0].lower() != "bearer":
        raise HTTPException(
            status_code=401,
            detail="Invalid authorization header format"
        )

    token = parts[1]
    user_data = validate_session(token)

    if not user_data:
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired session"
        )

    return User(
        user_id=user_data['id'],
        email=user_data.get('email'),
        name=user_data.get('name'),
        role=None  # Add role support if needed
    )


async def optional_auth(authorization: Optional[str] = Header(None)) -> Optional[User]:
    """
    FastAPI dependency for optional authentication.
    Returns User if session token is valid, None otherwise.

    Use this for endpoints that work with or without authentication.
    """
    config = get_auth_config()

    if not config.enabled:
        # Auth disabled
        return None

    if not authorization:
        # No token provided
        return None

    # Extract token
    parts = authorization.split()
    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None

    token = parts[1]
    user_data = validate_session(token)

    if not user_data:
        return None

    return User(
        user_id=user_data['id'],
        email=user_data.get('email'),
        name=user_data.get('name'),
        role=None  # Add role support if needed
    )
