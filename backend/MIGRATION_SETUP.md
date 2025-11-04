# Expert Networks Backend - Database Migration Setup

## Overview

Your setup:
- **Database**: PostgreSQL at `postgresql+asyncpg://raguser:ragpass@localhost:5432/ragdb`
- **Schemas**:
  - `public` schema: BetterAuth tables (user, session, account, verification)
  - `expert_network` schema: Your application tables (NEW)
- **Backend**: Python FastAPI with asyncpg
- **Auth**: BetterAuth integration already working

## Why Separate Schemas?

```
ragdb database
├── public schema (BetterAuth - DO NOT MODIFY)
│   ├── user
│   ├── session
│   ├── account
│   └── verification
│
└── expert_network schema (Your app - SAFE TO MODIFY)
    ├── projects
    ├── campaigns
    ├── experts
    └── ... (all app tables)
```

Benefits:
- ✅ Clean separation of concerns
- ✅ Can't accidentally break auth tables
- ✅ Easy to backup/restore separately
- ✅ Clear ownership boundaries

---

## Setup Steps

### 1. Install Dependencies

```bash
cd backend
pip install -r requirements.txt
```

This installs:
- `psycopg2-binary` - For running migrations (synchronous)
- `asyncpg` - For app runtime (asynchronous)
- `sqlalchemy` - Optional, for future ORM support

### 2. Verify Database Connection

```bash
# Test connection
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "SELECT version();"

# Check existing schemas
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "\dn"

# You should see:
#   public    | raguser
```

### 3. Run Migrations

```bash
cd backend/migrations
python run_migrations.py

# Output:
# Initializing migrations...
# ✓ Migrations table initialized
#
# Found 2 pending migration(s):
#   - 001_create_expert_network_schema
#   - 002_seed_vendor_platforms
#
# Executing migrations...
#
# Running migration: 001_create_expert_network_schema
# ✓ Migration completed: 001_create_expert_network_schema
# Running migration: 002_seed_vendor_platforms
# ✓ Migration completed: 002_seed_vendor_platforms
#
# ✓ Completed: 2/2 migrations
```

### 4. Verify Schema Creation

```bash
# Check schemas
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "\dn"

# You should now see:
#   expert_network | raguser
#   public         | raguser

# Check tables in expert_network schema
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  SELECT tablename FROM pg_tables
  WHERE schemaname = 'expert_network'
  ORDER BY tablename;
"

# You should see:
#   campaign_team_assignments
#   campaign_vendor_enrollments
#   campaigns
#   expert_screening_responses
#   experts
#   interviews
#   projects
#   screening_questions
#   team_members
#   user_ui_preferences
#   vendor_platforms

# Check vendor platforms were seeded
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  SELECT COUNT(*) FROM expert_network.vendor_platforms;
"

# Should return: 18
```

---

## Using the Database in Your App

### Option 1: Using the db.py utility (Recommended)

```python
# backend/main.py
from fastapi import FastAPI, Depends
from db import startup_db, shutdown_db, get_user_campaigns
from auth.better_auth import get_current_user

app = FastAPI()

# Register lifecycle hooks
app.add_event_handler("startup", startup_db)
app.add_event_handler("shutdown", shutdown_db)

# Use in endpoints
@app.get("/api/campaigns")
async def list_campaigns(user = Depends(get_current_user)):
    campaigns = await get_user_campaigns(user.user_id)
    return {"campaigns": campaigns}
```

### Option 2: Direct asyncpg usage

```python
from db import get_db

@app.get("/api/campaigns")
async def list_campaigns(user = Depends(get_current_user)):
    async with get_db() as conn:
        campaigns = await conn.fetch(
            """
            SELECT * FROM expert_network.campaigns
            WHERE user_id = $1
            ORDER BY created_at DESC
            """,
            user.user_id
        )
        return {"campaigns": [dict(c) for c in campaigns]}
```

### Option 3: Using helper functions

```python
from db import get_campaign, enroll_vendor

@app.get("/api/campaigns/{campaign_id}")
async def get_campaign_detail(
    campaign_id: str,
    user = Depends(get_current_user)
):
    campaign = await get_campaign(campaign_id, user.user_id)
    if not campaign:
        raise HTTPException(404, "Campaign not found")
    return campaign

@app.post("/api/vendors/enroll")
async def enroll_vendor_endpoint(
    campaign_id: str,
    vendor_id: str,
    user = Depends(get_current_user)
):
    enrollment = await enroll_vendor(campaign_id, vendor_id, user.user_id)
    if not enrollment:
        raise HTTPException(404, "Campaign not found")
    return enrollment
```

---

## Migration Commands

### Check migration status
```bash
python run_migrations.py --status
```

Output:
```
Migration Status:
============================================================
✓ APPLIED  001_create_expert_network_schema
✓ APPLIED  002_seed_vendor_platforms
============================================================
Total: 2 migrations, 2 applied, 0 pending
```

### Run pending migrations
```bash
python run_migrations.py
```

### Create new migration
```bash
# Create new file: 003_add_new_feature.sql
# Add your SQL code
# Run: python run_migrations.py
```

---

## Database Access Patterns

### Always Filter by user_id

```python
# ✅ CORRECT - Filters by user_id
campaigns = await conn.fetch(
    "SELECT * FROM expert_network.campaigns WHERE user_id = $1",
    user.user_id
)

# ❌ WRONG - Returns all users' campaigns
campaigns = await conn.fetch(
    "SELECT * FROM expert_network.campaigns"
)
```

### Use Schema-Qualified Table Names

```python
# ✅ CORRECT
"SELECT * FROM expert_network.campaigns"

# ❌ WRONG (will search public schema first)
"SELECT * FROM campaigns"
```

### Join with BetterAuth Tables

```python
# Get campaign with user details
query = """
    SELECT
        c.*,
        u.email as creator_email,
        u.name as creator_name
    FROM expert_network.campaigns c
    JOIN public.user u ON c.user_id = u.id
    WHERE c.id = $1
"""
```

---

## Common Queries

### Create a campaign
```python
from db import insert_and_return

campaign = await insert_and_return(
    "campaigns",
    {
        "user_id": user.user_id,
        "project_id": project_id,
        "campaign_name": "TechCo DD",
        "industry_vertical": "Healthcare Technology",
        "brief_description": "...",
        "start_date": "2025-01-15",
        "target_completion_date": "2025-02-15",
        "target_regions": ["North America", "Europe"],
        "min_calls": 15,
        "max_calls": 20
    }
)
```

### Update a campaign
```python
from db import update_and_return

updated = await update_and_return(
    "campaigns",
    {"campaign_name": "New Name", "min_calls": 20},
    where="id = $1 AND user_id = $2",
    where_params=[campaign_id, user.user_id]
)
```

### Get campaign with relationships
```python
query = """
    SELECT
        c.*,
        p.project_name,
        (SELECT COUNT(*) FROM expert_network.experts WHERE campaign_id = c.id) as expert_count,
        (SELECT COUNT(*) FROM expert_network.interviews WHERE campaign_id = c.id) as interview_count
    FROM expert_network.campaigns c
    LEFT JOIN expert_network.projects p ON c.project_id = p.id
    WHERE c.id = $1 AND c.user_id = $2
"""
```

---

## Troubleshooting

### Connection issues
```bash
# Test connection
psql postgresql://raguser:ragpass@localhost:5432/ragdb

# If fails, check:
# 1. Is PostgreSQL running?
systemctl status postgresql  # Linux
brew services list  # Mac

# 2. Is port 5432 open?
netstat -an | grep 5432

# 3. Check DATABASE_URL in .env
echo $DATABASE_URL
```

### Schema not found
```bash
# List schemas
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "\dn"

# If expert_network missing, run migrations
python run_migrations.py
```

### Permission denied
```bash
# Grant permissions
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  GRANT ALL ON SCHEMA expert_network TO raguser;
  GRANT ALL ON ALL TABLES IN SCHEMA expert_network TO raguser;
"
```

### Migration tracking issues
```bash
# Check migrations table
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  SELECT * FROM public.schema_migrations;
"

# Reset if needed (CAREFUL!)
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  DROP TABLE IF EXISTS public.schema_migrations;
"
python run_migrations.py  # Re-run all
```

---

## Best Practices

### 1. Always use prepared statements
```python
# ✅ CORRECT - SQL injection safe
await conn.fetch("SELECT * FROM expert_network.campaigns WHERE id = $1", campaign_id)

# ❌ WRONG - SQL injection vulnerable
await conn.fetch(f"SELECT * FROM expert_network.campaigns WHERE id = '{campaign_id}'")
```

### 2. Use transactions for multi-step operations
```python
async with get_db() as conn:
    async with conn.transaction():
        # All or nothing
        campaign = await conn.fetchrow("INSERT INTO ... RETURNING *")
        await conn.execute("INSERT INTO team_assignments ...")
        await conn.execute("INSERT INTO screening_questions ...")
```

### 3. Handle NULL values
```python
# PostgreSQL returns None for NULL
campaign = await get_campaign(id, user_id)
project_name = campaign.get('project_name') or 'No project'  # Handle NULL
```

### 4. Use connection pooling
```python
# ✅ CORRECT - Uses pool from db.py
async with get_db() as conn:
    ...

# ❌ WRONG - Creates new connection each time
conn = await asyncpg.connect(DATABASE_URL)
```

---

## Next Steps

1. ✅ Migrations are set up
2. ⬜ Create FastAPI endpoints (see `db.py` examples)
3. ⬜ Update frontend to call API instead of localStorage
4. ⬜ Set up LLM mock backend (vendor simulator)
5. ⬜ Test complete user flow
6. ⬜ Deploy to production

---

## No Drizzle Needed!

**Q: Do I need Drizzle ORM?**
**A: No!** Drizzle is for TypeScript/Node.js. You have Python FastAPI.

Your options:
1. ✅ **asyncpg directly** (what we're using) - fastest, most control
2. ✅ **SQLAlchemy ORM** - if you want an ORM later
3. ❌ **Drizzle** - TypeScript only, not compatible

We're using **asyncpg** because:
- Native async/await support
- Best performance for PostgreSQL
- Simple and Pythonic
- Already in your DATABASE_URL

---

## Questions?

Common questions:

**Q: Can I still use localStorage temporarily?**
A: Yes! Run both in parallel during migration.

**Q: How do I rollback a migration?**
A: Write a rollback SQL file and run manually for now. Alembic provides automatic rollbacks if you want that later.

**Q: Should I use SQLAlchemy?**
A: Only if you want ORM features. asyncpg is simpler and faster for direct queries.

**Q: How do I add indexes later?**
A: Create a new migration file with `CREATE INDEX` statements.

**Q: Can I test queries directly?**
A: Yes! Use `psql` or any PostgreSQL client. Schema is `expert_network`.
