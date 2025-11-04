# Database Export Guide

## Quick Reference

Your `expert_network` schema has been exported to: **`expert_network_backup.sql`** (34 KB)

---

## Export Commands

### Complete Backup (Schema + Data)
```bash
pg_dump -h localhost -U raguser -d ragdb -n expert_network -F p -f expert_network_backup.sql
```
**What it contains**: Everything - schema, tables, data, indexes, triggers

### Schema Only (No Data)
```bash
pg_dump -h localhost -U raguser -d ragdb -n expert_network --schema-only -f expert_network_schema_only.sql
```
**Use case**: Share table structures without data

### Data Only (No Schema)
```bash
pg_dump -h localhost -U raguser -d ragdb -n expert_network --data-only -f expert_network_data_only.sql
```
**Use case**: Migrate data to existing schema

### Compressed Format
```bash
pg_dump -h localhost -U raguser -d ragdb -n expert_network -F c -f expert_network.dump
```
**Use case**: Smaller file size, but not human-readable

### Single Table Export
```bash
# Just vendors
pg_dump -h localhost -U raguser -d ragdb -t expert_network.vendor_platforms -f vendors.sql

# Just campaigns
pg_dump -h localhost -U raguser -d ragdb -t expert_network.campaigns -f campaigns.sql
```

---

## Restore Commands

### Restore Complete Backup
```bash
psql -h localhost -U raguser -d ragdb -f expert_network_backup.sql
```

### Clean Restore (Drop First)
```bash
# Drop existing schema
psql -h localhost -U raguser -d ragdb -c "DROP SCHEMA IF EXISTS expert_network CASCADE;"

# Restore from backup
psql -h localhost -U raguser -d ragdb -f expert_network_backup.sql
```

### Restore to Different Database
```bash
psql -h localhost -U raguser -d other_database -f expert_network_backup.sql
```

### Restore Compressed Backup
```bash
pg_restore -h localhost -U raguser -d ragdb -n expert_network expert_network.dump
```

---

## What's in the Backup File

### 1. Schema Creation
```sql
CREATE SCHEMA expert_network;
ALTER SCHEMA expert_network OWNER TO raguser;
```

### 2. Helper Function
```sql
CREATE FUNCTION expert_network.update_updated_at_column() ...
```

### 3. Table Definitions (11 tables)
- campaign_team_assignments
- campaign_vendor_enrollments
- campaigns
- expert_screening_responses
- experts
- interviews
- projects
- screening_questions
- team_members
- user_ui_preferences
- vendor_platforms

### 4. Indexes
- Primary keys
- Foreign key indexes
- Performance indexes

### 5. Foreign Keys
- Relationships between tables
- Cascade rules

### 6. Triggers
- Auto-update `updated_at` timestamps

### 7. Data
- 18 vendor platforms with enhanced tags
- Any other data in the schema

---

## File Structure

```
expert_network_backup.sql
├── Header (PostgreSQL version, settings)
├── Schema creation
├── Functions
├── Table definitions
│   ├── CREATE TABLE statements
│   ├── Column definitions
│   └── Constraints
├── Data (INSERT statements)
├── Indexes
├── Foreign keys
└── Triggers
```

---

## Common Use Cases

### 1. Backup Before Changes
```bash
# Before running new migrations
pg_dump -h localhost -U raguser -d ragdb -n expert_network -f backup_$(date +%Y%m%d).sql
```

### 2. Share with Team
```bash
# Export and share
pg_dump -h localhost -U raguser -d ragdb -n expert_network -f expert_network.sql

# Team member restores
psql -h localhost -U their_user -d their_db -f expert_network.sql
```

### 3. Development → Staging → Production
```bash
# Export from dev
pg_dump -h dev-host -U raguser -d ragdb -n expert_network -f expert_network_dev.sql

# Import to staging
psql -h staging-host -U raguser -d ragdb -f expert_network_dev.sql

# Import to production
psql -h prod-host -U raguser -d ragdb -f expert_network_dev.sql
```

### 4. Reset to Clean State
```bash
# Drop and restore
psql -h localhost -U raguser -d ragdb << EOF
DROP SCHEMA IF EXISTS expert_network CASCADE;
\i expert_network_backup.sql
EOF
```

---

## Viewing Backup Contents

### Count Lines
```bash
wc -l expert_network_backup.sql
```

### View Table List
```bash
grep "CREATE TABLE" expert_network_backup.sql
```

### View INSERT Statements
```bash
grep "INSERT INTO" expert_network_backup.sql
```

### Check Vendor Data
```bash
grep "GLG\|AlphaSights\|Guidepoint" expert_network_backup.sql
```

---

## Advanced Options

### Exclude Specific Tables
```bash
pg_dump -h localhost -U raguser -d ragdb \
  -n expert_network \
  -T expert_network.user_ui_preferences \
  -f expert_network_no_prefs.sql
```

### Include Only Specific Tables
```bash
pg_dump -h localhost -U raguser -d ragdb \
  -t expert_network.vendor_platforms \
  -t expert_network.campaigns \
  -t expert_network.experts \
  -f expert_network_core.sql
```

### With Verbose Output
```bash
pg_dump -h localhost -U raguser -d ragdb \
  -n expert_network \
  -v -f expert_network_backup.sql
```

### Split Data and Schema
```bash
# Schema
pg_dump -h localhost -U raguser -d ragdb \
  -n expert_network --schema-only \
  -f expert_network_schema.sql

# Data
pg_dump -h localhost -U raguser -d ragdb \
  -n expert_network --data-only \
  -f expert_network_data.sql
```

---

## Automated Backups

### Daily Backup Script (bash)
```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/expert_network"
mkdir -p $BACKUP_DIR

pg_dump -h localhost -U raguser -d ragdb \
  -n expert_network \
  -f "$BACKUP_DIR/expert_network_$DATE.sql"

# Keep only last 7 days
find $BACKUP_DIR -name "expert_network_*.sql" -mtime +7 -delete
```

### Windows Scheduled Task
```powershell
# backup_expert_network.ps1
$date = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "C:\backups\expert_network"
New-Item -ItemType Directory -Force -Path $backupDir

pg_dump -h localhost -U raguser -d ragdb `
  -n expert_network `
  -f "$backupDir\expert_network_$date.sql"
```

---

## Troubleshooting

### Permission Denied
```bash
# Make sure you have read permissions
chmod +r expert_network_backup.sql
```

### Connection Issues
```bash
# Test connection first
psql -h localhost -U raguser -d ragdb -c "\dn"
```

### Large File Size
```bash
# Use compression
pg_dump -h localhost -U raguser -d ragdb \
  -n expert_network -F c \
  -f expert_network.dump

# Or gzip
pg_dump -h localhost -U raguser -d ragdb \
  -n expert_network | gzip > expert_network.sql.gz
```

### Restore Errors
```bash
# Check for conflicting data
psql -h localhost -U raguser -d ragdb -c \
  "SELECT COUNT(*) FROM expert_network.vendor_platforms;"

# Drop schema first if needed
psql -h localhost -U raguser -d ragdb -c \
  "DROP SCHEMA IF EXISTS expert_network CASCADE;"
```

---

## File Location

**Current backup**: `c:\Users\nikdu\my_python_projects\expert_networks_ui\expert_network_backup.sql`

**Size**: 34 KB

**Last updated**: Check file timestamp

---

## Git Consideration

**Should you commit this file?**

✅ **YES** if:
- You want schema versioning
- Team needs reference implementation
- Part of deployment process

❌ **NO** if:
- Contains sensitive data (but vendors are public info)
- Database changes frequently
- Prefer migrations over dumps

**Recommended**: Add to `.gitignore` if you have active migrations:
```gitignore
# Don't commit database dumps if using migrations
expert_network_backup.sql
expert_network*.dump
```

But keep the migration files:
```
backend/migrations/
├── 001_create_expert_network_schema.sql  ✅ Commit
├── 002_seed_vendor_platforms.sql         ✅ Commit
└── 003_enhance_vendor_tags.sql           ✅ Commit
```

---

## Summary

**Exported**: ✅ `expert_network_backup.sql` (34 KB)

**Contains**:
- Complete schema definition
- All 11 tables
- All 18 vendors with enhanced tags
- All indexes, constraints, triggers

**Use it to**:
- Backup your schema
- Share with team
- Deploy to other environments
- Reset to known state
- Document your schema

**Restore with**:
```bash
psql -h localhost -U raguser -d ragdb -f expert_network_backup.sql
```
