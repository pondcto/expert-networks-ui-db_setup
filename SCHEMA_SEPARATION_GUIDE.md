# Database Schema Separation - Expert Networks App

## Overview

The Expert Networks application uses a **clean, namespaced schema architecture** to ensure proper tenant isolation and avoid conflicts with existing applications.

---

## Schema Breakdown

### `public` Schema (Shared/Auth)

**Purpose**: Authentication, ACL, and pre-existing applications

**Tables we use**:
- `user` - BetterAuth user accounts
- `session` - BetterAuth session management
- `account` - BetterAuth OAuth accounts
- `verification` - BetterAuth email/phone verification
- `schema_migrations` - Migration tracking for expert_network schema

**Tables we DON'T touch** (pre-existing from other apps):
- `chat_messages`, `chat_sessions`, `chats` - Chat application
- `documents`, `chunks`, `collections` - RAG/document storage
- `project`, `project_members`, `project_mappings` - Pre-existing project system
- `organization`, `org_members` - Organization management
- `alembic_version` - Pre-existing Alembic migrations
- And 7 more...

### `expert_network` Schema (Our Application)

**Purpose**: All Expert Networks application data

**Tables** (11 total):
1. `projects` - Expert research project groupings
2. `campaigns` - Expert research campaigns
3. `vendor_platforms` - Expert network vendors (GLG, AlphaSights, etc.)
4. `campaign_vendor_enrollments` - Vendors enrolled in campaigns
5. `experts` - Expert proposals from vendors
6. `interviews` - Scheduled expert calls
7. `screening_questions` - Questions for expert vetting
8. `expert_screening_responses` - Expert answers
9. `team_members` - Team members in the organization
10. `campaign_team_assignments` - Team members assigned to campaigns
11. `user_ui_preferences` - Per-user UI settings

---

## Why This Architecture?

### ✅ Benefits

1. **Clean Separation**
   - Our app data completely isolated in `expert_network` schema
   - Won't interfere with pre-existing RAG/chat application in `public`
   - Easy to identify which tables belong to which application

2. **Security & Permissions**
   - Can grant/revoke permissions at schema level
   - `GRANT ALL ON SCHEMA expert_network TO raguser;`
   - Easy to restrict access for read-only users

3. **Multi-Tenant Ready**
   - BetterAuth handles user authentication in `public.user`
   - All `expert_network` tables reference `public.user(id)` via `user_id`
   - Clean foreign key relationships across schemas

4. **Easy Backup/Restore**
   - Can backup just `expert_network` schema
   - Won't accidentally affect auth or other apps
   - Easy to migrate to separate database later

5. **No Name Conflicts**
   - Pre-existing `public.project` doesn't conflict with `expert_network.projects`
   - Can coexist peacefully with other applications

---

## Schema References

### From expert_network → public

All expert_network tables reference `public.user` for authentication:

```sql
-- Example: campaigns table
CREATE TABLE expert_network.campaigns (
    id UUID PRIMARY KEY,
    user_id TEXT NOT NULL,  -- References public.user(id) from BetterAuth
    campaign_name TEXT NOT NULL,
    ...
);
```

**User ID Type**: `TEXT` (BetterAuth uses text-based user IDs, not UUIDs)

### Queries Across Schemas

You can easily join across schemas:

```sql
-- Get campaign with user email
SELECT
    c.*,
    u.email as user_email,
    u.name as user_name
FROM expert_network.campaigns c
JOIN public.user u ON c.user_id = u.id
WHERE c.id = $1;
```

---

## Migration Strategy

### Our Migrations

Located in `backend/migrations/`:
- `001_create_expert_network_schema.sql` - Creates schema + all tables
- `002_seed_vendor_platforms.sql` - Seeds vendor data
- `run_migrations.py` - Migration runner

**Tracking**: Uses `public.schema_migrations` table

```sql
CREATE TABLE IF NOT EXISTS public.schema_migrations (
    id SERIAL PRIMARY KEY,
    migration_name VARCHAR(255) UNIQUE NOT NULL,
    applied_at TIMESTAMP DEFAULT NOW()
);
```

### Pre-existing Migrations

The database already has Alembic migrations (tracked in `public.alembic_version`).

**Important**:
- ✅ Our migrations don't interfere with existing Alembic setup
- ✅ We use separate tracking table (`schema_migrations`)
- ✅ We only modify `expert_network` schema

---

## Best Practices

### ✅ DO

1. **Always qualify table names in queries**:
   ```sql
   -- Good
   SELECT * FROM expert_network.campaigns WHERE user_id = $1

   -- Bad (searches public first)
   SELECT * FROM campaigns WHERE user_id = $1
   ```

2. **Use schema prefix in database utilities**:
   ```python
   # Good
   await insert_and_return("campaigns", {...}, schema="expert_network")

   # Also good (default is expert_network)
   await insert_and_return("campaigns", {...})
   ```

3. **Filter by user_id for multi-tenancy**:
   ```sql
   -- Always scope to authenticated user
   SELECT * FROM expert_network.campaigns
   WHERE user_id = $1 AND id = $2
   ```

### ❌ DON'T

1. **Don't create tables in public schema**
   - All new tables go in `expert_network`
   - Keep `public` for auth only

2. **Don't modify pre-existing tables**
   - Don't touch tables from other apps (chat_messages, documents, etc.)
   - Don't modify BetterAuth tables (user, session, etc.)

3. **Don't use unqualified table names**
   - Always use `expert_network.table_name`
   - Prevents accidental queries to wrong schema

---

## Permissions

### Current Setup

```sql
-- Grant schema access
GRANT ALL ON SCHEMA expert_network TO raguser;

-- Grant table access
GRANT ALL ON ALL TABLES IN SCHEMA expert_network TO raguser;

-- Grant sequence access (for auto-increment)
GRANT ALL ON ALL SEQUENCES IN SCHEMA expert_network TO raguser;
```

### Adding Read-Only Users

```sql
-- Create read-only role
CREATE ROLE expert_network_readonly;

-- Grant read access
GRANT USAGE ON SCHEMA expert_network TO expert_network_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA expert_network TO expert_network_readonly;

-- Assign to user
GRANT expert_network_readonly TO some_user;
```

---

## Future: Cost Tracking Extension

If you want to add real cost tracking later (not needed for demo), add:

```sql
CREATE TABLE expert_network.campaign_costs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL REFERENCES expert_network.campaigns(id) ON DELETE CASCADE,
    vendor_platform_id UUID REFERENCES expert_network.vendor_platforms(id),
    fee_type VARCHAR(50) NOT NULL,  -- 'recruiting_fee', 'per_call', 'subscription'
    amount_usd DECIMAL(10,2) NOT NULL,
    units INTEGER,  -- Number of calls, hours, etc.
    memo TEXT,
    invoice_date DATE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_campaign_costs_campaign ON expert_network.campaign_costs(campaign_id);
CREATE INDEX idx_campaign_costs_vendor ON expert_network.campaign_costs(vendor_platform_id);
```

**For demo**: The transcript ratings and enrollments tell a good story without needing detailed cost tracking.

---

## Verification

Check schema separation:

```bash
# List tables by schema
psql postgresql://raguser:ragpass@localhost:5432/ragdb -c "
  SELECT
    schemaname,
    tablename,
    CASE
      WHEN schemaname = 'public' AND tablename IN ('user', 'session', 'account', 'verification')
        THEN 'BetterAuth'
      WHEN schemaname = 'expert_network'
        THEN 'Expert Networks App'
      ELSE 'Other App'
    END as purpose
  FROM pg_tables
  WHERE schemaname IN ('public', 'expert_network')
  ORDER BY schemaname, tablename;
"
```

**Expected**:
- `public` schema: 4 BetterAuth tables + pre-existing app tables
- `expert_network` schema: 11 Expert Networks tables

---

## Summary

✅ **Clean Architecture**
- `public` schema = BetterAuth + pre-existing apps (hands off!)
- `expert_network` schema = Our application (full control)

✅ **No Conflicts**
- Our `expert_network.projects` doesn't conflict with `public.project`
- Clean coexistence with other applications

✅ **Easy Permissions**
- Schema-level grants for clean ACL
- Can easily add read-only users

✅ **Multi-Tenant Ready**
- All queries scoped to `user_id` from BetterAuth
- Foreign key to `public.user(id)` for auth integration

**Result**: Production-ready schema architecture with proper isolation! 🎉
