-- Migration: Enhance vendor platform tags with SLA/operational metadata
-- Adds operational tags to help LLM mock backend choose vendors intelligently
-- Tags include: speed (24h/48h/72h sourcing), compliance, geography, service level

-- Third Bridge
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Investment Research', 'Forum Platform', 'APAC Coverage', '48h sourcing', 'Self-service portal', 'APAC bench', 'Multi-region', 'Cost effective']
WHERE name = 'Third Bridge';

-- Atheneum
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['AI-Powered Matching', 'European Focus', 'Technology Platform', 'Same-day response', 'EU specialists', 'GDPR compliant', 'Tech-enabled', 'Rapid matching']
WHERE name = 'Atheneum';

-- Inex One
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Multi-Network Access', 'Cost Effective', 'Platform Aggregation', '72h sourcing', 'Self-service', 'Multi-vendor', 'Budget-friendly', 'Wide coverage']
WHERE name = 'Inex One';

-- Coleman Research
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Healthcare', 'Regulatory', 'Boutique Service', '24h sourcing', 'White-glove service', 'Compliance heavy', 'Niche specialists', 'Regulatory focus']
WHERE name = 'Coleman Research';

-- Tegus
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Transcript Library', 'Technology', 'SaaS Focus', 'Instant access', 'Self-service portal', 'Tech platform', 'Searchable database', 'On-demand']
WHERE name = 'Tegus';

-- Prosapient
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Compliance Focus', 'Research Capabilities', 'Industry Depth', '48h sourcing', 'Compliance heavy', 'SOC2 certified', 'Research-grade', 'Regulated industries']
WHERE name = 'Prosapient';

-- Stream
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Technology Focus', 'Rapid Sourcing', 'Flexible Pricing', '24h sourcing', 'Tech-enabled', 'Enterprise focus', 'Fast turnaround', 'Flexible terms']
WHERE name = 'Stream';

-- Maven
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['User-Friendly', 'Transparent Pricing', 'Cross-Industry', '48h sourcing', 'Self-service portal', 'Transparent fees', 'Easy booking', 'Wide expertise']
WHERE name = 'Maven';

-- Dialectica
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['European Roots', 'Quick Turnaround', 'Global Expansion', '24h sourcing', 'EU specialists', 'Fast response', 'Global reach', 'Cost effective']
WHERE name = 'Dialectica';

-- Capvision
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Asia Focus', 'China Expertise', 'Cross-Border', '48h sourcing', 'APAC bench', 'China specialists', 'Local languages', 'Asia-Pacific']
WHERE name = 'Capvision';

-- Brainworks
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Boutique', 'Personalized Service', 'Financial Services', '48h sourcing', 'White-glove service', 'Relationship-driven', 'Finance focus', 'Personalized']
WHERE name = 'Brainworks';

-- Nexus
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['APAC', 'Japan', 'Manufacturing', '72h sourcing', 'APAC bench', 'Japan specialists', 'Regional focus', 'Manufacturing']
WHERE name = 'Nexus';

-- Zintro
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Cost Effective', 'Self-Service', 'Quick Consultations', '72h sourcing', 'Budget-friendly', 'Self-service portal', 'SME access', 'Fast booking']
WHERE name = 'Zintro';

-- NewtonX
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['AI-Powered', 'B2B Focus', 'Decision Makers', '24h sourcing', 'AI matching', 'C-suite access', 'Hard-to-reach', 'Tech-enabled']
WHERE name = 'NewtonX';

-- ExpertConnect
UPDATE expert_network.vendor_platforms
SET tags = ARRAY['Asian Markets', 'Local Languages', 'Compliance', '48h sourcing', 'APAC bench', 'Multi-lingual', 'Compliance focus', 'Regional expertise']
WHERE name = 'ExpertConnect';

-- Verify all vendors have enhanced tags
SELECT
    name,
    array_length(tags, 1) as tag_count,
    CASE
        WHEN tags && ARRAY['24h sourcing'] THEN '24h'
        WHEN tags && ARRAY['48h sourcing'] THEN '48h'
        WHEN tags && ARRAY['72h sourcing'] THEN '72h'
        WHEN tags && ARRAY['Same-day response', 'Instant access'] THEN 'Instant'
        ELSE 'No SLA'
    END as speed_sla,
    CASE
        WHEN tags && ARRAY['APAC bench', 'Asia Focus', 'China specialists', 'Japan specialists'] THEN 'APAC'
        WHEN tags && ARRAY['EU specialists', 'European Focus'] THEN 'EU'
        WHEN tags && ARRAY['US-focused'] THEN 'US'
        ELSE 'Global'
    END as region
FROM expert_network.vendor_platforms
ORDER BY name;
