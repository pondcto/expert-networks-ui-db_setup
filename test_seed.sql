BEGIN;

WITH
glg AS (SELECT id FROM expert_network.vendor_platforms WHERE name = 'GLG' LIMIT 1),
alpha AS (SELECT id FROM expert_network.vendor_platforms WHERE name = 'AlphaSights' LIMIT 1),

team AS (
  INSERT INTO expert_network.team_members (user_id, name, email, designation, avatar_url)
  VALUES
    ('demo-user-123', 'Nik Dulac', 'nik@windshift.io', 'Partner', NULL),
    ('demo-user-123', 'Santiago Alvarez', 'santiago@windshift.io', 'Engagement Manager', NULL)
  ON CONFLICT DO NOTHING
  RETURNING id, name
),

proj AS (
  INSERT INTO expert_network.projects (user_id, project_code, project_name, description, display_order)
  VALUES
    ('demo-user-123', 'VULCAN-MRO', 'Vulcan Engine MRO – Commercial Aero', 'Engine MRO dynamics', 1),
    ('demo-user-123', 'SENTINEL-DEF', 'Sentinel – Defense Electronics', 'Defense electronics', 2)
  ON CONFLICT (user_id, project_code) DO NOTHING
  RETURNING id, project_code, project_name
),

test_union AS (
  INSERT INTO expert_network.screening_questions (campaign_id, parent_question_id, question_text, question_type, options, display_order)
  (
    SELECT p.id, NULL, 'Question 1', 'text', NULL, 1 FROM proj p
    UNION ALL
    SELECT p.id, NULL, 'Question 2', 'text', NULL, 2 FROM proj p
  )
  RETURNING id
)

SELECT 'test ok' AS result;

ROLLBACK;
