"use client";

import { useState, useEffect } from "react";
import { useCampaign } from "../../lib/campaign-context";
import * as api from "../../lib/api-client";

export default function CampaignMetricsCardPanel() {
  const { campaignData } = useCampaign();
  const [expertsUnderScreening, setExpertsUnderScreening] = useState(0);
  const [scheduling, setScheduling] = useState(0);
  const [scheduledCount, setScheduledCount] = useState(0);
  const [completedCount, setCompletedCount] = useState(0);
  const [_cancelledCount, _setCancelledCount] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadMetrics = async () => {
      if (!campaignData?.id) {
        setLoading(false);
        return;
      }

      try {
        // Load experts under screening (status: 'proposed' or 'reviewed')
        const expertsResponse = await api.getExperts({ campaign_id: campaignData.id });
        const experts = expertsResponse.experts || [];
        const underScreening = experts.filter(e => e.status === 'proposed' || e.status === 'reviewed').length;
        setExpertsUnderScreening(underScreening);

        // Load experts in scheduling (status: 'approved' but not yet scheduled)
        const scheduling = experts.filter(e => e.status === 'approved').length;
        setScheduling(scheduling);

        // Load interview counts by status
        const [scheduledResponse, completedResponse, cancelledResponse] = await Promise.all([
          api.getInterviews({ campaign_id: campaignData.id, status: 'scheduled' }),
          api.getInterviews({ campaign_id: campaignData.id, status: 'completed' }),
          api.getInterviews({ campaign_id: campaignData.id, status: 'cancelled' })
        ]);

        setScheduledCount(scheduledResponse.total || 0);
        setCompletedCount(completedResponse.total || 0);
        setCancelledCount(cancelledResponse.total || 0);
      } catch (error) {
        console.error('Error loading campaign metrics:', error);
      } finally {
        setLoading(false);
      }
    };

    loadMetrics();
  }, [campaignData?.id]);
  
  return (
    <div className="px-2 py-2 pb-0 ml-[48px]">
        <div className="grid grid-cols-7 gap-4">
            {/* Campaign Name */}
            <div className="bg-white dark:bg-gray-800 col-span-1 flex items-center justify-center rounded-lg p-2 border border-gray-200 dark:border-gray-700">
                <div className="text-lg font-semibold text-gray-800 dark:text-gray-200 text-center">
                    {campaignData?.campaignName || "Campaign Name"}
                </div>
            </div>
            
            {/* Experts under screening */}
            <div className="bg-white col-span-1 flex justify-between items-center gap-2 dark:bg-gray-800 rounded-lg p-2 border border-gray-200 dark:border-gray-700 min-w-0">
                <div className="text-md text-gray-600 dark:text-gray-400 truncate min-w-0">Experts under screening</div>
                <div className="text-2xl font-semibold text-blue-600 dark:text-blue-400 flex-shrink-0">
                  {loading ? "..." : expertsUnderScreening}
                </div>
            </div>
            
            {/* Scheduling */}
            <div className="bg-white col-span-1 flex justify-between items-center gap-2 dark:bg-gray-800 rounded-lg p-2 border border-gray-200 dark:border-gray-700 min-w-0">
                <div className="text-md text-gray-600 dark:text-gray-400 truncate min-w-0">Scheduling</div>
                <div className="text-2xl font-semibold text-blue-600 dark:text-blue-400 flex-shrink-0">
                  {loading ? "..." : scheduling}
                </div>
            </div>
            
            {/* Interviews scheduled */}
            <div className="bg-white col-span-1 flex justify-between items-center gap-2 dark:bg-gray-800 rounded-lg p-2 border border-gray-200 dark:border-gray-700 min-w-0">
                <div className="text-md text-gray-600 dark:text-gray-400 truncate min-w-0">Interviews scheduled</div>
                <div className="text-2xl font-semibold text-blue-600 dark:text-blue-400 flex-shrink-0">
                  {loading ? "..." : scheduledCount}
                </div>
            </div>
            
            {/* Interviews completed */}
            <div className="bg-white col-span-1 flex justify-between items-center gap-2 dark:bg-gray-800 rounded-lg p-2 border border-gray-200 dark:border-gray-700 min-w-0">
                <div className="text-md text-gray-600 dark:text-gray-400 truncate min-w-0">Interviews completed</div>
                <div className="text-2xl font-semibold text-blue-600 dark:text-blue-400 flex-shrink-0">
                  {loading ? "..." : completedCount}
                </div>
            </div>
            
            {/* Cost */}
            <div className="bg-white col-span-2 flex justify-between items-center gap-2 dark:bg-gray-800 rounded-lg p-2 border border-gray-200 dark:border-gray-700 min-w-0">
                <div className="text-md text-gray-600 dark:text-gray-400 truncate min-w-0">Estimated Cost</div>
                <div className="flex items-center">
                    {/* Bar chart icon */}
                    {(() => {
                        // Calculate target calls
                        const getEstimatedCalls = (c: typeof campaignData): number => {
                            if (!c) return 0;
                            if (c.minCalls !== undefined && c.maxCalls !== undefined) {
                                return Math.round((c.minCalls + c.maxCalls) / 2);
                            }
                            return c.estimatedCalls || 0;
                        };
                        
                        const targetCalls = getEstimatedCalls(campaignData);
                        const avgCostPerCall = 1000;
                        const totalBudget = targetCalls * avgCostPerCall;
                        
                        // Calculate actual costs from database
                        const completedCost = loading ? 0 : completedCount * avgCostPerCall;
                        const scheduledCost = loading ? 0 : scheduledCount * avgCostPerCall;
                        const remainingCost = Math.max(0, totalBudget - completedCost - scheduledCost);
                        
                        // Calculate percentages for bar widths (maintain overall width of 19vw)
                        const totalWidth = 19; // 10vw + 5vw + 4vw = 19vw
                        const completedPct = totalBudget > 0 ? (completedCost / totalBudget) : 0;
                        const scheduledPct = totalBudget > 0 ? (scheduledCost / totalBudget) : 0;
                        const remainingPct = totalBudget > 0 ? (remainingCost / totalBudget) : 0;
                        
                        const completedWidth = `${completedPct * totalWidth}vw`;
                        const scheduledWidth = `${scheduledPct * totalWidth}vw`;
                        const remainingWidth = `${remainingPct * totalWidth}vw`;
                        
                        const formatCurrency = (amount: number) => {
                            return new Intl.NumberFormat('en-US', {
                                style: 'currency',
                                currency: 'USD',
                                minimumFractionDigits: 0,
                                maximumFractionDigits: 0,
                            }).format(amount);
                        };
                        
                        return (
                            <div className="flex justify-end h-4 gap-0.5">
                                {/* Completed Bar */}
                                {completedCost > 0 && (
                                    <div className="relative group">
                                        <div className="bg-primary-500 dark:bg-primary-600 h-4 rounded-sm cursor-pointer transition-opacity hover:opacity-80" style={{ width: completedWidth, minWidth: '2px' }}></div>
                                        <div className="absolute right-full top-1/2 transform -translate-y-1/2 mr-2 px-3 py-1.5 bg-gray-900 dark:bg-gray-700 text-white text-xs rounded-md opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap z-10 shadow-lg">
                                            Completed: {formatCurrency(completedCost)}
                                            <div className="absolute left-full top-1/2 transform -translate-y-1/2 -ml-1 border-4 border-transparent border-l-gray-900 dark:border-l-gray-700"></div>
                                        </div>
                                    </div>
                                )}
                                {/* Scheduled Bar */}
                                {scheduledCost > 0 && (
                                    <div className="relative group">
                                        <div className="bg-primary-300 dark:bg-primary-400 h-4 rounded-sm cursor-pointer transition-opacity hover:opacity-80" style={{ width: scheduledWidth, minWidth: '2px' }}></div>
                                        <div className="absolute right-full top-1/2 transform -translate-y-1/2 mr-2 px-3 py-1.5 bg-gray-900 dark:bg-gray-700 text-white text-xs rounded-md opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap z-10 shadow-lg">
                                            Scheduled: {formatCurrency(scheduledCost)}
                                            <div className="absolute left-full top-1/2 transform -translate-y-1/2 -ml-1 border-4 border-transparent border-l-gray-900 dark:border-l-gray-700"></div>
                                        </div>
                                    </div>
                                )}
                                {/* Remaining Budget Bar */}
                                {remainingCost > 0 && (
                                    <div className="relative group">
                                        <div className="bg-gray-300 dark:bg-gray-600 h-4 rounded-sm cursor-pointer transition-opacity hover:opacity-80" style={{ width: remainingWidth, minWidth: '2px' }}></div>
                                        <div className="absolute right-full top-1/2 transform -translate-y-1/2 mr-2 px-3 py-1.5 bg-gray-900 dark:bg-gray-700 text-white text-xs rounded-md opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap z-10 shadow-lg">
                                            Remaining: {formatCurrency(remainingCost)}
                                            <div className="absolute left-full top-1/2 transform -translate-y-1/2 -ml-1 border-4 border-transparent border-l-gray-900 dark:border-l-gray-700"></div>
                                        </div>
                                    </div>
                                )}
                            </div>
                        );
                    })()}
                </div>
            </div>
        </div>
    </div>
  );
}


