import { useState, useEffect } from "react";
import { useCampaign } from "../../lib/campaign-context";
import * as api from "../../lib/api-client";


interface ProposedExpert {
    id: string;
    vendor_id: string;
    vendor_name: string;
    name: string;
    title: string;
    avatar: string;
}

export default function SchedulingPipelinePanel() {
    const { campaignData } = useCampaign();
    const [experts, setExperts] = useState<ProposedExpert[]>([]);
    const [vendors, setVendors] = useState<api.Vendor[]>([]);
    const [loading, setLoading] = useState(true);

    // Load experts and vendors from API
    useEffect(() => {
        const loadData = async () => {
            if (!campaignData?.id) {
                setLoading(false);
                return;
            }

            try {
                // Load vendors
                const vendorsData = await api.getVendors();
                setVendors(vendorsData);

                // Load experts for this campaign
                const expertsResponse = await api.getExperts({ campaign_id: campaignData.id });
                
                // Convert to ProposedExpert format
                const proposedExperts: ProposedExpert[] = expertsResponse.experts.map((expert: api.Expert) => {
                    // Construct expert avatar path: use avatar_url from database, or fallback to images/experts/{expert_name}.png
                    const expertAvatar = expert.avatar_url || `/images/experts/${expert.expert_name.replace(/[^a-zA-Z0-9]/g, '_')}.png`;
                    
                    return {
                        id: expert.id,
                        vendor_id: expert.vendor_platform_id,
                        vendor_name: expert.vendor_name,
                        name: expert.expert_name,
                        title: expert.current_title || '',
                        avatar: expertAvatar,
                    };
                });

                setExperts(proposedExperts);
            } catch (error) {
                console.error('Error loading experts:', error);
                setExperts([]);
            } finally {
                setLoading(false);
            }
        };

        loadData();
    }, [campaignData?.id]);

    // Get scheduling status based on whether interview is scheduled
    const getSchedulingStatus = (_expertId: string): "Scheduled" | "Pending" => {
        // This can be enhanced to check actual interview status from API
        return "Pending";
    };

    const getStatusStyle = (status: "Scheduled" | "Pending") => {
        if (status === "Scheduled") {
            return "bg-green-100 dark:bg-green-900 text-green-800 dark:text-green-200 border border-green-300 dark:border-green-700";
        } else {
            return "bg-yellow-100 dark:bg-yellow-900 text-yellow-800 dark:text-yellow-200 border border-yellow-300 dark:border-yellow-700";
        }
    };

    if (loading) {
        return (
            <div className="h-full w-full flex flex-col overflow-hidden">
                <div className="flex items-center justify-between mb-4">
                    <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
                        Scheduling Pipeline
                    </h3>
                </div>
                <div className="flex-1 flex items-center justify-center">
                    <div className="text-light-text-secondary dark:text-dark-text-secondary">Loading...</div>
                </div>
            </div>
        );
    }

    if (!campaignData?.id) {
        return (
            <div className="h-full w-full flex flex-col overflow-hidden">
                <div className="flex items-center justify-between mb-4">
                    <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
                        Scheduling Pipeline
                    </h3>
                </div>
                <div className="flex-1 flex items-center justify-center">
                    <div className="text-light-text-secondary dark:text-dark-text-secondary">No campaign selected</div>
                </div>
            </div>
        );
    }

    return (
        <div className="h-full w-full flex flex-col overflow-hidden">
            <div className="flex items-center justify-between mb-4">
                <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
                    Scheduling Pipeline
                </h3>
            </div>
            
            <div className="flex-1 overflow-y-auto">
                {experts.length === 0 ? (
                    <div className="flex items-center justify-center h-full">
                        <div className="text-light-text-secondary dark:text-dark-text-secondary">
                            No experts to schedule yet
                        </div>
                    </div>
                ) : (
                <div className="space-y-1">
                    {experts.slice(0, 7).map((pe) => {
                        const vendor = vendors.find(v => v.id === pe.vendor_id);
                        const schedulingStatus = getSchedulingStatus(pe.id);
                        
                        return (
                            <div key={pe.id} className="flex items-center w-full gap-4 p-1 bg-light-surface dark:bg-dark-surface rounded-lg border border-light-border dark:border-dark-border">
                                {/* Avatars */}
                                <div className="flex items-center gap-3">
                                    {vendor && (
                                        <div className="w-10 h-10 rounded overflow-hidden bg-white dark:bg-dark-surface flex items-center justify-center">
                                            <img 
                                                src={vendor.logo_url || '/images/vendor-logos/default.png'} 
                                                alt="Vendor" 
                                                width={40} 
                                                height={40} 
                                                className="object-contain" 
                                            />
                                        </div>
                                    )}
                                    <div className="w-10 h-10 rounded overflow-hidden bg-gray-200 dark:bg-gray-700">
                                        <img 
                                            src={pe.avatar} 
                                            alt={pe.name}
                                            width={40}
                                            height={40}
                                            className="w-full h-full object-cover"
                                        />
                                    </div>
                                </div>
                                
                                {/* Expert Info */}
                                <div className="flex-1 min-w-0">
                                    <div className="font-medium text-light-text dark:text-dark-text truncate">
                                        {pe.name}
                                    </div>
                                    <div className="text-sm text-light-text-tertiary dark:text-dark-text-tertiary truncate">
                                        {pe.title}
                                    </div>
                                </div>
                                
                                {/* Status Tag */}
                                <div>
                                    <span className={`inline-flex items-center justify-center w-24 px-3 py-1 text-xs font-medium rounded-full whitespace-nowrap ${getStatusStyle(schedulingStatus)}`}>
                                        {schedulingStatus}
                                    </span>
                                </div>
                            </div>
                        );
                    })}
                </div>
                )}
            </div>
        </div>
    );
}