"use client";

import React, { useState, useMemo, useCallback } from "react";
import { 
  timeSlots, 
  daysOfWeek, 
  generateWeekDays, 
  navigateWeek,
  format, 
  startOfWeek,
  isSameDay, 
  isToday,
  parseISO,
  startOfDay,
  isBefore,
  getTimeSlotPosition
} from "../../utils/dateUtils";
import { COLOR_TAGS, COLOR_DOTS, type ColorTag } from "../../utils/constants";
import { formatTime } from "../../utils/formatting";
import { Interview } from "../../types";
import { useCampaign } from "../../lib/campaign-context";
import { useApi } from "../../hooks/use-api";
import * as api from "../../lib/api-client";
import { LoadingSpinner } from "../ui/loading-spinner";
import { ErrorMessage } from "../ui/error-message";
import { EmptyState } from "../ui/empty-state";
import { Calendar } from "lucide-react";

// Helper function to convert API interview to frontend format
function convertApiInterviewToInterview(apiInterview: api.Interview): Interview {
  const scheduledDate = new Date(apiInterview.scheduled_date);
  const endDate = new Date(scheduledDate.getTime() + apiInterview.duration_minutes * 60000);
  
  // Determine color tag based on status
  let colorTag: ColorTag = 'blue';
  if (apiInterview.status === 'completed') {
    colorTag = 'green';
  } else if (apiInterview.status === 'cancelled') {
    colorTag = 'red';
  } else if (apiInterview.status === 'no_show') {
    colorTag = 'orange';
  }
  
  // Map API status to Interview status
  let interviewStatus: "confirmed" | "pending" | "cancelled" | "completed" = "pending";
  if (apiInterview.status === 'scheduled') {
    interviewStatus = 'confirmed';
  } else if (apiInterview.status === 'completed') {
    interviewStatus = 'completed';
  } else if (apiInterview.status === 'cancelled') {
    interviewStatus = 'cancelled';
  }
  
  return {
    id: apiInterview.id,
    expertName: apiInterview.expert_name,
    time: formatTime(scheduledDate),
    date: scheduledDate,
    status: interviewStatus,
    duration: apiInterview.duration_minutes,
    endTime: formatTime(endDate),
    colorTag: colorTag,
    teamMembers: apiInterview.interviewer_name ? [apiInterview.interviewer_name] : [],
  };
}

export default function InterviewCalendarPanel() {
  const { campaignData } = useCampaign();
  const [currentWeek, setCurrentWeek] = useState(new Date());

  // Load interviews using custom hook
  const loadInterviews = useCallback(async () => {
    if (!campaignData?.id) {
      return { interviews: [], total: 0 };
    }

    // Load all interviews for the campaign (no status filter)
    // This ensures we see all interviews regardless of status
    const response = await api.getInterviews({ 
      campaign_id: campaignData.id
      // No status filter - get all interviews
    });
    
    return {
      interviews: response.interviews.map(convertApiInterviewToInterview),
      total: response.total
    };
  }, [campaignData?.id]);

  const { data, loading, error, refetch } = useApi(loadInterviews, {
    enabled: !!campaignData?.id,
  });

  const interviews = data?.interviews || [];

  const weekStart = useMemo(() => startOfWeek(currentWeek, { weekStartsOn: 0 }), [currentWeek]);
  const weekDays = useMemo(() => generateWeekDays(currentWeek), [currentWeek]);

  const handleNavigateWeek = useCallback((direction: "prev" | "next") => {
    setCurrentWeek(navigateWeek(currentWeek, direction));
  }, [currentWeek]);

  const getInterviewsForDay = useCallback((date: Date): Interview[] => {
    return interviews.filter(interview => isSameDay(interview.date, date));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [interviews]);

  const isPastDay = useCallback((date: Date): boolean => {
    const today = startOfDay(new Date());
    const checkDate = startOfDay(date);
    return isBefore(checkDate, today);
  }, []);

  const getColorTagClass = useCallback((color?: string): string => {
    if (!color || !(color in COLOR_TAGS)) {
      return COLOR_TAGS.gray;
    }
    return COLOR_TAGS[color as ColorTag];
  }, []);

  // const getExpertColorDot = useCallback((color: string): string => {
  //   if (!(color in COLOR_DOTS)) {
  //     return COLOR_DOTS.gray;
  //   }
  //   return COLOR_DOTS[color as ColorTag];
  // }, []);

  // Loading state
  if (loading) {
    return (
      <div className="h-full w-full flex items-center justify-center">
        <LoadingSpinner size="lg" text="Loading interviews..." />
      </div>
    );
  }

  // Error state
  if (error) {
    return (
      <div className="h-full w-full p-4">
        <ErrorMessage error={error} onDismiss={() => refetch()} />
      </div>
    );
  }

  // Empty state
  if (interviews.length === 0) {
    return (
      <div className="h-full w-full">
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
            Interview Calendar
          </h3>
        </div>
        <EmptyState
          icon={<Calendar className="w-12 h-12" />}
          title="No interviews scheduled"
          description="Interviews will appear here once they are scheduled for this campaign."
        />
      </div>
    );
  }

  return (
    <div className="h-full w-full flex flex-col overflow-hidden">
      <div className="flex items-center justify-between mb-3">
        <div>
          <h3 className="text-title font-semibold text-light-text dark:text-dark-text mb-2">
            Interview Calendar
          </h3>
        </div>
        <div className="flex items-center gap-2">
          <button 
            onClick={() => handleNavigateWeek("prev")}
            className="px-2 py-1 text-sm border border-light-border dark:border-dark-border rounded hover:bg-light-hover dark:hover:bg-dark-hover"
          >
            ←
          </button>
          <select 
            value={format(currentWeek, "yyyy-MM-dd")}
            onChange={(e) => setCurrentWeek(parseISO(e.target.value))}
            className="px-2 py-1 text-sm border border-light-border dark:border-dark-border rounded bg-light-surface dark:bg-dark-surface"
          >
            <option value={format(currentWeek, "yyyy-MM-dd")}>
              Week of {format(weekStart, "MMM d")}
            </option>
          </select>
          <button 
            onClick={() => handleNavigateWeek("next")}
            className="px-2 py-1 text-sm border border-light-border dark:border-dark-border rounded hover:bg-light-hover dark:hover:bg-dark-hover"
          >
            →
          </button>
        </div>
      </div>

      <div className="flex-1 overflow-auto">
        <div className="grid grid-cols-8 gap-0 border border-light-border dark:border-dark-border rounded-lg">
          {/* Time column header */}
          <div className="sticky top-0 p-2 text-body-md font-medium text-light-text-secondary dark:text-dark-text-secondary border-r border-light-border dark:border-dark-border bg-light-surface dark:bg-dark-surface z-20">
            <div className="text-xs text-light-text-secondary dark:text-dark-text-secondary mb-1">
              GMT - 05
            </div>
          </div>
          
          {/* Day headers */}
          {weekDays.slice(0, 7).map((day, index) => {
            const isPast = isPastDay(day);
            const isCurrentDay = isToday(day);
            
            return (
              <div 
                key={index} 
                className={`sticky top-0 p-2 text-center border-r border-light-border dark:border-dark-border last:border-r-0 z-20 ${
                  isCurrentDay ? 'bg-blue-50 dark:bg-blue-950' : 'bg-light-surface dark:bg-dark-surface'
                } ${isPast ? 'opacity-50' : ''}`}
              >
                <div className={`text-sm font-medium ${isPast ? 'text-gray-400 dark:text-gray-600' : 'text-light-text dark:text-dark-text'}`}>
                  {daysOfWeek[index]}
                </div>
                <div className={`text-lg font-bold ${
                  isCurrentDay 
                    ? 'text-blue-600 dark:text-blue-400 bg-blue-100 dark:bg-blue-900 rounded-full w-8 h-8 flex items-center justify-center mx-auto' 
                    : isPast
                    ? 'text-gray-400 dark:text-gray-600'
                    : 'text-light-text-secondary dark:text-dark-text-secondary'
                }`}>
                  {format(day, "d")}
                </div>
              </div>
            );
          })}

          {/* Time slots and calendar grid */}
          {timeSlots.map((timeSlot, timeIndex) => (
            <React.Fragment key={timeIndex}>
              {/* Time label */}
              <div className="p-2 text-sm text-light-text-secondary dark:text-dark-text-secondary border-r border-t border-light-border dark:border-dark-border">
                {timeSlot}
              </div>
              
              {/* Day columns */}
              {weekDays.slice(0, 7).map((day, dayIndex) => {
                const dayInterviews = getInterviewsForDay(day);
                const slotInterviews = dayInterviews.filter(interview => 
                  getTimeSlotPosition(interview.time) === timeIndex
                );
                const isPast = isPastDay(day);
                const isCurrentDay = isToday(day);
                
                // Check if this time slot is occupied by the single interview
                // const _isOccupied = dayInterviews.some(interview => {
                //   const startIndex = getTimeSlotPosition(interview.time);
                //   const durationSlots = interview.duration / 60;
                //   const occupiedSlots = Array.from({ length: durationSlots }, (_, i) => startIndex + i);
                //   return occupiedSlots.includes(timeIndex);
                // });
                
                return (
                  <div
                    key={dayIndex}
                    className={`relative h-[60px] border-r border-t border-light-border dark:border-dark-border last:border-r-0 ${
                      isCurrentDay ? 'bg-blue-50 dark:bg-blue-950' : ''
                    } ${isPast ? 'bg-gray-100 dark:bg-gray-900 opacity-40' : ''}`}
                  >
                    {slotInterviews.map((interview) => {
                      const slotHeight = (interview.duration / 60) * 60;
                      
                      return (
                        <div
                          key={interview.id}
                          className={`absolute text-xs border-2 ${getColorTagClass(interview.colorTag)} group rounded`}
                          style={{
                            width: '100%',
                            height: `${slotHeight}px`,
                            zIndex: 10
                          }}
                        >
                          <div className="p-2 h-full flex flex-col">
                            <div className="break-words">
                              <div className="font-semibold">{interview.expertName}</div>
                              <div className="text-xs mt-1">
                                {interview.time} - {interview.endTime}
                              </div>
                            </div>
                            
                            {/* Tooltip for team members */}
                            {interview.teamMembers && interview.teamMembers.length > 0 && (
                              <div className="absolute left-full ml-2 top-0 bg-gray-900 dark:bg-gray-700 text-white text-xs rounded-md px-3 py-2 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap z-50 shadow-lg">
                                <div className="font-semibold mb-1">Team Members:</div>
                                {interview.teamMembers.map((member, idx) => (
                                  <div key={idx}>• {member}</div>
                                ))}
                                <div className="absolute right-full top-2 -mr-1 border-4 border-transparent border-r-gray-900 dark:border-r-gray-700"></div>
                              </div>
                            )}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                );
              })}
            </React.Fragment>
          ))}
        </div>
      </div>
    </div>
  );
}