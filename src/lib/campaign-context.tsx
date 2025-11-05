

import React, { createContext, useContext, useState, useCallback } from 'react';
import * as api from './api-client';

export interface CampaignData {
  id?: string;
  campaignName: string;
  projectCode: string;
  industryVertical: string;
  customIndustry?: string;
  briefDescription: string;
  expandedDescription: string;
  targetRegions: string[];
  customRegions?: string;
  startDate: string;
  targetCompletionDate: string;
  estimatedCalls?: number; // Keep for backward compatibility
  minCalls?: number;
  maxCalls?: number;
  teamMembers: unknown[];
  screeningQuestions: unknown[];
  selectedVendors: string[];
  proposedExperts?: unknown[];
  createdAt?: string;
  updatedAt?: string;
}

interface CampaignContextType {
  campaignData: CampaignData | null;
  setCampaignData: (data: CampaignData | ((prev: CampaignData | null) => CampaignData)) => void;
  saveCampaign: (dataToSave?: Partial<CampaignData>) => Promise<string>;
  loadCampaign: (campaignId: string) => Promise<void>;
  isNewCampaign: boolean;
  setIsNewCampaign: (isNew: boolean) => void;
  refreshCampaigns: () => void;
}

const CampaignContext = createContext<CampaignContextType | undefined>(undefined);

export function CampaignProvider({ children }: { children: React.ReactNode }) {
  const [campaignData, setCampaignData] = useState<CampaignData | null>(null);
  const [isNewCampaign, setIsNewCampaign] = useState(true);

  // Generate a 16-digit hexadecimal campaign ID
  // const _generateCampaignId = (): string => {
  //   return Array.from({ length: 16 }, () => 
  //     Math.floor(Math.random() * 16).toString(16)
  //   ).join('');
  // };

  // Memoize saveCampaign to prevent infinite loops in components that depend on it
  const saveCampaign = useCallback(async (dataToSave?: Partial<CampaignData>): Promise<string> => {
    // Merge the provided data with current campaign data
    const mergedData = dataToSave 
      ? { ...campaignData, ...dataToSave } as CampaignData
      : campaignData;

    if (!mergedData) {
      throw new Error('No campaign data to save');
    }

    try {
      let campaignId = mergedData.id;
      
      if (campaignId) {
        // Update existing campaign
        const updateData: api.CampaignUpdate = {
          campaign_name: mergedData.campaignName,
          industry_vertical: mergedData.industryVertical,
          custom_industry: mergedData.customIndustry?.trim() || undefined,
          brief_description: mergedData.briefDescription,
          expanded_description: mergedData.expandedDescription,
          start_date: mergedData.startDate !== 'Any' ? mergedData.startDate : undefined,
          target_completion_date: mergedData.targetCompletionDate !== 'Any' ? mergedData.targetCompletionDate : undefined,
          target_regions: mergedData.targetRegions,
          custom_regions: mergedData.customRegions?.trim() || undefined,
          min_calls: mergedData.minCalls,
          max_calls: mergedData.maxCalls,
        };
        
        const updatedCampaign = await api.updateCampaign(campaignId, updateData);
        campaignId = updatedCampaign.id;
        
        // Update local state
        const updatedData: CampaignData = {
          ...mergedData,
          id: updatedCampaign.id,
          updatedAt: updatedCampaign.updated_at,
        };
        setCampaignData(updatedData);
      } else {
        // Create new campaign
        // Convert projectCode to project_id (UUID) if provided
        let projectId: string | undefined = undefined;
        if (mergedData.projectCode && mergedData.projectCode.trim() !== '') {
          try {
            // Check if projectCode is already a UUID (valid UUID format)
            const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
            if (uuidRegex.test(mergedData.projectCode)) {
              // It's already a UUID, use it directly
              projectId = mergedData.projectCode;
            } else {
              // It's a project code, look up the project to get its ID
              const projects = await api.getProjects();
              const project = projects.find((p: api.Project) => 
                p.project_code === mergedData.projectCode || p.id === mergedData.projectCode
              );
              if (project) {
                projectId = project.id;
              } else {
                // Project not found, but don't fail - just set to undefined
                console.warn(`Project with code "${mergedData.projectCode}" not found. Creating campaign without project.`);
              }
            }
          } catch (error) {
            console.error('Error looking up project:', error);
            // Continue without project_id if lookup fails
          }
        }
        
        const createData: api.CampaignCreate = {
          project_id: projectId,
          campaign_name: mergedData.campaignName,
          industry_vertical: mergedData.industryVertical,
          custom_industry: mergedData.customIndustry?.trim() || undefined,
          brief_description: mergedData.briefDescription,
          expanded_description: mergedData.expandedDescription,
          start_date: mergedData.startDate !== 'Any' ? mergedData.startDate : new Date().toISOString().split('T')[0],
          target_completion_date: mergedData.targetCompletionDate !== 'Any' ? mergedData.targetCompletionDate : new Date().toISOString().split('T')[0],
          target_regions: mergedData.targetRegions,
          custom_regions: mergedData.customRegions?.trim() || undefined,
          min_calls: mergedData.minCalls,
          max_calls: mergedData.maxCalls,
        };
        
        const newCampaign = await api.createCampaign(createData);
        campaignId = newCampaign.id;
        
        // Save screening questions if any were provided
        if (mergedData.screeningQuestions && Array.isArray(mergedData.screeningQuestions) && mergedData.screeningQuestions.length > 0) {
          try {
            // Import screening questions API
            const { createScreeningQuestion } = await import('./api-client');
            
            // Create root questions first
            const questionIdMap = new Map<string, string>();
            for (let i = 0; i < mergedData.screeningQuestions.length; i++) {
              const q = mergedData.screeningQuestions[i] as { id?: string; text?: string; subQuestions?: Array<{ text?: string }> };
              if (q.text) {
                const created = await createScreeningQuestion(newCampaign.id, {
                  campaign_id: newCampaign.id, // Required by backend model
                  question_text: q.text,
                  parent_question_id: null,
                  display_order: i
                });
                questionIdMap.set(q.id || String(i), created.id);
                
                // Create sub-questions if any
                if (q.subQuestions && Array.isArray(q.subQuestions)) {
                  for (let j = 0; j < q.subQuestions.length; j++) {
                    const sq = q.subQuestions[j];
                    if (sq.text) {
                      await createScreeningQuestion(newCampaign.id, {
                        campaign_id: newCampaign.id, // Required by backend model
                        question_text: sq.text,
                        parent_question_id: created.id,
                        display_order: j
                      });
                    }
                  }
                }
              }
            }
          } catch (error) {
            console.error('Failed to save screening questions after campaign creation:', error);
            // Don't fail the campaign creation if questions fail
          }
        }
        
        // Save team members if any were provided
        if (mergedData.teamMembers && Array.isArray(mergedData.teamMembers) && mergedData.teamMembers.length > 0) {
          try {
            // Import team members API
            const { assignTeamMemberToCampaign } = await import('./api-client');
            
            // Assign each team member to the campaign
            for (const member of mergedData.teamMembers) {
              const memberId = (member as { id?: string }).id;
              if (memberId) {
                await assignTeamMemberToCampaign(newCampaign.id, memberId);
              }
            }
          } catch (error) {
            console.error('Failed to save team members after campaign creation:', error);
            // Don't fail the campaign creation if team members fail
          }
        }
        
        // Update local state
        const newData: CampaignData = {
          ...mergedData,
          id: newCampaign.id,
          createdAt: newCampaign.created_at,
          updatedAt: newCampaign.updated_at,
        };
        setCampaignData(newData);
      }
      
      setIsNewCampaign(false);
      
      // Dispatch custom event to notify sidebar of campaign save
      if (typeof window !== 'undefined') {
        window.dispatchEvent(new CustomEvent('campaignSaved', { 
          detail: { campaignId, campaignName: mergedData.campaignName } 
        }));
      }
      
      return campaignId;
    } catch (error) {
      console.error('Error saving campaign:', error);
      throw error;
    }
  }, [campaignData]);

  // Memoize loadCampaign to prevent infinite loops in components that depend on it
  const loadCampaign = useCallback(async (campaignId: string): Promise<void> => {
    try {
      const campaign = await api.getCampaign(campaignId);
      
      // Load screening questions
      let screeningQuestions: Array<{ id: string; text: string; subQuestions?: Array<{ id: string; text: string }> }> = [];
      try {
        const { getScreeningQuestions } = await import('./api-client');
        const backendQuestions = await getScreeningQuestions(campaignId);
        // Convert backend format to frontend format
        screeningQuestions = backendQuestions.map(q => ({
          id: q.id,
          text: q.question_text,
          subQuestions: q.sub_questions ? q.sub_questions.map((sq: api.ScreeningQuestion) => ({
            id: sq.id,
            text: sq.question_text
          })) : undefined
        }));
      } catch (error) {
        console.error('Failed to load screening questions:', error);
      }
      
      // Load team members
      let teamMembers: Array<{ id: string; name: string; designation: string; avatar: string }> = [];
      try {
        const { getCampaignTeamMembers } = await import('./api-client');
        const backendMembers = await getCampaignTeamMembers(campaignId);
        // Convert backend format to frontend format
        teamMembers = backendMembers.map(m => ({
          id: m.id,
          name: m.name,
          designation: m.designation,
          avatar: m.avatar_url || `/images/team-members/${m.name}.png`
        }));
      } catch (error) {
        console.error('Failed to load team members:', error);
      }
      
      // Convert API campaign to CampaignData format
      const campaignData: CampaignData = {
        id: campaign.id,
        campaignName: campaign.campaign_name,
        projectCode: campaign.project_code || '',
        industryVertical: campaign.industry_vertical,
        customIndustry: campaign.custom_industry || undefined,
        briefDescription: campaign.brief_description || '',
        expandedDescription: campaign.expanded_description || '',
        targetRegions: campaign.target_regions || [],
        customRegions: campaign.custom_regions || undefined,
        startDate: campaign.start_date,
        targetCompletionDate: campaign.target_completion_date,
        minCalls: campaign.min_calls || 0,
        maxCalls: campaign.max_calls || 0,
        estimatedCalls: campaign.min_calls && campaign.max_calls ? Math.round((campaign.min_calls + campaign.max_calls) / 2) : 0,
        teamMembers: teamMembers,
        screeningQuestions: screeningQuestions,
        selectedVendors: [], // Can be loaded separately if needed
        createdAt: campaign.created_at,
        updatedAt: campaign.updated_at,
      };
      
      setCampaignData(campaignData);
      setIsNewCampaign(false);
    } catch (error) {
      console.error('Failed to load campaign:', error);
    }
  }, []);

  const refreshCampaigns = () => {
    // This is a placeholder for refreshing campaign list
    // In a real app, this might trigger a re-fetch from the database
    // For now, it's just a no-op since the sidebar handles its own refresh
  };

  return (
    <CampaignContext.Provider
      value={{
        campaignData,
        setCampaignData,
        saveCampaign,
        loadCampaign,
        isNewCampaign,
        setIsNewCampaign,
        refreshCampaigns,
      }}
    >
      {children}
    </CampaignContext.Provider>
  );
}

export function useCampaign() {
  const context = useContext(CampaignContext);
  if (context === undefined) {
    throw new Error('useCampaign must be used within a CampaignProvider');
  }
  return context;
}
