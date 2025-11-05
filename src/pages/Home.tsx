

import React, { Suspense, useEffect, useState, useRef, useCallback } from "react";
import { useNavigate } from 'react-router-dom';
import { AppSidebar } from "../components/app-sidebar";
import { SidebarInset } from "../components/ui/sidebar";
import Logo from "../components/Logo";
import { useTheme } from "../providers/theme-provider";
import UserMenu from "../components/UserMenu";
import NewProjectModal from "../components/NewProjectModal";
import { Tooltip, TooltipTrigger, TooltipContent } from "../components/ui/tooltip";
import { Sun, Moon, Calendar, FolderOpen, Plus, Trash2, GripVertical, Folder } from "lucide-react";
import * as api from "../lib/api-client";

// Column width keys for localStorage
const COLUMN_WIDTHS_KEY = "dashboard_column_widths";

// Default column widths (in pixels - will be converted to percentages)
const DEFAULT_COLUMN_WIDTHS = {
  dragHandle: 16,
  campaignName: 400,
  industry: 180,
  timeline: 250,
  targetRegions: 288,
  divider: 1,
  callsProgress: 200,
  status: 96,
  cost: 80,
  team: 80,
  delete: 32,
};

// Gap between columns (12px = gap-3)
const COLUMN_GAP = 12;

// Helper function to calculate total width including gaps
const calculateTotalWidth = (widths: typeof DEFAULT_COLUMN_WIDTHS): number => {
  const numColumns = Object.keys(widths).length;
  return Object.values(widths).reduce((sum, width) => sum + width, 0) + (numColumns - 1) * COLUMN_GAP;
};

// Helper function to get column percentage width
const getColumnPercentage = (columnWidth: number, totalWidth: number): string => {
  return `${(columnWidth / totalWidth) * 100}%`;
};

// Resize handle component
function ColumnResizer({
  onResizeStart,
  onResize,
  className = "",
}: {
  onResizeStart: (startX: number) => void;
  onResize: (currentX: number) => void;
  className?: string;
}) {
  const [isResizing, setIsResizing] = useState(false);

  const handleMouseDown = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    setIsResizing(true);
    onResizeStart(e.clientX);

    const handleMouseMove = (moveEvent: MouseEvent) => {
      onResize(moveEvent.clientX);
    };

    const handleMouseUp = () => {
      setIsResizing(false);
      document.removeEventListener("mousemove", handleMouseMove);
      document.removeEventListener("mouseup", handleMouseUp);
      document.body.style.cursor = "";
      document.body.style.userSelect = "";
    };

    document.addEventListener("mousemove", handleMouseMove);
    document.addEventListener("mouseup", handleMouseUp);
    document.body.style.cursor = "col-resize";
    document.body.style.userSelect = "none";
  };

  return (
    <div
      onMouseDown={handleMouseDown}
      className={`absolute right-0 top-0 bottom-0 w-1 cursor-col-resize hover:bg-primary-500 z-20 ${isResizing ? "bg-primary-500" : ""} ${className}`}
    />
  );
}
import {
  DndContext,
  DragOverlay,
  closestCenter,
  PointerSensor,
  useSensor,
  useSensors,
  DragStartEvent,
  DragEndEvent,
  useDroppable,
} from "@dnd-kit/core";
import {
  SortableContext,
  verticalListSortingStrategy,
  useSortable,
  arrayMove,
} from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";

interface Campaign {
  id: string;
  campaignName: string;
  projectCode: string;
  industryVertical: string;
  startDate: string;
  targetCompletionDate: string;
  estimatedCalls?: number; // Keep for backward compatibility
  minCalls?: number;
  maxCalls?: number;
  // Accurate call tracking (optional, defaults to 0 if not present)
  completedCalls?: number;
  scheduledCalls?: number;
  cancelledCalls?: number;
  teamMembers: { id: string; name: string; designation: string; avatar: string }[];
  createdAt: string;
  updatedAt: string;
  order?: number;
  targetRegions?: string[];
}

interface ProjectGroup {
  projectCode: string;
  projectName: string;
  campaigns: Campaign[];
  totalCalls: number;
  totalBudget: number;
  totalSpent: number;
  isRealProject: boolean; // Whether this is an actual saved project or just a grouping
  order?: number;
}

// Delete Confirmation Modal Component
function DeleteConfirmationModal({
  isOpen,
  itemName,
  itemType = "Campaign",
  message,
  onConfirm,
  onCancel,
}: {
  isOpen: boolean;
  itemName: string;
  itemType?: "Campaign" | "Project";
  message?: string;
  onConfirm: () => void;
  onCancel: () => void;
}) {
  if (!isOpen) return null;

  const defaultMessage = itemType === "Project"
    ? `Are you sure you want to delete the project "${itemName}"? All campaigns in this project will be moved to "Other Campaigns". This action cannot be undone.`
    : `Are you sure you want to delete "${itemName}"? This action cannot be undone.`;

  return (
    <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/50" onClick={onCancel}>
      <div 
        className="bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border rounded-lg shadow-xl max-w-md w-full mx-4 p-6"
        onClick={(e) => e.stopPropagation()}
      >
        <h3 className="text-lg font-semibold text-light-text dark:text-dark-text mb-2">
          Delete {itemType}
        </h3>
        <p className="text-body text-light-text-secondary dark:text-dark-text-secondary mb-6">
          {message || defaultMessage}
        </p>
        <div className="flex justify-end gap-3">
          <button
            onClick={onCancel}
            className="px-4 py-2 text-body font-medium text-light-text dark:text-dark-text bg-light-background dark:bg-dark-background border border-light-border dark:border-dark-border rounded-lg hover:bg-light-background-secondary dark:hover:bg-dark-background-secondary transition-colors"
          >
            Cancel
          </button>
          <button
            onClick={onConfirm}
            className="px-4 py-2 text-body font-medium text-white bg-red-600 hover:bg-red-700 rounded-lg transition-colors"
          >
            Delete
          </button>
        </div>
      </div>
    </div>
  );
}

// Droppable Project Section Component
function DroppableProjectSection({
  projectCode,
  isExpanded,
  children,
}: {
  projectCode: string;
  isExpanded: boolean;
  children: React.ReactNode;
}) {
  const { setNodeRef, isOver } = useDroppable({
    id: projectCode,
  });

  return (
    <div
      ref={isExpanded ? setNodeRef : undefined}
      className={`${
        isOver && isExpanded ? "ring-2 ring-primary-500 ring-offset-2" : ""
      } transition-all`}
    >
      {children}
    </div>
  );
}

// Draggable Campaign Card Row Component (single line display)
function DraggableCampaignCardRow({
  campaign,
  projectCode,
  onDelete,
  onNavigate,
  columnWidths,
}: {
  campaign: Campaign;
  projectCode: string;
  onDelete: (e: React.MouseEvent, campaignId: string) => void;
  onNavigate: (campaignId: string) => void;
  columnWidths: typeof DEFAULT_COLUMN_WIDTHS;
}) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: campaign.id, data: { campaign, projectCode } });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

  // Calculate campaign status based on dates
  const getCampaignStatus = (campaign: Campaign) => {
    const now = new Date();
    const start = new Date(campaign.startDate);
    const end = new Date(campaign.targetCompletionDate);

    if (now < start) {
      return { label: "Waiting", color: "bg-blue-100 text-blue-800 dark:bg-blue-900/20 dark:text-blue-300", isActive: false };
    } else if (now >= start && now <= end) {
      return { label: "Active", color: "bg-green-100 text-green-800 dark:bg-green-900/20 dark:text-green-300", isActive: true };
    } else {
      return { label: "Completed", color: "bg-gray-100 text-gray-800 dark:bg-gray-900/20 dark:text-gray-300", isActive: false };
    }
  };

  // Calculate progress percentage for active campaigns
  // const calculateProgress = (campaign: Campaign): number => {
  //   const now = new Date();
  //   const start = new Date(campaign.startDate);
  //   const end = new Date(campaign.targetCompletionDate);
  //   
  //   const totalDuration = end.getTime() - start.getTime();
  //   const elapsed = now.getTime() - start.getTime();
  //   
  //   const progress = (elapsed / totalDuration) * 100;
  //   return Math.min(Math.max(progress, 0), 100);
  // };

  // Format date range for timeline
  const formatDateRange = (startDate: string, endDate: string) => {
    if (!startDate || startDate === "Any") return "TBD";
    const start = new Date(startDate);
    const end = new Date(endDate);
    const startStr = start.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
    const endStr = end.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
    return `${startStr} - ${endStr}`;
  };

  // Helper to get estimated calls (handles both old and new format)
  const getEstimatedCalls = (c: Campaign): number => {
    if (c.minCalls !== undefined && c.maxCalls !== undefined) {
      return Math.round((c.minCalls + c.maxCalls) / 2);
    }
    return c.estimatedCalls || 0;
  };

  // Calculate budget info
  const avgCostPerCall = 1000;
  const estimatedCalls = getEstimatedCalls(campaign);
  // const totalBudget = estimatedCalls * avgCostPerCall;
  const status = getCampaignStatus(campaign);
  // let totalSpent = 0;
  // 
  // if (status.isActive) {
  //   const progress = calculateProgress(campaign) / 100;
  //   totalSpent = totalBudget * progress;
  // } else if (status.label === "Completed") {
  //   totalSpent = totalBudget;
  // }
  
  // const _costPercentage = totalBudget > 0 ? Math.min(Math.round((totalSpent / totalBudget) * 100), 100) : 0;

  // Format currency
  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(amount);
  };

  // Get target regions (from campaign data if available)
  const targetRegions: string[] = campaign.targetRegions && campaign.targetRegions.length > 0 
    ? campaign.targetRegions 
    : ["North America", "Europe"];

  // Map region names to abbreviations
  const getRegionAbbreviation = (region: string): string => {
    const regionMap: { [key: string]: string } = {
      'North America': 'NA',
      'Europe': 'EUR',
      'Middle East & Africa': 'MEA',
      'Middle East': 'MEA',
      'Africa': 'MEA',
      'Latin America': 'LATAM',
      'Asia Pacific': 'APAC',
      'Asia': 'APAC',
      'Other': 'OTHER',
    };
    return regionMap[region] || 'OTHER';
  };

  // Calculate total width and percentages
  const totalWidth = calculateTotalWidth(columnWidths);

  return (
    <div
      ref={setNodeRef}
      style={style}
      className="group flex items-center gap-3 w-[calc(100%-2.5vw)] ml-[2.5vw] bg-light-background dark:bg-dark-background border border-light-border dark:border-dark-border rounded-lg p-1 hover:border-primary-500 dark:hover:border-primary-500 transition-all"
    >
      {/* Drag Handle */}
      <div 
        className="flex-shrink-0 cursor-grab active:cursor-grabbing border-r border-light-border/40 dark:border-dark-border/40 pr-1.5"
        style={{ flexBasis: getColumnPercentage(columnWidths.dragHandle, totalWidth), minWidth: 0 }}
        {...attributes} 
        {...listeners}
      >
        <GripVertical className="w-4 h-4 text-light-text-tertiary dark:text-dark-text-tertiary opacity-0 group-hover:opacity-100 transition-opacity" />
      </div>

      {/* Campaign Name */}
      <div 
        className="min-w-0 cursor-pointer border-r border-light-border/40 dark:border-dark-border/40 pr-1.5"
        style={{ flexBasis: getColumnPercentage(columnWidths.campaignName, totalWidth), minWidth: 0 }}
        onClick={(e) => {
          e.stopPropagation();
          onNavigate(campaign.id);
        }}
      >
        <h4 className="font-medium text-sm text-light-text dark:text-dark-text truncate">
          {campaign.campaignName}
        </h4>
      </div>

      {/* Industry */}
      <div className="min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.industry, totalWidth), minWidth: 0 }}>
        <p className="text-xs text-light-text-secondary dark:text-dark-text-secondary truncate">
          {campaign.industryVertical}
        </p>
      </div>

      {/* Timeline */}
      <div className="min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.timeline, totalWidth), minWidth: 0 }}>
        <div className="flex items-center gap-1 text-xs text-light-text-secondary dark:text-dark-text-secondary">
          <Calendar className="w-3 h-3 flex-shrink-0" />
          <span className="truncate">{formatDateRange(campaign.startDate, campaign.targetCompletionDate)}</span>
        </div>
      </div>

      {/* Target Regions */}
      <div className="min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.targetRegions, totalWidth), minWidth: 0 }}>
        <div className="flex items-center gap-1 overflow-x-auto min-w-0">
          {targetRegions.slice(0, 3).map((region: string, index: number) => (
            <span 
              key={index}
              className="inline-flex items-center justify-center w-14 px-2 py-0.5 bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border rounded text-xs font-medium text-light-text-secondary dark:text-dark-text-secondary flex-shrink-0 whitespace-nowrap"
              title={region}
            >
              {getRegionAbbreviation(region)}
            </span>
          ))}
          {targetRegions.length > 3 && (
            <span className="text-xs text-light-text-tertiary dark:text-dark-text-tertiary flex-shrink-0 whitespace-nowrap">
              +{targetRegions.length - 3}
            </span>
          )}
        </div>
      </div>

      {/* Number of Calls Progress Bar */}
      <div className="min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.callsProgress, totalWidth), minWidth: 0 }}>
        <div className="pr-6 py-1">
          <Tooltip>
            <TooltipTrigger asChild>
              <div 
                className="w-full bg-light-background-secondary dark:bg-dark-background-tertiary rounded-full h-2  flex overflow-hidden cursor-help"
              >
                {(() => {
                  const status = getCampaignStatus(campaign);
                  const targetCalls = estimatedCalls || 0;
                  
                  // For "Waiting" status, show 0%
                  // For "Completed" status, show 100%
                  // For "Active" status, calculate based on actual calls
                  let performedPct = 0;
                  let scheduledPct = 0;
                  
                  if (status.label === "Waiting") {
                    performedPct = 0;
                    scheduledPct = 0;
                  } else if (status.label === "Completed") {
                    performedPct = 100;
                    scheduledPct = 0;
                  } else {
                    // Active status - calculate based on actual calls
                    const performedCalls = Math.max(0, Math.min(campaign.completedCalls ?? 0, targetCalls));
                    const scheduledCalls = Math.max(0, Math.min((campaign.scheduledCalls ?? 0), Math.max(0, targetCalls - performedCalls)));
                    performedPct = targetCalls > 0 ? (performedCalls / targetCalls) * 100 : 0;
                    scheduledPct = targetCalls > 0 ? (scheduledCalls / targetCalls) * 100 : 0;
                  }
                  
                  return (
                    <>
                      <div 
                        className="h-2 bg-green-500 transition-all"
                        style={{ width: `${performedPct}%` }}
                      />
                      <div 
                        className="h-2 bg-yellow-500 transition-all"
                        style={{ width: `${scheduledPct}%` }}
                      />
                    </>
                  );
                })()}
              </div>
            </TooltipTrigger>
            <TooltipContent 
              side="top" 
              className="bg-gray-900 dark:bg-gray-700 text-white border-none"
            >
              <div className="text-xs">
                {(() => {
                  const status = getCampaignStatus(campaign);
                  const targetCalls = estimatedCalls || 0;
                  
                  // For "Waiting" status, show 0%
                  // For "Completed" status, show 100%
                  // For "Active" status, calculate based on actual calls
                  let performedCalls = 0;
                  let scheduledCalls = 0;
                  
                  if (status.label === "Waiting") {
                    performedCalls = 0;
                    scheduledCalls = 0;
                  } else if (status.label === "Completed") {
                    performedCalls = targetCalls;
                    scheduledCalls = 0;
                  } else {
                    // Active status - use actual calls
                    performedCalls = Math.max(0, Math.min(campaign.completedCalls ?? 0, targetCalls));
                    scheduledCalls = Math.max(0, Math.min((campaign.scheduledCalls ?? 0), Math.max(0, targetCalls - performedCalls)));
                  }
                  
                  return (
                    <>
                      <span className="text-green-400">{performedCalls} performed</span>
                      {" / "}
                      <span className="text-yellow-400">{scheduledCalls} scheduled</span>
                      {" / "}
                      <span>{targetCalls} target</span>
                    </>
                  );
                })()}
              </div>
            </TooltipContent>
          </Tooltip>
        </div>
      </div>

      {/* Status */}
      <div className="flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.status, totalWidth), minWidth: 0 }}>
        <span className={`inline-flex items-center justify-center w-20 px-2 py-0.5 border border-primary-300 rounded-full text-xs font-medium ${status.color}`}>
          {status.label}
        </span>
      </div>

      {/* Cost - Based on performed calls */}
      <div className="flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.cost, totalWidth), minWidth: 0 }}>
        <span className="text-xs text-light-text-secondary dark:text-dark-text-secondary font-medium whitespace-nowrap">
          {(() => {
            const targetCalls = estimatedCalls || 0;
            const performedCalls = Math.max(0, Math.min(campaign.completedCalls ?? 0, targetCalls));
            return formatCurrency(performedCalls * avgCostPerCall);
          })()}
        </span>
      </div>

      {/* Team */}
      <div className="flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.team, totalWidth), minWidth: 0 }}>
        {campaign.teamMembers && campaign.teamMembers.length > 0 ? (
          <div className="flex -space-x-1">
            {campaign.teamMembers.slice(0, 3).map((member) => (
              <img
                key={member.id}
                src={member.avatar}
                alt={member.name}
                className="w-6 h-6 rounded-full border-2 border-light-background dark:border-dark-background object-cover"
                title={member.name}
              />
            ))}
            {campaign.teamMembers.length > 3 && (
              <div className="w-6 h-6 rounded-full border-2 border-light-background dark:border-dark-background bg-light-background-secondary dark:bg-dark-background-secondary flex items-center justify-center text-[10px] font-medium text-light-text dark:text-dark-text">
                +{campaign.teamMembers.length - 3}
              </div>
            )}
          </div>
        ) : (
          <div></div>
        )}
      </div>

      {/* Delete Button - Always at the start */}
      <div className="flex-shrink-0 flex justify-center ml-auto" style={{ flexBasis: getColumnPercentage(columnWidths.delete, totalWidth), minWidth: 0 }}>
        <button
          onClick={(e) => {
            e.stopPropagation();
            onDelete(e, campaign.id);
          }}
          className="p-1.5 text-light-text-tertiary dark:text-dark-text-tertiary hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded transition-colors opacity-0 group-hover:opacity-100"
          title="Delete campaign"
        >
          <Trash2 className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}

// Project Card Component with Toggle (Now Sortable)
function ProjectCard({
  project,
  costPercentage: _costPercentage,
  campaignIds,
  onDeleteProject,
  onDeleteCampaign,
  onNavigateToCampaign,
  formatCurrency,
  columnWidths,
}: {
  project: ProjectGroup;
  costPercentage: number;
  campaignIds: string[];
  onDeleteProject: (e: React.MouseEvent, projectCode: string, projectName: string) => void;
  onDeleteCampaign: (e: React.MouseEvent, campaignId: string) => void;
  onNavigateToCampaign: (campaignId: string) => void;
  formatCurrency: (amount: number) => string;
  columnWidths: typeof DEFAULT_COLUMN_WIDTHS;
}) {
  const [isExpanded, setIsExpanded] = useState(true);

  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
    isOver,
    active,
  } = useSortable({ 
    id: project.projectCode,
    data: { type: 'project', project }
  });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

  // Check if a project is being dragged and this card is the drop target
  const isDraggingProject = active?.data?.current?.type === 'project';
  const showDropIndicator = isDraggingProject && isOver && !isDragging;

  return (
    <DroppableProjectSection
      projectCode={project.projectCode}
      isExpanded={true}
    >
      <div 
        ref={setNodeRef}
        style={style}
        className={`group w-full bg-light-surface dark:bg-dark-surface border ${
          showDropIndicator 
            ? 'border-primary-500 border-2 shadow-lg shadow-primary-500/20' 
            : 'border-light-border dark:border-dark-border'
        } rounded-lg shadow-card dark:shadow-card-dark overflow-hidden transition-all`}
      >
        {/* Project Header - Always Visible */}
        <div className="p-1">
          {(() => {
            const projectTotalWidth = calculateTotalWidth(columnWidths);
            return (
              <div className="flex items-center gap-3 w-full">
                {/* Drag Handle */}
                <div 
                  className="flex-shrink-0 cursor-grab active:cursor-grabbing border-r border-light-border/40 dark:border-dark-border/40 pr-1.5"
                  style={{ flexBasis: getColumnPercentage(columnWidths.dragHandle, projectTotalWidth), minWidth: 0 }}
                  {...attributes}
                  {...listeners}
                >
                  <GripVertical className="w-4 h-4 text-light-text-tertiary dark:text-dark-text-tertiary opacity-0 group-hover:opacity-100 transition-opacity" />
                </div>

                {/* Project Info Column - Uses campaignName column space */}
                <div 
                  className="min-w-0 cursor-pointer flex items-center gap-2 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5"
                  onClick={(e) => {
                    e.stopPropagation();
                    setIsExpanded(!isExpanded);
                  }}
                  style={{ flexBasis: getColumnPercentage(columnWidths.campaignName, projectTotalWidth), minWidth: 0 }}
                >
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      setIsExpanded(!isExpanded);
                    }}
                    className="flex-shrink-0 p-0.5 hover:bg-light-surface-hover dark:hover:bg-dark-surface-hover rounded"
                  >
                    {isExpanded ? (
                      <FolderOpen className="w-4 h-4 text-primary-500 dark:text-primary-400" />
                    ) : (
                      <Folder className="w-4 h-4 text-light-text-tertiary dark:text-dark-text-tertiary" />
                    )}
                  </button>

                  <div className="min-w-0">
                    {/* First Line: Project Name */}
                    <h3 className="text-base font-semibold text-light-text dark:text-dark-text truncate hover:opacity-80 transition-opacity">
                      {project.projectName}
                    </h3>
                    
                    {/* Second Line: Project Code and Summary */}
                    <div className="flex items-center gap-2 text-xs text-light-text-secondary dark:text-dark-text-secondary mt-0.5 min-w-0 overflow-x-auto">
                      {project.isRealProject && (
                        <>
                          <span className="text-light-text-tertiary dark:text-dark-text-tertiary whitespace-nowrap flex-shrink-0">
                            {project.projectCode}
                          </span>
                          <span className="flex-shrink-0">•</span>
                        </>
                      )}
                      <span className="whitespace-nowrap flex-shrink-0">
                        {project.campaigns.length} campaign{project.campaigns.length !== 1 ? 's' : ''}
                      </span>
                      <span className="flex-shrink-0">•</span>
                      <span className="whitespace-nowrap flex-shrink-0">
                        Target: {project.totalCalls} calls
                      </span>
                      <span className="flex-shrink-0">•</span>
                      <span className="font-medium text-light-text dark:text-dark-text whitespace-nowrap flex-shrink-0">
                        Cost: {formatCurrency(project.totalSpent)}
                      </span>
                    </div>
                  </div>
                </div>

                {/* Empty spacer columns to match campaign row structure */}
                <div className="min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.industry, projectTotalWidth), minWidth: 0 }}></div>
                <div className="min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.timeline, projectTotalWidth), minWidth: 0 }}></div>
                <div className="min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.targetRegions, projectTotalWidth), minWidth: 0 }}></div>
                <div className="min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.callsProgress, projectTotalWidth), minWidth: 0 }}></div>
                <div className="flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.status, projectTotalWidth), minWidth: 0 }}></div>
                <div className="flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.cost, projectTotalWidth), minWidth: 0 }}></div>
                <div className="flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.team, projectTotalWidth), minWidth: 0 }}></div>

                {/* Delete Button - Same position as campaign delete button */}
                {project.isRealProject && (
                  <div className="flex-shrink-0 flex justify-start ml-auto" style={{ flexBasis: getColumnPercentage(columnWidths.delete, projectTotalWidth), minWidth: 0 }}>
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        onDeleteProject(e, project.projectCode, project.projectName);
                      }}
                      className="p-1.5 text-light-text-tertiary dark:text-dark-text-tertiary hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded transition-colors opacity-0 group-hover:opacity-100"
                      title="Delete project"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                )}
              </div>
            );
          })()}
        </div>

        {/* Expanded Campaign List */}
        {isExpanded && (
          <div className="border-t border-light-border dark:border-dark-border">
            <SortableContext
              items={campaignIds}
              strategy={verticalListSortingStrategy}
            >
              <div className="p-2 space-y-2">
                {project.campaigns.map((campaign) => (
                  <DraggableCampaignCardRow
                    key={campaign.id}
                    campaign={campaign}
                    projectCode={project.projectCode}
                    onDelete={onDeleteCampaign}
                    onNavigate={onNavigateToCampaign}
                    columnWidths={columnWidths}
                  />
                ))}
              </div>
            </SortableContext>
          </div>
        )}
      </div>
    </DroppableProjectSection>
  );
}

// Helper function to convert API campaign to local Campaign format with team members
async function convertApiCampaignToCampaign(c: api.Campaign, projects?: api.Project[]): Promise<Campaign> {
  // Determine target calls from min/max
  let target = 0;
  if (typeof c.min_calls === 'number' && typeof c.max_calls === 'number') {
    target = Math.max(0, Math.round((c.min_calls + c.max_calls) / 2));
  }
  
  // Fetch interview counts by status from database
  let completedCalls = 0;
  let scheduledCalls = 0;
  let cancelledCalls = 0;
  try {
    const [completedResponse, scheduledResponse, cancelledResponse] = await Promise.all([
      api.getInterviews({ campaign_id: c.id, status: 'completed' }),
      api.getInterviews({ campaign_id: c.id, status: 'scheduled' }),
      api.getInterviews({ campaign_id: c.id, status: 'cancelled' })
    ]);
    completedCalls = completedResponse.total || 0;
    scheduledCalls = scheduledResponse.total || 0;
    cancelledCalls = cancelledResponse.total || 0;
  } catch (error) {
    // If interview counts fail to load, use interview_count as fallback
    console.warn(`Failed to load interview counts for campaign ${c.id}:`, error);
    completedCalls = c.interview_count || 0;
    scheduledCalls = 0;
  }
  
  // Fetch team members for this campaign
  let teamMembers: { id: string; name: string; designation: string; avatar: string }[] = [];
  try {
    const teamMembersResponse = await api.getCampaignTeamMembers(c.id);
    teamMembers = teamMembersResponse.map((member) => ({
      id: member.id,
      name: member.name,
      designation: member.designation,
      avatar: member.avatar_url || `/images/team-members/${member.name}.png`,
    }));
  } catch (error) {
    // If team members fail to load, just use empty array
    console.warn(`Failed to load team members for campaign ${c.id}:`, error);
  }
  
  // Map project_id to project_code for grouping
  // The API returns project_code, but if not available, look it up from project_id
  let projectCode = c.project_code || '';
  if (!projectCode && c.project_id && projects) {
    const project = projects.find(p => p.id === c.project_id);
    if (project) {
      projectCode = project.project_code || project.id;
    }
  } else if (!projectCode && c.project_id) {
    // Fallback: if projects not provided, use project_id as projectCode
    // This will be fixed when projects are loaded
    projectCode = c.project_id;
  }
  
  return {
    id: c.id,
    campaignName: c.campaign_name,
    projectCode: projectCode,
    industryVertical: c.industry_vertical,
    targetRegions: c.target_regions || [],
    startDate: c.start_date,
    targetCompletionDate: c.target_completion_date,
    minCalls: c.min_calls || 0,
    maxCalls: c.max_calls || 0,
    estimatedCalls: target,
    completedCalls,
    scheduledCalls,
    cancelledCalls,
    teamMembers,
    createdAt: c.created_at,
    updatedAt: c.updated_at,
    order: 0, // Will be set by grouping
  };
}

function HomeContent() {
  const { theme, toggleTheme } = useTheme();
  const navigate = useNavigate();
  const [campaigns, setCampaigns] = useState<Campaign[]>([]);
  const [projects, setProjects] = useState<api.Project[]>([]);
  const [activeDragId, setActiveDragId] = useState<string | null>(null);
  
  // Delete confirmation modal state
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [campaignToDelete, setCampaignToDelete] = useState<{ id: string; name: string } | null>(null);
  
  // Project delete modal state
  const [isProjectDeleteModalOpen, setIsProjectDeleteModalOpen] = useState(false);
  const [projectToDelete, setProjectToDelete] = useState<{ code: string; name: string } | null>(null);
  
  // New project modal state
  const [isNewProjectModalOpen, setIsNewProjectModalOpen] = useState(false);
  
  const containerRef = useRef<HTMLDivElement>(null);
  
  // Memoize grouped projects to ensure consistency
  const [groupedProjects, setGroupedProjects] = useState<ProjectGroup[]>([]);

  // Column widths state - load from localStorage or use defaults
  const [columnWidths, setColumnWidths] = useState<typeof DEFAULT_COLUMN_WIDTHS>(() => {
    try {
      const saved = localStorage.getItem(COLUMN_WIDTHS_KEY);
      if (saved) {
        const parsed = JSON.parse(saved);
        return { ...DEFAULT_COLUMN_WIDTHS, ...parsed };
      }
    } catch (e) {
      console.error("Failed to load column widths from localStorage", e);
    }
    return DEFAULT_COLUMN_WIDTHS;
  });

  // Save column widths to localStorage
  const saveColumnWidths = (widths: typeof DEFAULT_COLUMN_WIDTHS) => {
    try {
      localStorage.setItem(COLUMN_WIDTHS_KEY, JSON.stringify(widths));
    } catch (e) {
      console.error("Failed to save column widths to localStorage", e);
    }
  };

  // Handler to resize a column
  const resizeStateRef = useRef<{ columnKey: keyof typeof DEFAULT_COLUMN_WIDTHS | null; startWidth: number; startX: number }>({ columnKey: null, startWidth: 0, startX: 0 });

  const startColumnResize = (columnKey: keyof typeof DEFAULT_COLUMN_WIDTHS, currentWidth: number, startX: number) => {
    resizeStateRef.current = { columnKey, startWidth: currentWidth, startX };
  };

  const updateColumnResize = (currentX: number) => {
    if (!resizeStateRef.current.columnKey) return;
    
    const deltaX = currentX - resizeStateRef.current.startX;
    
    setColumnWidths((prev) => {
      const newWidths = { ...prev };
      const minWidth = 50; // Minimum column width
      const maxWidth = 600; // Maximum column width
      const newWidth = resizeStateRef.current.startWidth + deltaX;
      newWidths[resizeStateRef.current.columnKey!] = Math.max(minWidth, Math.min(maxWidth, newWidth));
      saveColumnWidths(newWidths);
      return newWidths;
    });
  };

  // Mock data seeding removed - now using API

  // Set up drag sensors
  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: {
        distance: 8, // 8px of movement required to start drag
      },
    })
  );

  // Load campaigns from API
  useEffect(() => {
    const loadCampaigns = async () => {
      try {
        const response = await api.getCampaigns();
        const apiCampaigns = response.campaigns;
        
        // Load projects first to map project_id to project_code
        const projectsList = await api.getProjects();
        
        // Convert API campaigns to local Campaign format and load team members
        const allCampaigns: Campaign[] = await Promise.all(
          apiCampaigns.map((c: api.Campaign) => convertApiCampaignToCampaign(c, projectsList))
        );
        
      // Sort by most recent first
      allCampaigns.sort((a, b) => 
        new Date(b.updatedAt || b.createdAt).getTime() - 
        new Date(a.updatedAt || a.createdAt).getTime()
      );
      
      setCampaigns(allCampaigns);
      } catch (error) {
        console.error("Error loading campaigns from API:", error);
        // Fallback to empty array on error
        setCampaigns([]);
      }
    };

    loadCampaigns();

    // Listen for campaign and project updates
    const handleCampaignSaved = () => {
      loadCampaigns();
    };
    const handleProjectSaved = () => {
      loadCampaigns(); // Reload to refresh display
    };
    
    window.addEventListener("campaignSaved", handleCampaignSaved);
    window.addEventListener("projectSaved", handleProjectSaved);
    return () => {
      window.removeEventListener("campaignSaved", handleCampaignSaved);
      window.removeEventListener("projectSaved", handleProjectSaved);
    };
  }, []);

  // Get project info from API projects
  const getProjectInfo = useCallback((projectCode: string): { projectName: string; isRealProject: boolean } => {
    if (projectCode === "Other Campaigns") {
        return {
        projectName: "Other Campaigns",
        isRealProject: false
      };
    }
    
    const project = projects.find((p: api.Project) => (p.project_code || p.id) === projectCode);
    if (project) {
      return {
        projectName: project.project_name || projectCode,
          isRealProject: true
        };
      }
    
    return {
      projectName: projectCode,
      isRealProject: false
    };
  }, [projects]);

  // Group campaigns by project (including projects without campaigns)
  const groupCampaignsByProject = useCallback((): ProjectGroup[] => {
    const projectMap = new Map<string, Campaign[]>();
    
    // Initialize project map from API projects (already sorted by display_order from API)
    projects.forEach((project: api.Project) => {
      const projectCode = project.project_code || project.id;
      if (projectCode) {
        projectMap.set(projectCode, []);
      }
    });
    
    // Separate campaigns with and without valid projects
    const campaignsWithoutProject: Campaign[] = [];

    campaigns.forEach(campaign => {
      const projectCode = campaign.projectCode || '';
      if (projectCode) {
        // Check if project exists
        if (projectMap.has(projectCode)) {
          projectMap.get(projectCode)!.push(campaign);
        } else {
          campaignsWithoutProject.push(campaign);
        }
      } else {
        campaignsWithoutProject.push(campaign);
      }
    });

    // Add "Other Campaigns" group if there are campaigns without projects
    if (campaignsWithoutProject.length > 0) {
      projectMap.set("Other Campaigns", campaignsWithoutProject);
    }

    return Array.from(projectMap.entries()).map(([projectCode, projectCampaigns]) => {
      const { projectName, isRealProject } = getProjectInfo(projectCode);
      const projectInfo = projects.find((p: api.Project) => (p.project_code || p.id) === projectCode);
      // Helper to get estimated calls (handles both old and new format)
      const getEstCallsForCalc = (c: Campaign): number => {
        if (c.minCalls !== undefined && c.maxCalls !== undefined) {
          return Math.round((c.minCalls + c.maxCalls) / 2);
        }
        return c.estimatedCalls || 0;
      };
      
      const totalCalls = projectCampaigns.reduce((sum, c) => sum + getEstCallsForCalc(c), 0);
      // Assume $1000 per call as average cost
      const avgCostPerCall = 1000;
      const totalBudget = totalCalls * avgCostPerCall;
      // Calculate project cost as sum of campaign consumption costs
      // Campaign consumption cost = completedCalls * avgCostPerCall (same as campaign card calculation)
      const totalSpent = projectCampaigns.reduce((sum, c) => {
        const targetCalls = getEstCallsForCalc(c);
        const performedCalls = Math.max(0, Math.min(c.completedCalls ?? 0, targetCalls));
        return sum + (performedCalls * avgCostPerCall);
      }, 0);

      // Sort campaigns by order field
      const sortedCampaigns = projectCampaigns.sort((a, b) => {
        const orderA = a.order !== undefined ? a.order : 999999;
        const orderB = b.order !== undefined ? b.order : 999999;
        return orderA - orderB;
      });

      return {
        projectCode,
        projectName,
        campaigns: sortedCampaigns,
        totalCalls,
        totalBudget,
        totalSpent,
        isRealProject,
        order: projectInfo?.display_order || 0
      };
    }).sort((a, b) => {
      // Sort "Other Campaigns" to the end
      if (a.projectCode === "Other Campaigns") return 1;
      if (b.projectCode === "Other Campaigns") return -1;
      
      // Sort by order field if available, otherwise by creation date
      const orderA = a.order !== undefined ? a.order : 999999;
      const orderB = b.order !== undefined ? b.order : 999999;
      
      if (orderA !== orderB) {
        return orderA - orderB;
      }
      
      // Fallback to creation date if orders are equal
      const aProject = projects.find((p: api.Project) => (p.project_code || p.id) === a.projectCode);
      const bProject = projects.find((p: api.Project) => (p.project_code || p.id) === b.projectCode);
      return new Date(bProject?.created_at || 0).getTime() - new Date(aProject?.created_at || 0).getTime();
    });
  }, [campaigns, projects, getProjectInfo]);

  // Update grouped projects and initialize widths when campaigns or projects change
  useEffect(() => {
    const grouped = groupCampaignsByProject();
    setGroupedProjects(grouped);
  }, [groupCampaignsByProject]);

  // Calculate campaign status based on dates
  // const _getCampaignStatus = (campaign: Campaign) => {
  //   const now = new Date();
  //   const start = new Date(campaign.startDate);
  //   const end = new Date(campaign.targetCompletionDate);
  //
  //   if (now < start) {
  //     return { label: "Waiting for vendors", color: "bg-blue-100 text-blue-800 dark:bg-blue-900/20 dark:text-blue-300", isActive: false };
  //   } else if (now >= start && now <= end) {
  //     return { label: "Active", color: "bg-green-100 text-green-800 dark:bg-green-900/20 dark:text-green-300", isActive: true };
  //   } else {
  //     return { label: "Completed", color: "bg-gray-100 text-gray-800 dark:bg-gray-900/20 dark:text-gray-300", isActive: false };
  //   }
  // };

  // Calculate progress percentage for active campaigns
  // const _calculateProgress = (campaign: Campaign): number => {
  //   const now = new Date();
  //   const start = new Date(campaign.startDate);
  //   const end = new Date(campaign.targetCompletionDate);
  //   
  //   const totalDuration = end.getTime() - start.getTime();
  //   const elapsed = now.getTime() - start.getTime();
  //   
  //   const progress = (elapsed / totalDuration) * 100;
  //   return Math.min(Math.max(progress, 0), 100); // Clamp between 0 and 100
  // };

  // Drag handlers
  const handleDragStart = (event: DragStartEvent) => {
    setActiveDragId(event.active.id as string);
  };

  const handleDragEnd = async (event: DragEndEvent) => {
    const { active, over } = event;
    setActiveDragId(null);

    if (!over) return;

    const activeId = active.id as string;
    const overId = over.id as string;

    // Check if we're dragging a project (by checking if it exists in groupedProjects)
    const draggedProject = groupedProjects.find(p => p.projectCode === activeId);
    
    if (draggedProject) {
      // We're dragging a project
      // Check if we're dropping over another project (not a campaign inside a project)
      let targetProjectCode = overId;
      
      // If dropping over a campaign, find its parent project
      const overCampaign = campaigns.find(c => c.id === overId);
      if (overCampaign) {
        // Dropping over a campaign - move to that campaign's project position
        targetProjectCode = overCampaign.projectCode || "Other Campaigns";
      }
      
      const overProject = groupedProjects.find(p => p.projectCode === targetProjectCode);
      
      if (overProject && activeId !== targetProjectCode) {
        const oldIndex = groupedProjects.findIndex(p => p.projectCode === activeId);
        const newIndex = groupedProjects.findIndex(p => p.projectCode === targetProjectCode);
        
        // Reorder projects
        const reorderedProjects = arrayMove(groupedProjects, oldIndex, newIndex);
        
        // Update display_order for all projects in the database
        try {
          await Promise.all(
            reorderedProjects.map(async (project, index) => {
              if (project.isRealProject) {
                // Find the project in the projects list to get its ID
                const projectInfo = projects.find((p: api.Project) => 
                  (p.project_code || p.id) === project.projectCode
                );
                
                if (projectInfo) {
                  // Update display_order via API
                  await api.updateProject(projectInfo.id, {
                    display_order: index
                  });
                }
              }
            })
          );
          
          // Reload projects to get updated order
          const updatedProjects = await api.getProjects();
          setProjects(updatedProjects);
        } catch (error) {
          console.error('Error updating project order:', error);
          alert(`Failed to save project order: ${error instanceof Error ? error.message : 'Unknown error'}`);
          // Revert to previous order on error
          setGroupedProjects(groupedProjects);
          return;
        }
        
        // Update state
        setGroupedProjects(reorderedProjects);
        
        // Dispatch event to update sidebar
        window.dispatchEvent(new CustomEvent('projectSaved'));
      }
      return;
    }

    // Otherwise, we're dragging a campaign
    const draggedCampaignId = activeId;
    const overItemId = overId;

    // Find the dragged campaign
    const draggedCampaign = campaigns.find(c => c.id === draggedCampaignId);
    if (!draggedCampaign) return;

    // Check if we're dropping over another campaign
    const overCampaign = campaigns.find(c => c.id === overItemId);
    
    if (overCampaign) {
      // Check if it's the same project (reordering) or different project (moving)
      if (draggedCampaign.projectCode === overCampaign.projectCode) {
        // Reordering within the same project
        // Get all campaigns in this project
        const projectCampaigns = campaigns.filter(c => c.projectCode === draggedCampaign.projectCode);
        
        // Sort by order or original position
        projectCampaigns.sort((a, b) => (a.order || 0) - (b.order || 0));
        
        const oldIndex = projectCampaigns.findIndex(c => c.id === draggedCampaignId);
        const newIndex = projectCampaigns.findIndex(c => c.id === overItemId);
        
        if (oldIndex !== newIndex) {
          // Reorder the campaigns
          const reorderedCampaigns = arrayMove(projectCampaigns, oldIndex, newIndex);
          
          // Update order field for all campaigns in this project
          reorderedCampaigns.forEach((campaign, index) => {
            campaign.order = index;
            campaign.updatedAt = new Date().toISOString();
            localStorage.setItem(`campaign_${campaign.id}`, JSON.stringify(campaign));
          });
          
          // Update state
          const updatedAllCampaigns = campaigns.map(c => {
            const reordered = reorderedCampaigns.find(rc => rc.id === c.id);
            return reordered || c;
          });
          
          setCampaigns(updatedAllCampaigns);
          
          // Dispatch event to update sidebar
          window.dispatchEvent(new CustomEvent('campaignSaved'));
        }
        return; // Done with reordering
      } else {
        // Dropping on a campaign in a different project - move to that project
        const targetProjectCode = overCampaign.projectCode;
        
        // Find the target project to get its project_id (UUID)
        const targetProject = projects.find(p => 
          (p.project_code || p.id) === targetProjectCode
        );
        
        if (!targetProject) {
          console.error(`Target project not found for projectCode: ${targetProjectCode}`);
          return;
        }
        
        // Update the campaign's project_id in the database
        try {
          await api.updateCampaign(draggedCampaign.id, {
            project_id: targetProject.id
          });
          
          // Update the campaign's projectCode in local state
        const updatedCampaign = {
          ...draggedCampaign,
          projectCode: targetProjectCode,
          updatedAt: new Date().toISOString()
        };

        // Update state
        setCampaigns(prev => prev.map(c => c.id === draggedCampaignId ? updatedCampaign : c));

        // Dispatch event to update sidebar
        window.dispatchEvent(new CustomEvent('campaignSaved'));
        } catch (error) {
          console.error('Failed to move campaign to different project:', error);
          alert(`Failed to move campaign: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
        return; // Done with moving
      }
    }

    // If we get here, we're dropping over a project droppable area (moving between projects)
    const targetProjectCode = overItemId;

    // If dropped on the same project (droppable area), do nothing
    if (draggedCampaign.projectCode === targetProjectCode) return;

    // Find the target project to get its project_id (UUID)
    // If "Other Campaigns", set project_id to null
    let targetProjectId: string | null = null;
    if (targetProjectCode !== "Other Campaigns") {
      const targetProject = projects.find(p => 
        (p.project_code || p.id) === targetProjectCode
      );
      
      if (!targetProject) {
        console.error(`Target project not found for projectCode: ${targetProjectCode}`);
        return;
      }
      
      targetProjectId = targetProject.id;
    }

    // Update the campaign's project_id in the database
    try {
      await api.updateCampaign(draggedCampaign.id, {
        project_id: targetProjectId
      });
      
      // Update the campaign's projectCode in local state
    const updatedCampaign = {
      ...draggedCampaign,
      projectCode: targetProjectCode === "Other Campaigns" ? "" : targetProjectCode,
      updatedAt: new Date().toISOString()
    };

    // Update state
    setCampaigns(prev => prev.map(c => c.id === draggedCampaignId ? updatedCampaign : c));

    // Dispatch event to update sidebar
    window.dispatchEvent(new CustomEvent('campaignSaved'));
    } catch (error) {
      console.error('Failed to move campaign to different project:', error);
      alert(`Failed to move campaign: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  };

  // Delete campaign
  const handleDeleteCampaign = (e: React.MouseEvent, campaignId: string) => {
    e.stopPropagation(); // Prevent navigation when clicking delete
    
    const campaign = campaigns.find(c => c.id === campaignId);
    if (campaign) {
      setCampaignToDelete({ id: campaignId, name: campaign.campaignName });
      setIsDeleteModalOpen(true);
    }
  };

  const confirmDeleteCampaign = async () => {
    if (campaignToDelete) {
      try {
        await api.deleteCampaign(campaignToDelete.id);
        
        // Reload campaigns from API
        const [campaignsResponse, projectsList] = await Promise.all([
          api.getCampaigns(),
          api.getProjects()
        ]);
        const apiCampaigns = await Promise.all(
          campaignsResponse.campaigns.map((c: api.Campaign) => convertApiCampaignToCampaign(c, projectsList))
        );
        setCampaigns(apiCampaigns);
      
      // Dispatch event to update sidebar
      window.dispatchEvent(new CustomEvent('campaignSaved'));
      
      // Close modal and reset state
      setIsDeleteModalOpen(false);
      setCampaignToDelete(null);
      } catch (error) {
        console.error("Error deleting campaign:", error);
        alert("Failed to delete campaign. Please try again.");
      }
    }
  };

  const cancelDeleteCampaign = () => {
    setIsDeleteModalOpen(false);
    setCampaignToDelete(null);
  };

  // Project deletion handlers
  const handleDeleteProject = (e: React.MouseEvent, projectCode: string, projectName: string) => {
    e.preventDefault();
    e.stopPropagation();
    
    setProjectToDelete({ code: projectCode, name: projectName });
    setIsProjectDeleteModalOpen(true);
  };

  const confirmDeleteProject = async () => {
    if (projectToDelete) {
      try {
        // Find the project by code to get its ID
        const project = projects.find((p: api.Project) => (p.project_code || p.id) === projectToDelete.code);
        if (project) {
          await api.deleteProject(project.id);
          
          // Reload projects and campaigns from API
          const [apiProjects, campaignsResponse] = await Promise.all([
            api.getProjects(),
            api.getCampaigns()
          ]);
          setProjects(apiProjects);
          
          // Convert API campaigns to local format with team members
          const apiCampaigns = await Promise.all(
            campaignsResponse.campaigns.map((c: api.Campaign) => convertApiCampaignToCampaign(c, apiProjects))
          );
          setCampaigns(apiCampaigns);
      
      // Dispatch events to update sidebar and refresh
      window.dispatchEvent(new CustomEvent('projectSaved'));
      window.dispatchEvent(new CustomEvent('campaignSaved'));
        }
      
      // Close modal and reset state
      setIsProjectDeleteModalOpen(false);
      setProjectToDelete(null);
      } catch (error) {
        console.error("Error deleting project:", error);
        alert("Failed to delete project. Please try again.");
      }
    }
  };

  const cancelDeleteProject = () => {
    setIsProjectDeleteModalOpen(false);
    setProjectToDelete(null);
  };

  // Handle new project creation
  const handleNewProject = async (projectData: { projectName: string; projectCode: string }) => {
    try {
      await api.createProject({
        project_name: projectData.projectName,
        project_code: projectData.projectCode,
      });
      
      // Reload projects from API
      const apiProjects = await api.getProjects();
      setProjects(apiProjects);
    
    // Dispatch event to update sidebar and dashboard
    window.dispatchEvent(new CustomEvent('projectSaved'));
    
    // Close modal
    setIsNewProjectModalOpen(false);
    } catch (error) {
      console.error("Error creating project:", error);
      alert("Failed to create project. Please try again.");
    }
  };

  // Load projects from API
  useEffect(() => {
    const loadProjects = async () => {
      try {
        const apiProjects = await api.getProjects();
        setProjects(apiProjects);
      } catch (error) {
        console.error("Error loading projects from API:", error);
        setProjects([]);
      }
    };
    loadProjects();
    
    // Listen for project updates
    const handleProjectSaved = () => {
      loadProjects();
    };
    
    window.addEventListener("projectSaved", handleProjectSaved);
    return () => {
      window.removeEventListener("projectSaved", handleProjectSaved);
    };
  }, []);


  // Format currency
  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(amount);
  };

  return (
    <main className="h-screen w-[100vw] flex flex-col bg-light-background dark:bg-dark-background overflow-x-hidden">
      {/* Windshift Ribbon */}
      <header className="w-full sticky top-0 z-50 shrink-0 bg-light-surface dark:bg-dark-surface border-b border-light-border dark:border-dark-border">
        <div className="w-full px-4 py-3 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Logo />
          </div>
          <div className="flex items-center gap-4">
            <button
              type="button"
              onClick={toggleTheme}
              aria-label="Toggle theme"
              className="btn-secondary h-9 w-9 p-0 flex items-center justify-center"
              title={theme === "dark" ? "Switch to light mode" : "Switch to dark mode"}
            >
              {theme === "dark" ? <Sun className="h-5 w-5" /> : <Moon className="h-5 w-5" />}
            </button>
            <UserMenu />
          </div>
        </div>
      </header>

      {/* Main Content */}
      <div className="flex-1 overflow-hidden max-w-full">
        <div className="w-[100vw-48px] h-full px-2 pb-2 ml-[48px] overflow-y-auto overflow-x-hidden">

          {/* New Campaign Button*/}
          <div className="my-3">
            <div className="flex gap-2">
              <button
                className="btn-primary flex items-center gap-2 py-1 w-[170px]"
                onClick={() => setIsNewProjectModalOpen(true)}
              >
                <Plus className="w-4 h-4" />
                New Project
              </button>

              <button
                onClick={() => navigate("/campaign/new")}
                className="btn-primary flex items-center gap-2 py-1 w-[170px]"
              >
                <Plus className="w-4 h-4" />
                New Campaign
              </button>
            </div>
          </div>

          {/* Column Header (Frozen) */}
          {campaigns.length > 0 && (() => {
            const headerTotalWidth = calculateTotalWidth(columnWidths);
            return (
              <div className="sticky top-0 z-10 bg-light-background dark:bg-dark-background border-b-2 border-light-border dark:border-dark-border mb-2">
                <div className="flex items-center gap-3 w-[calc(100%-2.5vw)] ml-[2.5vw] py-2 px-1">
                  {/* Drag Handle Column */}
                  <div className="flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.dragHandle, headerTotalWidth), minWidth: 0 }}></div>

                  {/* Campaign Name */}
                  <div className="relative min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.campaignName, headerTotalWidth), minWidth: 0 }}>
                    <span className="text-xs font-semibold text-light-text-secondary dark:text-dark-text-secondary uppercase tracking-wide">
                    </span>
                    <ColumnResizer 
                      onResizeStart={(startX) => startColumnResize("campaignName", columnWidths.campaignName, startX)} 
                      onResize={updateColumnResize} 
                    />
                  </div>

                  {/* Industry */}
                  <div className="relative min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.industry, headerTotalWidth), minWidth: 0 }}>
                    <span className="text-xs font-semibold text-light-text-secondary dark:text-dark-text-secondary uppercase tracking-wide">
                      Industry
                    </span>
                    <ColumnResizer 
                      onResizeStart={(startX) => startColumnResize("industry", columnWidths.industry, startX)} 
                      onResize={updateColumnResize} 
                    />
                  </div>

                  {/* Timeline */}
                  <div className="relative min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.timeline, headerTotalWidth), minWidth: 0 }}>
                    <span className="text-xs font-semibold text-light-text-secondary dark:text-dark-text-secondary uppercase tracking-wide">
                      Timeline
                    </span>
                    <ColumnResizer 
                      onResizeStart={(startX) => startColumnResize("timeline", columnWidths.timeline, startX)} 
                      onResize={updateColumnResize} 
                    />
                  </div>

                  {/* Target Regions */}
                  <div className="relative min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.targetRegions, headerTotalWidth), minWidth: 0 }}>
                    <span className="text-xs font-semibold text-light-text-secondary dark:text-dark-text-secondary uppercase tracking-wide">
                      Target Regions
                    </span>
                    <ColumnResizer 
                      onResizeStart={(startX) => startColumnResize("targetRegions", columnWidths.targetRegions, startX)} 
                      onResize={updateColumnResize} 
                    />
                  </div>

                  {/* Calls Progress */}
                  <div className="relative min-w-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ marginLeft: '-7px', flexBasis: getColumnPercentage(columnWidths.callsProgress, headerTotalWidth), minWidth: 0 }}>
                    <span className="text-xs font-semibold text-light-text-secondary dark:text-dark-text-secondary uppercase tracking-wide">
                      Calls Progress
                    </span>
                    <ColumnResizer 
                      onResizeStart={(startX) => startColumnResize("callsProgress", columnWidths.callsProgress, startX)} 
                      onResize={updateColumnResize} 
                    />
                  </div>

                  {/* Status */}
                  <div className="relative flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.status, headerTotalWidth), minWidth: 0 }}>
                    <span className="text-xs font-semibold text-light-text-secondary dark:text-dark-text-secondary uppercase tracking-wide">
                      Status
                    </span>
                    <ColumnResizer 
                      onResizeStart={(startX) => startColumnResize("status", columnWidths.status, startX)} 
                      onResize={updateColumnResize} 
                    />
                  </div>

                  {/* Cost */}
                  <div className="relative flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.cost, headerTotalWidth), minWidth: 0 }}>
                    <span className="text-xs font-semibold text-light-text-secondary dark:text-dark-text-secondary uppercase tracking-wide">
                      Cost
                    </span>
                    <ColumnResizer 
                      onResizeStart={(startX) => startColumnResize("cost", columnWidths.cost, startX)} 
                      onResize={updateColumnResize} 
                    />
                  </div>

                  {/* Team */}
                  <div className="relative flex-shrink-0 border-r border-light-border/40 dark:border-dark-border/40 pr-1.5" style={{ flexBasis: getColumnPercentage(columnWidths.team, headerTotalWidth), minWidth: 0 }}>
                    <span className="text-xs font-semibold text-light-text-secondary dark:text-dark-text-secondary uppercase tracking-wide">
                      Team
                    </span>
                    <ColumnResizer 
                      onResizeStart={(startX) => startColumnResize("team", columnWidths.team, startX)} 
                      onResize={updateColumnResize} 
                    />
                  </div>

                  {/* Delete Column */}
                  <div className="flex-shrink-0" style={{ flexBasis: getColumnPercentage(columnWidths.delete, headerTotalWidth), minWidth: 0 }}></div>
                </div>
              </div>
            );
          })()}

          {/* Projects and Campaigns List */}
          {campaigns.length === 0 ? (
            <div className="bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border rounded-lg p-12 text-center">
              <FolderOpen className="w-16 h-16 mx-auto mb-4 text-light-text-tertiary dark:text-dark-text-tertiary" />
              <h3 className="text-lg font-semibold text-light-text dark:text-dark-text mb-2">
                No campaigns yet
              </h3>
              <p className="text-light-text-secondary dark:text-dark-text-secondary mb-6">
                Get started by creating your first campaign
              </p>
              <button
                onClick={() => navigate("/campaign/new")}
                className="btn-primary flex items-center gap-2 mx-auto"
              >
                <Plus className="w-4 h-4" />
                Create Campaign
              </button>
            </div>
          ) : (
            <DndContext
              sensors={sensors}
              collisionDetection={closestCenter}
              onDragStart={handleDragStart}
              onDragEnd={handleDragEnd}
            >
              <SortableContext
                items={groupedProjects.map(p => p.projectCode)}
                strategy={verticalListSortingStrategy}
              >
                <div className="flex flex-col gap-4 overflow-y-auto" ref={containerRef}>
                {groupedProjects.map((project) => {
                    const costPercentage = project.totalBudget > 0 
                      ? Math.min(Math.round((project.totalSpent / project.totalBudget) * 100), 100)
                      : 0;
                    const campaignIds = project.campaigns.map(c => c.id);
                    
                    return (
                      <ProjectCard
                        key={project.projectCode}
                        project={project}
                        costPercentage={costPercentage}
                        campaignIds={campaignIds}
                        onDeleteProject={handleDeleteProject}
                        onDeleteCampaign={handleDeleteCampaign}
                        onNavigateToCampaign={(id) => navigate(`/campaign/${id}/settings`)}
                        formatCurrency={formatCurrency}
                        columnWidths={columnWidths}
                      />
                    );
                  })}
                </div>
              </SortableContext>
              <DragOverlay>
                {activeDragId ? (
                  (() => {
                    const draggedCampaign = campaigns.find(c => c.id === activeDragId);
                    const draggedProject = groupedProjects.find(p => p.projectCode === activeDragId);
                    
                    if (draggedProject) {
                      return (
                        <div className="bg-light-surface dark:bg-dark-surface border-2 border-primary-500 rounded-lg p-4 shadow-xl opacity-90">
                          <div className="font-medium text-light-text dark:text-dark-text">
                            {draggedProject.projectName}
                          </div>
                        </div>
                      );
                    }
                    
                    if (draggedCampaign) {
                      return (
                        <div className="bg-light-surface dark:bg-dark-surface border-2 border-primary-500 rounded-lg p-2 shadow-xl opacity-90">
                          <div className="font-medium text-light-text dark:text-dark-text">
                            {draggedCampaign.campaignName}
                          </div>
                        </div>
                      );
                    }
                    
                    return null;
                  })()
                ) : null}
              </DragOverlay>
            </DndContext>
          )}
        </div>
      </div>

      {/* Delete Confirmation Modals */}
      <DeleteConfirmationModal
        isOpen={isDeleteModalOpen}
        itemName={campaignToDelete?.name || ""}
        itemType="Campaign"
        onConfirm={confirmDeleteCampaign}
        onCancel={cancelDeleteCampaign}
      />
      
      <DeleteConfirmationModal
        isOpen={isProjectDeleteModalOpen}
        itemName={projectToDelete?.name || ""}
        itemType="Project"
        onConfirm={confirmDeleteProject}
        onCancel={cancelDeleteProject}
      />
      
      {/* New Project Modal */}
      <NewProjectModal 
        isOpen={isNewProjectModalOpen}
        onClose={() => setIsNewProjectModalOpen(false)}
        onSave={handleNewProject}
      />
    </main>
  );
}

export default function HomePage() {
  return (
    <Suspense
      fallback={
        <div className="h-screen flex items-center justify-center bg-light-background dark:bg-dark-background">
          <div className="text-body text-light-text-secondary dark:text-dark-text-secondary">
            Loading...
          </div>
        </div>
      }
    >
      <div className="flex min-h-screen">
        <AppSidebar />
        <SidebarInset className="flex-1">
          <div className="h-full">
            <HomeContent />
          </div>
        </SidebarInset>
      </div>
    </Suspense>
  );
}
