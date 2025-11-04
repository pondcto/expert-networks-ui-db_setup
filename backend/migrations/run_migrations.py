#!/usr/bin/env python3
"""
Simple SQL migration runner for expert_network schema.

Usage:
    python run_migrations.py             # Run all pending migrations
    python run_migrations.py --rollback  # Rollback last migration
    python run_migrations.py --status    # Show migration status
"""

import os
import sys
import psycopg2
from pathlib import Path
from datetime import datetime

# Database connection from environment
DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:123456@localhost:5432/ragdb')

def get_connection():
    """Get database connection (synchronous)."""
    # Convert asyncpg URL to psycopg2 format
    url = DATABASE_URL.replace('postgresql+asyncpg://', 'postgresql://')
    return psycopg2.connect(url)

def init_migrations_table(conn):
    """Create migrations tracking table if it doesn't exist."""
    with conn.cursor() as cur:
        cur.execute("""
            CREATE TABLE IF NOT EXISTS public.schema_migrations (
                id SERIAL PRIMARY KEY,
                migration_name TEXT NOT NULL UNIQUE,
                executed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
            );
        """)
        conn.commit()
    print("✓ Migrations table initialized")

def get_executed_migrations(conn):
    """Get list of executed migrations."""
    with conn.cursor() as cur:
        cur.execute("SELECT migration_name FROM public.schema_migrations ORDER BY id")
        return [row[0] for row in cur.fetchall()]

def get_migration_files():
    """Get sorted list of migration SQL files."""
    migrations_dir = Path(__file__).parent
    files = sorted(migrations_dir.glob('*.sql'))
    return [(f.stem, f) for f in files]

def run_migration(conn, name, file_path):
    """Execute a single migration file."""
    print(f"Running migration: {name}")

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            sql = f.read()

        with conn.cursor() as cur:
            # Execute migration
            cur.execute(sql)

            # Record migration
            cur.execute(
                "INSERT INTO public.schema_migrations (migration_name) VALUES (%s)",
                (name,)
            )

        conn.commit()
        print(f"✓ Migration completed: {name}")
        return True

    except Exception as e:
        conn.rollback()
        print(f"✗ Migration failed: {name}")
        print(f"  Error: {e}")
        return False

def show_status():
    """Show migration status."""
    conn = get_connection()
    init_migrations_table(conn)

    executed = get_executed_migrations(conn)
    available = get_migration_files()

    print("\nMigration Status:")
    print("=" * 60)

    if not available:
        print("No migration files found")
        return

    for name, _ in available:
        status = "✓ APPLIED" if name in executed else "○ PENDING"
        print(f"{status}  {name}")

    print("=" * 60)
    print(f"Total: {len(available)} migrations, {len(executed)} applied, {len(available) - len(executed)} pending")

    conn.close()

def run_migrations():
    """Run all pending migrations."""
    conn = get_connection()

    print("\nInitializing migrations...")
    init_migrations_table(conn)

    executed = get_executed_migrations(conn)
    available = get_migration_files()

    pending = [(name, path) for name, path in available if name not in executed]

    if not pending:
        print("\n✓ No pending migrations")
        conn.close()
        return

    print(f"\nFound {len(pending)} pending migration(s):")
    for name, _ in pending:
        print(f"  - {name}")

    print("\nExecuting migrations...\n")

    success_count = 0
    for name, path in pending:
        if run_migration(conn, name, path):
            success_count += 1
        else:
            print("\n✗ Migration failed. Stopping.")
            break

    print(f"\n{'✓' if success_count == len(pending) else '✗'} Completed: {success_count}/{len(pending)} migrations")

    conn.close()

def main():
    """Main entry point."""
    args = sys.argv[1:]

    if '--status' in args:
        show_status()
    elif '--rollback' in args:
        print("Rollback not implemented yet. Manually rollback using SQL.")
        sys.exit(1)
    else:
        run_migrations()

if __name__ == '__main__':
    main()
