# Expert Networks Application - Database Schema Design

## Overview
This document provides a comprehensive PostgreSQL database schema for the Expert Networks UI application. The schema supports multi-tenancy, complex hierarchical data, and preserves all UI state per user.

---

## Core Entities & Relationships

### 1. **Users** (from BetterAuth/SSO)
- Primary entity for authentication and authorization
- All data is scoped per user
- Managed by BetterAuth

### 2. **Projects**
- Top-level organizational container
- Contains multiple campaigns
- Has custom ordering per user

### 3. **Campaigns**
- Main work unit for organizing expert interview efforts
- Belongs to a project (or no project - "Other Campaigns")
- Has complex workflow state

### 4. **Expert Network Vendors**
- External platforms (GLG, AlphaSights, Guidepoint, etc.)
- Enrolled per campaign
- Global vendor catalog + per-campaign enrollment status

### 5. **Experts**
- Individuals proposed by vendors
- Can be in various states (proposed, reviewed, scheduled, interviewed)
- Complex profile data with skills, screening responses

### 6. **Interviews**
- Scheduled or completed interviews with experts
- Linked to campaigns and experts
- Has ratings, transcripts, team assignments

### 7. **Team Members**
- Users or profiles that can be assigned to campaigns
- Many-to-many relationship with campaigns

---

## Detailed Schema

### Table: `users`
*Managed by BetterAuth - referenced by foreign keys*

```sql
-- This table is managed by BetterAuth
-- We reference it but don't create it
-- Typical structure:
-- id (uuid/text)
-- email
-- name
-- created_at
-- etc.
```

---

### Table: `projects`

```sql
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References better_auth users
    project_code TEXT NOT NULL,
    project_name TEXT NOT NULL,
    description TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE(user_id, project_code),
    INDEX idx_projects_user (user_id),
    INDEX idx_projects_order (user_id, display_order)
);

COMMENT ON TABLE projects IS 'Top-level organizational container for campaigns';
COMMENT ON COLUMN projects.display_order IS 'User-specific ordering for dashboard display';
```

---

### Table: `campaigns`

```sql
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

    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL,
    INDEX idx_campaigns_user (user_id),
    INDEX idx_campaigns_project (project_id),
    INDEX idx_campaigns_order (user_id, project_id, display_order),
    INDEX idx_campaigns_dates (start_date, target_completion_date)
);

COMMENT ON TABLE campaigns IS 'Interview campaigns for commercial diligence projects';
COMMENT ON COLUMN campaigns.target_regions IS 'Array of regions: North America, Europe, Asia Pacific, etc.';
COMMENT ON COLUMN campaigns.completed_calls IS 'Number of interviews completed';
COMMENT ON COLUMN campaigns.scheduled_calls IS 'Number of interviews scheduled but not yet completed';
```

---

### Table: `team_members`

```sql
CREATE TABLE team_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References better_auth users (owner)
    name TEXT NOT NULL,
    email TEXT,
    designation TEXT NOT NULL,
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    INDEX idx_team_members_user (user_id)
);

COMMENT ON TABLE team_members IS 'Pool of team members that can be assigned to campaigns';
```

---

### Table: `campaign_team_assignments`

```sql
CREATE TABLE campaign_team_assignments (
    campaign_id UUID NOT NULL,
    team_member_id UUID NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (campaign_id, team_member_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (team_member_id) REFERENCES team_members(id) ON DELETE CASCADE,
    INDEX idx_campaign_team_campaign (campaign_id),
    INDEX idx_campaign_team_member (team_member_id)
);

COMMENT ON TABLE campaign_team_assignments IS 'Many-to-many relationship between campaigns and team members';
```

---

### Table: `screening_questions`

```sql
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

    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_question_id) REFERENCES screening_questions(id) ON DELETE CASCADE,
    INDEX idx_screening_campaign (campaign_id),
    INDEX idx_screening_parent (parent_question_id),
    INDEX idx_screening_order (campaign_id, display_order)
);

COMMENT ON TABLE screening_questions IS 'Screening questions for expert vetting, supports hierarchical sub-questions';
COMMENT ON COLUMN screening_questions.parent_question_id IS 'NULL for top-level questions, references parent for sub-questions';
```

---

### Table: `vendor_platforms`

```sql
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
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    INDEX idx_vendors_active (is_active)
);

COMMENT ON TABLE vendor_platforms IS 'Global catalog of expert network platforms (GLG, AlphaSights, etc.)';
```

---

### Table: `campaign_vendor_enrollments`

```sql
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

    UNIQUE(campaign_id, vendor_platform_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_platform_id) REFERENCES vendor_platforms(id) ON DELETE CASCADE,
    INDEX idx_enrollments_campaign (campaign_id),
    INDEX idx_enrollments_vendor (vendor_platform_id),
    INDEX idx_enrollments_status (status)
);

COMMENT ON TABLE campaign_vendor_enrollments IS 'Tracks which vendors are enrolled for each campaign';
```

---

### Table: `experts`

```sql
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
    rating DECIMAL(2,1),  -- Overall rating (0-5)
    ai_fit_score INTEGER,  -- AI-generated fit score (0-10)

    -- Status
    status TEXT NOT NULL DEFAULT 'proposed',  -- 'proposed', 'reviewed', 'rejected', 'scheduling', 'scheduled', 'completed'
    is_new BOOLEAN NOT NULL DEFAULT true,

    -- Metadata
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    reviewed_at TIMESTAMPTZ,

    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_platform_id) REFERENCES vendor_platforms(id),
    INDEX idx_experts_campaign (campaign_id),
    INDEX idx_experts_vendor (vendor_platform_id),
    INDEX idx_experts_status (status),
    INDEX idx_experts_campaign_status (campaign_id, status)
);

COMMENT ON TABLE experts IS 'Expert profiles proposed by vendors for campaigns';
COMMENT ON COLUMN experts.ai_fit_score IS 'AI-generated score indicating how well expert matches campaign requirements';
```

---

### Table: `expert_screening_responses`

```sql
CREATE TABLE expert_screening_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expert_id UUID NOT NULL,
    screening_question_id UUID NOT NULL,
    response_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    FOREIGN KEY (expert_id) REFERENCES experts(id) ON DELETE CASCADE,
    FOREIGN KEY (screening_question_id) REFERENCES screening_questions(id) ON DELETE CASCADE,
    INDEX idx_responses_expert (expert_id),
    INDEX idx_responses_question (screening_question_id)
);

COMMENT ON TABLE expert_screening_responses IS 'Experts responses to screening questions';
```

---

### Table: `interviews`

```sql
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

    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (expert_id) REFERENCES experts(id) ON DELETE CASCADE,
    INDEX idx_interviews_campaign (campaign_id),
    INDEX idx_interviews_expert (expert_id),
    INDEX idx_interviews_date (scheduled_date),
    INDEX idx_interviews_status (status),
    INDEX idx_interviews_campaign_status (campaign_id, status)
);

COMMENT ON TABLE interviews IS 'Scheduled interviews with experts';
```

---

### Table: `interview_team_assignments`

```sql
CREATE TABLE interview_team_assignments (
    interview_id UUID NOT NULL,
    team_member_id UUID NOT NULL,

    PRIMARY KEY (interview_id, team_member_id),
    FOREIGN KEY (interview_id) REFERENCES interviews(id) ON DELETE CASCADE,
    FOREIGN KEY (team_member_id) REFERENCES team_members(id) ON DELETE CASCADE,
    INDEX idx_interview_team_interview (interview_id),
    INDEX idx_interview_team_member (team_member_id)
);

COMMENT ON TABLE interview_team_assignments IS 'Assigns team members to specific interviews';
```

---

### Table: `completed_interviews`

```sql
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
    rating DECIMAL(2,1),  -- Overall rating (0-5)
    relevance_rating DECIMAL(2,1),
    expertise_rating DECIMAL(2,1),
    communication_rating DECIMAL(2,1),
    review_text TEXT,

    -- Metadata
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    rated_at TIMESTAMPTZ,

    FOREIGN KEY (interview_id) REFERENCES interviews(id) ON DELETE CASCADE,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (expert_id) REFERENCES experts(id) ON DELETE CASCADE,
    INDEX idx_completed_campaign (campaign_id),
    INDEX idx_completed_expert (expert_id),
    INDEX idx_completed_date (interview_date),
    INDEX idx_completed_rating (rating)
);

COMMENT ON TABLE completed_interviews IS 'Completed interviews with transcripts and ratings';
```

---

### Table: `chat_sessions`

```sql
CREATE TABLE chat_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,  -- References better_auth users
    campaign_id UUID,  -- Optional: chat can be campaign-specific or general
    title TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE SET NULL,
    INDEX idx_chat_sessions_user (user_id),
    INDEX idx_chat_sessions_campaign (campaign_id),
    INDEX idx_chat_sessions_updated (user_id, updated_at DESC)
);

COMMENT ON TABLE chat_sessions IS 'AI assistant chat sessions for research and analysis';
```

---

### Table: `chat_messages`

```sql
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_session_id UUID NOT NULL,
    role TEXT NOT NULL,  -- 'user' or 'assistant'
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    FOREIGN KEY (chat_session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE,
    INDEX idx_chat_messages_session (chat_session_id),
    INDEX idx_chat_messages_created (chat_session_id, created_at)
);

COMMENT ON TABLE chat_messages IS 'Messages within AI assistant chat sessions';
```

---

### Table: `research_activities`

```sql
CREATE TABLE research_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_session_id UUID NOT NULL,
    activity_name TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'queued',  -- 'queued', 'processing', 'completed', 'failed'
    confidence INTEGER,  -- Percentage (0-100)
    result_data JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,

    FOREIGN KEY (chat_session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE,
    INDEX idx_research_session (chat_session_id),
    INDEX idx_research_status (status)
);

COMMENT ON TABLE research_activities IS 'Tracks research tasks and agents during assistant sessions';
```

---

### Table: `research_sources`

```sql
CREATE TABLE research_sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_session_id UUID NOT NULL,
    source_name TEXT NOT NULL,
    source_type TEXT NOT NULL,  -- 'URL', 'Document', 'API', etc.
    status TEXT NOT NULL DEFAULT 'processing',  -- 'scraped', 'processing', 'failed'
    size_text TEXT,  -- '142 KB', etc.
    url TEXT,
    content_preview TEXT,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    FOREIGN KEY (chat_session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE,
    INDEX idx_sources_session (chat_session_id),
    INDEX idx_sources_status (status)
);

COMMENT ON TABLE research_sources IS 'Sources gathered during research sessions';
```

---

### Table: `user_ui_preferences`

```sql
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
    theme TEXT NOT NULL DEFAULT 'light',  -- 'light' or 'dark'

    -- Other UI state
    expanded_projects TEXT[] DEFAULT '{}',  -- Project IDs that are expanded in sidebar

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE user_ui_preferences IS 'Stores per-user UI preferences, layouts, and settings';
COMMENT ON COLUMN user_ui_preferences.column_widths IS 'Dashboard column widths in pixels';
COMMENT ON COLUMN user_ui_preferences.panel_sizing IS 'Workspace panel dimensions in pixels';
```

---

### Table: `answer_sections`

```sql
CREATE TABLE answer_sections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_session_id UUID NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    FOREIGN KEY (chat_session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE,
    INDEX idx_answer_sections_session (chat_session_id),
    INDEX idx_answer_sections_order (chat_session_id, display_order)
);

COMMENT ON TABLE answer_sections IS 'Structured answer sections generated during research sessions';
```

---

## Indexes Summary

All critical foreign keys have indexes created automatically. Additional composite indexes are created for:
- User-scoped queries (most tables)
- Campaign status and timeline queries
- Ordering/display order
- Date-based queries for interviews
- Status-based queries for workflows

---

## Data Relationships

```
users (BetterAuth)
  ├─ projects (1:many)
  │   └─ campaigns (1:many)
  │       ├─ team_assignments (many:many) ─ team_members
  │       ├─ screening_questions (1:many)
  │       │   └─ sub_questions (hierarchical)
  │       ├─ vendor_enrollments (many:many) ─ vendor_platforms
  │       ├─ experts (1:many)
  │       │   ├─ screening_responses (1:many)
  │       │   └─ interviews (1:many)
  │       │       ├─ team_assignments (many:many)
  │       │       └─ completed_interview (1:1)
  │       └─ chat_sessions (1:many)
  │           ├─ messages (1:many)
  │           ├─ research_activities (1:many)
  │           ├─ research_sources (1:many)
  │           └─ answer_sections (1:many)
  ├─ team_members (1:many)
  ├─ chat_sessions (1:many)
  └─ ui_preferences (1:1)
```

---

## Key Features

### Multi-Tenancy
- All user data is scoped by `user_id` from BetterAuth
- Projects, campaigns, and all related data are per-user
- UI preferences are per-user

### Hierarchical Data
- Projects → Campaigns (with "Other Campaigns" as null project)
- Screening Questions → Sub-questions (recursive hierarchy)
- Campaigns have custom ordering within projects
- Projects have custom ordering for display

### Workflow State
- Experts: proposed → reviewed → scheduling → scheduled → completed
- Interviews: scheduled → confirmed → completed → rated
- Vendor enrollments: not_enrolled → pending → enrolled
- Research activities: queued → processing → completed

### UI State Preservation
- Column widths for dashboard
- Panel sizes for workspace
- Expanded/collapsed projects in sidebar
- Theme preference
- All ordering information

---

## Migration Strategy

For demo purposes with LLM mock vendor:

1. **Seed vendor_platforms** with the 18 vendors from mockData.ts
2. **Create mock LLM service** that:
   - Responds to vendor enrollment requests
   - Generates realistic expert profiles based on campaign scope
   - Simulates expert proposal workflow
   - Generates realistic screening question responses
3. **Populate with sample data** from existing mockData for demonstration

---

## Future Enhancements

1. **Audit Logging**: Add audit tables for compliance
2. **Notifications**: Table for user notifications
3. **File Attachments**: Table for storing campaign documents
4. **Expert Network Integrations**: API credentials and webhooks
5. **Analytics**: Pre-computed metrics and dashboards
6. **Export Templates**: Saved report templates
7. **Collaboration**: Comments and mentions on campaigns/experts
8. **Calendar Integration**: Sync with external calendars
9. **Cost Tracking**: Detailed invoice and payment tracking
10. **Compliance**: FCPA, conflict checks, and documentation
