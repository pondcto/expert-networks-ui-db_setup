-- Migration: Make project_code nullable in projects table
-- The Project model allows project_code to be optional, so the database should match

-- First, drop the unique constraint that includes project_code
ALTER TABLE expert_network.projects
DROP CONSTRAINT IF EXISTS projects_user_code_unique;

-- Make project_code nullable
ALTER TABLE expert_network.projects
ALTER COLUMN project_code DROP NOT NULL;

-- Recreate the unique constraint, but only when project_code is not null
-- This allows multiple projects with NULL project_code per user
-- We'll use a partial unique index instead
CREATE UNIQUE INDEX IF NOT EXISTS idx_projects_user_code_unique 
ON expert_network.projects(user_id, project_code)
WHERE project_code IS NOT NULL;

COMMENT ON COLUMN expert_network.projects.project_code IS 'Project code (e.g., ''DEAL-2025-001''). Optional but must be unique per user when provided.';

