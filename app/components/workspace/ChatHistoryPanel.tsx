"use client";

import React, { useState, useCallback } from "react";
import { useApi } from "../../hooks/use-api";
import { LoadingSpinner } from "../ui/loading-spinner";
import { ErrorMessage } from "../ui/error-message";
import { EmptyState } from "../ui/empty-state";
import { MessageCircle } from "lucide-react";

export interface ChatMessage {
  id: string;
  role: "user" | "assistant";
  content: string;
  created_at?: string;
}

export interface DeepResearchChatPanelProps {
  interviewId?: string;
  messages?: ChatMessage[];
  onSendMessage?: (message: string) => void;
}

export default function DeepResearchChatPanel({
  interviewId,
  messages: propMessages,
  onSendMessage,
}: DeepResearchChatPanelProps) {
  const [inputValue, setInputValue] = useState("");

  // Load messages from API if interviewId is provided
  // Note: Chat API endpoint not yet implemented in backend
  // For now, use prop messages or empty array
  const loadMessages = useCallback(async (): Promise<ChatMessage[]> => {
    if (!interviewId) {
      return propMessages || [];
    }
    
    // TODO: Implement when chat API is available
    // const response = await api.getInterviewMessages(interviewId);
    // return response.messages;
    
    return propMessages || [];
  }, [interviewId, propMessages]);

  const { data, loading, error } = useApi(loadMessages, {
    enabled: false, // Disabled until API is implemented
  });

  const messages = data || propMessages || [];

  const handleSend = () => {
    if (inputValue.trim()) {
      if (onSendMessage) {
        onSendMessage(inputValue);
      }
      // TODO: Send message to API when available
      // await api.sendInterviewMessage(interviewId, inputValue);
      setInputValue("");
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  return (
    <div className="card h-full w-full flex flex-col overflow-hidden pb-0 px-3 pt-3">
      <div className="flex items-center justify-between mb-3">
        <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
          Chat - Interview Transcript
        </h3>
        <div className="flex items-center gap-2">
          <button className="w-20 px-3 py-1 bg-primary-500 hover:bg-primary-600 text-white text-sm font-medium rounded-md transition-colors h-6 flex items-center justify-center">
            Settings
          </button>
          <button className="w-20 px-3 py-1 bg-primary-500 hover:bg-primary-600 text-white text-sm font-medium rounded-md transition-colors h-6 flex items-center justify-center">
            Refresh
          </button>
        </div>
      </div>

      {/* Loading state */}
      {loading && (
        <div className="flex-1 flex items-center justify-center">
          <LoadingSpinner size="md" text="Loading messages..." />
        </div>
      )}

      {/* Error state */}
      {error && !loading && (
        <div className="flex-1 p-4">
          <ErrorMessage error={error} variant="compact" />
        </div>
      )}

      {/* Empty state */}
      {!loading && !error && messages.length === 0 && (
        <div className="flex-1">
          <EmptyState
            icon={<MessageCircle className="w-12 h-12" />}
            title="No messages yet"
            description="Start a conversation by sending a message."
          />
        </div>
      )}

      {/* Messages + overlay composer */}
      {!loading && !error && messages.length > 0 && (
        <div className="relative flex-1 min-h-0">
          <div className="h-full overflow-auto space-y-2 pr-1 pb-20">
            {messages.map((m) => (
            <div
              key={m.id}
              className={
                m.role === "user" ? "flex justify-end" : "flex justify-start"
              }
            >
              <div
                className={
                  (m.role === "user"
                    ? "bg-primary-500 text-white rounded-2xl rounded-bl-sm"
                    : "rounded-2xl rounded-br-sm bg-light-background-secondary border border-light-border text-light-text dark:bg-dark-background-secondary dark:border-dark-border dark:text-dark-text shadow-card dark:shadow-card-dark") +
                  " px-3 py-2 max-w-[80%]"
                }
              >
                {m.role === "assistant" ? (
                  <div className="whitespace-pre-wrap text-sm leading-6">
                    {m.content}
                  </div>
                ) : (
                  <p className="whitespace-pre-wrap text-sm leading-6">
                    {m.content}
                  </p>
                )}
              </div>
            </div>
            ))}
          </div>

          {/* Overlay Composer */}
        <div className="absolute left-2 right-6 bottom-2 z-40">
          <div className="pointer-events-auto relative">
            <input
              className="w-full h-10 rounded-full border border-light-border dark:border-dark-border bg-light-surface dark:bg-dark-surface pl-4 pr-36 text-body focus:outline-none ring-1 ring-primary-500/20 dark:ring-primary-500/65 focus:ring-2 focus:ring-primary-500 shadow-md hover:shadow-lg focus:shadow-lg transition-shadow truncate dark:shadow-[0_0_0_2px_rgba(59,130,246,0.35),inset_0_0_14px_rgba(59,130,246,0.20)] dark:hover:shadow-[0_0_0_2px_rgba(59,130,246,0.35),inset_0_0_16px_rgba(59,130,246,0.25)]"
              placeholder="Enter a query…"
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              onKeyPress={handleKeyPress}
            />
            <button
              onClick={handleSend}
              className="absolute right-[1px] top-1/2 -translate-y-1/2 btn-primary h-[38px] px-5 rounded-full min-w-[132px]"
            >
              Send
            </button>
          </div>
        </div>
        </div>
      )}
    </div>
  );
}
