-- Expert Networks Application - PostgreSQL Schema
-- Version: 1.0
-- Description: Complete database schema for multi-tenant expert networks management platform
--
-- Prerequisites:
-- - PostgreSQL 14+
-- - BetterAuth tables already created
-- - UUID extension enabled

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- For text search

-- =============================================================================
-- PROJECTS
-- =============================================================================

CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References better_auth users table
    project_code TEXT NOT NULL,
    project_name TEXT NOT NULL,
    description TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT projects_user_code_unique UNIQUE(user_id, project_code)
);

CREATE INDEX idx_projects_user ON projects(user_id);
CREATE INDEX idx_projects_order ON projects(user_id, display_order);

COMMENT ON TABLE projects IS 'Top-level organizational container for campaigns';
COMMENT ON COLUMN projects.display_order IS 'User-specific ordering for dashboard display';

-- =============================================================================
-- CAMPAIGNS
-- =============================================================================

CREATE TABLE campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References better_auth users
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
    estimated_calls INTEGER,  -- Deprecated but kept for backwards compatibility
    completed_calls INTEGER NOT NULL DEFAULT 0,
    scheduled_calls INTEGER NOT NULL DEFAULT 0,

    -- Ordering
    display_order INTEGER NOT NULL DEFAULT 0,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_campaigns_project FOREIGN KEY (project_id)
        REFERENCES projects(id) ON DELETE SET NULL
);

CREATE INDEX idx_campaigns_user ON campaigns(user_id);
CREATE INDEX idx_campaigns_project ON campaigns(project_id);
CREATE INDEX idx_campaigns_order ON campaigns(user_id, project_id, display_order);
CREATE INDEX idx_campaigns_dates ON campaigns(start_date, target_completion_date);
CREATE INDEX idx_campaigns_industry ON campaigns(industry_vertical);

COMMENT ON TABLE campaigns IS 'Interview campaigns for commercial diligence projects';
COMMENT ON COLUMN campaigns.target_regions IS 'Array of regions: North America, Europe, Asia Pacific, Latin America, Middle East & Africa';
COMMENT ON COLUMN campaigns.completed_calls IS 'Number of interviews completed';
COMMENT ON COLUMN campaigns.scheduled_calls IS 'Number of interviews scheduled but not yet completed';

-- =============================================================================
-- TEAM MEMBERS
-- =============================================================================

CREATE TABLE team_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References better_auth users (owner of this team member pool)
    name TEXT NOT NULL,
    email TEXT,
    designation TEXT NOT NULL,
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_team_members_user ON team_members(user_id);
CREATE INDEX idx_team_members_name ON team_members(name);

COMMENT ON TABLE team_members IS 'Pool of team members that can be assigned to campaigns';

-- =============================================================================
-- CAMPAIGN TEAM ASSIGNMENTS
-- =============================================================================

CREATE TABLE campaign_team_assignments (
    campaign_id UUID NOT NULL,
    team_member_id UUID NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (campaign_id, team_member_id),
    CONSTRAINT fk_campaign_team_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_campaign_team_member FOREIGN KEY (team_member_id)
        REFERENCES team_members(id) ON DELETE CASCADE
);

CREATE INDEX idx_campaign_team_campaign ON campaign_team_assignments(campaign_id);
CREATE INDEX idx_campaign_team_member ON campaign_team_assignments(team_member_id);

COMMENT ON TABLE campaign_team_assignments IS 'Many-to-many relationship between campaigns and team members';

-- =============================================================================
-- SCREENING QUESTIONS
-- =============================================================================

CREATE TABLE screening_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL,
    parent_question_id UUID,  -- NULL for top-level questions
    question_text TEXT NOT NULL,
    question_type TEXT DEFAULT 'text',  -- 'text', 'multiple-choice', 'rating'
    options JSONB,  -- For multiple-choice questions
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_screening_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_screening_parent FOREIGN KEY (parent_question_id)
        REFERENCES screening_questions(id) ON DELETE CASCADE
);

CREATE INDEX idx_screening_campaign ON screening_questions(campaign_id);
CREATE INDEX idx_screening_parent ON screening_questions(parent_question_id);
CREATE INDEX idx_screening_order ON screening_questions(campaign_id, display_order);

COMMENT ON TABLE screening_questions IS 'Screening questions for expert vetting, supports hierarchical sub-questions';
COMMENT ON COLUMN screening_questions.parent_question_id IS 'NULL for top-level questions, references parent for sub-questions';

-- =============================================================================
-- VENDOR PLATFORMS
-- =============================================================================

CREATE TABLE vendor_platforms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    logo_url TEXT,
    location TEXT,
    overall_score DECIMAL(2,1),
    avg_cost_per_call_min INTEGER,  -- In USD
    avg_cost_per_call_max INTEGER,  -- In USD
    description TEXT,
    tags TEXT[] DEFAULT '{}',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_vendors_active ON vendor_platforms(is_active);
CREATE INDEX idx_vendors_name ON vendor_platforms(name);

COMMENT ON TABLE vendor_platforms IS 'Global catalog of expert network platforms (GLG, AlphaSights, Guidepoint, etc.)';

-- =============================================================================
-- CAMPAIGN VENDOR ENROLLMENTS
-- =============================================================================

CREATE TABLE campaign_vendor_enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL,
    vendor_platform_id UUID NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',  -- 'pending', 'enrolled', 'not_enrolled'
    enrolled_at TIMESTAMPTZ,
    account_manager_name TEXT,
    account_manager_email TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT enrollment_unique UNIQUE(campaign_id, vendor_platform_id),
    CONSTRAINT fk_enrollment_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_vendor FOREIGN KEY (vendor_platform_id)
        REFERENCES vendor_platforms(id) ON DELETE CASCADE
);

CREATE INDEX idx_enrollments_campaign ON campaign_vendor_enrollments(campaign_id);
CREATE INDEX idx_enrollments_vendor ON campaign_vendor_enrollments(vendor_platform_id);
CREATE INDEX idx_enrollments_status ON campaign_vendor_enrollments(status);

COMMENT ON TABLE campaign_vendor_enrollments IS 'Tracks which vendors are enrolled for each campaign';

-- =============================================================================
-- EXPERTS
-- =============================================================================

CREATE TABLE experts (
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
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 5),  -- Overall rating (0-5)
    ai_fit_score INTEGER CHECK (ai_fit_score >= 0 AND ai_fit_score <= 10),  -- AI-generated fit score (0-10)

    -- Status
    status TEXT NOT NULL DEFAULT 'proposed',  -- 'proposed', 'reviewed', 'rejected', 'scheduling', 'scheduled', 'completed'
    is_new BOOLEAN NOT NULL DEFAULT true,

    -- Metadata
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    reviewed_at TIMESTAMPTZ,

    CONSTRAINT fk_experts_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_experts_vendor FOREIGN KEY (vendor_platform_id)
        REFERENCES vendor_platforms(id)
);

CREATE INDEX idx_experts_campaign ON experts(campaign_id);
CREATE INDEX idx_experts_vendor ON experts(vendor_platform_id);
CREATE INDEX idx_experts_status ON experts(status);
CREATE INDEX idx_experts_campaign_status ON experts(campaign_id, status);
CREATE INDEX idx_experts_name ON experts USING gin(name gin_trgm_ops);

COMMENT ON TABLE experts IS 'Expert profiles proposed by vendors for campaigns';
COMMENT ON COLUMN experts.ai_fit_score IS 'AI-generated score indicating how well expert matches campaign requirements';

-- =============================================================================
-- EXPERT SCREENING RESPONSES
-- =============================================================================

CREATE TABLE expert_screening_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expert_id UUID NOT NULL,
    screening_question_id UUID NOT NULL,
    response_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_responses_expert FOREIGN KEY (expert_id)
        REFERENCES experts(id) ON DELETE CASCADE,
    CONSTRAINT fk_responses_question FOREIGN KEY (screening_question_id)
        REFERENCES screening_questions(id) ON DELETE CASCADE
);

CREATE INDEX idx_responses_expert ON expert_screening_responses(expert_id);
CREATE INDEX idx_responses_question ON expert_screening_responses(screening_question_id);

COMMENT ON TABLE expert_screening_responses IS 'Expert responses to screening questions';

-- =============================================================================
-- INTERVIEWS
-- =============================================================================

CREATE TABLE interviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL,
    expert_id UUID NOT NULL,

    -- Scheduling
    scheduled_date DATE NOT NULL,
    scheduled_time TIME NOT NULL,
    duration_minutes INTEGER NOT NULL DEFAULT 60,
    timezone TEXT NOT NULL DEFAULT 'UTC',

    -- Status
    status TEXT NOT NULL DEFAULT 'scheduled',  -- 'scheduled', 'confirmed', 'pending', 'cancelled', 'completed'

    -- Visual
    color_tag TEXT,  -- For calendar display

    -- Metadata
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,

    CONSTRAINT fk_interviews_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_interviews_expert FOREIGN KEY (expert_id)
        REFERENCES experts(id) ON DELETE CASCADE
);

CREATE INDEX idx_interviews_campaign ON interviews(campaign_id);
CREATE INDEX idx_interviews_expert ON interviews(expert_id);
CREATE INDEX idx_interviews_date ON interviews(scheduled_date);
CREATE INDEX idx_interviews_status ON interviews(status);
CREATE INDEX idx_interviews_campaign_status ON interviews(campaign_id, status);
CREATE INDEX idx_interviews_campaign_date ON interviews(campaign_id, scheduled_date);

COMMENT ON TABLE interviews IS 'Scheduled interviews with experts';

-- =============================================================================
-- INTERVIEW TEAM ASSIGNMENTS
-- =============================================================================

CREATE TABLE interview_team_assignments (
    interview_id UUID NOT NULL,
    team_member_id UUID NOT NULL,

    PRIMARY KEY (interview_id, team_member_id),
    CONSTRAINT fk_interview_team_interview FOREIGN KEY (interview_id)
        REFERENCES interviews(id) ON DELETE CASCADE,
    CONSTRAINT fk_interview_team_member FOREIGN KEY (team_member_id)
        REFERENCES team_members(id) ON DELETE CASCADE
);

CREATE INDEX idx_interview_team_interview ON interview_team_assignments(interview_id);
CREATE INDEX idx_interview_team_member ON interview_team_assignments(team_member_id);

COMMENT ON TABLE interview_team_assignments IS 'Assigns team members to specific interviews';

-- =============================================================================
-- COMPLETED INTERVIEWS
-- =============================================================================

CREATE TABLE completed_interviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    interview_id UUID NOT NULL UNIQUE,  -- One-to-one with interviews
    campaign_id UUID NOT NULL,
    expert_id UUID NOT NULL,

    -- Interview details
    interview_date DATE NOT NULL,
    interview_time TEXT NOT NULL,
    duration TEXT NOT NULL,

    -- Artifacts
    transcript_url TEXT,
    transcript_available BOOLEAN NOT NULL DEFAULT false,
    recording_url TEXT,
    notes TEXT,

    -- Ratings
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 5),  -- Overall rating (0-5)
    relevance_rating DECIMAL(2,1) CHECK (relevance_rating >= 0 AND relevance_rating <= 5),
    expertise_rating DECIMAL(2,1) CHECK (expertise_rating >= 0 AND expertise_rating <= 5),
    communication_rating DECIMAL(2,1) CHECK (communication_rating >= 0 AND communication_rating <= 5),
    review_text TEXT,

    -- Metadata
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    rated_at TIMESTAMPTZ,

    CONSTRAINT fk_completed_interview FOREIGN KEY (interview_id)
        REFERENCES interviews(id) ON DELETE CASCADE,
    CONSTRAINT fk_completed_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_completed_expert FOREIGN KEY (expert_id)
        REFERENCES experts(id) ON DELETE CASCADE
);

CREATE INDEX idx_completed_campaign ON completed_interviews(campaign_id);
CREATE INDEX idx_completed_expert ON completed_interviews(expert_id);
CREATE INDEX idx_completed_date ON completed_interviews(interview_date);
CREATE INDEX idx_completed_rating ON completed_interviews(rating);

COMMENT ON TABLE completed_interviews IS 'Completed interviews with transcripts and ratings';

-- =============================================================================
-- CHAT SESSIONS (AI Assistant)
-- =============================================================================

CREATE TABLE chat_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References better_auth users
    campaign_id UUID,  -- Optional: chat can be campaign-specific or general
    title TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_chat_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE SET NULL
);

CREATE INDEX idx_chat_sessions_user ON chat_sessions(user_id);
CREATE INDEX idx_chat_sessions_campaign ON chat_sessions(campaign_id);
CREATE INDEX idx_chat_sessions_updated ON chat_sessions(user_id, updated_at DESC);

COMMENT ON TABLE chat_sessions IS 'AI assistant chat sessions for research and analysis';

-- =============================================================================
-- CHAT MESSAGES
-- =============================================================================

CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_session_id UUID NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_message_session FOREIGN KEY (chat_session_id)
        REFERENCES chat_sessions(id) ON DELETE CASCADE
);

CREATE INDEX idx_chat_messages_session ON chat_messages(chat_session_id);
CREATE INDEX idx_chat_messages_created ON chat_messages(chat_session_id, created_at);

COMMENT ON TABLE chat_messages IS 'Messages within AI assistant chat sessions';

-- =============================================================================
-- RESEARCH ACTIVITIES
-- =============================================================================

CREATE TABLE research_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_session_id UUID NOT NULL,
    activity_name TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'queued' CHECK (status IN ('queued', 'processing', 'completed', 'failed')),
    confidence INTEGER CHECK (confidence >= 0 AND confidence <= 100),  -- Percentage
    result_data JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,

    CONSTRAINT fk_activity_session FOREIGN KEY (chat_session_id)
        REFERENCES chat_sessions(id) ON DELETE CASCADE
);

CREATE INDEX idx_research_session ON research_activities(chat_session_id);
CREATE INDEX idx_research_status ON research_activities(status);

COMMENT ON TABLE research_activities IS 'Tracks research tasks and agents during assistant sessions';

-- =============================================================================
-- RESEARCH SOURCES
-- =============================================================================

CREATE TABLE research_sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_session_id UUID NOT NULL,
    source_name TEXT NOT NULL,
    source_type TEXT NOT NULL,  -- 'URL', 'Document', 'API', etc.
    status TEXT NOT NULL DEFAULT 'processing' CHECK (status IN ('scraped', 'processing', 'failed')),
    size_text TEXT,  -- '142 KB', etc.
    url TEXT,
    content_preview TEXT,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_source_session FOREIGN KEY (chat_session_id)
        REFERENCES chat_sessions(id) ON DELETE CASCADE
);

CREATE INDEX idx_sources_session ON research_sources(chat_session_id);
CREATE INDEX idx_sources_status ON research_sources(status);

COMMENT ON TABLE research_sources IS 'Sources gathered during research sessions';

-- =============================================================================
-- ANSWER SECTIONS
-- =============================================================================

CREATE TABLE answer_sections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_session_id UUID NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_answer_session FOREIGN KEY (chat_session_id)
        REFERENCES chat_sessions(id) ON DELETE CASCADE
);

CREATE INDEX idx_answer_sections_session ON answer_sections(chat_session_id);
CREATE INDEX idx_answer_sections_order ON answer_sections(chat_session_id, display_order);

COMMENT ON TABLE answer_sections IS 'Structured answer sections generated during research sessions';

-- =============================================================================
-- USER UI PREFERENCES
-- =============================================================================

CREATE TABLE user_ui_preferences (
    user_id TEXT PRIMARY KEY,  -- References better_auth users

    -- Dashboard column widths
    column_widths JSONB NOT NULL DEFAULT '{
        "dragHandle": 16,
        "campaignName": 400,
        "industry": 180,
        "timeline": 250,
        "targetRegions": 288,
        "divider": 1,
        "callsProgress": 200,
        "status": 96,
        "cost": 80,
        "team": 80,
        "delete": 32
    }'::jsonb,

    -- Panel sizes (workspace layout)
    panel_sizing JSONB NOT NULL DEFAULT '{
        "chatWidth": 400,
        "answerWidth": 600,
        "topHeight": 300,
        "activitiesWidth": 300,
        "sourcesWidth": 300
    }'::jsonb,

    -- Theme preference
    theme TEXT NOT NULL DEFAULT 'light' CHECK (theme IN ('light', 'dark')),

    -- Other UI state
    expanded_projects TEXT[] DEFAULT '{}',  -- Project IDs that are expanded in sidebar

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE user_ui_preferences IS 'Stores per-user UI preferences, layouts, and settings';
COMMENT ON COLUMN user_ui_preferences.column_widths IS 'Dashboard column widths in pixels';
COMMENT ON COLUMN user_ui_preferences.panel_sizing IS 'Workspace panel dimensions in pixels';

-- =============================================================================
-- TRIGGERS FOR UPDATED_AT
-- =============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to all tables with updated_at column
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_campaigns_updated_at BEFORE UPDATE ON campaigns
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_screening_questions_updated_at BEFORE UPDATE ON screening_questions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vendor_platforms_updated_at BEFORE UPDATE ON vendor_platforms
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_campaign_vendor_enrollments_updated_at BEFORE UPDATE ON campaign_vendor_enrollments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_experts_updated_at BEFORE UPDATE ON experts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_interviews_updated_at BEFORE UPDATE ON interviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chat_sessions_updated_at BEFORE UPDATE ON chat_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_ui_preferences_updated_at BEFORE UPDATE ON user_ui_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================================================
-- VIEWS FOR COMMON QUERIES
-- =============================================================================

-- View: Active campaigns with computed status
CREATE VIEW v_active_campaigns AS
SELECT
    c.*,
    p.project_name,
    CASE
        WHEN CURRENT_DATE < c.start_date THEN 'Waiting'
        WHEN CURRENT_DATE >= c.start_date AND CURRENT_DATE <= c.target_completion_date THEN 'Active'
        ELSE 'Completed'
    END AS computed_status,
    CASE
        WHEN c.min_calls IS NOT NULL AND c.max_calls IS NOT NULL
        THEN (c.min_calls + c.max_calls) / 2
        ELSE c.estimated_calls
    END AS target_calls,
    (SELECT COUNT(*) FROM experts e WHERE e.campaign_id = c.id) AS expert_count,
    (SELECT COUNT(*) FROM campaign_vendor_enrollments cve WHERE cve.campaign_id = c.id AND cve.status = 'enrolled') AS enrolled_vendor_count
FROM campaigns c
LEFT JOIN projects p ON c.project_id = p.id;

COMMENT ON VIEW v_active_campaigns IS 'Campaigns with computed status and aggregate counts';

-- View: Expert pipeline summary per campaign
CREATE VIEW v_campaign_expert_pipeline AS
SELECT
    c.id AS campaign_id,
    c.campaign_name,
    COUNT(CASE WHEN e.status = 'proposed' THEN 1 END) AS proposed_count,
    COUNT(CASE WHEN e.status = 'reviewed' THEN 1 END) AS reviewed_count,
    COUNT(CASE WHEN e.status = 'scheduling' THEN 1 END) AS scheduling_count,
    COUNT(CASE WHEN e.status = 'scheduled' THEN 1 END) AS scheduled_count,
    COUNT(CASE WHEN e.status = 'completed' THEN 1 END) AS completed_count,
    AVG(CASE WHEN e.rating IS NOT NULL THEN e.rating END) AS avg_expert_rating,
    AVG(e.ai_fit_score) AS avg_ai_fit_score
FROM campaigns c
LEFT JOIN experts e ON c.id = e.campaign_id
GROUP BY c.id, c.campaign_name;

COMMENT ON VIEW v_campaign_expert_pipeline IS 'Summary of expert pipeline status per campaign';

-- =============================================================================
-- GRANT PERMISSIONS
-- =============================================================================

-- Grant usage on sequences
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO PUBLIC;

-- Grant permissions on tables (adjust role name as needed)
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO your_app_role;

-- =============================================================================
-- COMPLETION
-- =============================================================================

-- Schema creation complete
SELECT 'Expert Networks schema created successfully!' AS status;
