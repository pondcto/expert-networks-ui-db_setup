-- ==================================================================
-- Reset Expert Network Schema and Load Demo Data
-- ==================================================================
-- This script:
-- 1. Backs up current row counts
-- 2. Deletes ALL data from expert_network tables (except vendor_platforms)
-- 3. Loads demo seed data from seed_demo_expert_network_v2.sql
--
-- Usage:
--   psql -h localhost -U raguser -d ragdb -f reset_and_seed_demo.sql
-- ==================================================================

BEGIN;

\echo ''
\echo '======================================================================'
\echo 'EXPERT NETWORK - RESET AND SEED DEMO DATA'
\echo '======================================================================'
\echo ''

-- Step 1: Show current data counts
\echo 'Step 1: Current data snapshot'
\echo '----------------------------------------------------------------------'

SELECT
    'Current Data' as step,
    (SELECT COUNT(*) FROM expert_network.projects) as projects,
    (SELECT COUNT(*) FROM expert_network.campaigns) as campaigns,
    (SELECT COUNT(*) FROM expert_network.experts) as experts,
    (SELECT COUNT(*) FROM expert_network.interviews) as interviews,
    (SELECT COUNT(*) FROM expert_network.team_members) as team_members,
    (SELECT COUNT(*) FROM expert_network.vendor_platforms) as vendor_platforms;

\echo ''
\echo 'Step 2: Clearing all data (keeping vendors)'
\echo '----------------------------------------------------------------------'

-- Delete in correct order to respect foreign keys
-- Child tables first, parent tables last

-- Level 5: Deepest dependencies
DELETE FROM expert_network.expert_screening_responses;
\echo '  ✓ Cleared expert_screening_responses'

-- Level 4: Interview and assignment data
DELETE FROM expert_network.interviews;
\echo '  ✓ Cleared interviews'

DELETE FROM expert_network.campaign_team_assignments;
\echo '  ✓ Cleared campaign_team_assignments'

-- Level 3: Campaign-related data
DELETE FROM expert_network.campaign_vendor_enrollments;
\echo '  ✓ Cleared campaign_vendor_enrollments'

DELETE FROM expert_network.screening_questions;
\echo '  ✓ Cleared screening_questions'

DELETE FROM expert_network.experts;
\echo '  ✓ Cleared experts'

-- Level 2: Team and preferences
DELETE FROM expert_network.team_members;
\echo '  ✓ Cleared team_members'

DELETE FROM expert_network.user_ui_preferences;
\echo '  ✓ Cleared user_ui_preferences'

-- Level 1: Top-level entities (campaigns must be deleted before projects)
DELETE FROM expert_network.campaigns;
\echo '  ✓ Cleared campaigns'

DELETE FROM expert_network.projects;
\echo '  ✓ Cleared projects'

-- NOTE: vendor_platforms is NOT deleted - it's pre-seeded and shared across all users

\echo ''
\echo 'Step 3: Verification - All tables empty (except vendors)'
\echo '----------------------------------------------------------------------'

SELECT
    'After Delete' as step,
    (SELECT COUNT(*) FROM expert_network.projects) as projects,
    (SELECT COUNT(*) FROM expert_network.campaigns) as campaigns,
    (SELECT COUNT(*) FROM expert_network.experts) as experts,
    (SELECT COUNT(*) FROM expert_network.interviews) as interviews,
    (SELECT COUNT(*) FROM expert_network.team_members) as team_members,
    (SELECT COUNT(*) FROM expert_network.vendor_platforms) as vendor_platforms;

COMMIT;

\echo ''
\echo '======================================================================'
\echo 'Data cleared successfully. Now loading demo seed data...'
\echo '======================================================================'
\echo ''

-- Step 4: Load demo seed data
\i seed_demo_expert_network_v2.sql

\echo ''
\echo '======================================================================'
\echo 'Step 4: Final verification - Demo data loaded'
\echo '======================================================================'
\echo ''

SELECT
    'Final State' as step,
    (SELECT COUNT(*) FROM expert_network.projects) as projects,
    (SELECT COUNT(*) FROM expert_network.campaigns) as campaigns,
    (SELECT COUNT(*) FROM expert_network.experts) as experts,
    (SELECT COUNT(*) FROM expert_network.interviews) as interviews,
    (SELECT COUNT(*) FROM expert_network.team_members) as team_members,
    (SELECT COUNT(*) FROM expert_network.vendor_platforms) as vendor_platforms;

\echo ''
\echo '======================================================================'
\echo '✓ COMPLETE - Demo data loaded successfully!'
\echo '======================================================================'
\echo ''
\echo 'Demo User ID: demo-user-123'
\echo ''
\echo 'What was created:'
\echo '  • 4 Projects (VULCAN-MRO, SENTINEL-DEF, HELIOS-HC, NOVA-CONS)'
\echo '  • 7 Campaigns across aerospace, defense, healthcare, consumer'
\echo '  • 5 Team members'
\echo '  • Multiple experts per campaign'
\echo '  • Sample interviews (scheduled, confirmed, completed)'
\echo '  • Screening questions and responses'
\echo ''
\echo 'Next steps:'
\echo '  1. Update BetterAuth to use user_id: "demo-user-123" for demo'
\echo '  2. Or modify seed file to use real user IDs'
\echo '  3. Test the app!'
\echo ''
