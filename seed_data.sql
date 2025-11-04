-- Expert Networks Application - Seed Data
-- Version: 1.0
-- Description: Seed data for development and demo purposes

-- =============================================================================
-- VENDOR PLATFORMS (from mockData.ts)
-- =============================================================================

INSERT INTO vendor_platforms (id, name, logo_url, location, overall_score, avg_cost_per_call_min, avg_cost_per_call_max, description, tags, is_active) VALUES
(
    'e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b',
    'GLG',
    '/images/vendor-logos/GLG.png',
    'New York, USA',
    4.8,
    800,
    1500,
    'One of the world''s largest expert networks, connecting clients with industry experts across all sectors. Known for comprehensive vetting and high-quality experts.',
    ARRAY['Global Coverage', 'Life Sciences', 'Technology', 'Financial Services'],
    true
),
(
    'a1b2c3d4-e5f6-7890-1234-567890abcdef',
    'AlphaSights',
    '/images/vendor-logos/AlphaSights.png',
    'London, UK',
    4.7,
    700,
    1400,
    'Premium expert network focused on connecting clients with C-suite executives and industry leaders. Strong presence in Europe and Asia.',
    ARRAY['Executive Access', 'Private Equity', 'Consulting', 'Global Project Execution'],
    true
),
(
    'b2c3d4e5-f6a7-8901-2345-678901bcdefg',
    'Guidepoint',
    '/images/vendor-logos/Guidepoint.png',
    'New York, USA',
    4.6,
    750,
    1300,
    'Specialized in providing deep industry insights through a network of experienced professionals. Strong focus on healthcare and technology sectors.',
    ARRAY['Healthcare Expertise', 'Technology', 'Quick Turnaround'],
    true
),
(
    'c3d4e5f6-a7b8-9012-3456-789012cdefgh',
    'Third Bridge',
    '/images/vendor-logos/Third Bridge.png',
    'London, UK',
    4.5,
    600,
    1200,
    'Expert network with a focus on providing actionable insights for investment decisions. Known for proprietary Forum platform and research.',
    ARRAY['Investment Research', 'Forum Platform', 'APAC Coverage'],
    true
),
(
    'd4e5f6a7-b8c9-0123-4567-890123defghi',
    'Atheneum',
    '/images/vendor-logos/Atheneum.png',
    'Berlin, Germany',
    4.4,
    650,
    1250,
    'Technology-driven expert network platform with strong European presence. AI-powered matching and project management tools.',
    ARRAY['AI-Powered Matching', 'European Focus', 'Technology Platform'],
    true
),
(
    'e5f6a7b8-c9d0-1234-5678-901234efghij',
    'Inex One',
    '/images/vendor-logos/Inex One.png',
    'Chicago, USA',
    4.3,
    500,
    1000,
    'Expert network aggregator that connects clients with multiple expert network platforms. Streamlines project management across vendors.',
    ARRAY['Multi-Network Access', 'Cost Effective', 'Platform Aggregation'],
    true
),
(
    'f6a7b8c9-d0e1-2345-6789-012345fghijk',
    'Coleman Research',
    '/images/vendor-logos/Coleman Research.png',
    'Chapel Hill, USA',
    4.5,
    700,
    1300,
    'Boutique expert network focused on delivering high-quality experts for complex research projects. Strong healthcare and regulatory expertise.',
    ARRAY['Healthcare', 'Regulatory', 'Boutique Service'],
    true
),
(
    'a7b8c9d0-e1f2-3456-7890-123456ghijkl',
    'Tegus',
    '/images/vendor-logos/Tegus.png',
    'Chicago, USA',
    4.6,
    800,
    1500,
    'Expert insights platform with a searchable library of thousands of expert transcripts. Strong technology and SaaS coverage.',
    ARRAY['Transcript Library', 'Technology', 'SaaS Focus'],
    true
),
(
    'b8c9d0e1-f2a3-4567-8901-234567hijklm',
    'Prosapient',
    '/images/vendor-logos/Prosapient.png',
    'New York, USA',
    4.4,
    650,
    1200,
    'Expert network with deep industry expertise and proprietary research capabilities. Known for detailed expert vetting and compliance.',
    ARRAY['Compliance Focus', 'Research Capabilities', 'Industry Depth'],
    true
),
(
    'c9d0e1f2-a3b4-5678-9012-345678ijklmn',
    'Stream',
    '/images/vendor-logos/Stream.png',
    'New York, USA',
    4.3,
    600,
    1150,
    'Technology-enabled expert network focused on enterprise and technology sectors. Rapid sourcing and flexible pricing models.',
    ARRAY['Technology Focus', 'Rapid Sourcing', 'Flexible Pricing'],
    true
),
(
    'd0e1f2a3-b4c5-6789-0123-456789jklmno',
    'Maven',
    '/images/vendor-logos/Maven.png',
    'San Francisco, USA',
    4.5,
    700,
    1350,
    'Platform connecting clients with vetted subject matter experts across industries. Known for user-friendly platform and transparent pricing.',
    ARRAY['User-Friendly', 'Transparent Pricing', 'Cross-Industry'],
    true
),
(
    'e1f2a3b4-c5d6-7890-1234-567890klmnop',
    'Dialectica',
    '/images/vendor-logos/Dialectica.png',
    'Athens, Greece',
    4.4,
    550,
    1100,
    'Fast-growing expert network with European roots and global expansion. Focus on quick turnaround and quality matching.',
    ARRAY['European Roots', 'Quick Turnaround', 'Global Expansion'],
    true
),
(
    'f2a3b4c5-d6e7-8901-2345-678901lmnopq',
    'Capvision',
    '/images/vendor-logos/Capvision.png',
    'Shanghai, China',
    4.3,
    500,
    1000,
    'Leading expert network in Asia with strong China coverage. Expertise in Asian markets and cross-border research.',
    ARRAY['Asia Focus', 'China Expertise', 'Cross-Border'],
    true
),
(
    'a3b4c5d6-e7f8-9012-3456-789012mnopqr',
    'Brainworks',
    '/images/vendor-logos/Brainworks.png',
    'New York, USA',
    4.2,
    600,
    1200,
    'Boutique expert network with personalized service and deep industry relationships. Strong in financial services and healthcare.',
    ARRAY['Boutique', 'Personalized Service', 'Financial Services'],
    true
),
(
    'b4c5d6e7-f8a9-0123-4567-890123nopqrs',
    'Nexus',
    '/images/vendor-logos/Nexus.png',
    'Tokyo, Japan',
    4.1,
    550,
    1050,
    'Asia-Pacific focused expert network with strong presence in Japan and Australia. Specializes in technology and manufacturing.',
    ARRAY['APAC', 'Japan', 'Manufacturing'],
    true
),
(
    'c5d6e7f8-a9b0-1234-5678-901234opqrst',
    'Zintro',
    '/images/vendor-logos/Zintro.png',
    'Boston, USA',
    4.0,
    400,
    900,
    'Cost-effective expert network platform with self-service options. Good for smaller projects and quick consultations.',
    ARRAY['Cost Effective', 'Self-Service', 'Quick Consultations'],
    true
),
(
    'd6e7f8a9-b0c1-2345-6789-012345pqrstu',
    'NewtonX',
    '/images/vendor-logos/NewtonX.png',
    'New York, USA',
    4.5,
    750,
    1400,
    'AI-powered B2B expert network specializing in hard-to-reach decision makers. Strong technology and data-driven matching.',
    ARRAY['AI-Powered', 'B2B Focus', 'Decision Makers'],
    true
),
(
    'e7f8a9b0-c1d2-3456-7890-123456qrstuv',
    'ExpertConnect',
    '/images/vendor-logos/ExpertConnect.png',
    'Singapore',
    4.2,
    600,
    1150,
    'Asian expert network with regional expertise and local language support. Strong compliance and regulatory knowledge.',
    ARRAY['Asian Markets', 'Local Languages', 'Compliance'],
    true
);

-- =============================================================================
-- UPDATE SEQUENCES
-- =============================================================================

-- Ensure the next ID generation doesn't conflict with seeded data
-- No action needed for UUID-based primary keys

-- =============================================================================
-- VERIFICATION
-- =============================================================================

-- Verify vendor platforms were inserted
SELECT
    COUNT(*) as total_vendors,
    COUNT(CASE WHEN is_active THEN 1 END) as active_vendors
FROM vendor_platforms;

-- Show vendor distribution by tags
SELECT
    unnest(tags) as tag,
    COUNT(*) as vendor_count
FROM vendor_platforms
GROUP BY tag
ORDER BY vendor_count DESC;

-- =============================================================================
-- COMPLETION
-- =============================================================================

SELECT 'Seed data inserted successfully!' AS status;
