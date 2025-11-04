
-- ==================================================================
-- WindShift Expert Network Demo Seed (NAMESPACED) - v2
-- Schema: expert_network.*
-- Date: 2025-10-31
-- Requirements: vendor_platforms pre-seeded with GLG, AlphaSights, Guidepoint
-- ==================================================================

BEGIN;

-- Look up vendor IDs by name (ignore missing vendors gracefully via LEFT JOINs later)
WITH
glg AS (SELECT id FROM expert_network.vendor_platforms WHERE name = 'GLG' LIMIT 1),
alpha AS (SELECT id FROM expert_network.vendor_platforms WHERE name = 'AlphaSights' LIMIT 1),
guide AS (SELECT id FROM expert_network.vendor_platforms WHERE name = 'Guidepoint' LIMIT 1),

team AS (
  INSERT INTO expert_network.team_members (user_id, name, email, designation, avatar_url)
  VALUES
    ('demo-user-123', 'Nik Dulac', 'nik@windshift.io', 'Partner', NULL),
    ('demo-user-123', 'Santiago Alvarez', 'santiago@windshift.io', 'Engagement Manager', NULL),
    ('demo-user-123', 'Jordan Pfost', 'jordan@windshift.io', 'Senior Consultant', NULL),
    ('demo-user-123', 'Allen Chen', 'allen@windshift.io', 'Senior Consultant', NULL),
    ('demo-user-123', 'Priya Nair', 'priya@windshift.io', 'Analyst', NULL)
  ON CONFLICT DO NOTHING
  RETURNING id, name
),

proj AS (
  INSERT INTO expert_network.projects (user_id, project_code, project_name, description, display_order)
  VALUES
    ('demo-user-123', 'VULCAN-MRO', 'Vulcan Engine MRO – Commercial Aero', 'Engine MRO dynamics, USM vs OEM, contracts, shop visits', 1),
    ('demo-user-123', 'SENTINEL-DEF', 'Sentinel – Defense Electronics Components', 'Defense electronics disty, obsolescence, LTAs', 2),
    ('demo-user-123', 'HELIOS-HC', 'Helios – Healthcare RevCycle SaaS', 'RCS growth/pricing/churn', 3),
    ('demo-user-123', 'NOVA-CONS', 'Nova – DTC Home Appliances', 'DTC vs retail margins, CAC/LTV, service ops', 4)
  ON CONFLICT (user_id, project_code) DO NOTHING
  RETURNING id, project_code, project_name
),

camp AS (
  INSERT INTO expert_network.campaigns (
    user_id, project_id, campaign_name, industry_vertical, custom_industry,
    brief_description, expanded_description, start_date, target_completion_date,
    target_regions, min_calls, max_calls, estimated_calls, completed_calls, scheduled_calls, display_order
  )
  SELECT 'demo-user-123', p.id,
         c.campaign_name, c.industry_vertical, c.custom_industry,
         c.brief, c.expanded, c.start_date, c.end_date,
         c.target_regions, c.min_calls, c.max_calls, c.estimated, 0, 0, c.display_order
  FROM (VALUES
    -- Project VULCAN-MRO
    ('Engine MRO landscape – PW1100G/LEAP focus','Aerospace',NULL,
     'Understand MRO demand, TAT, pricing power for new-gen NB engines',
     'Deep dive: capacity, DER vs OEM, PMA risk, USM pricing bands by LLP/hot section',
     '2025-09-16','2025-11-15',ARRAY['North America','Europe'],18,28,24,1),

    ('USM supply chain – CFM56/V2500 teardown','Aerospace',NULL,
     'USM availability, feedstock, harvest yields and pricing',
     'Teardown economics, yield, module pricing, salvage vs repair tradeoffs, PMA geography risk',
     '2025-10-01','2025-11-20',ARRAY['North America','APAC'],10,16,12,2),

    -- Project SENTINEL-DEF
    ('Defense electronics disty – radar/avionics','Defense','Defense Electronics',
     'Fragmentation of defense electronics distribution, margins, LTAs',
     'MIL-spec discretes, RF components, obsolescence mgmt, sole-source risk, ITAR/EAR flows',
     '2025-09-26','2025-11-10',ARRAY['North America','Europe'],14,20,16,1),

    ('Defense sustainment – depot vs contractor','Defense','MRO/Depot',
     'Depot backlogs, CLS models, competitive positioning',
     'Depot vs contractor sustainment split, funding cadence, readiness KPIs',
     '2025-10-19','2025-11-22',ARRAY['North America'],8,12,10,2),

    -- Project HELIOS-HC
    ('RevCycle SaaS – mid-market hospitals','Healthcare','Healthcare IT',
     'Buyer journey, pricing, integrations, churn drivers',
     'Epic/Cerner integrations, coding automation, denials mgmt ROI',
     '2025-10-06','2025-11-05',ARRAY['North America'],12,18,15,1),

    -- Project NOVA-CONS
    ('DTC appliances – channel mix & service','Consumer','Appliances',
     'Retail vs DTC split, warranty service flows',
     'Last-mile cost, returns/refurbs, attachment rates for service plans',
     '2025-10-11','2025-11-10',ARRAY['North America'],10,14,12,1),

    -- Extra A&D breadth
    ('A&D Tier-2 machining – capacity & pricing','Aerospace','Precision Machining',
     'Lead times, capacity, pricing power in tight programs',
     'CNC, castings vs forgings flow, OEM schedule stability, penalty structures',
     '2025-10-13','2025-11-25',ARRAY['North America','Europe'],8,12,10,3)
  ) AS c(campaign_name,industry_vertical,custom_industry,brief,expanded,start_date,end_date,target_regions,min_calls,max_calls,estimated,display_order)
  JOIN proj p ON (
    (c.campaign_name like 'Engine MRO%' OR c.campaign_name like 'USM%') AND p.project_code = 'VULCAN-MRO'
    OR  c.campaign_name like 'Defense electronics%'                    AND p.project_code = 'SENTINEL-DEF'
    OR  c.campaign_name like 'Defense sustainment%'                     AND p.project_code = 'SENTINEL-DEF'
    OR  c.campaign_name like 'RevCycle%'                                AND p.project_code = 'HELIOS-HC'
    OR  c.campaign_name like 'DTC appliances%'                          AND p.project_code = 'NOVA-CONS'
    OR  c.campaign_name like 'A&D Tier-2%'                              AND p.project_code = 'VULCAN-MRO'
  )
  RETURNING id, campaign_name
),

camp_team AS (
  INSERT INTO expert_network.campaign_team_assignments (campaign_id, team_member_id)
  SELECT c.id, t.id
  FROM camp c
  JOIN LATERAL (SELECT id FROM team ORDER BY random() LIMIT 2) t ON true
  ON CONFLICT DO NOTHING
  RETURNING campaign_id, team_member_id
),

q AS (
  INSERT INTO expert_network.screening_questions (campaign_id, parent_question_id, question_text, question_type, options, display_order)
  SELECT c.id, NULL::uuid, 'What roles have you held directly relevant to this topic?', 'text', NULL, 1 FROM camp c
  UNION ALL SELECT c.id, NULL::uuid, 'In the last 24 months, which customers or programs did you support?', 'text', NULL, 2 FROM camp c
  UNION ALL SELECT c.id, NULL::uuid, 'Geography coverage?', 'multiple-choice', '{"North America","Europe","APAC","LATAM","MEA"}'::jsonb, 3 FROM camp c
  UNION ALL SELECT c.id, NULL::uuid, 'Any conflicts or NDAs that would limit this interview?', 'text', NULL, 4 FROM camp c
  RETURNING id, campaign_id
),
q_sub AS (
  INSERT INTO expert_network.screening_questions (campaign_id, parent_question_id, question_text, question_type, options, display_order)
  SELECT q.campaign_id, q.id, 'Rate your depth of knowledge on this sub-topic (0-5)', 'rating', NULL, 1 FROM q
  RETURNING id, campaign_id
),

enr AS (
  INSERT INTO expert_network.campaign_vendor_enrollments (campaign_id, vendor_platform_id, status, enrolled_at, account_manager_name, account_manager_email, notes)
  SELECT * FROM (
    SELECT c.id, g.id, 'enrolled'::text, now(), 'AM GLG'::text, 'am_glg@glg.com'::text, 'Priority vendor for speed'::text
    FROM camp c JOIN glg g ON true
    UNION ALL
    SELECT c.id, a.id, 'enrolled'::text, now(), 'AM Alpha'::text, 'am@alphasights.com'::text, 'Exec coverage'::text
    FROM camp c JOIN alpha a ON true
    UNION ALL
    SELECT c.id, gp.id, 'pending'::text, NULL::timestamp with time zone, NULL::text, NULL::text, 'Add if healthcare-heavy'::text
    FROM camp c JOIN guide gp ON true
  ) AS enrollment_data
  ON CONFLICT (campaign_id, vendor_platform_id) DO NOTHING
  RETURNING id, campaign_id, vendor_platform_id
),

exp AS (
  INSERT INTO expert_network.experts (campaign_id, vendor_platform_id, name, title, company, description, work_history, skills, rating, ai_fit_score, status, is_new)
  SELECT c.id, (SELECT id FROM glg), 'Morgan Reyes', 'VP MRO Strategy', 'AeroWorks', 'Ex-OEM MRO lead with USM pricing experience', '10y OEM -> 5y independent MRO', ARRAY['MRO','USM','Pricing'], 4.6, 9, 'reviewed', true FROM camp c
  UNION ALL SELECT c.id, (SELECT id FROM alpha), 'Helena Zhou', 'Director Supply Chain', 'SkyFleet', 'Led CFM56 teardown sourcing', '7y airline supply chain', ARRAY['USM','Teardown','CFM56'], 4.4, 8, 'proposed', true FROM camp c
  UNION ALL SELECT c.id, (SELECT id FROM guide), 'Robert Quinn', 'Sr Engineer', 'DefenseTech', 'RF components sourcing and obsolescence', '12y defense primes', ARRAY['Defense','Electronics','Sustainment'], 4.7, 8, 'proposed', true FROM camp c
  UNION ALL SELECT c.id, (SELECT id FROM glg), 'Priyanka Desai', 'Product Lead', 'MediRev', 'RCS product owner', '8y HCIT SaaS', ARRAY['RCS','EHR','Integration'], 4.5, 7, 'proposed', true FROM camp c
  UNION ALL SELECT c.id, (SELECT id FROM alpha), 'Gustavo Lima', 'COO', 'HomeSpark', 'DTC ops leader', '10y ecommerce ops', ARRAY['DTC','Fulfillment','Service'], 4.2, 6, 'proposed', true FROM camp c
  RETURNING id, campaign_id, name
),

exp_extra AS (
  INSERT INTO expert_network.experts (campaign_id, vendor_platform_id, name, title, company, description, work_history, skills, rating, ai_fit_score, status, is_new)
  SELECT c.id, (SELECT id FROM glg), 'Jamie O''Connell', 'Shop Visit Planner', 'Indigo Aero', 'LEAP/PW1100G slotting and LLP mgmt', '6y planner at top MRO', ARRAY['PW1100G','LEAP','TAT'], 4.8, 10, 'scheduling', true
  FROM camp c WHERE c.campaign_name LIKE 'Engine MRO%'
  UNION ALL
  SELECT c.id, (SELECT id FROM alpha), 'Arun Menon', 'Teardown Program Manager', 'AeroHarvest', 'USM yield optimization across CFM56/V2500', '9y teardown projects', ARRAY['CFM56','V2500','Yield'], 4.5, 9, 'reviewed', true
  FROM camp c WHERE c.campaign_name LIKE 'USM supply chain%'
  RETURNING id, campaign_id
),

iv AS (
  INSERT INTO expert_network.interviews (campaign_id, expert_id, scheduled_date, scheduled_time, duration_minutes, timezone, status, color_tag, completed_at)
  SELECT e.campaign_id, e.id, DATE '2025-11-02',  TIME '10:00', 60, 'America/New_York', 'scheduled', '#2E86AB', NULL FROM exp e LIMIT 6
  UNION ALL
  SELECT e.campaign_id, e.id, DATE '2025-11-05',  TIME '14:00', 60, 'America/New_York', 'confirmed', '#2E86AB', NULL FROM exp e OFFSET 6 LIMIT 4
  UNION ALL
  SELECT e.campaign_id, e.id, DATE '2025-10-24', TIME '09:30', 60, 'America/New_York', 'completed', '#3C9A5F', now() - interval '7 days' FROM exp e OFFSET 10 LIMIT 4
  RETURNING id, campaign_id, expert_id, status
),

resp AS (
  INSERT INTO expert_network.expert_screening_responses (expert_id, screening_question_id, response_text)
  SELECT e.id, q.id, 'VP MRO at OEM; led pricing committee for PW1100G repairs'
    FROM exp e
    JOIN q ON q.campaign_id = e.campaign_id
    WHERE q.question_text LIKE 'What roles%'
  UNION ALL
  SELECT e.id, q.id, 'Supported Indigo, JetBlue, Lufthansa on LEAP/PW1100G TAT initiatives'
    FROM exp e
    JOIN q ON q.campaign_id = e.campaign_id
    WHERE q.question_text LIKE 'In the last 24 months%'
  UNION ALL
  SELECT e.id, q.id, 'North America; Europe'
    FROM exp e
    JOIN q ON q.campaign_id = e.campaign_id
    WHERE q.question_text = 'Geography coverage?'
  RETURNING id
)

SELECT 'ok' AS seeded;

COMMIT;
