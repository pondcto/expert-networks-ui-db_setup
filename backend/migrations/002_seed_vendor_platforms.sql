-- Migration: Seed vendor platforms
-- Seeds the vendor_platforms table with initial data

INSERT INTO expert_network.vendor_platforms (id, name, logo_url, location, overall_score, avg_cost_per_call_min, avg_cost_per_call_max, description, tags, is_active) VALUES
('e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b'::uuid, 'GLG', '/images/vendor-logos/GLG.png', 'New York, USA', 4.8, 800, 1500,
 'One of the world''s largest expert networks, connecting clients with industry experts across all sectors.',
 ARRAY['Global Coverage', 'Life Sciences', 'Technology', 'Financial Services', '24h sourcing', 'Premium service', 'C-suite access', 'Compliance heavy', 'Deep bench'], true),

('a1b2c3d4-e5f6-4789-a123-567890abcdef'::uuid, 'AlphaSights', '/images/vendor-logos/AlphaSights.png', 'London, UK', 4.7, 700, 1400,
 'Premium expert network focused on connecting clients with C-suite executives and industry leaders.',
 ARRAY['Executive Access', 'Private Equity', 'Consulting', 'Global Project Execution', '24h sourcing', 'White-glove service', 'C-suite access', 'EU specialists', 'GDPR compliant'], true),

('b2c3d4e5-f6a7-4801-b345-678901bcdefb'::uuid, 'Guidepoint', '/images/vendor-logos/Guidepoint.png', 'New York, USA', 4.6, 750, 1300,
 'Specialized in providing deep industry insights through a network of experienced professionals.',
 ARRAY['Healthcare Expertise', 'Technology', 'Quick Turnaround', '48h sourcing', 'SME access', 'US-focused', 'Regulatory expertise', 'Deep bench'], true),

('c3d4e5f6-a7b8-4012-c456-789012cdefab'::uuid, 'Third Bridge', '/images/vendor-logos/Third Bridge.png', 'London, UK', 4.5, 600, 1200,
 'Expert network with a focus on providing actionable insights for investment decisions.',
 ARRAY['Investment Research', 'Forum Platform', 'APAC Coverage', '48h sourcing', 'Self-service portal', 'APAC bench', 'Multi-region', 'Cost effective'], true),

('d4e5f6a7-b8c9-4123-d567-890123defabc'::uuid, 'Atheneum', '/images/vendor-logos/Atheneum.png', 'Berlin, Germany', 4.4, 650, 1250,
 'Technology-driven expert network platform with strong European presence.',
 ARRAY['AI-Powered Matching', 'European Focus', 'Technology Platform', 'Same-day response', 'EU specialists', 'GDPR compliant', 'Tech-enabled', 'Rapid matching'], true),

('e5f6a7b8-c9d0-4234-e678-901234efabcd'::uuid, 'Inex One', '/images/vendor-logos/Inex One.png', 'Chicago, USA', 4.3, 500, 1000,
 'Expert network aggregator that connects clients with multiple expert network platforms.',
 ARRAY['Multi-Network Access', 'Cost Effective', 'Platform Aggregation', '72h sourcing', 'Self-service', 'Multi-vendor', 'Budget-friendly', 'Wide coverage'], true),

('f6a7b8c9-d0e1-4345-f789-012345fabcde'::uuid, 'Coleman Research', '/images/vendor-logos/Coleman Research.png', 'Chapel Hill, USA', 4.5, 700, 1300,
 'Boutique expert network focused on delivering high-quality experts for complex research projects.',
 ARRAY['Healthcare', 'Regulatory', 'Boutique Service', '24h sourcing', 'White-glove service', 'Compliance heavy', 'Niche specialists', 'Regulatory focus'], true),

('a7b8c9d0-e1f2-4456-a890-123456abcdef'::uuid, 'Tegus', '/images/vendor-logos/Tegus.png', 'Chicago, USA', 4.6, 800, 1500,
 'Expert insights platform with a searchable library of thousands of expert transcripts.',
 ARRAY['Transcript Library', 'Technology', 'SaaS Focus', 'Instant access', 'Self-service portal', 'Tech platform', 'Searchable database', 'On-demand'], true),

('b8c9d0e1-f2a3-4567-b901-234567bcdefb'::uuid, 'Prosapient', '/images/vendor-logos/Prosapient.png', 'New York, USA', 4.4, 650, 1200,
 'Expert network with deep industry expertise and proprietary research capabilities.',
 ARRAY['Compliance Focus', 'Research Capabilities', 'Industry Depth', '48h sourcing', 'Compliance heavy', 'SOC2 certified', 'Research-grade', 'Regulated industries'], true),

('c9d0e1f2-a3b4-4678-c012-345678cdefab'::uuid, 'Stream', '/images/vendor-logos/Stream.png', 'New York, USA', 4.3, 600, 1150,
 'Technology-enabled expert network focused on enterprise and technology sectors.',
 ARRAY['Technology Focus', 'Rapid Sourcing', 'Flexible Pricing', '24h sourcing', 'Tech-enabled', 'Enterprise focus', 'Fast turnaround', 'Flexible terms'], true),

('d0e1f2a3-b4c5-4789-d123-456789defabc'::uuid, 'Maven', '/images/vendor-logos/Maven.png', 'San Francisco, USA', 4.5, 700, 1350,
 'Platform connecting clients with vetted subject matter experts across industries.',
 ARRAY['User-Friendly', 'Transparent Pricing', 'Cross-Industry', '48h sourcing', 'Self-service portal', 'Transparent fees', 'Easy booking', 'Wide expertise'], true),

('e1f2a3b4-c5d6-4890-e234-567890efabcd'::uuid, 'Dialectica', '/images/vendor-logos/Dialectica.png', 'Athens, Greece', 4.4, 550, 1100,
 'Fast-growing expert network with European roots and global expansion.',
 ARRAY['European Roots', 'Quick Turnaround', 'Global Expansion', '24h sourcing', 'EU specialists', 'Fast response', 'Global reach', 'Cost effective'], true),

('f2a3b4c5-d6e7-4901-f345-678901fabcde'::uuid, 'Capvision', '/images/vendor-logos/Capvision.png', 'Shanghai, China', 4.3, 500, 1000,
 'Leading expert network in Asia with strong China coverage.',
 ARRAY['Asia Focus', 'China Expertise', 'Cross-Border', '48h sourcing', 'APAC bench', 'China specialists', 'Local languages', 'Asia-Pacific'], true),

('a3b4c5d6-e7f8-4012-a456-789012abcdef'::uuid, 'Brainworks', '/images/vendor-logos/Brainworks.png', 'New York, USA', 4.2, 600, 1200,
 'Boutique expert network with personalized service and deep industry relationships.',
 ARRAY['Boutique', 'Personalized Service', 'Financial Services', '48h sourcing', 'White-glove service', 'Relationship-driven', 'Finance focus', 'Personalized'], true),

('b4c5d6e7-f8a9-4123-b567-890123bcdefb'::uuid, 'Nexus', '/images/vendor-logos/Nexus.png', 'Tokyo, Japan', 4.1, 550, 1050,
 'Asia-Pacific focused expert network with strong presence in Japan and Australia.',
 ARRAY['APAC', 'Japan', 'Manufacturing', '72h sourcing', 'APAC bench', 'Japan specialists', 'Regional focus', 'Manufacturing'], true),

('c5d6e7f8-a9b0-4234-c678-901234cdefab'::uuid, 'Zintro', '/images/vendor-logos/Zintro.png', 'Boston, USA', 4.0, 400, 900,
 'Cost-effective expert network platform with self-service options.',
 ARRAY['Cost Effective', 'Self-Service', 'Quick Consultations', '72h sourcing', 'Budget-friendly', 'Self-service portal', 'SME access', 'Fast booking'], true),

('d6e7f8a9-b0c1-4345-d789-012345defabc'::uuid, 'NewtonX', '/images/vendor-logos/NewtonX.png', 'New York, USA', 4.5, 750, 1400,
 'AI-powered B2B expert network specializing in hard-to-reach decision makers.',
 ARRAY['AI-Powered', 'B2B Focus', 'Decision Makers', '24h sourcing', 'AI matching', 'C-suite access', 'Hard-to-reach', 'Tech-enabled'], true),

('e7f8a9b0-c1d2-4456-e890-123456efabcd'::uuid, 'ExpertConnect', '/images/vendor-logos/ExpertConnect.png', 'Singapore', 4.2, 600, 1150,
 'Asian expert network with regional expertise and local language support.',
 ARRAY['Asian Markets', 'Local Languages', 'Compliance', '48h sourcing', 'APAC bench', 'Multi-lingual', 'Compliance focus', 'Regional expertise'], true);

-- Verify
SELECT COUNT(*) as vendor_count FROM expert_network.vendor_platforms;
