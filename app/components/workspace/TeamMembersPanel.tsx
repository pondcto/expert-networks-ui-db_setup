"use client";

import React, { useState, useEffect, useRef } from "react";
import { Plus, X, Trash2 } from "lucide-react";
import { useCampaign } from "../../lib/campaign-context";
import * as api from "../../lib/api-client";

export interface TeamMember {
  id: string;
  name: string;
  designation: string;
  avatar: string;
}

export interface TeamMembersPanelProps {
  members?: TeamMember[];
  onInviteMore?: () => void;
  onDataChange?: (data: TeamMember[]) => void;
}

// Convert backend team member to frontend format
function convertBackendToFrontend(backendMember: api.TeamMember): TeamMember {
  return {
    id: backendMember.id,
    name: backendMember.name,
    designation: backendMember.designation,
    avatar: backendMember.avatar_url || `/images/team-members/${backendMember.name}.png`,
  };
}

export default function TeamMembersPanel({
  members = [],
  onInviteMore,
  onDataChange,
}: TeamMembersPanelProps) {
  const { campaignData, isNewCampaign } = useCampaign();
  const [showModal, setShowModal] = useState(false);
  const [filterText, setFilterText] = useState("");
  const [currentMembers, setCurrentMembers] = useState<TeamMember[]>(members);
  const [availableMembers, setAvailableMembers] = useState<TeamMember[]>([]);
  const [invitedMembers, setInvitedMembers] = useState<Set<string>>(new Set());
  const [currentCampaignId, setCurrentCampaignId] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const modalStateRef = useRef(false); // Track modal state across re-renders

  // Load available team members from database
  useEffect(() => {
    const loadAvailableMembers = async () => {
      try {
        setLoading(true);
        const backendMembers = await api.getTeamMembers();
        const frontendMembers = backendMembers.map(convertBackendToFrontend);
        setAvailableMembers(frontendMembers);
      } catch (error: unknown) {
        // If backend is not available, show empty list gracefully
        const errorMessage = error instanceof Error ? error.message : String(error);
        if (errorMessage?.includes('Unable to connect') || errorMessage?.includes('Failed to fetch')) {
          // Backend is offline - this is expected, just log a warning
          console.warn('Backend server appears to be offline. Team members will be unavailable.');
        } else {
          // Other errors should be logged
          console.error('Failed to load team members:', error);
        }
        setAvailableMembers([]);
      } finally {
        setLoading(false);
      }
    };
    
    loadAvailableMembers();
  }, []);

  // Sync with campaignData for new campaigns, but don't overwrite if we just added members locally
  const isUpdatingRef = useRef(false);
  const previousTeamMembersRef = useRef<TeamMember[]>([]);
  
  useEffect(() => {
    // Skip sync if we're in the middle of updating (to prevent race condition)
    if (isUpdatingRef.current) {
      return;
    }
    
    if (isNewCampaign && campaignData?.teamMembers) {
      // For new campaigns, use the teamMembers from campaignData
      const teamMembers = Array.isArray(campaignData.teamMembers) ? (campaignData.teamMembers as TeamMember[]) : [];
      // Only update if the data is actually different to avoid unnecessary resets
      const previousIds = previousTeamMembersRef.current.map(m => m.id).sort().join(',');
      const currentIds = teamMembers.map(m => m.id).sort().join(',');
      
      if (previousIds !== currentIds) {
      setCurrentMembers(teamMembers);
        previousTeamMembersRef.current = teamMembers;
      }
    } else if (isNewCampaign && !campaignData?.teamMembers) {
      // Only reset to empty if we don't have any current members (initial state)
      if (previousTeamMembersRef.current.length === 0) {
      setCurrentMembers([]);
        previousTeamMembersRef.current = [];
      }
    }
  }, [isNewCampaign, campaignData?.teamMembers]);

  // Load campaign team members when campaign changes
  useEffect(() => {
    const loadCampaignMembers = async () => {
      // Skip if we're in the middle of updating (to prevent race condition)
      if (isUpdatingRef.current) {
        return;
      }
      
      if (isNewCampaign) {
        // For new campaigns, only initialize once
        // Don't reset if we already have members - they were intentionally added
        const hasMembers = previousTeamMembersRef.current.length > 0 || currentMembers.length > 0;
        const campaignHasMembers = campaignData?.teamMembers && Array.isArray(campaignData.teamMembers) && campaignData.teamMembers.length > 0;
        
        // Only reset if we don't have any members yet (initial state)
        if (!hasMembers && !campaignHasMembers) {
          setCurrentCampaignId(null);
          setCurrentMembers([]);
          previousTeamMembersRef.current = [];
          setInvitedMembers(new Set());
        } else if (campaignHasMembers && !hasMembers) {
          // Sync from campaignData if it has members but we don't
          const teamMembers = campaignData.teamMembers as TeamMember[];
          setCurrentMembers(teamMembers);
          previousTeamMembersRef.current = teamMembers;
        }
      } else if (campaignData?.id) {
        // If campaign ID changed, load new campaign's team members
        if (currentCampaignId !== campaignData.id) {
          setCurrentCampaignId(campaignData.id);
          try {
            setLoading(true);
            const backendMembers = await api.getCampaignTeamMembers(campaignData.id);
            const frontendMembers = backendMembers.map(convertBackendToFrontend);
            setCurrentMembers(frontendMembers);
            setInvitedMembers(new Set());
            onDataChange?.(frontendMembers);
          } catch (error: unknown) {
            // If backend is not available, show empty list gracefully
            const errorMessage = error instanceof Error ? error.message : String(error);
            if (errorMessage?.includes('Unable to connect') || errorMessage?.includes('Failed to fetch')) {
              // Backend is offline - this is expected, just log a warning
              console.warn('Backend server appears to be offline. Campaign team members will be unavailable.');
            } else {
              // Other errors should be logged
              console.error('Failed to load campaign team members:', error);
            }
            setCurrentMembers([]);
          } finally {
            setLoading(false);
          }
        }
      }
    };
    
    loadCampaignMembers();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [campaignData, currentCampaignId, isNewCampaign, currentMembers.length, onDataChange]);

  const filteredMembers = availableMembers.filter(member =>
    (member.name.toLowerCase().includes(filterText.toLowerCase()) ||
    member.designation.toLowerCase().includes(filterText.toLowerCase())) &&
    !currentMembers.some(currentMember => currentMember.id === member.id)
  );

  // Sync modal state ref with state
  useEffect(() => {
    modalStateRef.current = showModal;
  }, [showModal]);

  // Restore modal state if it should be open after re-render
  // This handles cases where parent re-renders cause modal to close unexpectedly
  useEffect(() => {
    if (modalStateRef.current && !showModal) {
      // Use requestAnimationFrame to ensure this runs after any re-renders
      requestAnimationFrame(() => {
        if (modalStateRef.current) {
          setShowModal(true);
        }
      });
    }
  }, [showModal]);

  const handleInviteMore = () => {
    // Call parent callback first to ensure panel is expanded/visible
    onInviteMore?.();
    // Small delay to ensure panel expansion completes before opening modal
    setTimeout(() => {
    modalStateRef.current = true;
    setShowModal(true);
    }, 100);
  };

  const handleCloseModal = () => {
    modalStateRef.current = false;
    setShowModal(false);
    setFilterText("");
  };

  const handleInviteMember = async (member: TeamMember) => {
    // Preserve modal state - ensure it stays open
    modalStateRef.current = true;
    // Immediately ensure modal is open
    if (!showModal) {
      setShowModal(true);
    }
    
    if (isNewCampaign || !campaignData?.id) {
      // Mark that we're updating to prevent useEffect from overwriting
      isUpdatingRef.current = true;
      
      // For new campaigns, just add to local state
      const newMembers = [...currentMembers, member];
      setCurrentMembers(newMembers);
      previousTeamMembersRef.current = newMembers; // Update ref immediately
      setInvitedMembers(prev => new Set(prev).add(member.id));
      
      // Ensure modal stays open after state update
      modalStateRef.current = true;
      setShowModal(true);
      
      // Update parent data and then allow sync
      setTimeout(() => {
        onDataChange?.(newMembers);
        // Allow useEffect to sync again after a brief delay to let parent update
        setTimeout(() => {
          isUpdatingRef.current = false;
        }, 150);
        // Ensure modal stays open after data update
        if (modalStateRef.current && !showModal) {
          setShowModal(true);
        }
      }, 0);
      return;
    }

    try {
      setLoading(true);
      // Assign team member to campaign in database
      await api.assignTeamMemberToCampaign(campaignData.id, member.id);
      
      // Add the member to the current team members list
      const newMembers = [...currentMembers, member];
      setCurrentMembers(newMembers);
      
      // Mark as invited for visual feedback
      setInvitedMembers(prev => new Set(prev).add(member.id));
      
      // Ensure modal stays open after state update
      modalStateRef.current = true;
      setShowModal(true);
      
      // Defer onDataChange to next tick to avoid interfering with modal state
      setTimeout(() => {
        onDataChange?.(newMembers);
        // Ensure modal stays open after data update
        if (modalStateRef.current && !showModal) {
          setShowModal(true);
        }
      }, 0);
    } catch (error) {
      console.error('Failed to assign team member:', error);
      alert(`Failed to assign team member: ${error instanceof Error ? error.message : 'Unknown error'}`);
      // Ensure modal stays open even on error
      modalStateRef.current = true;
      if (!showModal) {
        setShowModal(true);
      }
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteMember = async (memberId: string) => {
    if (isNewCampaign || !campaignData?.id) {
      // For new campaigns, just remove from local state
      const newMembers = currentMembers.filter(member => member.id !== memberId);
      setCurrentMembers(newMembers);
      setInvitedMembers(prev => {
        const newSet = new Set(prev);
        newSet.delete(memberId);
        return newSet;
      });
      onDataChange?.(newMembers);
      return;
    }

    try {
      setLoading(true);
      // Unassign team member from campaign in database
      await api.unassignTeamMemberFromCampaign(campaignData.id, memberId);
      
      const newMembers = currentMembers.filter(member => member.id !== memberId);
      setCurrentMembers(newMembers);
      
      // Remove from invited members set so they can be re-invited
      setInvitedMembers(prev => {
        const newSet = new Set(prev);
        newSet.delete(memberId);
        return newSet;
      });
      
      // Notify parent of data change
      onDataChange?.(newMembers);
    } catch (error) {
      console.error('Failed to unassign team member:', error);
      alert(`Failed to remove team member: ${error instanceof Error ? error.message : 'Unknown error'}`);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <div className="h-full flex flex-col overflow-hidden">
        <div className="flex items-center justify-between mb-2">
          <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
            Team Members
          </h3>
        </div>

        <div className="flex-1 min-h-0 overflow-auto px-1">
          {loading && currentMembers.length === 0 ? (
            <div className="text-center py-4 text-light-text-secondary dark:text-dark-text-secondary text-sm">
              Loading team members...
            </div>
          ) : currentMembers.length === 0 ? (
            <div className="text-center py-4 text-light-text-secondary dark:text-dark-text-secondary text-sm">
              No team members assigned yet. Click &quot;Invite more members&quot; to add team members.
            </div>
          ) : (
            <div className="space-y-2">
              {currentMembers.map((member) => (
                <div key={member.id} className="group relative flex items-center gap-3 dark:hover:bg-dark-background-secondary rounded transition-colors">
                  <img
                    src={member.avatar}
                    alt={member.name}
                    className="w-8 h-8 rounded-full object-cover"
                  />
                  <div className="flex-1 min-w-0">
                    <div className=" font-medium text-light-text dark:text-dark-text truncate">
                      {member.name}
                    </div>
                    <div className="text-xs text-light-text-tertiary dark:text-dark-text-tertiary truncate">
                      {member.designation}
                    </div>
                  </div>
                  {/* Delete button - appears on hover */}
                  <button
                    onClick={() => handleDeleteMember(member.id)}
                    className="opacity-0 group-hover:opacity-100 transition-opacity duration-200 p-2 bg-red-500 hover:bg-red-600 text-white rounded transition-colors"
                    title="Remove member"
                  >
                    <Trash2 className="w-3 h-3" />
                  </button>
                </div>
              ))}
            </div>
          )}
          
          {/* Invite more members */}
          {!loading && (
            <div className="mt-2">
              <button
                onClick={handleInviteMore}
                className="flex items-center gap-3 py-1 w-full rounded transition-colors"
              >
                <div className="w-8 h-8 rounded bg-light-background-secondary dark:bg-dark-background-secondary border border-light-border dark:border-dark-border flex items-center justify-center">
                  <Plus className="w-4 h-4 text-light-text dark:text-dark-text" />
                </div>
                <span className=" text-light-text dark:text-dark-text">
                  Invite more members
                </span>
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Invite Members Modal */}
      {showModal && (
        <div 
          className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-[9999]"
          onClick={handleCloseModal}
        >
          <div 
            className="bg-white dark:bg-dark-surface rounded-lg shadow-lg max-w-md w-full mx-4 max-h-[80vh] flex flex-col"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Modal Header */}
            <div className="flex items-center justify-between p-4 border-b border-light-border dark:border-dark-border">
              <h2 className="text-lg font-semibold text-light-text dark:text-dark-text">
                Team Members
              </h2>
              <button
                onClick={handleCloseModal}
                className="p-1 hover:bg-light-background-secondary dark:hover:bg-dark-background-secondary rounded transition-colors"
              >
                <X className="w-5 h-5 text-light-text dark:text-dark-text" />
              </button>
            </div>

            {/* Filter Input */}
            <div className="p-4 border-b border-light-border dark:border-dark-border">
              <input
                type="text"
                placeholder="Filter team members..."
                value={filterText}
                onChange={(e) => setFilterText(e.target.value)}
                className="w-full px-2 py-1 bg-light-background-secondary dark:bg-dark-background-secondary border border-light-border dark:border-dark-border rounded-md text-light-text dark:text-dark-text placeholder-light-text-tertiary dark:placeholder-dark-text-tertiary focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
              />
            </div>

            {/* Members List */}
            <div className="flex-1 overflow-auto p-2">
              {loading ? (
                <div className="text-center py-8 text-light-text-secondary dark:text-dark-text-secondary">
                  <div className="animate-pulse">Loading team members...</div>
                </div>
              ) : availableMembers.length === 0 ? (
                <div className="text-center py-8 text-light-text-secondary dark:text-dark-text-secondary">
                  <p className="mb-2">No team members available.</p>
                  <p className="text-sm">Team members will appear here once they are added to the system.</p>
                </div>
              ) : filteredMembers.length === 0 ? (
                <div className="text-center py-8 text-light-text-secondary dark:text-dark-text-secondary">
                  {filterText ? (
                    <>
                      <p className="mb-2">No team members found matching &quot;{filterText}&quot;.</p>
                      <p className="text-sm">Try adjusting your search.</p>
                    </>
                  ) : (
                    <>
                      <p className="mb-2">All available team members are already assigned.</p>
                      <p className="text-sm">Total team members: {availableMembers.length}</p>
                    </>
                  )}
                </div>
              ) : (
                <div className="space-y-1">
                  {filteredMembers.map((member) => (
                    <div 
                      key={member.id} 
                      className="flex items-center gap-3 p-3 hover:bg-light-background-secondary dark:hover:bg-dark-background-secondary rounded-lg transition-colors border border-transparent hover:border-light-border dark:hover:border-dark-border"
                    >
                      <img
                        src={member.avatar}
                        alt={member.name}
                        className="w-12 h-12 rounded-lg object-cover flex-shrink-0"
                        onError={(e) => {
                          // Fallback to a default avatar if image fails to load
                          const target = e.target as HTMLImageElement;
                          target.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(member.name)}&background=random&size=48`;
                        }}
                      />
                      <div className="flex-1 min-w-0">
                        <div className="font-semibold text-light-text dark:text-dark-text truncate">
                          {member.name}
                        </div>
                        <div className="text-sm text-light-text-tertiary dark:text-dark-text-tertiary truncate">
                          {member.designation || 'No designation'}
                        </div>
                      </div>
                      <button
                        onClick={() => handleInviteMember(member)}
                        disabled={invitedMembers.has(member.id) || currentMembers.some(m => m.id === member.id)}
                        className={`px-4 py-2 text-sm font-medium rounded-md transition-colors flex-shrink-0 ${
                          invitedMembers.has(member.id) || currentMembers.some(m => m.id === member.id)
                            ? "bg-green-500 text-white cursor-not-allowed opacity-75"
                            : "bg-primary-500 hover:bg-primary-600 text-white active:scale-95"
                        }`}
                      >
                        {invitedMembers.has(member.id) || currentMembers.some(m => m.id === member.id) ? "Invited" : "Invite"}
                      </button>
                    </div>
                  ))}
                  <div className="text-xs text-light-text-tertiary dark:text-dark-text-tertiary text-center py-2 px-2">
                    Showing {filteredMembers.length} of {availableMembers.length} team members
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  );
}
