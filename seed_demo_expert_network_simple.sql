-- ==================================================================
-- WindShift Expert Network Demo Seed (Simplified Version)
-- Schema: expert_network.*
-- Date: 2025-10-31
-- ==================================================================

BEGIN;

-- Clean up existing data first (handled by reset script)

-- ==================
-- 1. TEAM MEMBERS
-- ==================
WITH inserted_team AS (
  INSERT INTO expert_network.team_members (user_id, name, email, designation, avatar_url)
  VALUES
    ('demo-user-123', 'Nik Dulac', 'nik@windshift.io', 'Partner', NULL),
    ('demo-user-123', 'Santiago Alvarez', 'santiago@windshift.io', 'Engagement Manager', NULL),
    ('demo-user-123', 'Jordan Pfost', 'jordan@windshift.io', 'Senior Consultant', NULL),
    ('demo-user-123', 'Allen Chen', 'allen@windshift.io', 'Senior Consultant', NULL),
    ('demo-user-123', 'Priya Nair', 'priya@windshift.io', 'Analyst', NULL)
  ON CONFLICT DO NOTHING
  RETURNING id
)
SELECT COUNT(*) AS team_members_created FROM inserted_team;

-- ==================
-- 2. PROJECTS
-- ==================
WITH inserted_proj AS (
  INSERT INTO expert_network.projects (user_id, project_code, project_name, description, display_order)
  VALUES
    ('demo-user-123', 'VULCAN-MRO', 'Vulcan Engine MRO – Commercial Aero', 'Engine MRO dynamics, USM vs OEM, contracts, shop visits', 1),
    ('demo-user-123', 'SENTINEL-DEF', 'Sentinel – Defense Electronics Components', 'Defense electronics disty, obsolescence, LTAs', 2),
    ('demo-user-123', 'HELIOS-HC', 'Helios – Healthcare RevCycle SaaS', 'RCS growth/pricing/churn', 3),
    ('demo-user-123', 'NOVA-CONS', 'Nova – DTC Home Appliances', 'DTC vs retail margins, CAC/LTV, service ops', 4)
  ON CONFLICT (user_id, project_code) DO NOTHING
  RETURNING id
)
SELECT COUNT(*) AS projects_created FROM inserted_proj;

-- ==================
-- 3. CAMPAIGNS
-- ==================
INSERT INTO expert_network.campaigns (
  user_id, project_id, campaign_name, industry_vertical, custom_industry,
  brief_description, expanded_description, start_date, target_completion_date,
  target_regions, min_calls, max_calls, estimated_calls, completed_calls, scheduled_calls, display_order
)
SELECT
  'demo-user-123',
  p.id,
  'Engine MRO landscape – PW1100G/LEAP focus',
  'Aerospace',
  NULL,
  'Understand MRO demand, TAT, pricing power for new-gen NB engines',
  'Deep dive: capacity, DER vs OEM, PMA risk, USM pricing bands by LLP/hot section',
  '2025-09-16',
  '2025-11-15',
  ARRAY['North America','Europe'],
  18, 28, 24, 0, 0, 1
FROM expert_network.projects p
WHERE p.user_id = 'demo-user-123' AND p.project_code = 'VULCAN-MRO';

INSERT INTO expert_network.campaigns (
  user_id, project_id, campaign_name, industry_vertical, custom_industry,
  brief_description, expanded_description, start_date, target_completion_date,
  target_regions, min_calls, max_calls, estimated_calls, completed_calls, scheduled_calls, display_order
)
SELECT
  'demo-user-123',
  p.id,
  'USM supply chain – CFM56/V2500 teardown',
  'Aerospace',
  NULL,
  'USM availability, feedstock, harvest yields and pricing',
  'Teardown economics, yield, module pricing, salvage vs repair tradeoffs, PMA geography risk',
  '2025-10-01',
  '2025-11-20',
  ARRAY['North America','APAC'],
  10, 16, 12, 0, 0, 2
FROM expert_network.projects p
WHERE p.user_id = 'demo-user-123' AND p.project_code = 'VULCAN-MRO';

-- Add remaining campaigns...
INSERT INTO expert_network.campaigns (
  user_id, project_id, campaign_name, industry_vertical, custom_industry,
  brief_description, expanded_description, start_date, target_completion_date,
  target_regions, min_calls, max_calls, estimated_calls, completed_calls, scheduled_calls, display_order
)
SELECT
  'demo-user-123',
  project_id,
  campaign_name, industry_vertical, custom_industry,
  brief, expanded, start_date, end_date,
  target_regions, min_calls, max_calls, estimated, 0, 0, display_order
FROM (VALUES
  ((SELECT id FROM expert_network.projects WHERE user_id = 'demo-user-123' AND project_code = 'SENTINEL-DEF'),
   'Defense electronics disty – radar/avionics','Defense','Defense Electronics',
   'Fragmentation of defense electronics distribution, margins, LTAs',
   'MIL-spec discretes, RF components, obsolescence mgmt, sole-source risk, ITAR/EAR flows',
   '2025-09-26'::date,'2025-11-10'::date,ARRAY['North America','Europe'],14,20,16,1),

  ((SELECT id FROM expert_network.projects WHERE user_id = 'demo-user-123' AND project_code = 'SENTINEL-DEF'),
   'Defense sustainment – depot vs contractor','Defense','MRO/Depot',
   'Depot backlogs, CLS models, competitive positioning',
   'Depot vs contractor sustainment split, funding cadence, readiness KPIs',
   '2025-10-19'::date,'2025-11-22'::date,ARRAY['North America'],8,12,10,2),

  ((SELECT id FROM expert_network.projects WHERE user_id = 'demo-user-123' AND project_code = 'HELIOS-HC'),
   'RevCycle SaaS – mid-market hospitals','Healthcare','Healthcare IT',
   'Buyer journey, pricing, integrations, churn drivers',
   'Epic/Cerner integrations, coding automation, denials mgmt ROI',
   '2025-10-06'::date,'2025-11-05'::date,ARRAY['North America'],12,18,15,1),

  ((SELECT id FROM expert_network.projects WHERE user_id = 'demo-user-123' AND project_code = 'NOVA-CONS'),
   'DTC appliances – channel mix & service','Consumer','Appliances',
   'Retail vs DTC split, warranty service flows',
   'Last-mile cost, returns/refurbs, attachment rates for service plans',
   '2025-10-11'::date,'2025-11-10'::date,ARRAY['North America'],10,14,12,1),

  ((SELECT id FROM expert_network.projects WHERE user_id = 'demo-user-123' AND project_code = 'VULCAN-MRO'),
   'A&D Tier-2 machining – capacity & pricing','Aerospace','Precision Machining',
   'Lead times, capacity, pricing power in tight programs',
   'CNC, castings vs forgings flow, OEM schedule stability, penalty structures',
   '2025-10-13'::date,'2025-11-25'::date,ARRAY['North America','Europe'],8,12,10,3)
) AS v(project_id, campaign_name,industry_vertical,custom_industry,brief,expanded,start_date,end_date,target_regions,min_calls,max_calls,estimated,display_order);

-- ==================
-- 4. VENDOR ENROLLMENTS
-- ==================
INSERT INTO expert_network.campaign_vendor_enrollments (campaign_id, vendor_platform_id, status, enrolled_at, account_manager_name, account_manager_email, notes)
SELECT c.id, v.id, 'enrolled', now(), 'AM GLG', 'am_glg@glg.com', 'Priority vendor for speed'
FROM expert_network.campaigns c
CROSS JOIN expert_network.vendor_platforms v
WHERE c.user_id = 'demo-user-123' AND v.name = 'GLG'
ON CONFLICT (campaign_id, vendor_platform_id) DO NOTHING;

INSERT INTO expert_network.campaign_vendor_enrollments (campaign_id, vendor_platform_id, status, enrolled_at, account_manager_name, account_manager_email, notes)
SELECT c.id, v.id, 'enrolled', now(), 'AM Alpha', 'am@alphasights.com', 'Exec coverage'
FROM expert_network.campaigns c
CROSS JOIN expert_network.vendor_platforms v
WHERE c.user_id = 'demo-user-123' AND v.name = 'AlphaSights'
ON CONFLICT (campaign_id, vendor_platform_id) DO NOTHING;

INSERT INTO expert_network.campaign_vendor_enrollments (campaign_id, vendor_platform_id, status, enrolled_at, account_manager_name, account_manager_email, notes)
SELECT c.id, v.id, 'pending', NULL, NULL, NULL, 'Add if healthcare-heavy'
FROM expert_network.campaigns c
CROSS JOIN expert_network.vendor_platforms v
WHERE c.user_id = 'demo-user-123' AND v.name = 'Guidepoint'
ON CONFLICT (campaign_id, vendor_platform_id) DO NOTHING;

-- ==================
-- 5. CAMPAIGN TEAM ASSIGNMENTS
-- ==================
INSERT INTO expert_network.campaign_team_assignments (campaign_id, team_member_id)
SELECT c.id, t.id
FROM expert_network.campaigns c
CROSS JOIN LATERAL (
  SELECT id FROM expert_network.team_members
  WHERE user_id = 'demo-user-123'
  ORDER BY random()
  LIMIT 2
) t
WHERE c.user_id = 'demo-user-123'
ON CONFLICT DO NOTHING;

-- ==================
-- 6. SCREENING QUESTIONS
-- ==================
-- Main questions for all campaigns
INSERT INTO expert_network.screening_questions (campaign_id, parent_question_id, question_text, question_type, options, display_order)
SELECT c.id, NULL, 'What roles have you held directly relevant to this topic?', 'text', NULL, 1
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123';

INSERT INTO expert_network.screening_questions (campaign_id, parent_question_id, question_text, question_type, options, display_order)
SELECT c.id, NULL, 'In the last 24 months, which customers or programs did you support?', 'text', NULL, 2
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123';

INSERT INTO expert_network.screening_questions (campaign_id, parent_question_id, question_text, question_type, options, display_order)
SELECT c.id, NULL, 'Geography coverage?', 'multiple-choice', '["North America","Europe","APAC","LATAM","MEA"]'::jsonb, 3
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123';

INSERT INTO expert_network.screening_questions (campaign_id, parent_question_id, question_text, question_type, options, display_order)
SELECT c.id, NULL, 'Any conflicts or NDAs that would limit this interview?', 'text', NULL, 4
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123';

-- Sub-questions (depth rating)
INSERT INTO expert_network.screening_questions (campaign_id, parent_question_id, question_text, question_type, options, display_order)
SELECT q.campaign_id, q.id, 'Rate your depth of knowledge on this sub-topic (0-5)', 'rating', NULL, 1
FROM expert_network.screening_questions q
WHERE q.question_text LIKE 'What roles%';

-- ==================
-- 7. EXPERTS
-- ==================
-- Generic experts for all campaigns (5 experts each from GLG, AlphaSights, Guidepoint)
INSERT INTO expert_network.experts (campaign_id, vendor_platform_id, name, title, company, description, work_history, skills, rating, ai_fit_score, status, is_new)
SELECT
  c.id,
  (SELECT id FROM expert_network.vendor_platforms WHERE name = 'GLG' LIMIT 1),
  'Morgan Reyes', 'VP MRO Strategy', 'AeroWorks',
  'Ex-OEM MRO lead with USM pricing experience',
  '10y OEM -> 5y independent MRO',
  ARRAY['MRO','USM','Pricing'],
  4.6, 9, 'reviewed', true
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123';

INSERT INTO expert_network.experts (campaign_id, vendor_platform_id, name, title, company, description, work_history, skills, rating, ai_fit_score, status, is_new)
SELECT
  c.id,
  (SELECT id FROM expert_network.vendor_platforms WHERE name = 'AlphaSights' LIMIT 1),
  'Helena Zhou', 'Director Supply Chain', 'SkyFleet',
  'Led CFM56 teardown sourcing',
  '7y airline supply chain',
  ARRAY['USM','Teardown','CFM56'],
  4.4, 8, 'proposed', true
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123';

INSERT INTO expert_network.experts (campaign_id, vendor_platform_id, name, title, company, description, work_history, skills, rating, ai_fit_score, status, is_new)
SELECT
  c.id,
  (SELECT id FROM expert_network.vendor_platforms WHERE name = 'Guidepoint' LIMIT 1),
  'Robert Quinn', 'Sr Engineer', 'DefenseTech',
  'RF components sourcing and obsolescence',
  '12y defense primes',
  ARRAY['Defense','Electronics','Sustainment'],
  4.7, 8, 'proposed', true
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123';

INSERT INTO expert_network.experts (campaign_id, vendor_platform_id, name, title, company, description, work_history, skills, rating, ai_fit_score, status, is_new)
SELECT
  c.id,
  (SELECT id FROM expert_network.vendor_platforms WHERE name = 'GLG' LIMIT 1),
  'Priyanka Desai', 'Product Lead', 'MediRev',
  'RCS product owner',
  '8y HCIT SaaS',
  ARRAY['RCS','EHR','Integration'],
  4.5, 7, 'proposed', true
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123';

INSERT INTO expert_network.experts (campaign_id, vendor_platform_id, name, title, company, description, work_history, skills, rating, ai_fit_score, status, is_new)
SELECT
  c.id,
  (SELECT id FROM expert_network.vendor_platforms WHERE name = 'AlphaSights' LIMIT 1),
  'Gustavo Lima', 'COO', 'HomeSpark',
  'DTC ops leader',
  '10y ecommerce ops',
  ARRAY['DTC','Fulfillment','Service'],
  4.2, 6, 'proposed', true
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123';

-- Specific experts for Engine MRO campaign
INSERT INTO expert_network.experts (campaign_id, vendor_platform_id, name, title, company, description, work_history, skills, rating, ai_fit_score, status, is_new)
SELECT
  c.id,
  (SELECT id FROM expert_network.vendor_platforms WHERE name = 'GLG' LIMIT 1),
  'Jamie O''Connell', 'Shop Visit Planner', 'Indigo Aero',
  'LEAP/PW1100G slotting and LLP mgmt',
  '6y planner at top MRO',
  ARRAY['PW1100G','LEAP','TAT'],
  4.8, 10, 'scheduling', true
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123' AND c.campaign_name LIKE 'Engine MRO%';

-- Specific expert for USM supply chain campaign
INSERT INTO expert_network.experts (campaign_id, vendor_platform_id, name, title, company, description, work_history, skills, rating, ai_fit_score, status, is_new)
SELECT
  c.id,
  (SELECT id FROM expert_network.vendor_platforms WHERE name = 'AlphaSights' LIMIT 1),
  'Arun Menon', 'Teardown Program Manager', 'AeroHarvest',
  'USM yield optimization across CFM56/V2500',
  '9y teardown projects',
  ARRAY['CFM56','V2500','Yield'],
  4.5, 9, 'reviewed', true
FROM expert_network.campaigns c
WHERE c.user_id = 'demo-user-123' AND c.campaign_name LIKE 'USM supply chain%';

-- ==================
-- 8. INTERVIEWS
-- ==================
-- Scheduled interviews (first 6 experts globally)
WITH first_experts AS (
  SELECT id, campaign_id FROM expert_network.experts
  WHERE campaign_id IN (SELECT id FROM expert_network.campaigns WHERE user_id = 'demo-user-123')
  ORDER BY created_at
  LIMIT 6
)
INSERT INTO expert_network.interviews (campaign_id, expert_id, scheduled_date, scheduled_time, duration_minutes, timezone, status, color_tag, completed_at)
SELECT campaign_id, id, DATE '2025-11-02', TIME '10:00', 60, 'America/New_York', 'scheduled', '#2E86AB', NULL
FROM first_experts;

-- Confirmed interviews (next 4 experts)
WITH confirmed_experts AS (
  SELECT id, campaign_id FROM expert_network.experts
  WHERE campaign_id IN (SELECT id FROM expert_network.campaigns WHERE user_id = 'demo-user-123')
  ORDER BY created_at
  OFFSET 6 LIMIT 4
)
INSERT INTO expert_network.interviews (campaign_id, expert_id, scheduled_date, scheduled_time, duration_minutes, timezone, status, color_tag, completed_at)
SELECT campaign_id, id, DATE '2025-11-05', TIME '14:00', 60, 'America/New_York', 'confirmed', '#2E86AB', NULL
FROM confirmed_experts;

-- Completed interviews (next 4 experts)
WITH completed_experts AS (
  SELECT id, campaign_id FROM expert_network.experts
  WHERE campaign_id IN (SELECT id FROM expert_network.campaigns WHERE user_id = 'demo-user-123')
  ORDER BY created_at
  OFFSET 10 LIMIT 4
)
INSERT INTO expert_network.interviews (campaign_id, expert_id, scheduled_date, scheduled_time, duration_minutes, timezone, status, color_tag, completed_at)
SELECT campaign_id, id, DATE '2025-10-24', TIME '09:30', 60, 'America/New_York', 'completed', '#3C9A5F', now() - interval '7 days'
FROM completed_experts;

-- ==================
-- 9. SCREENING RESPONSES
-- ==================
-- Response to "What roles..." question
INSERT INTO expert_network.expert_screening_responses (expert_id, screening_question_id, response_text)
SELECT e.id, q.id, 'VP MRO at OEM; led pricing committee for PW1100G repairs'
FROM expert_network.experts e
JOIN expert_network.screening_questions q ON q.campaign_id = e.campaign_id
WHERE q.question_text LIKE 'What roles%'
LIMIT 20;

-- Response to "In the last 24 months..." question
INSERT INTO expert_network.expert_screening_responses (expert_id, screening_question_id, response_text)
SELECT e.id, q.id, 'Supported Indigo, JetBlue, Lufthansa on LEAP/PW1100G TAT initiatives'
FROM expert_network.experts e
JOIN expert_network.screening_questions q ON q.campaign_id = e.campaign_id
WHERE q.question_text LIKE 'In the last 24 months%'
LIMIT 20;

-- Response to "Geography coverage?" question
INSERT INTO expert_network.expert_screening_responses (expert_id, screening_question_id, response_text)
SELECT e.id, q.id, 'North America; Europe'
FROM expert_network.experts e
JOIN expert_network.screening_questions q ON q.campaign_id = e.campaign_id
WHERE q.question_text = 'Geography coverage?'
LIMIT 20;

SELECT 'Demo data loaded successfully!' AS status;

COMMIT;
