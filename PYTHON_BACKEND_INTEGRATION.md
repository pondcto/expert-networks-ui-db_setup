# Expert Networks - Python Backend Integration Summary

## Your Current Setup ✅

- **Backend**: Python FastAPI
- **Database**: PostgreSQL at `postgresql+asyncpg://raguser:ragpass@localhost:5432/ragdb`
- **Auth**: BetterAuth (already working with `public` schema)
- **Async Driver**: asyncpg (already installed)
- **Migration Tools**: Alembic + SQLAlchemy (already installed)

---

## What We Created

### 1. **Separate Schema Architecture** ✅

```
ragdb database
├── public schema (BetterAuth - hands off!)
│   ├── user
│   ├── session
│   ├── account
│   └── verification
│
└── expert_network schema (Your app - safe to modify!)
    ├── projects
    ├── campaigns
    ├── experts
    ├── interviews
    └── 15+ other tables
```

**Why separate schemas?**
- Clean isolation from auth tables
- Can't accidentally break authentication
- Easy to backup/restore independently
- Clear ownership boundaries

### 2. **Migration Files** (SQL-based)

Created in `backend/migrations/`:

1. **001_create_expert_network_schema.sql**
   - Creates `expert_network` schema
   - All 15+ application tables
   - Proper foreign keys and constraints
   - Triggers for updated_at timestamps
   - All indexes for performance

2. **002_seed_vendor_platforms.sql**
   - Seeds 18 vendor platforms (GLG, AlphaSights, etc.)
   - Ready for immediate use

3. **run_migrations.py**
   - Simple Python migration runner
   - Tracks executed migrations in `public.schema_migrations`
   - No complex framework needed

### 3. **Database Utility Module**

Created `backend/db.py`:
- Async connection pooling with asyncpg
- Helper functions for common operations
- Schema-aware queries (uses `expert_network.` prefix)
- Integration with BetterAuth user context

### 4. **Documentation**

- **MIGRATION_SETUP.md** - Complete setup guide
- **PYTHON_BACKEND_INTEGRATION.md** - This file

---

## Quick Start

### 1. Install Dependencies

```bash
cd backend
pip install -r requirements.txt
```

This installs:
- ✅ `asyncpg` (already had it)
- ✅ `alembic` + `SQLAlchemy` (already had them)
- ✅ `psycopg2-binary` (added for migration runner)

### 2. Run Migrations

```bash
cd backend/migrations
python run_migrations.py

# Output:
# ✓ Migrations table initialized
# Found 2 pending migration(s)
# ✓ Migration completed: 001_create_expert_network_schema
# ✓ Migration completed: 002_seed_vendor_platforms
# ✓ Completed: 2/2 migrations
```

### 3. Verify

```bash
# Check the new schema exists
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "\dn"

# Should show:
#   expert_network | raguser
#   public         | raguser

# Check tables
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  SELECT tablename FROM pg_tables
  WHERE schemaname = 'expert_network';
"

# Verify vendors were seeded
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  SELECT name FROM expert_network.vendor_platforms;
"
```

---

## Using in Your FastAPI App

### Setup (main.py)

```python
from fastapi import FastAPI
from db import startup_db, shutdown_db

app = FastAPI()

# Register database lifecycle
app.add_event_handler("startup", startup_db)
app.add_event_handler("shutdown", shutdown_db)
```

### Example Endpoints

```python
from fastapi import Depends, HTTPException
from auth.better_auth import get_current_user
from db import get_user_campaigns, get_campaign, insert_and_return

@app.get("/api/campaigns")
async def list_campaigns(user = Depends(get_current_user)):
    """Get all campaigns for logged-in user."""
    campaigns = await get_user_campaigns(user.user_id)
    return {"campaigns": campaigns}

@app.get("/api/campaigns/{campaign_id}")
async def get_campaign_detail(
    campaign_id: str,
    user = Depends(get_current_user)
):
    """Get single campaign with details."""
    campaign = await get_campaign(campaign_id, user.user_id)
    if not campaign:
        raise HTTPException(404, "Campaign not found")
    return campaign

@app.post("/api/campaigns")
async def create_campaign(
    data: dict,  # Use Pydantic model in production
    user = Depends(get_current_user)
):
    """Create new campaign."""
    campaign = await insert_and_return(
        "campaigns",
        {
            "user_id": user.user_id,
            "campaign_name": data["campaignName"],
            "industry_vertical": data["industryVertical"],
            "start_date": data["startDate"],
            "target_completion_date": data["targetCompletionDate"],
            "target_regions": data["targetRegions"],
            "min_calls": data.get("minCalls"),
            "max_calls": data.get("maxCalls"),
        }
    )
    return campaign
```

---

## Key Differences from Original Plan

### Original (Next.js with Drizzle)
❌ TypeScript backend
❌ Drizzle ORM (TypeScript only)
❌ Next.js API routes
❌ All in `public` schema

### Actual (Python FastAPI with asyncpg)
✅ Python backend (FastAPI)
✅ asyncpg (native async PostgreSQL driver)
✅ Separate `expert_network` schema
✅ Simple SQL migrations (no ORM needed)
✅ BetterAuth integration preserved

---

## Do You Need Drizzle? ❌ NO!

**Drizzle is for TypeScript/Node.js only.**

You have **Python FastAPI**, so your options are:

| Option | When to Use | Pros | Cons |
|--------|-------------|------|------|
| **asyncpg** (current) | Direct SQL queries | Fastest, full control, simple | Write raw SQL |
| **SQLAlchemy** | Want ORM features | Type-safe, auto-migrations | More complex, slower |
| **Alembic only** | Just migrations | Simple, SQL-based | Still need query library |

**We're using asyncpg because:**
- You already have it installed
- It's the fastest async PostgreSQL driver
- Simple and Pythonic
- Direct SQL queries give you full control
- No learning curve for ORM

---

## Migration Strategy

### You Already Have Alembic

Since you already have `alembic>=1.16.0` installed, you could use Alembic instead of my simple runner. Here's how:

```bash
cd backend

# Initialize Alembic (if not done)
alembic init alembic

# Edit alembic.ini
# Set: sqlalchemy.url = postgresql+asyncpg://raguser:ragpass@localhost:5432/ragdb

# Create a migration from existing SQL
alembic revision -m "create_expert_network_schema"

# Edit the generated migration file in alembic/versions/
# Paste the SQL from 001_create_expert_network_schema.sql

# Run migration
alembic upgrade head
```

**OR** just use my simple Python runner (simpler for SQL files):

```bash
python migrations/run_migrations.py
```

Both work fine! Choose based on preference:
- **Simple runner**: Easy, SQL-based, no config needed
- **Alembic**: More features, auto-generate from models, built-in rollback

---

## BetterAuth Integration

### Your existing better_auth.py already works! ✅

```python
from auth.better_auth import get_current_user

@app.get("/protected")
async def protected_route(user = Depends(get_current_user)):
    # user.user_id references public.user(id)
    # All queries filter by user.user_id
    return {"user_id": user.user_id}
```

### How it works:

1. User signs in → BetterAuth creates session in `public.session`
2. Frontend sends `Authorization: Bearer <token>` header
3. `get_current_user()` validates token against `public.session`
4. Returns `User` object with `user_id`
5. All queries filter by `user_id` for multi-tenancy

---

## Schema-Qualified Queries

**Always use schema prefix in queries:**

```python
# ✅ CORRECT
"SELECT * FROM expert_network.campaigns WHERE user_id = $1"

# ❌ WRONG (searches public schema first)
"SELECT * FROM campaigns WHERE user_id = $1"
```

**Joining across schemas:**

```python
# Campaign with user details (join public + expert_network)
query = """
    SELECT
        c.*,
        u.email as user_email,
        u.name as user_name
    FROM expert_network.campaigns c
    JOIN public.user u ON c.user_id = u.id
    WHERE c.id = $1
"""
```

---

## Testing the Setup

### 1. Run migrations

```bash
cd backend/migrations
python run_migrations.py
```

### 2. Check database

```bash
psql postgresql://raguser:ragpass@localhost:5432/ragdb

-- List schemas
\dn

-- List tables in expert_network
\dt expert_network.*

-- Check vendors
SELECT COUNT(*) FROM expert_network.vendor_platforms;
-- Should return: 18

-- Check BetterAuth tables still there
\dt public.*
-- Should show: user, session, account, verification
```

### 3. Test a query

```python
# In Python shell or test endpoint
import asyncio
from db import get_vendor_platforms

async def test():
    vendors = await get_vendor_platforms()
    print(f"Found {len(vendors)} vendors")
    for v in vendors[:3]:
        print(f"  - {v['name']}: ${v['avg_cost_per_call_min']}-{v['avg_cost_per_call_max']}")

asyncio.run(test())

# Output:
# Found 18 vendors
#   - AlphaSights: $700-1400
#   - Atheneum: $650-1250
#   - Brainworks: $600-1200
```

---

## Next Steps

1. ✅ **Database schema created** (expert_network schema)
2. ✅ **Migrations ready** (run_migrations.py)
3. ✅ **Database utility created** (db.py)
4. ⬜ **Create API endpoints** (campaigns, experts, vendors)
5. ⬜ **Update frontend** to call API instead of localStorage
6. ⬜ **LLM mock backend** (vendor simulator with OpenAI)
7. ⬜ **Test end-to-end** flow

---

## Common Questions

### Q: Can I use both localStorage and database during migration?
**A:** Yes! Run both in parallel. Read from database, fallback to localStorage if not found.

### Q: Do I need to rewrite all frontend code at once?
**A:** No! Migrate incrementally:
1. Start with campaigns API
2. Then experts
3. Then interviews
4. Keep localStorage as fallback during transition

### Q: Should I use SQLAlchemy ORM?
**A:** Only if you want ORM features. asyncpg with raw SQL is simpler and faster.

### Q: Can I add indexes later?
**A:** Yes! Create new migration: `003_add_indexes.sql`

### Q: How do I handle the LLM part mentioned in your context?
**A:** You mentioned entity extraction and fuzzy matching - that's separate from this database work. The database will store the results, but the LLM logic goes in your FastAPI endpoints.

---

## File Summary

Created/Modified files:

```
backend/
├── migrations/
│   ├── 001_create_expert_network_schema.sql  (NEW)
│   ├── 002_seed_vendor_platforms.sql         (NEW)
│   └── run_migrations.py                     (NEW)
├── db.py                                      (NEW)
├── requirements.txt                           (UPDATED)
└── MIGRATION_SETUP.md                         (NEW)

Root/
├── PYTHON_BACKEND_INTEGRATION.md              (NEW - this file)
├── database_schema.md                         (UPDATED for schema)
├── LLM_MOCK_BACKEND.md                        (UPDATED for Python)
└── schema.sql                                 (REFERENCE - not using)
```

---

## Support

If you have questions:

1. Check [MIGRATION_SETUP.md](backend/MIGRATION_SETUP.md) for detailed setup
2. Review [database_schema.md](database_schema.md) for schema details
3. Look at `backend/db.py` for example queries
4. Check your existing `better_auth.py` - it already works!

---

## Summary

✅ **No Drizzle needed** - you have Python, not TypeScript
✅ **Using asyncpg** - already installed, fast, async
✅ **Separate schema** - `expert_network` isolates your app from auth
✅ **BetterAuth works** - just reference `public.user(id)`
✅ **Simple migrations** - SQL files + Python runner
✅ **Ready to code** - db.py has helpers, auth is integrated

**Next**: Run migrations, create API endpoints, update frontend! 🚀
