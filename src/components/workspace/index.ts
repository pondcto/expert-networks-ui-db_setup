// Main workspace layout
export { default as CampaignSettingsWorkspace } from "./CampaignSettingsWorkspace";
export { default as CampaignExpertsWorkspace } from "./CampaignExpertsWorkspace";

// Individual panel components
export { default as ScreeningQuestionsPanel } from "./ScreeningQuestionsPanel";
export { default as CampaignBasicsPanel } from "./CampaignBasicsPanel";
export { default as ScopeRefinementPanel } from "./ScopeRefinementPanel";
export { default as VendorSelectionPanel } from "./VendorSelectionPanel";
export { default as TeamMembersPanel } from "./TeamMembersPanel";
export { default as ProposedExpertsPanel } from "./ProposedExpertsPanel";
export { default as ExpertDetailsPanel } from "./ExpertDetailsPanel";

// Type exports
export type { ScreeningQuestionsPanelProps } from "./ScreeningQuestionsPanel";
export type { CampaignBasicsPanelProps } from "./CampaignBasicsPanel";
export type { ScopeRefinementPanelProps } from "./ScopeRefinementPanel";
export type { VendorSelectionPanelProps } from "./VendorSelectionPanel";
export type { TeamMembersPanelProps } from "./TeamMembersPanel";

// Re-export types (keeping for backward compatibility)
// Note: These types should be moved to app/types/index.ts in the future
export type {
  ChatMessage,
} from "./ChatHistoryPanel";
