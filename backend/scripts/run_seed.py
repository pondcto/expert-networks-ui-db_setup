#!/usr/bin/env python3
"""
Script to run the seed_sample_data.sql file.

Usage:
    python scripts/run_seed.py
    python scripts/run_seed.py --file ../seed_sample_data.sql
"""

import os
import sys
import psycopg2
from pathlib import Path

# Database connection from environment
DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:123456@localhost:5432/ragdb')

def get_connection():
    """Get database connection (synchronous)."""
    # Convert asyncpg URL to psycopg2 format
    url = DATABASE_URL.replace('postgresql+asyncpg://', 'postgresql://')
    return psycopg2.connect(url)

def run_seed_script(sql_file_path):
    """Execute the seed SQL script."""
    print(f"Running seed script: {sql_file_path}")
    print("=" * 60)
    
    conn = get_connection()
    
    try:
        with open(sql_file_path, 'r', encoding='utf-8') as f:
            sql = f.read()
        
        with conn.cursor() as cur:
            # Execute the seed script
            cur.execute(sql)
        
        conn.commit()
        print("\n✓ Seed script completed successfully!")
        print("=" * 60)
        
        # Show summary
        with conn.cursor() as cur:
            cur.execute("""
                SELECT 
                    (SELECT COUNT(*) FROM expert_network.projects WHERE user_id = 'demo-user-123') as projects,
                    (SELECT COUNT(*) FROM expert_network.campaigns WHERE user_id = 'demo-user-123') as campaigns,
                    (SELECT COUNT(*) FROM expert_network.team_members WHERE user_id = 'demo-user-123') as team_members,
                    (SELECT COUNT(*) FROM expert_network.experts e 
                     JOIN expert_network.campaigns c ON e.campaign_id = c.id 
                     WHERE c.user_id = 'demo-user-123') as experts,
                    (SELECT COUNT(*) FROM expert_network.interviews i 
                     JOIN expert_network.campaigns c ON i.campaign_id = c.id 
                     WHERE c.user_id = 'demo-user-123') as interviews,
                    (SELECT COUNT(*) FROM expert_network.screening_questions sq 
                     JOIN expert_network.campaigns c ON sq.campaign_id = c.id 
                     WHERE c.user_id = 'demo-user-123') as screening_questions,
                    (SELECT COUNT(*) FROM expert_network.expert_screening_responses esr
                     JOIN expert_network.experts e ON esr.expert_id = e.id
                     JOIN expert_network.campaigns c ON e.campaign_id = c.id
                     WHERE c.user_id = 'demo-user-123') as screening_responses
            """)
            result = cur.fetchone()
            
            print("\nData Summary:")
            print(f"  Projects: {result[0]}")
            print(f"  Campaigns: {result[1]}")
            print(f"  Team Members: {result[2]}")
            print(f"  Experts: {result[3]}")
            print(f"  Interviews: {result[4]}")
            print(f"  Screening Questions: {result[5]}")
            print(f"  Screening Responses: {result[6]}")
            print("=" * 60)
        
        return True
        
    except Exception as e:
        conn.rollback()
        print(f"\n✗ Seed script failed!")
        print(f"  Error: {e}")
        import traceback
        traceback.print_exc()
        return False
    finally:
        conn.close()

def main():
    """Main entry point."""
    # Get script path
    if len(sys.argv) > 1 and sys.argv[1] == '--file':
        sql_file = sys.argv[2]
    else:
        # Default to seed_sample_data.sql in project root
        script_dir = Path(__file__).parent.parent.parent
        sql_file = script_dir / 'seed_sample_data.sql'
    
    if not os.path.exists(sql_file):
        print(f"✗ Error: Seed file not found: {sql_file}")
        print(f"\nUsage:")
        print(f"  python scripts/run_seed.py")
        print(f"  python scripts/run_seed.py --file <path_to_seed.sql>")
        sys.exit(1)
    
    success = run_seed_script(sql_file)
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()

