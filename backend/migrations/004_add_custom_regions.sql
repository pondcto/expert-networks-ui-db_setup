-- Migration: Add custom_regions field to campaigns table
-- This field stores custom region specifications when "Other" is selected in the Campaign Scope panel

ALTER TABLE expert_network.campaigns
ADD COLUMN IF NOT EXISTS custom_regions TEXT;

COMMENT ON COLUMN expert_network.campaigns.custom_regions IS 'Custom region specification when "Other" is selected for target regions';

