-- Quick verification queries for Expert Networks database

-- 1. Show all schemas
\echo '=== ALL SCHEMAS ==='
\dn

-- 2. Show tables in expert_network schema
\echo ''
\echo '=== EXPERT_NETWORK TABLES ==='
SELECT tablename FROM pg_tables WHERE schemaname = 'expert_network' ORDER BY tablename;

-- 3. Count vendors
\echo ''
\echo '=== VENDOR COUNT ==='
SELECT COUNT(*) as total_vendors FROM expert_network.vendor_platforms;

-- 4. Show sample vendors with tags
\echo ''
\echo '=== SAMPLE VENDORS ==='
SELECT
    name,
    location,
    array_length(tags, 1) as tag_count,
    overall_score
FROM expert_network.vendor_platforms
ORDER BY overall_score DESC
LIMIT 5;

-- 5. Verify migrations
\echo ''
\echo '=== APPLIED MIGRATIONS ==='
SELECT migration_name FROM public.schema_migrations ORDER BY id;
