-- Migration: Add client_name, start_date, and end_date fields to projects table
-- These fields are used in the Project model and API but were missing from the initial schema

ALTER TABLE expert_network.projects
ADD COLUMN IF NOT EXISTS client_name TEXT,
ADD COLUMN IF NOT EXISTS start_date DATE,
ADD COLUMN IF NOT EXISTS end_date DATE;

COMMENT ON COLUMN expert_network.projects.client_name IS 'Client name for the project';
COMMENT ON COLUMN expert_network.projects.start_date IS 'Project start date';
COMMENT ON COLUMN expert_network.projects.end_date IS 'Project end date';

