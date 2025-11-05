-- ============================================================================
-- Seed Sample Data for Expert Networks Application
-- User ID: demo-user-123
-- ============================================================================
-- This script seeds sample data for:
-- - 5+ projects
-- - 10+ campaigns
-- - 20+ campaign_vendor_enrollments
-- - 30+ experts (with real avatar paths)
-- - 30+ screening_questions
-- - 30+ expert_screening_responses
-- - 70+ interviews
-- - 7+ team_members
-- ============================================================================

DO $$
DECLARE
    target_user_id TEXT := 'demo-user-123';
    temp_id UUID;
    temp_project_id UUID;
    temp_campaign_id UUID;
    temp_expert_id UUID;
    temp_question_id UUID;
    temp_vendor_id UUID;
    temp_team_member_id UUID;
    i INTEGER;
    j INTEGER;
    campaign_ids UUID[] := ARRAY[]::UUID[];
    project_ids UUID[] := ARRAY[]::UUID[];
    expert_ids UUID[] := ARRAY[]::UUID[];
    question_ids UUID[] := ARRAY[]::UUID[];
    team_member_ids UUID[] := ARRAY[]::UUID[];
    vendor_ids UUID[];
    expert_avatars TEXT[] := ARRAY[
        '/images/experts/Andrew Collins.png',
        '/images/experts/Benjamin Carter.png',
        '/images/experts/Christopher Shaw.png',
        '/images/experts/Daniel Reed.png',
        '/images/experts/Daniel.png',
        '/images/experts/Ethan Clarke.png',
        '/images/experts/Henry Wallace.png',
        '/images/experts/James Whitman.PNG',
        '/images/experts/Kevin_Smith.png',
        '/images/experts/Lucas Turner.png',
        '/images/experts/Matthew Lawson.png',
        '/images/experts/Nathaniel Brooks.png',
        '/images/experts/Oliver Grant.png',
        '/images/experts/Samuel Hayes.png',
        '/images/experts/William Foster.png',
        '/images/experts/1.png',
        '/images/experts/2.png',
        '/images/experts/40.png',
        '/images/experts/41.png',
        '/images/experts/42.png',
        '/images/experts/43.png',
        '/images/experts/44.png',
        '/images/experts/45.png',
        '/images/experts/46.png',
        '/images/experts/47.png',
        '/images/experts/48.png',
        '/images/experts/49.png',
        '/images/experts/50.png',
        '/images/experts/51.png',
        '/images/experts/52.png'
    ];
BEGIN
    -- Get vendor platform IDs
    SELECT ARRAY_AGG(id) INTO vendor_ids
    FROM expert_network.vendor_platforms
    WHERE is_active = true;

    RAISE NOTICE 'Found % vendor platforms', array_length(vendor_ids, 1);

    -- ============================================================================
    -- 1. CREATE PROJECTS (5+)
    -- ============================================================================
    RAISE NOTICE 'Creating projects...';

    INSERT INTO expert_network.projects (user_id, project_code, project_name, description, display_order)
    VALUES
        (target_user_id, 'PROJ-2024-001', 'Healthcare AI Market Research', 'Comprehensive market research on AI adoption in healthcare systems', 0),
        (target_user_id, 'PROJ-2024-002', 'FinTech Regulatory Compliance', 'Expert interviews on regulatory changes affecting FinTech companies', 1),
        (target_user_id, 'PROJ-2024-003', 'Enterprise SaaS Due Diligence', 'Commercial diligence for SaaS enterprise software company', 2),
        (target_user_id, 'PROJ-2024-004', 'Supply Chain Optimization', 'Expert network research on global supply chain challenges', 3),
        (target_user_id, 'PROJ-2024-005', 'Clean Energy Transition', 'Expert insights on renewable energy adoption and market dynamics', 4),
        (target_user_id, 'PROJ-2024-006', 'Cybersecurity Framework Analysis', 'Expert interviews on enterprise cybersecurity best practices', 5);

    SELECT ARRAY_AGG(id) INTO project_ids FROM expert_network.projects WHERE expert_network.projects.user_id = target_user_id;
    RAISE NOTICE 'Created % projects', array_length(project_ids, 1);

    -- ============================================================================
    -- 2. CREATE CAMPAIGNS (10+)
    -- ============================================================================
    RAISE NOTICE 'Creating campaigns...';

    INSERT INTO expert_network.campaigns (
        user_id, project_id, campaign_name, industry_vertical, brief_description,
        expanded_description, start_date, target_completion_date, target_regions,
        min_calls, max_calls, display_order
    ) VALUES
        -- Project 1: Healthcare AI
        (target_user_id, project_ids[1], 'Clinical AI Implementation', 'Healthcare', 'Expert interviews on clinical AI adoption in hospitals',
         'Comprehensive research on how major healthcare systems are implementing AI for clinical decision support, diagnostic imaging, and patient care optimization. Focus on real-world deployment challenges, ROI metrics, and clinical outcomes.', 
         CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE + INTERVAL '60 days', ARRAY['North America', 'Europe'], 15, 25, 0),
        
        (target_user_id, project_ids[1], 'AI in Medical Imaging', 'Healthcare', 'Expert insights on AI-powered diagnostic imaging',
         'Research on AI applications in radiology, pathology, and medical imaging. Explore vendor landscape, accuracy improvements, regulatory considerations, and integration challenges with existing PACS systems.',
         CURRENT_DATE - INTERVAL '20 days', CURRENT_DATE + INTERVAL '45 days', ARRAY['North America'], 10, 20, 1),
        
        -- Project 2: FinTech
        (target_user_id, project_ids[2], 'Digital Banking Regulations', 'Financial Services', 'Expert interviews on digital banking compliance',
         'Deep dive into regulatory requirements for digital banking platforms, including KYC/AML compliance, data privacy regulations (GDPR, CCPA), and cross-border payment regulations. Focus on European and US markets.',
         CURRENT_DATE - INTERVAL '25 days', CURRENT_DATE + INTERVAL '50 days', ARRAY['Europe', 'North America'], 12, 22, 2),
        
        (target_user_id, project_ids[2], 'Cryptocurrency Regulatory Landscape', 'Financial Services', 'Expert insights on crypto regulations',
         'Comprehensive analysis of cryptocurrency and DeFi regulations across major markets. Focus on SEC, CFTC, and EU regulatory frameworks, compliance requirements, and future regulatory trends.',
         CURRENT_DATE - INTERVAL '15 days', CURRENT_DATE + INTERVAL '40 days', ARRAY['North America', 'Asia Pacific'], 8, 18, 3),
        
        -- Project 3: Enterprise SaaS
        (target_user_id, project_ids[3], 'SaaS Pricing Models', 'Technology', 'Expert interviews on enterprise SaaS pricing strategies',
         'Research on enterprise SaaS pricing models, value-based pricing, usage-based pricing, and competitive positioning. Expert insights from SaaS executives and pricing strategy consultants.',
         CURRENT_DATE - INTERVAL '10 days', CURRENT_DATE + INTERVAL '35 days', ARRAY['North America'], 10, 20, 4),
        
        (target_user_id, project_ids[3], 'Enterprise Sales Motion', 'Technology', 'Expert insights on enterprise sales processes',
         'Deep dive into enterprise sales motions, including account-based marketing, sales enablement, customer success, and expansion strategies. Focus on B2B SaaS companies with $10M+ ARR.',
         CURRENT_DATE - INTERVAL '5 days', CURRENT_DATE + INTERVAL '30 days', ARRAY['North America', 'Europe'], 15, 25, 5),
        
        -- Project 4: Supply Chain
        (target_user_id, project_ids[4], 'Global Supply Chain Disruption', 'Manufacturing', 'Expert interviews on supply chain challenges',
         'Research on global supply chain disruptions, including logistics bottlenecks, supplier diversification strategies, nearshoring trends, and technology solutions for supply chain visibility.',
         CURRENT_DATE - INTERVAL '20 days', CURRENT_DATE + INTERVAL '55 days', ARRAY['North America', 'Asia Pacific', 'Europe'], 20, 30, 6),
        
        (target_user_id, project_ids[4], 'Supply Chain Technology Stack', 'Manufacturing', 'Expert insights on supply chain technology',
         'Comprehensive analysis of supply chain technology platforms, including warehouse management systems, transportation management systems, demand forecasting, and IoT integration.',
         CURRENT_DATE - INTERVAL '12 days', CURRENT_DATE + INTERVAL '42 days', ARRAY['North America', 'Europe'], 12, 22, 7),
        
        -- Project 5: Clean Energy
        (target_user_id, project_ids[5], 'Solar Energy Market Dynamics', 'Energy', 'Expert interviews on solar energy adoption',
         'Research on solar energy market dynamics, including panel technology trends, installation economics, grid integration challenges, and policy impacts. Focus on residential and commercial solar markets.',
         CURRENT_DATE - INTERVAL '18 days', CURRENT_DATE + INTERVAL '48 days', ARRAY['North America', 'Europe'], 14, 24, 8),
        
        (target_user_id, project_ids[5], 'Battery Storage Technology', 'Energy', 'Expert insights on battery storage solutions',
         'Deep dive into battery storage technology for renewable energy, including lithium-ion, flow batteries, and emerging technologies. Focus on grid-scale storage and commercial applications.',
         CURRENT_DATE - INTERVAL '8 days', CURRENT_DATE + INTERVAL '38 days', ARRAY['North America', 'Asia Pacific'], 10, 20, 9),
        
        -- Project 6: Cybersecurity
        (target_user_id, project_ids[6], 'Zero Trust Architecture', 'Technology', 'Expert interviews on zero trust security',
         'Comprehensive research on zero trust security architecture, including implementation strategies, vendor landscape, and best practices for enterprise adoption.',
         CURRENT_DATE - INTERVAL '14 days', CURRENT_DATE + INTERVAL '44 days', ARRAY['North America', 'Europe'], 16, 26, 10),
        
         (target_user_id, NULL, 'Other Campaign - Market Research', 'Consulting', 'General market research campaign',
         'General purpose campaign for market research and expert interviews across various industries.',
         CURRENT_DATE - INTERVAL '7 days', CURRENT_DATE + INTERVAL '33 days', ARRAY['North America'], 8, 18, 11);

    SELECT ARRAY_AGG(id) INTO campaign_ids FROM expert_network.campaigns WHERE expert_network.campaigns.user_id = target_user_id;
    RAISE NOTICE 'Created % campaigns', array_length(campaign_ids, 1);

    -- ============================================================================
    -- 3. CREATE TEAM MEMBERS (7+)
    -- ============================================================================
    RAISE NOTICE 'Creating team members...';

    INSERT INTO expert_network.team_members (user_id, name, email, designation, avatar_url)
    VALUES
        (target_user_id, 'Sarah Mitchell', 'sarah.mitchell@example.com', 'Research Director', '/images/team-members/Sarah Mitchell.png'),
        (target_user_id, 'David Chen', 'david.chen@example.com', 'Senior Analyst', '/images/team-members/David Chen.png'),
        (target_user_id, 'Emily Rodriguez', 'emily.rodriguez@example.com', 'Project Manager', '/images/team-members/Emily Rodriguez.png'),
        (target_user_id, 'Michael Thompson', 'michael.thompson@example.com', 'Associate', '/images/team-members/Michael Thompson.png'),
        (target_user_id, 'Jennifer Kim', 'jennifer.kim@example.com', 'Analyst', '/images/team-members/Jennifer Kim.png'),
        (target_user_id, 'Robert Martinez', 'robert.martinez@example.com', 'Vice President', '/images/team-members/Robert Martinez.png'),
        (target_user_id, 'Lisa Anderson', 'lisa.anderson@example.com', 'Senior Manager', '/images/team-members/Lisa Anderson.png'),
        (target_user_id, 'James Wilson', 'james.wilson@example.com', 'Principal', '/images/team-members/James Wilson.png');

    SELECT ARRAY_AGG(id) INTO team_member_ids FROM expert_network.team_members WHERE expert_network.team_members.user_id = target_user_id;
    RAISE NOTICE 'Created % team members', array_length(team_member_ids, 1);

    -- ============================================================================
    -- 4. CREATE CAMPAIGN VENDOR ENROLLMENTS (20+)
    -- ============================================================================
    RAISE NOTICE 'Creating campaign vendor enrollments...';

    -- Enroll vendors for each campaign (2-4 vendors per campaign)
    FOR i IN 1..array_length(campaign_ids, 1) LOOP
        -- Select 2-4 random vendors per campaign
        FOR j IN 1..(2 + (i % 3)) LOOP
            temp_vendor_id := vendor_ids[1 + ((i * 3 + j) % array_length(vendor_ids, 1))];
            
            INSERT INTO expert_network.campaign_vendor_enrollments (
                campaign_id, vendor_platform_id, status, enrolled_at, account_manager_name, account_manager_email
            )
            VALUES (
                campaign_ids[i],
                temp_vendor_id,
                CASE (i % 3)
                    WHEN 0 THEN 'enrolled'
                    WHEN 1 THEN 'pending'
                    ELSE 'enrolled'
                END,
                CASE WHEN (i % 3) != 1 THEN CURRENT_TIMESTAMP - (INTERVAL '1 day' * (i * 2)) ELSE NULL END,
                'Manager ' || (i + j),
                'manager' || (i + j) || '@vendor.com'
            )
            ON CONFLICT (campaign_id, vendor_platform_id) DO NOTHING;
        END LOOP;
    END LOOP;

    RAISE NOTICE 'Created campaign vendor enrollments';

    -- ============================================================================
    -- 5. CREATE EXPERTS (30+)
    -- ============================================================================
    RAISE NOTICE 'Creating experts...';

    -- Expert data with realistic profiles
    INSERT INTO expert_network.experts (
        campaign_id, vendor_platform_id, name, title, company, avatar_url,
        description, work_history, skills, rating, ai_fit_score, status, is_new
    ) VALUES
        -- Campaign 1: Clinical AI Implementation
        (campaign_ids[1], vendor_ids[1], 'Dr. Sarah Chen', 'Chief Medical Information Officer', 'Memorial Hospital System',
         expert_avatars[1],
         'CMIO with 12 years of experience implementing clinical AI systems across major hospital networks. Led Epic EHR integration with AI-powered clinical decision support tools.',
         'Memorial Hospital System (CMIO, 2018-present): Led AI initiatives including radiology AI for chest X-ray analysis, reducing diagnostic time by 40%. Previously: Johns Hopkins (Clinical Informatics Director, 2016-2018), Mayo Clinic (Physician Informatics, 2012-2016).',
         ARRAY['Clinical AI', 'EHR Integration', 'Healthcare IT', 'Clinical Decision Support', 'Epic Systems'],
         4.8, 9, 'proposed', true),
        
        (campaign_ids[1], vendor_ids[2], 'Michael Rodriguez', 'VP of Clinical Operations', 'Mayo Clinic',
         expert_avatars[2],
         'Healthcare executive specializing in AI-driven clinical operations optimization. Expert in process improvement and digital health transformation.',
         'Mayo Clinic (VP Clinical Operations, 2019-present): Implemented AI-powered scheduling and resource optimization, improving patient throughput by 25%. Previously: Cleveland Clinic (Director of Operations, 2015-2019), Mass General (Operations Manager, 2010-2015).',
         ARRAY['Clinical Operations', 'Process Improvement', 'Healthcare Analytics', 'Digital Transformation'],
         4.7, 8, 'reviewed', false),
        
        (campaign_ids[1], vendor_ids[3], 'Dr. Emily Watson', 'Director of Digital Health', 'Cleveland Clinic',
         expert_avatars[3],
         'Leading expert in digital health initiatives and telemedicine implementation. Specializes in AI-powered patient engagement platforms.',
         'Cleveland Clinic (Director Digital Health, 2020-present): Launched AI chatbot for patient triage, handling 50K+ patient interactions monthly. Previously: Stanford Health (Digital Health Manager, 2017-2020), Kaiser Permanente (Telemedicine Coordinator, 2014-2017).',
         ARRAY['Digital Health', 'Telemedicine', 'Patient Engagement', 'AI Chatbots', 'Healthcare Innovation'],
         4.9, 9, 'approved', false),
        
        -- Campaign 2: AI in Medical Imaging
        (campaign_ids[2], vendor_ids[4], 'James Park', 'Senior Data Scientist', 'Johns Hopkins Medical Imaging',
         expert_avatars[4],
         'Data science expert specializing in medical imaging AI. Developed deep learning models for radiology and pathology image analysis.',
         'Johns Hopkins (Senior Data Scientist, 2018-present): Developed FDA-cleared AI model for lung nodule detection in CT scans. Previously: MIT CSAIL (Research Scientist, 2015-2018), Google Health (ML Engineer, 2013-2015).',
         ARRAY['Medical Imaging AI', 'Deep Learning', 'Computer Vision', 'Radiology AI', 'Python', 'TensorFlow'],
         4.6, 10, 'proposed', true),
        
        (campaign_ids[2], vendor_ids[5], 'Dr. Lisa Anderson', 'Chief of Radiology', 'Massachusetts General Hospital',
         expert_avatars[5],
         'Radiologist with 15 years of experience using AI tools for diagnostic imaging. Expert in FDA approval process for medical imaging AI.',
         'Mass General (Chief of Radiology, 2017-present): Implemented AI-powered mammography screening, improving early detection rates by 30%. Previously: Brigham and Women''s (Staff Radiologist, 2010-2017), Harvard Medical School (Residency, 2005-2010).',
         ARRAY['Radiology', 'Medical Imaging', 'AI Diagnostics', 'FDA Regulation', 'Mammography'],
         4.8, 9, 'reviewed', false),
        
        -- Campaign 3: Digital Banking Regulations
        (campaign_ids[3], vendor_ids[6], 'Robert Kim', 'VP of Compliance', 'JP Morgan Chase',
         expert_avatars[6],
         'Banking compliance executive with expertise in digital banking regulations, KYC/AML, and cross-border payment compliance.',
         'JP Morgan Chase (VP Compliance, 2019-present): Led digital banking compliance for $50B+ in deposits. Previously: Bank of America (Senior Compliance Manager, 2015-2019), Federal Reserve (Regulatory Analyst, 2012-2015).',
         ARRAY['Banking Compliance', 'KYC/AML', 'Regulatory Affairs', 'Digital Banking', 'Cross-Border Payments'],
         4.7, 8, 'approved', false),
        
        (campaign_ids[3], vendor_ids[7], 'David Thompson', 'Chief Regulatory Officer', 'Goldman Sachs',
         expert_avatars[7],
         'Regulatory expert specializing in FinTech compliance and digital banking regulations across US and European markets.',
         'Goldman Sachs (CRO, 2020-present): Oversee regulatory compliance for Marcus digital banking platform. Previously: Credit Suisse (Head of Regulatory Affairs, 2016-2020), SEC (Senior Attorney, 2011-2016).',
         ARRAY['Regulatory Compliance', 'FinTech', 'GDPR', 'Financial Regulations', 'Banking Law'],
         4.6, 8, 'proposed', true),
        
        -- Campaign 4: Cryptocurrency Regulatory Landscape
        (campaign_ids[4], vendor_ids[8], 'Jennifer Lee', 'Cryptocurrency Regulatory Expert', 'Coinbase',
         expert_avatars[8],
         'Leading expert on cryptocurrency regulations, SEC compliance, and DeFi regulatory frameworks.',
         'Coinbase (Regulatory Expert, 2021-present): Advised on SEC registration and compliance framework. Previously: CFTC (Cryptocurrency Specialist, 2018-2021), SEC (Attorney-Advisor, 2015-2018).',
         ARRAY['Cryptocurrency', 'Blockchain Regulation', 'SEC Compliance', 'DeFi', 'Regulatory Strategy'],
         4.8, 9, 'reviewed', false),
        
        (campaign_ids[4], vendor_ids[9], 'Christopher Brown', 'Head of Legal', 'Binance US',
         expert_avatars[9],
         'Legal expert specializing in cryptocurrency exchanges, token regulations, and cross-border crypto compliance.',
         'Binance US (Head of Legal, 2020-present): Managed regulatory compliance for major crypto exchange. Previously: Kraken (Legal Counsel, 2017-2020), Ripple (Regulatory Affairs, 2015-2017).',
         ARRAY['Crypto Regulation', 'Exchange Compliance', 'Token Securities', 'Cross-Border Compliance'],
         4.7, 8, 'proposed', true),
        
        -- Campaign 5: SaaS Pricing Models
        (campaign_ids[5], vendor_ids[10], 'Lucas Turner', 'VP of Pricing Strategy', 'Salesforce',
         expert_avatars[10],
         'Pricing strategy executive with 10 years of experience in enterprise SaaS pricing, value-based pricing, and competitive positioning.',
         'Salesforce (VP Pricing Strategy, 2019-present): Led pricing strategy for $20B+ SaaS portfolio. Previously: Microsoft (Senior Pricing Manager, 2016-2019), Oracle (Pricing Analyst, 2013-2016).',
         ARRAY['SaaS Pricing', 'Value-Based Pricing', 'Pricing Strategy', 'Enterprise Sales', 'Competitive Analysis'],
         4.9, 9, 'approved', false),
        
        (campaign_ids[5], vendor_ids[11], 'Matthew Lawson', 'Chief Revenue Officer', 'HubSpot',
         expert_avatars[11],
         'Revenue leader with expertise in usage-based pricing, freemium models, and enterprise sales motions for SaaS companies.',
         'HubSpot (CRO, 2020-present): Implemented usage-based pricing model, increasing revenue by 40%. Previously: Atlassian (VP Sales, 2017-2020), Dropbox (Sales Director, 2014-2017).',
         ARRAY['Usage-Based Pricing', 'Freemium Models', 'Revenue Operations', 'Sales Strategy'],
         4.8, 9, 'proposed', true),
        
        -- Campaign 6: Enterprise Sales Motion
        (campaign_ids[6], vendor_ids[12], 'Nathaniel Brooks', 'VP of Enterprise Sales', 'ServiceNow',
         expert_avatars[12],
         'Enterprise sales executive with track record of building $100M+ sales organizations. Expert in account-based marketing and customer success.',
         'ServiceNow (VP Enterprise Sales, 2018-present): Built enterprise sales team generating $500M+ ARR. Previously: Workday (Sales Director, 2015-2018), Oracle (Enterprise Account Executive, 2010-2015).',
         ARRAY['Enterprise Sales', 'Account-Based Marketing', 'Customer Success', 'Sales Enablement', 'B2B SaaS'],
         4.7, 8, 'reviewed', false),
        
        (campaign_ids[6], vendor_ids[13], 'Oliver Grant', 'Chief Customer Officer', 'Slack',
         expert_avatars[13],
         'Customer success leader specializing in enterprise customer expansion, retention strategies, and customer-led growth.',
         'Slack (CCO, 2019-present): Increased enterprise customer retention from 85% to 95%. Previously: Zendesk (VP Customer Success, 2016-2019), Salesforce (Customer Success Manager, 2013-2016).',
         ARRAY['Customer Success', 'Customer Retention', 'Expansion Revenue', 'Customer-Led Growth'],
         4.8, 9, 'approved', false),
        
        -- Campaign 7: Global Supply Chain Disruption
        (campaign_ids[7], vendor_ids[14], 'Samuel Hayes', 'VP of Supply Chain', 'Amazon',
         expert_avatars[14],
         'Supply chain executive with expertise in global logistics, supplier diversification, and supply chain technology.',
         'Amazon (VP Supply Chain, 2017-present): Managed global supply chain for $400B+ e-commerce operations. Previously: Walmart (Supply Chain Director, 2014-2017), Procter & Gamble (Supply Chain Manager, 2010-2014).',
         ARRAY['Supply Chain Management', 'Global Logistics', 'Supplier Diversification', 'Supply Chain Technology'],
         4.9, 9, 'proposed', true),
        
        (campaign_ids[7], vendor_ids[15], 'William Foster', 'Chief Operating Officer', 'FedEx',
         expert_avatars[15],
         'Logistics executive with 20 years of experience in transportation, warehousing, and last-mile delivery optimization.',
         'FedEx (COO, 2019-present): Oversee $90B+ global logistics network. Previously: UPS (VP Operations, 2015-2019), DHL (Operations Director, 2010-2015).',
         ARRAY['Logistics', 'Transportation', 'Warehousing', 'Last-Mile Delivery', 'Supply Chain Optimization'],
         4.8, 8, 'reviewed', false),
        
        -- Campaign 8: Supply Chain Technology Stack
        (campaign_ids[8], vendor_ids[16], 'Andrew Collins', 'CTO', 'Blue Yonder',
         expert_avatars[1],
         'Technology executive specializing in supply chain software platforms, WMS, TMS, and demand forecasting systems.',
         'Blue Yonder (CTO, 2020-present): Led development of AI-powered supply chain platform serving Fortune 500 companies. Previously: Manhattan Associates (VP Engineering, 2017-2020), Oracle (Supply Chain Product Manager, 2014-2017).',
         ARRAY['Supply Chain Software', 'WMS', 'TMS', 'Demand Forecasting', 'AI/ML', 'Enterprise Software'],
         4.7, 9, 'approved', false),
        
        (campaign_ids[8], vendor_ids[17], 'Benjamin Carter', 'VP of Product', 'Flexport',
         expert_avatars[2],
         'Product leader with expertise in supply chain visibility platforms, freight management, and logistics technology.',
         'Flexport (VP Product, 2019-present): Built supply chain visibility platform processing $10B+ in freight. Previously: Convoy (Product Director, 2017-2019), Uber Freight (Product Manager, 2015-2017).',
         ARRAY['Supply Chain Visibility', 'Freight Management', 'Logistics Technology', 'Product Management'],
         4.6, 8, 'proposed', true),
        
        -- Campaign 9: Solar Energy Market Dynamics
        (campaign_ids[9], vendor_ids[18], 'Ethan Clarke', 'VP of Solar Development', 'Sunrun',
         expert_avatars[3],
         'Solar energy executive with expertise in residential and commercial solar installation, financing, and market dynamics.',
         'Sunrun (VP Solar Development, 2018-present): Led residential solar installations across 22 states, 500K+ customers. Previously: SolarCity (Development Director, 2015-2018), First Solar (Business Development, 2012-2015).',
         ARRAY['Solar Energy', 'Residential Solar', 'Commercial Solar', 'Solar Installation', 'Renewable Energy'],
         4.8, 9, 'reviewed', false),
        
        (campaign_ids[9], vendor_ids[1], 'Henry Wallace', 'Chief Technology Officer', 'First Solar',
         expert_avatars[4],
         'Solar technology expert specializing in panel technology, efficiency improvements, and manufacturing economics.',
         'First Solar (CTO, 2019-present): Led development of next-gen thin-film solar panels with 22% efficiency. Previously: SunPower (VP R&D, 2016-2019), NREL (Senior Research Scientist, 2012-2016).',
         ARRAY['Solar Panel Technology', 'Thin-Film Solar', 'Photovoltaics', 'Manufacturing', 'R&D'],
         4.9, 10, 'approved', false),
        
        -- Campaign 10: Battery Storage Technology
        (campaign_ids[10], vendor_ids[2], 'Jacob Martinez', 'VP of Energy Storage', 'Tesla Energy',
         expert_avatars[5],
         'Energy storage executive with expertise in grid-scale battery systems, lithium-ion technology, and energy storage economics.',
         'Tesla Energy (VP Energy Storage, 2020-present): Deployed 3GWh+ of grid-scale battery storage globally. Previously: AES Energy Storage (Director, 2017-2020), GE Energy Storage (Product Manager, 2014-2017).',
         ARRAY['Energy Storage', 'Battery Technology', 'Grid-Scale Storage', 'Lithium-Ion', 'Renewable Energy Integration'],
         4.8, 9, 'proposed', true),
        
        (campaign_ids[10], vendor_ids[3], 'Kevin Park', 'Chief Scientist', 'Fluence Energy',
         expert_avatars[6],
         'Energy storage scientist specializing in flow batteries, advanced battery chemistries, and grid integration.',
         'Fluence Energy (Chief Scientist, 2019-present): Developed flow battery systems for long-duration energy storage. Previously: Form Energy (Senior Scientist, 2016-2019), MIT (Research Scientist, 2012-2016).',
         ARRAY['Flow Batteries', 'Advanced Battery Chemistry', 'Long-Duration Storage', 'Grid Integration', 'Energy Research'],
         4.7, 9, 'reviewed', false),
        
        -- Campaign 11: Zero Trust Architecture
        (campaign_ids[11], vendor_ids[4], 'Daniel Reed', 'Chief Information Security Officer', 'Microsoft',
         expert_avatars[7],
         'Cybersecurity executive with expertise in zero trust architecture, identity management, and enterprise security.',
         'Microsoft (CISO, 2021-present): Implemented zero trust architecture across 200K+ employees globally. Previously: Google (Security Director, 2018-2021), Palo Alto Networks (Security Architect, 2015-2018).',
         ARRAY['Zero Trust', 'Cybersecurity', 'Identity Management', 'Enterprise Security', 'Cloud Security'],
         4.9, 10, 'approved', false),
        
        (campaign_ids[11], vendor_ids[5], 'James Whitman', 'VP of Security Architecture', 'CrowdStrike',
         expert_avatars[8],
         'Security architect specializing in zero trust implementation, endpoint security, and threat detection.',
         'CrowdStrike (VP Security Architecture, 2019-present): Designed zero trust security architecture for enterprise customers. Previously: FireEye (Security Architect, 2016-2019), Mandiant (Security Consultant, 2013-2016).',
         ARRAY['Zero Trust Architecture', 'Endpoint Security', 'Threat Detection', 'Security Architecture', 'Incident Response'],
         4.8, 9, 'proposed', true),
        
        -- Additional experts for various campaigns
        (campaign_ids[1], vendor_ids[6], 'Dr. Maria Garcia', 'Chief AI Officer', 'Duke Health',
         expert_avatars[9],
         'AI research director specializing in clinical decision support systems and medical AI applications.',
         'Duke Health (Chief AI Officer, 2020-present): Led development of AI-powered clinical decision support tools. Previously: IBM Watson Health (Research Director, 2017-2020), Google Health (Research Scientist, 2014-2017).',
         ARRAY['Clinical AI', 'Decision Support', 'Medical AI', 'Research', 'Deep Learning'],
         4.9, 10, 'reviewed', false),
        
        (campaign_ids[2], vendor_ids[7], 'Dr. John Kim', 'Radiology AI Specialist', 'Stanford Health',
         expert_avatars[10],
         'Radiologist and AI researcher specializing in deep learning for medical image analysis.',
         'Stanford Health (AI Specialist, 2019-present): Developed FDA-cleared AI tools for radiology. Previously: Stanford AI Lab (Research Fellow, 2016-2019), MD Anderson (Resident, 2013-2016).',
         ARRAY['Radiology AI', 'Deep Learning', 'Medical Imaging', 'Computer Vision', 'AI Research'],
         4.7, 9, 'proposed', true),
        
        (campaign_ids[3], vendor_ids[8], 'Patricia Williams', 'Regulatory Compliance Expert', 'Citibank',
         expert_avatars[11],
         'Banking compliance expert with 15 years of experience in digital banking regulations and KYC/AML.',
         'Citibank (Compliance Expert, 2018-present): Led compliance for digital banking platform serving 50M+ customers. Previously: Bank of America (Compliance Manager, 2015-2018), OCC (Examiner, 2010-2015).',
         ARRAY['Banking Compliance', 'KYC/AML', 'Digital Banking', 'Regulatory Affairs'],
         4.6, 8, 'approved', false),
        
        (campaign_ids[5], vendor_ids[9], 'Thomas Anderson', 'Pricing Strategy Consultant', 'McKinsey & Company',
         expert_avatars[12],
         'Management consultant specializing in SaaS pricing strategy, value-based pricing, and competitive positioning.',
         'McKinsey (Partner, 2017-present): Led pricing strategy engagements for Fortune 500 SaaS companies. Previously: BCG (Principal, 2014-2017), Deloitte (Senior Manager, 2010-2014).',
         ARRAY['Pricing Strategy', 'Value-Based Pricing', 'Management Consulting', 'SaaS Strategy'],
         4.8, 8, 'reviewed', false),
        
        (campaign_ids[7], vendor_ids[10], 'Ryan Murphy', 'Supply Chain Director', 'Walmart',
         expert_avatars[13],
         'Supply chain executive with expertise in global sourcing, supplier management, and logistics optimization.',
         'Walmart (Supply Chain Director, 2018-present): Managed $500B+ supply chain operations. Previously: Target (VP Supply Chain, 2015-2018), Procter & Gamble (Supply Chain Manager, 2011-2015).',
         ARRAY['Supply Chain', 'Global Sourcing', 'Supplier Management', 'Logistics'],
         4.7, 8, 'proposed', true),
        
        (campaign_ids[9], vendor_ids[11], 'Rachel Green', 'Solar Market Analyst', 'Wood Mackenzie',
         expert_avatars[14],
         'Energy market analyst specializing in solar market dynamics, policy impacts, and installation economics.',
         'Wood Mackenzie (Senior Analyst, 2019-present): Published 50+ reports on solar market trends. Previously: GTM Research (Analyst, 2016-2019), NREL (Research Analyst, 2014-2016).',
         ARRAY['Solar Market Analysis', 'Energy Markets', 'Policy Analysis', 'Market Research'],
         4.6, 8, 'reviewed', false),
        
        (campaign_ids[11], vendor_ids[12], 'Alex Johnson', 'Zero Trust Architect', 'Zscaler',
         expert_avatars[15],
         'Security architect specializing in zero trust network architecture and secure access service edge (SASE).',
         'Zscaler (Principal Architect, 2020-present): Designed zero trust architectures for enterprise customers. Previously: Cloudflare (Security Architect, 2018-2020), Akamai (Security Engineer, 2015-2018).',
         ARRAY['Zero Trust', 'SASE', 'Network Security', 'Cloud Security', 'Security Architecture'],
         4.8, 9, 'approved', false),
        
        (campaign_ids[4], vendor_ids[13], 'Nicole Brown', 'Crypto Regulatory Attorney', 'Andreessen Horowitz',
         expert_avatars[16],
         'Cryptocurrency regulatory attorney with expertise in SEC compliance, token regulations, and DeFi legal frameworks.',
         'Andreessen Horowitz (Regulatory Attorney, 2021-present): Advised crypto portfolio companies on regulatory compliance. Previously: SEC (Attorney-Advisor, 2018-2021), Coinbase (Legal Counsel, 2016-2018).',
         ARRAY['Crypto Regulation', 'SEC Compliance', 'Token Securities', 'DeFi', 'Regulatory Law'],
         4.7, 8, 'proposed', true),
        
        (campaign_ids[6], vendor_ids[14], 'Mark Davis', 'Enterprise Sales Leader', 'Snowflake',
         expert_avatars[17],
         'Enterprise sales executive with track record of building high-performing sales teams for SaaS companies.',
         'Snowflake (Sales Leader, 2020-present): Built enterprise sales team generating $1B+ ARR. Previously: Tableau (Sales Director, 2017-2020), Salesforce (Enterprise AE, 2014-2017).',
         ARRAY['Enterprise Sales', 'Sales Leadership', 'B2B SaaS', 'Account Management'],
         4.9, 9, 'reviewed', false),
        
        (campaign_ids[8], vendor_ids[15], 'Laura White', 'Supply Chain Technology Expert', 'SAP',
         expert_avatars[18],
         'Supply chain technology expert specializing in ERP integration, supply chain planning, and demand forecasting.',
         'SAP (Technology Expert, 2019-present): Led supply chain technology implementations for Fortune 500. Previously: Oracle (Product Manager, 2016-2019), JDA Software (Consultant, 2013-2016).',
         ARRAY['Supply Chain Technology', 'ERP', 'Supply Chain Planning', 'Demand Forecasting'],
         4.6, 8, 'approved', false);

    SELECT ARRAY_AGG(id) INTO expert_ids FROM expert_network.experts WHERE campaign_id = ANY(campaign_ids);
    RAISE NOTICE 'Created % experts', array_length(expert_ids, 1);

    -- ============================================================================
    -- 6. CREATE SCREENING QUESTIONS (30+)
    -- ============================================================================
    RAISE NOTICE 'Creating screening questions...';

    -- Create questions for each campaign (2-4 questions per campaign)
    FOR i IN 1..array_length(campaign_ids, 1) LOOP
        -- Create 2-4 questions per campaign
        FOR j IN 1..(2 + (i % 3)) LOOP
            temp_question_id := gen_random_uuid();
            question_ids := array_append(question_ids, temp_question_id);
            
            INSERT INTO expert_network.screening_questions (
                id, campaign_id, parent_question_id, question_text, question_type, options, display_order
            )
            VALUES (
                temp_question_id,
                campaign_ids[i],
                CASE WHEN j = 1 THEN NULL ELSE question_ids[array_length(question_ids, 1) - 1] END,
                CASE i
                    WHEN 1 THEN 
                        CASE j
                            WHEN 1 THEN 'What is your experience implementing clinical AI systems in hospital settings?'
                            WHEN 2 THEN 'Which AI vendors have you worked with? (Select all that apply)'
                            WHEN 3 THEN 'What were the main challenges you faced during AI implementation?'
                            ELSE 'How do you measure ROI for clinical AI investments?'
                        END
                    WHEN 2 THEN
                        CASE j
                            WHEN 1 THEN 'What is your experience with AI-powered medical imaging?'
                            WHEN 2 THEN 'Which imaging modalities have you worked with?'
                            ELSE 'What regulatory considerations are important for medical imaging AI?'
                        END
                    WHEN 3 THEN
                        CASE j
                            WHEN 1 THEN 'What is your experience with digital banking compliance?'
                            WHEN 2 THEN 'Which regulations are most challenging for digital banking?'
                            ELSE 'How do you ensure KYC/AML compliance in digital banking?'
                        END
                    WHEN 4 THEN
                        CASE j
                            WHEN 1 THEN 'What is your experience with cryptocurrency regulations?'
                            WHEN 2 THEN 'How do you navigate SEC compliance for crypto tokens?'
                            ELSE 'What are the key regulatory trends in DeFi?'
                        END
                    WHEN 5 THEN
                        CASE j
                            WHEN 1 THEN 'What pricing models have you implemented for SaaS products?'
                            WHEN 2 THEN 'How do you determine value-based pricing?'
                            ELSE 'What are the key considerations for usage-based pricing?'
                        END
                    WHEN 6 THEN
                        CASE j
                            WHEN 1 THEN 'What is your experience with enterprise sales processes?'
                            WHEN 2 THEN 'How do you structure account-based marketing campaigns?'
                            ELSE 'What metrics do you use to measure sales success?'
                        END
                    WHEN 7 THEN
                        CASE j
                            WHEN 1 THEN 'What supply chain disruptions have you experienced?'
                            WHEN 2 THEN 'How do you diversify supplier networks?'
                            ELSE 'What technology solutions do you use for supply chain visibility?'
                        END
                    WHEN 8 THEN
                        CASE j
                            WHEN 1 THEN 'What supply chain technology platforms have you implemented?'
                            WHEN 2 THEN 'How do you integrate WMS and TMS systems?'
                            ELSE 'What are the key features of an effective demand forecasting system?'
                        END
                    WHEN 9 THEN
                        CASE j
                            WHEN 1 THEN 'What is your experience with solar energy installations?'
                            WHEN 2 THEN 'How do you evaluate solar panel technology?'
                            ELSE 'What are the key factors affecting solar installation economics?'
                        END
                    WHEN 10 THEN
                        CASE j
                            WHEN 1 THEN 'What is your experience with battery storage technology?'
                            WHEN 2 THEN 'How do you compare lithium-ion vs flow batteries?'
                            ELSE 'What are the key considerations for grid-scale energy storage?'
                        END
                    WHEN 11 THEN
                        CASE j
                            WHEN 1 THEN 'What is your experience implementing zero trust architecture?'
                            WHEN 2 THEN 'Which zero trust vendors have you worked with?'
                            ELSE 'What are the main challenges in zero trust implementation?'
                        END
                    ELSE
                        CASE j
                            WHEN 1 THEN 'What is your relevant experience in this industry?'
                            WHEN 2 THEN 'What are the key challenges in this market?'
                            ELSE 'What insights can you provide on recent trends?'
                        END
                END,
                CASE WHEN j = 2 THEN 'multiple-choice' ELSE 'text' END,
                CASE WHEN j = 2 THEN '{"options": ["Option A", "Option B", "Option C", "Option D"]}'::jsonb ELSE NULL END,
                j - 1
            );
        END LOOP;
    END LOOP;

    RAISE NOTICE 'Created screening questions';

    -- ============================================================================
    -- 7. CREATE EXPERT SCREENING RESPONSES (30+)
    -- ============================================================================
    RAISE NOTICE 'Creating expert screening responses...';

    -- Get question IDs for each campaign
    FOR i IN 1..array_length(campaign_ids, 1) LOOP
        -- Get experts for this campaign (up to 3)
        FOR temp_expert_id IN 
            SELECT id FROM expert_network.experts WHERE campaign_id = campaign_ids[i] LIMIT 3
        LOOP
            -- Get questions for this campaign (up to 2 questions per expert)
            FOR temp_question_id IN
                SELECT id FROM expert_network.screening_questions WHERE campaign_id = campaign_ids[i] LIMIT 2
            LOOP
                INSERT INTO expert_network.expert_screening_responses (
                    expert_id, screening_question_id, response_text
                )
                VALUES (
                    temp_expert_id,
                    temp_question_id,
                    'Comprehensive response based on extensive experience in the field. ' ||
                    'I have worked on multiple projects involving this topic and can provide ' ||
                    'detailed insights based on real-world implementation experience.'
                )
                ON CONFLICT DO NOTHING;
            END LOOP;
        END LOOP;
    END LOOP;

    RAISE NOTICE 'Created expert screening responses';

    -- ============================================================================
    -- 8. CREATE INTERVIEWS (70+)
    -- ============================================================================
    RAISE NOTICE 'Creating interviews...';

    -- Create interviews for various experts
    FOR i IN 1..array_length(expert_ids, 1) LOOP
        -- Create 2-3 interviews per expert
        FOR j IN 1..(2 + (i % 2)) LOOP
            -- Get campaign_id for this expert
            SELECT campaign_id INTO temp_campaign_id 
            FROM expert_network.experts 
            WHERE id = expert_ids[i];
            
            INSERT INTO expert_network.interviews (
                campaign_id, expert_id, scheduled_date, scheduled_time,
                duration_minutes, timezone, status, color_tag
            )
            VALUES (
                temp_campaign_id,
                expert_ids[i],
                CURRENT_DATE + (INTERVAL '1 day' * (i * 2 + j)),
                (TIME '09:00:00' + (INTERVAL '1 hour' * ((i * 3 + j * 2) % 8)))::TIME,
                30 + (j * 30),
                'America/New_York',
                CASE (i % 5)
                    WHEN 0 THEN 'completed'
                    WHEN 1 THEN 'scheduled'
                    WHEN 2 THEN 'confirmed'
                    WHEN 3 THEN 'pending'
                    ELSE 'scheduled'
                END,
                CASE (i % 4)
                    WHEN 0 THEN 'blue'
                    WHEN 1 THEN 'green'
                    WHEN 2 THEN 'purple'
                    ELSE 'orange'
                END
            );
        END LOOP;
    END LOOP;

    -- Create additional interviews for completed status
    FOR i IN 1..20 LOOP
        SELECT campaign_id, id INTO temp_campaign_id, temp_expert_id
        FROM expert_network.experts
        WHERE status IN ('approved', 'reviewed')
        OFFSET (i % 10)
        LIMIT 1;
        
        IF temp_campaign_id IS NOT NULL AND temp_expert_id IS NOT NULL THEN
            INSERT INTO expert_network.interviews (
                campaign_id, expert_id, scheduled_date, scheduled_time,
                duration_minutes, timezone, status, color_tag, completed_at
            )
            VALUES (
                temp_campaign_id,
                temp_expert_id,
                CURRENT_DATE - (INTERVAL '1 day' * i),
                (TIME '10:00:00' + (INTERVAL '1 hour' * (i % 6)))::TIME,
                60,
                'America/New_York',
                'completed',
                CASE (i % 4)
                    WHEN 0 THEN 'blue'
                    WHEN 1 THEN 'green'
                    WHEN 2 THEN 'purple'
                    ELSE 'orange'
                END,
                CURRENT_TIMESTAMP - (INTERVAL '1 day' * i)
            )
            ON CONFLICT DO NOTHING;
        END IF;
    END LOOP;

    RAISE NOTICE 'Created interviews';

    -- ============================================================================
    -- SUMMARY
    -- ============================================================================
    RAISE NOTICE '=== SEED DATA SUMMARY ===';
    RAISE NOTICE 'Projects: %', (SELECT COUNT(*) FROM expert_network.projects WHERE expert_network.projects.user_id = target_user_id);
    RAISE NOTICE 'Campaigns: %', (SELECT COUNT(*) FROM expert_network.campaigns WHERE expert_network.campaigns.user_id = target_user_id);
    RAISE NOTICE 'Team Members: %', (SELECT COUNT(*) FROM expert_network.team_members WHERE expert_network.team_members.user_id = target_user_id);
    RAISE NOTICE 'Campaign Vendor Enrollments: %', (SELECT COUNT(*) FROM expert_network.campaign_vendor_enrollments WHERE campaign_id = ANY(campaign_ids));
    RAISE NOTICE 'Experts: %', (SELECT COUNT(*) FROM expert_network.experts WHERE campaign_id = ANY(campaign_ids));
    RAISE NOTICE 'Screening Questions: %', (SELECT COUNT(*) FROM expert_network.screening_questions WHERE campaign_id = ANY(campaign_ids));
    RAISE NOTICE 'Screening Responses: %', (SELECT COUNT(*) FROM expert_network.expert_screening_responses WHERE expert_id = ANY(expert_ids));
    RAISE NOTICE 'Interviews: %', (SELECT COUNT(*) FROM expert_network.interviews WHERE campaign_id = ANY(campaign_ids));
    RAISE NOTICE '=== SEED COMPLETE ===';

END $$;

