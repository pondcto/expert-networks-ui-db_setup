-- Migration: Create expert_network schema
-- Database: ragdb (postgresql+asyncpg://raguser:ragpass@localhost:5432/ragdb)
--
-- This migration creates a separate 'expert_network' schema to isolate
-- the expert networks application data from the 'public' schema used
-- by BetterAuth for authentication and session management.
--
-- The 'public' schema remains dedicated to:
--   - user, session, account, verification tables (BetterAuth)
--
-- The 'expert_network' schema will contain all application-specific tables.

-- =============================================================================
-- CREATE SCHEMA
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS expert_network;

-- Grant permissions to raguser
GRANT ALL ON SCHEMA expert_network TO raguser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA expert_network TO raguser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA expert_network TO raguser;

-- Set default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA expert_network GRANT ALL ON TABLES TO raguser;
ALTER DEFAULT PRIVILEGES IN SCHEMA expert_network GRANT ALL ON SEQUENCES TO raguser;

-- Enable required extensions (these are global, not schema-specific)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- =============================================================================
-- PROJECTS
-- =============================================================================

CREATE TABLE expert_network.projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References public.user(id) from BetterAuth
    project_code TEXT NOT NULL,
    project_name TEXT NOT NULL,
    description TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT projects_user_code_unique UNIQUE(user_id, project_code)
);

CREATE INDEX idx_projects_user ON expert_network.projects(user_id);
CREATE INDEX idx_projects_order ON expert_network.projects(user_id, display_order);

COMMENT ON TABLE expert_network.projects IS 'Top-level organizational container for campaigns';
COMMENT ON COLUMN expert_network.projects.user_id IS 'References public.user(id) from BetterAuth';

-- =============================================================================
-- CAMPAIGNS
-- =============================================================================

CREATE TABLE expert_network.campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References public.user(id) from BetterAuth
    project_id UUID,  -- NULL means "Other Campaigns"

    -- Basic info
    campaign_name TEXT NOT NULL,
    industry_vertical TEXT NOT NULL,
    custom_industry TEXT,
    brief_description TEXT,
    expanded_description TEXT,

    -- Timeline
    start_date DATE NOT NULL,
    target_completion_date DATE NOT NULL,

    -- Target regions (stored as array)
    target_regions TEXT[] NOT NULL DEFAULT '{}',

    -- Call targets and tracking
    min_calls INTEGER,
    max_calls INTEGER,
    estimated_calls INTEGER,
    completed_calls INTEGER NOT NULL DEFAULT 0,
    scheduled_calls INTEGER NOT NULL DEFAULT 0,

    -- Ordering
    display_order INTEGER NOT NULL DEFAULT 0,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_campaigns_project FOREIGN KEY (project_id)
        REFERENCES expert_network.projects(id) ON DELETE SET NULL
);

CREATE INDEX idx_campaigns_user ON expert_network.campaigns(user_id);
CREATE INDEX idx_campaigns_project ON expert_network.campaigns(project_id);
CREATE INDEX idx_campaigns_order ON expert_network.campaigns(user_id, project_id, display_order);
CREATE INDEX idx_campaigns_dates ON expert_network.campaigns(start_date, target_completion_date);
CREATE INDEX idx_campaigns_industry ON expert_network.campaigns(industry_vertical);

COMMENT ON TABLE expert_network.campaigns IS 'Interview campaigns for commercial diligence projects';

-- =============================================================================
-- TEAM MEMBERS
-- =============================================================================

CREATE TABLE expert_network.team_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References public.user(id) - owner of this pool
    name TEXT NOT NULL,
    email TEXT,
    designation TEXT NOT NULL,
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_team_members_user ON expert_network.team_members(user_id);
CREATE INDEX idx_team_members_name ON expert_network.team_members(name);

COMMENT ON TABLE expert_network.team_members IS 'Pool of team members that can be assigned to campaigns';

-- =============================================================================
-- CAMPAIGN TEAM ASSIGNMENTS
-- =============================================================================

CREATE TABLE expert_network.campaign_team_assignments (
    campaign_id UUID NOT NULL,
    team_member_id UUID NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (campaign_id, team_member_id),
    CONSTRAINT fk_campaign_team_campaign FOREIGN KEY (campaign_id)
        REFERENCES expert_network.campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_campaign_team_member FOREIGN KEY (team_member_id)
        REFERENCES expert_network.team_members(id) ON DELETE CASCADE
);

CREATE INDEX idx_campaign_team_campaign ON expert_network.campaign_team_assignments(campaign_id);
CREATE INDEX idx_campaign_team_member ON expert_network.campaign_team_assignments(team_member_id);

-- =============================================================================
-- SCREENING QUESTIONS
-- =============================================================================

CREATE TABLE expert_network.screening_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL,
    parent_question_id UUID,
    question_text TEXT NOT NULL,
    question_type TEXT DEFAULT 'text',
    options JSONB,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_screening_campaign FOREIGN KEY (campaign_id)
        REFERENCES expert_network.campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_screening_parent FOREIGN KEY (parent_question_id)
        REFERENCES expert_network.screening_questions(id) ON DELETE CASCADE
);

CREATE INDEX idx_screening_campaign ON expert_network.screening_questions(campaign_id);
CREATE INDEX idx_screening_parent ON expert_network.screening_questions(parent_question_id);
CREATE INDEX idx_screening_order ON expert_network.screening_questions(campaign_id, display_order);

-- =============================================================================
-- VENDOR PLATFORMS
-- =============================================================================

CREATE TABLE expert_network.vendor_platforms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    logo_url TEXT,
    location TEXT,
    overall_score DECIMAL(2,1),
    avg_cost_per_call_min INTEGER,
    avg_cost_per_call_max INTEGER,
    description TEXT,
    tags TEXT[] DEFAULT '{}',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_vendors_active ON expert_network.vendor_platforms(is_active);
CREATE INDEX idx_vendors_name ON expert_network.vendor_platforms(name);

-- =============================================================================
-- CAMPAIGN VENDOR ENROLLMENTS
-- =============================================================================

CREATE TABLE expert_network.campaign_vendor_enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL,
    vendor_platform_id UUID NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    enrolled_at TIMESTAMPTZ,
    account_manager_name TEXT,
    account_manager_email TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT enrollment_unique UNIQUE(campaign_id, vendor_platform_id),
    CONSTRAINT fk_enrollment_campaign FOREIGN KEY (campaign_id)
        REFERENCES expert_network.campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_vendor FOREIGN KEY (vendor_platform_id)
        REFERENCES expert_network.vendor_platforms(id) ON DELETE CASCADE
);

CREATE INDEX idx_enrollments_campaign ON expert_network.campaign_vendor_enrollments(campaign_id);
CREATE INDEX idx_enrollments_vendor ON expert_network.campaign_vendor_enrollments(vendor_platform_id);
CREATE INDEX idx_enrollments_status ON expert_network.campaign_vendor_enrollments(status);

-- =============================================================================
-- EXPERTS
-- =============================================================================

CREATE TABLE expert_network.experts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL,
    vendor_platform_id UUID NOT NULL,

    -- Basic info
    name TEXT NOT NULL,
    title TEXT NOT NULL,
    company TEXT,
    avatar_url TEXT,

    -- Profile
    description TEXT,
    work_history TEXT,
    skills TEXT[] DEFAULT '{}',

    -- Ratings and fit
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 5),
    ai_fit_score INTEGER CHECK (ai_fit_score >= 0 AND ai_fit_score <= 10),

    -- Status
    status TEXT NOT NULL DEFAULT 'proposed',
    is_new BOOLEAN NOT NULL DEFAULT true,

    -- Metadata
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    reviewed_at TIMESTAMPTZ,

    CONSTRAINT fk_experts_campaign FOREIGN KEY (campaign_id)
        REFERENCES expert_network.campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_experts_vendor FOREIGN KEY (vendor_platform_id)
        REFERENCES expert_network.vendor_platforms(id)
);

CREATE INDEX idx_experts_campaign ON expert_network.experts(campaign_id);
CREATE INDEX idx_experts_vendor ON expert_network.experts(vendor_platform_id);
CREATE INDEX idx_experts_status ON expert_network.experts(status);
CREATE INDEX idx_experts_campaign_status ON expert_network.experts(campaign_id, status);
CREATE INDEX idx_experts_name ON expert_network.experts USING gin(name gin_trgm_ops);

-- =============================================================================
-- EXPERT SCREENING RESPONSES
-- =============================================================================

CREATE TABLE expert_network.expert_screening_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expert_id UUID NOT NULL,
    screening_question_id UUID NOT NULL,
    response_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_responses_expert FOREIGN KEY (expert_id)
        REFERENCES expert_network.experts(id) ON DELETE CASCADE,
    CONSTRAINT fk_responses_question FOREIGN KEY (screening_question_id)
        REFERENCES expert_network.screening_questions(id) ON DELETE CASCADE
);

CREATE INDEX idx_responses_expert ON expert_network.expert_screening_responses(expert_id);
CREATE INDEX idx_responses_question ON expert_network.expert_screening_responses(screening_question_id);

-- =============================================================================
-- INTERVIEWS
-- =============================================================================

CREATE TABLE expert_network.interviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL,
    expert_id UUID NOT NULL,
    scheduled_date DATE NOT NULL,
    scheduled_time TIME NOT NULL,
    duration_minutes INTEGER NOT NULL DEFAULT 60,
    timezone TEXT NOT NULL DEFAULT 'UTC',
    status TEXT NOT NULL DEFAULT 'scheduled',
    color_tag TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,

    CONSTRAINT fk_interviews_campaign FOREIGN KEY (campaign_id)
        REFERENCES expert_network.campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_interviews_expert FOREIGN KEY (expert_id)
        REFERENCES expert_network.experts(id) ON DELETE CASCADE
);

CREATE INDEX idx_interviews_campaign ON expert_network.interviews(campaign_id);
CREATE INDEX idx_interviews_expert ON expert_network.interviews(expert_id);
CREATE INDEX idx_interviews_date ON expert_network.interviews(scheduled_date);
CREATE INDEX idx_interviews_status ON expert_network.interviews(status);

-- =============================================================================
-- USER UI PREFERENCES
-- =============================================================================

CREATE TABLE expert_network.user_ui_preferences (
    user_id TEXT PRIMARY KEY,
    column_widths JSONB NOT NULL DEFAULT '{"dragHandle": 16, "campaignName": 400, "industry": 180}'::jsonb,
    panel_sizing JSONB NOT NULL DEFAULT '{"chatWidth": 400, "answerWidth": 600}'::jsonb,
    theme TEXT NOT NULL DEFAULT 'light' CHECK (theme IN ('light', 'dark')),
    expanded_projects TEXT[] DEFAULT '{}',
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE expert_network.user_ui_preferences IS 'Per-user UI state and preferences';

-- =============================================================================
-- TRIGGERS FOR UPDATED_AT
-- =============================================================================

CREATE OR REPLACE FUNCTION expert_network.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers
CREATE TRIGGER update_projects_updated_at
    BEFORE UPDATE ON expert_network.projects
    FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();

CREATE TRIGGER update_campaigns_updated_at
    BEFORE UPDATE ON expert_network.campaigns
    FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();

CREATE TRIGGER update_screening_questions_updated_at
    BEFORE UPDATE ON expert_network.screening_questions
    FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();

CREATE TRIGGER update_vendor_platforms_updated_at
    BEFORE UPDATE ON expert_network.vendor_platforms
    FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();

CREATE TRIGGER update_campaign_vendor_enrollments_updated_at
    BEFORE UPDATE ON expert_network.campaign_vendor_enrollments
    FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();

CREATE TRIGGER update_experts_updated_at
    BEFORE UPDATE ON expert_network.experts
    FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();

CREATE TRIGGER update_interviews_updated_at
    BEFORE UPDATE ON expert_network.interviews
    FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();

CREATE TRIGGER update_user_ui_preferences_updated_at
    BEFORE UPDATE ON expert_network.user_ui_preferences
    FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();

-- =============================================================================
-- VERIFICATION
-- =============================================================================

SELECT 'expert_network schema created successfully!' AS status;

-- Show all tables in expert_network schema
SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname = 'expert_network'
ORDER BY tablename;
