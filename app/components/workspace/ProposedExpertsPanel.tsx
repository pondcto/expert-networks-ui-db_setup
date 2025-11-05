"use client";

import React, { useState, useEffect, useCallback } from "react";
import Image from "next/image";
import { Star } from "lucide-react";
import { Tooltip, TooltipTrigger, TooltipContent } from "@/components/ui/tooltip";
import { LoadingSpinner } from "../ui/loading-spinner";
import { ErrorMessage } from "../ui/error-message";
import { EmptyState } from "../ui/empty-state";
import { Users } from "lucide-react";
import { useCampaign } from "../../lib/campaign-context";
import { useApi } from "../../hooks/use-api";
import * as api from "../../lib/api-client";

interface ProposedExpert {
  id: string;
  number: number;
  vendor_id: string;
  vendor_name: string;
  company: string;
  name: string;
  title: string;
  avatar: string;
  isNew: boolean;
  history: string;
  rating: number;
  aiFitScore: number;
  status: "Awaiting Review" | "Reviewed";
  description: string;
  skills: string[];
  screeningResponses: {
    question: string;
    answer: string;
  }[];
}

interface ProposedExpertsPanelProps {
  onExpertSelect?: (expert: ProposedExpert) => void;
  selectedExpertId?: string | null;
  onExpertsChange?: (hasExperts: boolean) => void;
}

export default function ProposedExpertsPanel({ onExpertSelect, selectedExpertId, onExpertsChange }: ProposedExpertsPanelProps) {
  const { campaignData } = useCampaign();
  const [experts, setExperts] = useState<ProposedExpert[]>([]);
  const [selectedExperts, setSelectedExperts] = useState<Set<string>>(new Set());
  const [selectAll, setSelectAll] = useState(false);

  // Load vendors
  const { data: vendors } = useApi(api.getVendors);

  // Load experts for this campaign
  const loadExperts = useCallback(async () => {
    if (!campaignData?.id) {
      return { experts: [], total: 0 };
    }

    const vendorsData = vendors || await api.getVendors();
    const expertsResponse = await api.getExperts({ campaign_id: campaignData.id });
    
    // Convert API experts to ProposedExpert format
    const proposedExperts: ProposedExpert[] = expertsResponse.experts.map((expert, index) => {
      const expertAvatar = expert.avatar_url || `/images/experts/${expert.expert_name.replace(/[^a-zA-Z0-9]/g, '_')}.png`;
      
      return {
        id: expert.id,
        number: index + 1,
        vendor_id: expert.vendor_platform_id,
        vendor_name: expert.vendor_name,
        company: expert.current_company || '',
        name: expert.expert_name,
        title: expert.current_title || '',
        avatar: expertAvatar,
        isNew: expert.status === 'proposed',
        history: expert.work_history || '',
        rating: expert.rating != null ? Number(expert.rating) : 4.0,
        aiFitScore: expert.relevance_score != null ? Math.round(Number(expert.relevance_score)) : 7,
        status: expert.status === 'reviewed' || expert.status === 'approved' ? 'Reviewed' : 'Awaiting Review',
        description: expert.bio || '',
        skills: expert.expertise_areas || [],
        screeningResponses: [],
      };
    });

    // Automatically select the first expert if none is currently selected
    if (proposedExperts.length > 0 && onExpertSelect && !selectedExpertId) {
      onExpertSelect(proposedExperts[0]);
    }

    return { experts: proposedExperts, total: expertsResponse.total };
  }, [campaignData?.id, vendors, onExpertSelect, selectedExpertId]);

  const { data, loading, error, refetch } = useApi(loadExperts, {
    enabled: !!campaignData?.id && !!vendors,
  });

  useEffect(() => {
    if (data) {
      setExperts(data.experts);
      // Notify parent about experts availability
      onExpertsChange?.(data.experts.length > 0);
    } else {
      // No data loaded yet, assume no experts
      onExpertsChange?.(false);
    }
  }, [data, onExpertsChange]);
  
  // Also notify when experts array changes directly
  useEffect(() => {
    onExpertsChange?.(experts.length > 0);
  }, [experts.length, onExpertsChange]);

  // Notify parent when campaign changes or when there are no experts
  useEffect(() => {
    if (!campaignData?.id) {
      onExpertsChange?.(false);
    }
  }, [campaignData?.id, onExpertsChange]);

  const getVendorById = (vendorId: string): api.Vendor | undefined => {
    return vendors?.find(vendor => vendor.id === vendorId);
  };

  const _handleExpertSelect = (expertId: string) => {
    const newSelected = new Set(selectedExperts);
    if (newSelected.has(expertId)) {
      newSelected.delete(expertId);
    } else {
      newSelected.add(expertId);
    }
    setSelectedExperts(newSelected);
    setSelectAll(newSelected.size === experts.length);
  };

  const _handleSelectAll = () => {
    if (selectAll) {
      setSelectedExperts(new Set());
      setSelectAll(false);
    } else {
      setSelectedExperts(new Set(experts.map(expert => expert.id)));
      setSelectAll(true);
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "Reviewed":
        return "bg-green-100 text-green-800";
      case "Awaiting Review":
        return "bg-red-100 text-red-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };


  const getAiFitScoreColor = (score: number) => {
    if (score >= 9) return "bg-green-500 text-white";
    if (score >= 7) return "bg-yellow-500 text-white";
    return "bg-red-500 text-white";
  };

  const handleRowClick = (expert: ProposedExpert) => {
    if (onExpertSelect) {
      onExpertSelect(expert);
    }
  };

  if (loading) {
    return (
      <div className="card h-full w-full flex flex-col overflow-hidden pb-0 px-3 pt-3">
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
            Proposed Experts
          </h3>
        </div>
        <div className="flex-1 flex items-center justify-center">
          <LoadingSpinner size="lg" text="Loading experts..." />
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="card h-full w-full flex flex-col overflow-hidden pb-0 px-3 pt-3">
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
            Proposed Experts
          </h3>
        </div>
        <div className="flex-1 p-4">
          <ErrorMessage error={error} onDismiss={() => refetch()} />
        </div>
      </div>
    );
  }

  if (!campaignData?.id) {
    return (
      <div className="card h-full w-full flex flex-col overflow-hidden pb-0 px-3 pt-3">
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
            Proposed Experts
          </h3>
        </div>
        <div className="flex-1 flex items-center justify-center">
          <EmptyState
            icon={<Users className="w-12 h-12" />}
            title="No campaign selected"
            description="Select a campaign to view proposed experts."
          />
        </div>
      </div>
    );
  }

  if (experts.length === 0) {
    return (
      <div className="card h-full w-full flex flex-col overflow-hidden pb-0 px-3 pt-3">
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
            Proposed Experts
          </h3>
        </div>
        <div className="flex-1 flex items-center justify-center">
          <EmptyState
            icon={<Users className="w-12 h-12" />}
            title="No experts proposed yet"
            description="Enroll vendors to get expert proposals for this campaign."
          />
        </div>
      </div>
    );
  }

  const renderStars = (rating: number) => {
    const stars = [] as React.ReactNode[];
    for (let i = 0; i < 5; i++) {
      const fillPercent = Math.max(0, Math.min(100, (rating - i) * 100));
      stars.push(
        <div key={i} className="relative w-4 h-4">
          <Star className="w-4 h-4 text-orange-200 fill-orange-200" />
          {fillPercent > 0 && (
            <div className="absolute top-0 left-0 h-full overflow-hidden" style={{ width: `${fillPercent}%` }}>
              <Star className="w-4 h-4 text-orange-500 fill-orange-500" />
            </div>
          )}
        </div>
      );
    }
    return <div className="flex items-center gap-0.5">{stars}</div>;
  };

  return (
    <div className="card h-full w-full flex flex-col overflow-hidden pb-0 px-3 pt-3">
      <div className="flex items-center justify-between mb-3">
        <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
          Proposed Experts
        </h3>
      </div>

      <div className="flex-1 overflow-hidden">
        <div className="h-full overflow-auto">
          <table className="w-full">
            <thead className="sticky top-0 bg-light-surface dark:bg-dark-surface border-b border-light-border dark:border-dark-border z-10">
              <tr>
                <th className="text-left p-3 text-sm font-medium text-light-text-secondary dark:text-dark-text-secondary w-[3vw]">#</th>
                <th className="text-left p-3 pl-0 text-sm font-medium text-light-text-secondary dark:text-dark-text-secondary w-[15vw]">Expert</th>
                <th className="text-left p-3 pl-0 text-sm font-medium text-light-text-secondary dark:text-dark-text-secondary w-[10vw]">Vendor</th>
                <th className="text-left p-3 pl-0 text-sm font-medium text-light-text-secondary dark:text-dark-text-secondary w-[40vw]">History</th>
                <th className="text-left p-3 pl-0 text-sm font-medium text-light-text-secondary dark:text-dark-text-secondary w-[8vw]">Rating</th>
                <th className="text-left p-3 pl-0 text-sm font-medium text-light-text-secondary dark:text-dark-text-secondary w-[8vw]">AI fit score</th>
                <th className="text-left p-3 pl-0 text-sm font-medium text-light-text-secondary dark:text-dark-text-secondary w-[10vw]">Status</th>
              </tr>
            </thead>
            <tbody>
              {experts.map((expert) => (
                <tr 
                  key={expert.id} 
                  className={`border-b border-light-border dark:border-dark-border hover:bg-light-hover dark:hover:bg-dark-hover cursor-pointer ${
                    selectedExpertId === expert.id ? "bg-primary-50 dark:bg-primary-800" : ""
                  }`}
                  onClick={() => handleRowClick(expert)}
                >
                  <td className="p-1 pl-3 text-sm text-light-text dark:text-dark-text">
                    #{expert.number}
                  </td>
                  <td className="p-1">
                    <div className="flex items-center gap-3">
                      <div className="flex items-center gap-2">
                        <div className="relative">
                          <div className="w-10 h-10 rounded overflow-hidden bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
                            <Image src={expert.avatar} alt={expert.name} width={40} height={40} />
                          </div>
                          {expert.isNew && (
                            <div className="absolute -bottom-1 -right-1 bg-blue-500 text-white text-xs px-0.5 rounded">
                              New
                            </div>
                          )}
                        </div>
                      </div>
                      <div className="min-w-0 flex-1">
                        <div className="font-medium text-light-text dark:text-dark-text truncate">{expert.name}</div>
                        <div className="text-sm text-light-text-secondary dark:text-dark-text-secondary truncate">{expert.title}</div>
                      </div>
                    </div>
                  </td>
                  <td className="p-1">
                    {(() => {
                      const vendor = getVendorById(expert.vendor_id);
                      return vendor ? (
                        <div className="flex items-center gap-2 min-w-0">
                          <div className="w-6 h-6 rounded overflow-hidden bg-gray-100 dark:bg-gray-700 flex items-center justify-center flex-shrink-0">
                            <Image src={vendor.logo_url || '/images/vendor-logos/default.png'} alt={vendor.name} width={24} height={24} className="object-contain" />
                          </div>
                          <span className="text-sm font-medium text-light-text dark:text-dark-text truncate min-w-0">{vendor.name}</span>
                        </div>
                      ) : (
                        <span className="text-sm text-light-text-secondary dark:text-dark-text-secondary truncate block">
                          {expert.vendor_name || expert.company}
                        </span>
                      );
                    })()}
                  </td>
                  <td className="p-1 text-sm text-light-text-secondary dark:text-dark-text-secondary max-w-xs">
                    <div className="relative group mr-6">
                      <div className="truncate cursor-help">{expert.history}</div>
                      <div className="absolute left-0 top-full mt-1 px-3 py-2 bg-gray-900 dark:bg-gray-700 text-white text-xs rounded-md opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-normal z-20 shadow-lg max-w-md">
                        {expert.history}
                      </div>
                    </div>
                  </td>
                  <td className="p-1">
                    <div className="flex items-center gap-2">
                      {renderStars(expert.rating)}
                      <span className="text-xs text-light-text-secondary dark:text-dark-text-secondary">{expert.rating.toFixed(1)}</span>
                    </div>
                  </td>
                  <td className="p-1">
                    <div className="flex items-center gap-2 ml-3">
                      <Tooltip>
                        <TooltipTrigger asChild>
                          <span className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold cursor-help ${getAiFitScoreColor(expert.aiFitScore)}`}>
                            {expert.aiFitScore}
                          </span>
                        </TooltipTrigger>
                        <TooltipContent side="top" className="max-w-xs text-left leading-snug">
                          <div className="text-xs bg-primary-800 text-white p-2 rounded-md">
                            <div className="font-semibold mb-1">AI Fit Score: {expert.aiFitScore}/10</div>
                            {(() => {
                              const vendor = getVendorById(expert.vendor_id);
                              const topSkills = (expert.skills || []).slice(0, 3);
                              const screeningCount = expert.screeningResponses?.length || 0;
                              const historyPreview = expert.history?.slice(0, 100) || "";
                              return (
                                <div>
                                  <div className="mb-1">This score estimates how well this expert matches your scope:</div>
                                  <ul className="list-disc pl-4 mt-1 space-y-0.5">
                                    <li>
                                      <span className="font-semibold">Top skills match:</span> {topSkills.length > 0 ? topSkills.join(", ") : "N/A"}
                                    </li>
                                    <li>
                                      <span className="font-semibold">Role/Seniority:</span> {expert.title || "N/A"}
                                    </li>
                                    <li>
                                      <span className="font-semibold">Sourcing vendor:</span> {vendor ? vendor.name : expert.company}
                                    </li>
                                    <li>
                                      <span className="font-semibold">Screening alignment:</span> {screeningCount} response{screeningCount === 1 ? "" : "s"} reviewed
                                    </li>
                                  </ul>
                                  {historyPreview && (
                                    <div className="mt-1 opacity-90">
                                      <span className="font-semibold">Recent work:</span> {historyPreview}
                                      {expert.history && expert.history.length > 100 ? "…" : ""}
                                    </div>
                                  )}
                                  <div className="mt-1 opacity-80">Higher is better. Use alongside qualitative review.</div>
                                </div>
                              );
                            })()}
                          </div>
                        </TooltipContent>
                      </Tooltip>
                    </div>
                  </td>
                  <td className="p-1">
                    <span className={`inline-flex items-center justify-center w-32 px-3 py-1 rounded-full text-xs font-medium whitespace-nowrap ${getStatusColor(expert.status)}`}>
                      {expert.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
