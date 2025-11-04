--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: expert_network; Type: SCHEMA; Schema: -; Owner: raguser
--

CREATE SCHEMA expert_network;


ALTER SCHEMA expert_network OWNER TO raguser;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: expert_network; Owner: raguser
--

CREATE FUNCTION expert_network.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION expert_network.update_updated_at_column() OWNER TO raguser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: campaign_team_assignments; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.campaign_team_assignments (
    campaign_id uuid NOT NULL,
    team_member_id uuid NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE expert_network.campaign_team_assignments OWNER TO raguser;

--
-- Name: campaign_vendor_enrollments; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.campaign_vendor_enrollments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    vendor_platform_id uuid NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    enrolled_at timestamp with time zone,
    account_manager_name text,
    account_manager_email text,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE expert_network.campaign_vendor_enrollments OWNER TO raguser;

--
-- Name: campaigns; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.campaigns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id text NOT NULL,
    project_id uuid,
    campaign_name text NOT NULL,
    industry_vertical text NOT NULL,
    custom_industry text,
    brief_description text,
    expanded_description text,
    start_date date NOT NULL,
    target_completion_date date NOT NULL,
    target_regions text[] DEFAULT '{}'::text[] NOT NULL,
    min_calls integer,
    max_calls integer,
    estimated_calls integer,
    completed_calls integer DEFAULT 0 NOT NULL,
    scheduled_calls integer DEFAULT 0 NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE expert_network.campaigns OWNER TO raguser;

--
-- Name: TABLE campaigns; Type: COMMENT; Schema: expert_network; Owner: raguser
--

COMMENT ON TABLE expert_network.campaigns IS 'Interview campaigns for commercial diligence projects';


--
-- Name: expert_screening_responses; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.expert_screening_responses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    expert_id uuid NOT NULL,
    screening_question_id uuid NOT NULL,
    response_text text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE expert_network.expert_screening_responses OWNER TO raguser;

--
-- Name: experts; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.experts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    vendor_platform_id uuid NOT NULL,
    name text NOT NULL,
    title text NOT NULL,
    company text,
    avatar_url text,
    description text,
    work_history text,
    skills text[] DEFAULT '{}'::text[],
    rating numeric(2,1),
    ai_fit_score integer,
    status text DEFAULT 'proposed'::text NOT NULL,
    is_new boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    reviewed_at timestamp with time zone,
    CONSTRAINT experts_ai_fit_score_check CHECK (((ai_fit_score >= 0) AND (ai_fit_score <= 10))),
    CONSTRAINT experts_rating_check CHECK (((rating >= (0)::numeric) AND (rating <= (5)::numeric)))
);


ALTER TABLE expert_network.experts OWNER TO raguser;

--
-- Name: interviews; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.interviews (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    expert_id uuid NOT NULL,
    scheduled_date date NOT NULL,
    scheduled_time time without time zone NOT NULL,
    duration_minutes integer DEFAULT 60 NOT NULL,
    timezone text DEFAULT 'UTC'::text NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    color_tag text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    cancelled_at timestamp with time zone
);


ALTER TABLE expert_network.interviews OWNER TO raguser;

--
-- Name: projects; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.projects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id text NOT NULL,
    project_code text NOT NULL,
    project_name text NOT NULL,
    description text,
    display_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE expert_network.projects OWNER TO raguser;

--
-- Name: TABLE projects; Type: COMMENT; Schema: expert_network; Owner: raguser
--

COMMENT ON TABLE expert_network.projects IS 'Top-level organizational container for campaigns';


--
-- Name: COLUMN projects.user_id; Type: COMMENT; Schema: expert_network; Owner: raguser
--

COMMENT ON COLUMN expert_network.projects.user_id IS 'References public.user(id) from BetterAuth';


--
-- Name: screening_questions; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.screening_questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    parent_question_id uuid,
    question_text text NOT NULL,
    question_type text DEFAULT 'text'::text,
    options jsonb,
    display_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE expert_network.screening_questions OWNER TO raguser;

--
-- Name: team_members; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.team_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id text NOT NULL,
    name text NOT NULL,
    email text,
    designation text NOT NULL,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE expert_network.team_members OWNER TO raguser;

--
-- Name: TABLE team_members; Type: COMMENT; Schema: expert_network; Owner: raguser
--

COMMENT ON TABLE expert_network.team_members IS 'Pool of team members that can be assigned to campaigns';


--
-- Name: user_ui_preferences; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.user_ui_preferences (
    user_id text NOT NULL,
    column_widths jsonb DEFAULT '{"industry": 180, "dragHandle": 16, "campaignName": 400}'::jsonb NOT NULL,
    panel_sizing jsonb DEFAULT '{"chatWidth": 400, "answerWidth": 600}'::jsonb NOT NULL,
    theme text DEFAULT 'light'::text NOT NULL,
    expanded_projects text[] DEFAULT '{}'::text[],
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT user_ui_preferences_theme_check CHECK ((theme = ANY (ARRAY['light'::text, 'dark'::text])))
);


ALTER TABLE expert_network.user_ui_preferences OWNER TO raguser;

--
-- Name: TABLE user_ui_preferences; Type: COMMENT; Schema: expert_network; Owner: raguser
--

COMMENT ON TABLE expert_network.user_ui_preferences IS 'Per-user UI state and preferences';


--
-- Name: vendor_platforms; Type: TABLE; Schema: expert_network; Owner: raguser
--

CREATE TABLE expert_network.vendor_platforms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    logo_url text,
    location text,
    overall_score numeric(2,1),
    avg_cost_per_call_min integer,
    avg_cost_per_call_max integer,
    description text,
    tags text[] DEFAULT '{}'::text[],
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE expert_network.vendor_platforms OWNER TO raguser;

--
-- Data for Name: campaign_team_assignments; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.campaign_team_assignments (campaign_id, team_member_id, assigned_at) FROM stdin;
\.


--
-- Data for Name: campaign_vendor_enrollments; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.campaign_vendor_enrollments (id, campaign_id, vendor_platform_id, status, enrolled_at, account_manager_name, account_manager_email, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.campaigns (id, user_id, project_id, campaign_name, industry_vertical, custom_industry, brief_description, expanded_description, start_date, target_completion_date, target_regions, min_calls, max_calls, estimated_calls, completed_calls, scheduled_calls, display_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: expert_screening_responses; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.expert_screening_responses (id, expert_id, screening_question_id, response_text, created_at) FROM stdin;
\.


--
-- Data for Name: experts; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.experts (id, campaign_id, vendor_platform_id, name, title, company, avatar_url, description, work_history, skills, rating, ai_fit_score, status, is_new, created_at, updated_at, reviewed_at) FROM stdin;
\.


--
-- Data for Name: interviews; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.interviews (id, campaign_id, expert_id, scheduled_date, scheduled_time, duration_minutes, timezone, status, color_tag, created_at, updated_at, completed_at, cancelled_at) FROM stdin;
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.projects (id, user_id, project_code, project_name, description, display_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: screening_questions; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.screening_questions (id, campaign_id, parent_question_id, question_text, question_type, options, display_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: team_members; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.team_members (id, user_id, name, email, designation, avatar_url, created_at) FROM stdin;
\.


--
-- Data for Name: user_ui_preferences; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.user_ui_preferences (user_id, column_widths, panel_sizing, theme, expanded_projects, updated_at) FROM stdin;
\.


--
-- Data for Name: vendor_platforms; Type: TABLE DATA; Schema: expert_network; Owner: raguser
--

COPY expert_network.vendor_platforms (id, name, logo_url, location, overall_score, avg_cost_per_call_min, avg_cost_per_call_max, description, tags, is_active, created_at, updated_at) FROM stdin;
e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b	GLG	/images/vendor-logos/GLG.png	New York, USA	4.8	800	1500	One of the world's largest expert networks, connecting clients with industry experts across all sectors.	{"Global Coverage","Life Sciences",Technology,"Financial Services","24h sourcing","Premium service","C-suite access","Compliance heavy","Deep bench"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:57:32.935666-04
a1b2c3d4-e5f6-4789-a123-567890abcdef	AlphaSights	/images/vendor-logos/AlphaSights.png	London, UK	4.7	700	1400	Premium expert network focused on connecting clients with C-suite executives and industry leaders.	{"Executive Access","Private Equity",Consulting,"Global Project Execution","24h sourcing","White-glove service","C-suite access","EU specialists","GDPR compliant"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:57:32.935666-04
b2c3d4e5-f6a7-4801-b345-678901bcdefb	Guidepoint	/images/vendor-logos/Guidepoint.png	New York, USA	4.6	750	1300	Specialized in providing deep industry insights through a network of experienced professionals.	{"Healthcare Expertise",Technology,"Quick Turnaround","48h sourcing","SME access",US-focused,"Regulatory expertise","Deep bench"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:57:32.935666-04
c3d4e5f6-a7b8-4012-c456-789012cdefab	Third Bridge	/images/vendor-logos/Third Bridge.png	London, UK	4.5	600	1200	Expert network with a focus on providing actionable insights for investment decisions.	{"Investment Research","Forum Platform","APAC Coverage","48h sourcing","Self-service portal","APAC bench",Multi-region,"Cost effective"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
d4e5f6a7-b8c9-4123-d567-890123defabc	Atheneum	/images/vendor-logos/Atheneum.png	Berlin, Germany	4.4	650	1250	Technology-driven expert network platform with strong European presence.	{"AI-Powered Matching","European Focus","Technology Platform","Same-day response","EU specialists","GDPR compliant",Tech-enabled,"Rapid matching"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
e5f6a7b8-c9d0-4234-e678-901234efabcd	Inex One	/images/vendor-logos/Inex One.png	Chicago, USA	4.3	500	1000	Expert network aggregator that connects clients with multiple expert network platforms.	{"Multi-Network Access","Cost Effective","Platform Aggregation","72h sourcing",Self-service,Multi-vendor,Budget-friendly,"Wide coverage"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
f6a7b8c9-d0e1-4345-f789-012345fabcde	Coleman Research	/images/vendor-logos/Coleman Research.png	Chapel Hill, USA	4.5	700	1300	Boutique expert network focused on delivering high-quality experts for complex research projects.	{Healthcare,Regulatory,"Boutique Service","24h sourcing","White-glove service","Compliance heavy","Niche specialists","Regulatory focus"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
a7b8c9d0-e1f2-4456-a890-123456abcdef	Tegus	/images/vendor-logos/Tegus.png	Chicago, USA	4.6	800	1500	Expert insights platform with a searchable library of thousands of expert transcripts.	{"Transcript Library",Technology,"SaaS Focus","Instant access","Self-service portal","Tech platform","Searchable database",On-demand}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
b8c9d0e1-f2a3-4567-b901-234567bcdefb	Prosapient	/images/vendor-logos/Prosapient.png	New York, USA	4.4	650	1200	Expert network with deep industry expertise and proprietary research capabilities.	{"Compliance Focus","Research Capabilities","Industry Depth","48h sourcing","Compliance heavy","SOC2 certified",Research-grade,"Regulated industries"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
c9d0e1f2-a3b4-4678-c012-345678cdefab	Stream	/images/vendor-logos/Stream.png	New York, USA	4.3	600	1150	Technology-enabled expert network focused on enterprise and technology sectors.	{"Technology Focus","Rapid Sourcing","Flexible Pricing","24h sourcing",Tech-enabled,"Enterprise focus","Fast turnaround","Flexible terms"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
d0e1f2a3-b4c5-4789-d123-456789defabc	Maven	/images/vendor-logos/Maven.png	San Francisco, USA	4.5	700	1350	Platform connecting clients with vetted subject matter experts across industries.	{User-Friendly,"Transparent Pricing",Cross-Industry,"48h sourcing","Self-service portal","Transparent fees","Easy booking","Wide expertise"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
e1f2a3b4-c5d6-4890-e234-567890efabcd	Dialectica	/images/vendor-logos/Dialectica.png	Athens, Greece	4.4	550	1100	Fast-growing expert network with European roots and global expansion.	{"European Roots","Quick Turnaround","Global Expansion","24h sourcing","EU specialists","Fast response","Global reach","Cost effective"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
f2a3b4c5-d6e7-4901-f345-678901fabcde	Capvision	/images/vendor-logos/Capvision.png	Shanghai, China	4.3	500	1000	Leading expert network in Asia with strong China coverage.	{"Asia Focus","China Expertise",Cross-Border,"48h sourcing","APAC bench","China specialists","Local languages",Asia-Pacific}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
a3b4c5d6-e7f8-4012-a456-789012abcdef	Brainworks	/images/vendor-logos/Brainworks.png	New York, USA	4.2	600	1200	Boutique expert network with personalized service and deep industry relationships.	{Boutique,"Personalized Service","Financial Services","48h sourcing","White-glove service",Relationship-driven,"Finance focus",Personalized}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
b4c5d6e7-f8a9-4123-b567-890123bcdefb	Nexus	/images/vendor-logos/Nexus.png	Tokyo, Japan	4.1	550	1050	Asia-Pacific focused expert network with strong presence in Japan and Australia.	{APAC,Japan,Manufacturing,"72h sourcing","APAC bench","Japan specialists","Regional focus",Manufacturing}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
c5d6e7f8-a9b0-4234-c678-901234cdefab	Zintro	/images/vendor-logos/Zintro.png	Boston, USA	4.0	400	900	Cost-effective expert network platform with self-service options.	{"Cost Effective",Self-Service,"Quick Consultations","72h sourcing",Budget-friendly,"Self-service portal","SME access","Fast booking"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
d6e7f8a9-b0c1-4345-d789-012345defabc	NewtonX	/images/vendor-logos/NewtonX.png	New York, USA	4.5	750	1400	AI-powered B2B expert network specializing in hard-to-reach decision makers.	{AI-Powered,"B2B Focus","Decision Makers","24h sourcing","AI matching","C-suite access",Hard-to-reach,Tech-enabled}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
e7f8a9b0-c1d2-4456-e890-123456efabcd	ExpertConnect	/images/vendor-logos/ExpertConnect.png	Singapore	4.2	600	1150	Asian expert network with regional expertise and local language support.	{"Asian Markets","Local Languages",Compliance,"48h sourcing","APAC bench",Multi-lingual,"Compliance focus","Regional expertise"}	t	2025-10-31 12:02:03.666889-04	2025-10-31 12:58:18.849542-04
\.


--
-- Name: campaign_team_assignments campaign_team_assignments_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.campaign_team_assignments
    ADD CONSTRAINT campaign_team_assignments_pkey PRIMARY KEY (campaign_id, team_member_id);


--
-- Name: campaign_vendor_enrollments campaign_vendor_enrollments_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.campaign_vendor_enrollments
    ADD CONSTRAINT campaign_vendor_enrollments_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: campaign_vendor_enrollments enrollment_unique; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.campaign_vendor_enrollments
    ADD CONSTRAINT enrollment_unique UNIQUE (campaign_id, vendor_platform_id);


--
-- Name: expert_screening_responses expert_screening_responses_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.expert_screening_responses
    ADD CONSTRAINT expert_screening_responses_pkey PRIMARY KEY (id);


--
-- Name: experts experts_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.experts
    ADD CONSTRAINT experts_pkey PRIMARY KEY (id);


--
-- Name: interviews interviews_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.interviews
    ADD CONSTRAINT interviews_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects projects_user_code_unique; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.projects
    ADD CONSTRAINT projects_user_code_unique UNIQUE (user_id, project_code);


--
-- Name: screening_questions screening_questions_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.screening_questions
    ADD CONSTRAINT screening_questions_pkey PRIMARY KEY (id);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- Name: user_ui_preferences user_ui_preferences_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.user_ui_preferences
    ADD CONSTRAINT user_ui_preferences_pkey PRIMARY KEY (user_id);


--
-- Name: vendor_platforms vendor_platforms_name_key; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.vendor_platforms
    ADD CONSTRAINT vendor_platforms_name_key UNIQUE (name);


--
-- Name: vendor_platforms vendor_platforms_pkey; Type: CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.vendor_platforms
    ADD CONSTRAINT vendor_platforms_pkey PRIMARY KEY (id);


--
-- Name: idx_campaign_team_campaign; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_campaign_team_campaign ON expert_network.campaign_team_assignments USING btree (campaign_id);


--
-- Name: idx_campaign_team_member; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_campaign_team_member ON expert_network.campaign_team_assignments USING btree (team_member_id);


--
-- Name: idx_campaigns_dates; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_campaigns_dates ON expert_network.campaigns USING btree (start_date, target_completion_date);


--
-- Name: idx_campaigns_industry; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_campaigns_industry ON expert_network.campaigns USING btree (industry_vertical);


--
-- Name: idx_campaigns_order; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_campaigns_order ON expert_network.campaigns USING btree (user_id, project_id, display_order);


--
-- Name: idx_campaigns_project; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_campaigns_project ON expert_network.campaigns USING btree (project_id);


--
-- Name: idx_campaigns_user; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_campaigns_user ON expert_network.campaigns USING btree (user_id);


--
-- Name: idx_enrollments_campaign; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_enrollments_campaign ON expert_network.campaign_vendor_enrollments USING btree (campaign_id);


--
-- Name: idx_enrollments_status; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_enrollments_status ON expert_network.campaign_vendor_enrollments USING btree (status);


--
-- Name: idx_enrollments_vendor; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_enrollments_vendor ON expert_network.campaign_vendor_enrollments USING btree (vendor_platform_id);


--
-- Name: idx_experts_campaign; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_experts_campaign ON expert_network.experts USING btree (campaign_id);


--
-- Name: idx_experts_campaign_status; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_experts_campaign_status ON expert_network.experts USING btree (campaign_id, status);


--
-- Name: idx_experts_name; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_experts_name ON expert_network.experts USING gin (name public.gin_trgm_ops);


--
-- Name: idx_experts_status; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_experts_status ON expert_network.experts USING btree (status);


--
-- Name: idx_experts_vendor; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_experts_vendor ON expert_network.experts USING btree (vendor_platform_id);


--
-- Name: idx_interviews_campaign; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_interviews_campaign ON expert_network.interviews USING btree (campaign_id);


--
-- Name: idx_interviews_date; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_interviews_date ON expert_network.interviews USING btree (scheduled_date);


--
-- Name: idx_interviews_expert; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_interviews_expert ON expert_network.interviews USING btree (expert_id);


--
-- Name: idx_interviews_status; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_interviews_status ON expert_network.interviews USING btree (status);


--
-- Name: idx_projects_order; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_projects_order ON expert_network.projects USING btree (user_id, display_order);


--
-- Name: idx_projects_user; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_projects_user ON expert_network.projects USING btree (user_id);


--
-- Name: idx_responses_expert; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_responses_expert ON expert_network.expert_screening_responses USING btree (expert_id);


--
-- Name: idx_responses_question; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_responses_question ON expert_network.expert_screening_responses USING btree (screening_question_id);


--
-- Name: idx_screening_campaign; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_screening_campaign ON expert_network.screening_questions USING btree (campaign_id);


--
-- Name: idx_screening_order; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_screening_order ON expert_network.screening_questions USING btree (campaign_id, display_order);


--
-- Name: idx_screening_parent; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_screening_parent ON expert_network.screening_questions USING btree (parent_question_id);


--
-- Name: idx_team_members_name; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_team_members_name ON expert_network.team_members USING btree (name);


--
-- Name: idx_team_members_user; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_team_members_user ON expert_network.team_members USING btree (user_id);


--
-- Name: idx_vendors_active; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_vendors_active ON expert_network.vendor_platforms USING btree (is_active);


--
-- Name: idx_vendors_name; Type: INDEX; Schema: expert_network; Owner: raguser
--

CREATE INDEX idx_vendors_name ON expert_network.vendor_platforms USING btree (name);


--
-- Name: campaign_vendor_enrollments update_campaign_vendor_enrollments_updated_at; Type: TRIGGER; Schema: expert_network; Owner: raguser
--

CREATE TRIGGER update_campaign_vendor_enrollments_updated_at BEFORE UPDATE ON expert_network.campaign_vendor_enrollments FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();


--
-- Name: campaigns update_campaigns_updated_at; Type: TRIGGER; Schema: expert_network; Owner: raguser
--

CREATE TRIGGER update_campaigns_updated_at BEFORE UPDATE ON expert_network.campaigns FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();


--
-- Name: experts update_experts_updated_at; Type: TRIGGER; Schema: expert_network; Owner: raguser
--

CREATE TRIGGER update_experts_updated_at BEFORE UPDATE ON expert_network.experts FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();


--
-- Name: interviews update_interviews_updated_at; Type: TRIGGER; Schema: expert_network; Owner: raguser
--

CREATE TRIGGER update_interviews_updated_at BEFORE UPDATE ON expert_network.interviews FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();


--
-- Name: projects update_projects_updated_at; Type: TRIGGER; Schema: expert_network; Owner: raguser
--

CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON expert_network.projects FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();


--
-- Name: screening_questions update_screening_questions_updated_at; Type: TRIGGER; Schema: expert_network; Owner: raguser
--

CREATE TRIGGER update_screening_questions_updated_at BEFORE UPDATE ON expert_network.screening_questions FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();


--
-- Name: user_ui_preferences update_user_ui_preferences_updated_at; Type: TRIGGER; Schema: expert_network; Owner: raguser
--

CREATE TRIGGER update_user_ui_preferences_updated_at BEFORE UPDATE ON expert_network.user_ui_preferences FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();


--
-- Name: vendor_platforms update_vendor_platforms_updated_at; Type: TRIGGER; Schema: expert_network; Owner: raguser
--

CREATE TRIGGER update_vendor_platforms_updated_at BEFORE UPDATE ON expert_network.vendor_platforms FOR EACH ROW EXECUTE FUNCTION expert_network.update_updated_at_column();


--
-- Name: campaign_team_assignments fk_campaign_team_campaign; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.campaign_team_assignments
    ADD CONSTRAINT fk_campaign_team_campaign FOREIGN KEY (campaign_id) REFERENCES expert_network.campaigns(id) ON DELETE CASCADE;


--
-- Name: campaign_team_assignments fk_campaign_team_member; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.campaign_team_assignments
    ADD CONSTRAINT fk_campaign_team_member FOREIGN KEY (team_member_id) REFERENCES expert_network.team_members(id) ON DELETE CASCADE;


--
-- Name: campaigns fk_campaigns_project; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.campaigns
    ADD CONSTRAINT fk_campaigns_project FOREIGN KEY (project_id) REFERENCES expert_network.projects(id) ON DELETE SET NULL;


--
-- Name: campaign_vendor_enrollments fk_enrollment_campaign; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.campaign_vendor_enrollments
    ADD CONSTRAINT fk_enrollment_campaign FOREIGN KEY (campaign_id) REFERENCES expert_network.campaigns(id) ON DELETE CASCADE;


--
-- Name: campaign_vendor_enrollments fk_enrollment_vendor; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.campaign_vendor_enrollments
    ADD CONSTRAINT fk_enrollment_vendor FOREIGN KEY (vendor_platform_id) REFERENCES expert_network.vendor_platforms(id) ON DELETE CASCADE;


--
-- Name: experts fk_experts_campaign; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.experts
    ADD CONSTRAINT fk_experts_campaign FOREIGN KEY (campaign_id) REFERENCES expert_network.campaigns(id) ON DELETE CASCADE;


--
-- Name: experts fk_experts_vendor; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.experts
    ADD CONSTRAINT fk_experts_vendor FOREIGN KEY (vendor_platform_id) REFERENCES expert_network.vendor_platforms(id);


--
-- Name: interviews fk_interviews_campaign; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.interviews
    ADD CONSTRAINT fk_interviews_campaign FOREIGN KEY (campaign_id) REFERENCES expert_network.campaigns(id) ON DELETE CASCADE;


--
-- Name: interviews fk_interviews_expert; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.interviews
    ADD CONSTRAINT fk_interviews_expert FOREIGN KEY (expert_id) REFERENCES expert_network.experts(id) ON DELETE CASCADE;


--
-- Name: expert_screening_responses fk_responses_expert; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.expert_screening_responses
    ADD CONSTRAINT fk_responses_expert FOREIGN KEY (expert_id) REFERENCES expert_network.experts(id) ON DELETE CASCADE;


--
-- Name: expert_screening_responses fk_responses_question; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.expert_screening_responses
    ADD CONSTRAINT fk_responses_question FOREIGN KEY (screening_question_id) REFERENCES expert_network.screening_questions(id) ON DELETE CASCADE;


--
-- Name: screening_questions fk_screening_campaign; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.screening_questions
    ADD CONSTRAINT fk_screening_campaign FOREIGN KEY (campaign_id) REFERENCES expert_network.campaigns(id) ON DELETE CASCADE;


--
-- Name: screening_questions fk_screening_parent; Type: FK CONSTRAINT; Schema: expert_network; Owner: raguser
--

ALTER TABLE ONLY expert_network.screening_questions
    ADD CONSTRAINT fk_screening_parent FOREIGN KEY (parent_question_id) REFERENCES expert_network.screening_questions(id) ON DELETE CASCADE;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: expert_network; Owner: raguser
--

ALTER DEFAULT PRIVILEGES FOR ROLE raguser IN SCHEMA expert_network GRANT ALL ON SEQUENCES TO raguser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: expert_network; Owner: raguser
--

ALTER DEFAULT PRIVILEGES FOR ROLE raguser IN SCHEMA expert_network GRANT ALL ON TABLES TO raguser;


--
-- PostgreSQL database dump complete
--

