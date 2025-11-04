-- ==================================================================
-- Reset Expert Network Schema and Load Demo Data (Simplified)
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
DELETE FROM expert_network.expert_screening_responses;
\echo '  ✓ Cleared expert_screening_responses'

DELETE FROM expert_network.interviews;
\echo '  ✓ Cleared interviews'

DELETE FROM expert_network.campaign_team_assignments;
\echo '  ✓ Cleared campaign_team_assignments'

DELETE FROM expert_network.campaign_vendor_enrollments;
\echo '  ✓ Cleared campaign_vendor_enrollments'

DELETE FROM expert_network.screening_questions;
\echo '  ✓ Cleared screening_questions'

DELETE FROM expert_network.experts;
\echo '  ✓ Cleared experts'

DELETE FROM expert_network.team_members;
\echo '  ✓ Cleared team_members'

DELETE FROM expert_network.user_ui_preferences;
\echo '  ✓ Cleared user_ui_preferences'

DELETE FROM expert_network.campaigns;
\echo '  ✓ Cleared campaigns'

DELETE FROM expert_network.projects;
\echo '  ✓ Cleared projects'

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
\i seed_demo_expert_network_simple.sql

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
