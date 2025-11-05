"use client";

import React, { useState, useEffect, useCallback } from "react";
import { Plus, Edit2, Trash2, Circle, Dot } from "lucide-react";
import { useCampaign } from "../../lib/campaign-context";
import * as api from "../../lib/api-client";

export interface ScreeningQuestion {
  id: string;
  text: string;
  subQuestions?: ScreeningQuestion[];
}

export interface ScreeningQuestionsPanelProps {
  questions?: ScreeningQuestion[];
  onAddQuestion?: (question: ScreeningQuestion) => void;
  onDataChange?: (data: ScreeningQuestion[]) => void;
}

export default function ScreeningQuestionsPanel({
  questions = [],
  onAddQuestion,
  onDataChange,
}: ScreeningQuestionsPanelProps) {
  const { campaignData, isNewCampaign } = useCampaign();
  const [currentQuestions, setCurrentQuestions] = useState<ScreeningQuestion[]>(questions);
  const [newQuestionText, setNewQuestionText] = useState("");
  const [editingQuestionId, setEditingQuestionId] = useState<string | null>(null);
  const [editingText, setEditingText] = useState("");
  const [hoveredQuestionId, setHoveredQuestionId] = useState<string | null>(null);
  const [addingSubQuestionTo, setAddingSubQuestionTo] = useState<string | null>(null);
  const [newSubQuestionText, setNewSubQuestionText] = useState("");
  const [loading, setLoading] = useState(false);

  // Convert backend format to frontend format (recursive, memoized to avoid dependency issues)
  const convertBackendToFrontend = useCallback((backendQuestions: api.ScreeningQuestion[]): ScreeningQuestion[] => {
    return backendQuestions.map(q => ({
      id: q.id,
      text: q.question_text,
      subQuestions: q.sub_questions ? convertBackendToFrontend(q.sub_questions) : undefined
    }));
  }, []);


  // Reset to empty for new campaigns and sync with campaignData
  useEffect(() => {
    if (isNewCampaign) {
      // For new campaigns, use the screeningQuestions from campaignData (should be empty array)
      const questions = campaignData?.screeningQuestions && Array.isArray(campaignData.screeningQuestions) 
        ? (campaignData.screeningQuestions as ScreeningQuestion[]) 
        : [];
      setCurrentQuestions(questions);
    }
  }, [isNewCampaign, campaignData?.screeningQuestions]);

  // Load screening questions from database when campaign is available
  useEffect(() => {
    const loadQuestions = async () => {
      if (!isNewCampaign && campaignData?.id && !editingQuestionId) {
        try {
          setLoading(true);
          const backendQuestions = await api.getScreeningQuestions(campaignData.id);
          const frontendQuestions = convertBackendToFrontend(backendQuestions);
          setCurrentQuestions(frontendQuestions);
          onDataChange?.(frontendQuestions);
        } catch (error) {
          console.error('Failed to load screening questions:', error);
          // If no questions exist yet, start with empty array
          setCurrentQuestions([]);
        } finally {
          setLoading(false);
        }
      }
    };
    
    loadQuestions();
  }, [campaignData?.id, isNewCampaign, editingQuestionId, convertBackendToFrontend, onDataChange]);

  // Save questions to database - simplified version that replaces all questions
  const saveQuestionsToDatabase = async (questionsToSave: ScreeningQuestion[]) => {
    if (isNewCampaign || !campaignData?.id) {
      // For new campaigns, questions will be saved after campaign is created
      return;
    }

    try {
      setLoading(true);
      
      // Get current questions from database
      let existingQuestions: api.ScreeningQuestion[] = [];
      try {
        existingQuestions = await api.getScreeningQuestions(campaignData.id);
      } catch (error: unknown) {
        // If campaign doesn't have questions yet, that's fine - start with empty array
        const errorMessage = error instanceof Error ? error.message : String(error);
        if (errorMessage?.includes('404') || errorMessage?.includes('not found')) {
          existingQuestions = [];
        } else {
          throw error;
        }
      }
      
      // Delete all existing questions (sub-questions will be deleted via CASCADE)
      for (const existing of existingQuestions) {
        if (!existing.parent_question_id) {
          // Only delete root questions, sub-questions will cascade
          try {
            await api.deleteScreeningQuestion(campaignData.id, existing.id);
          } catch (error) {
            console.error(`Failed to delete question ${existing.id}:`, error);
            // Continue with other deletions
          }
        }
      }
      
      // Create new questions from frontend format
      const questionIdMap = new Map<string, string>(); // Map from frontend ID to backend ID
      
      // Create root questions first
      for (let i = 0; i < questionsToSave.length; i++) {
        const q = questionsToSave[i];
        if (!q.text || !q.text.trim()) {
          console.warn(`Skipping question ${i} - empty text`);
          continue;
        }
        try {
          const created = await api.createScreeningQuestion(campaignData.id, {
            campaign_id: campaignData.id, // Required by backend model
            question_text: q.text.trim(),
            parent_question_id: null,
            display_order: i
          });
          questionIdMap.set(q.id, created.id);
        } catch (error: unknown) {
          const errorMessage = error instanceof Error ? error.message : String(error);
          console.error(`Failed to create question "${q.text}":`, error);
          throw new Error(`Failed to create question: ${errorMessage}`);
        }
      }
      
      // Create sub-questions
      for (const q of questionsToSave) {
        if (q.subQuestions && q.subQuestions.length > 0) {
          const parentBackendId = questionIdMap.get(q.id);
          if (!parentBackendId) {
            console.warn(`Skipping sub-questions for question "${q.text}" - parent ID not found`);
            continue;
          }
          
          for (let i = 0; i < q.subQuestions.length; i++) {
            const sq = q.subQuestions[i];
            if (!sq.text || !sq.text.trim()) {
              console.warn(`Skipping sub-question ${i} - empty text`);
              continue;
            }
            try {
              await api.createScreeningQuestion(campaignData.id, {
                campaign_id: campaignData.id, // Required by backend model
                question_text: sq.text.trim(),
                parent_question_id: parentBackendId,
                display_order: i
              });
            } catch (error: unknown) {
              const errorMessage = error instanceof Error ? error.message : String(error);
              console.error(`Failed to create sub-question "${sq.text}":`, error);
              throw new Error(`Failed to create sub-question: ${errorMessage}`);
            }
          }
        }
      }
      
      // Reload questions to get updated structure
      const updatedQuestions = await api.getScreeningQuestions(campaignData.id);
      const frontendQuestions = convertBackendToFrontend(updatedQuestions);
      setCurrentQuestions(frontendQuestions);
      onDataChange?.(frontendQuestions);
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ? error.message : String(error);
      console.error('Failed to save screening questions:', errorMessage, error);
      // Show user-friendly error message
      alert(`Failed to save screening questions: ${errorMessage}`);
      // Re-throw to let caller handle if needed
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const handleAddQuestion = async () => {
    if (newQuestionText.trim()) {
      const newQuestion: ScreeningQuestion = {
        id: Date.now().toString(),
        text: newQuestionText.trim(),
      };
      const newQuestions = [...currentQuestions, newQuestion];
      setCurrentQuestions(newQuestions);
      setNewQuestionText("");
      onAddQuestion?.(newQuestion);
      onDataChange?.(newQuestions);
      await saveQuestionsToDatabase(newQuestions);
    }
  };


  const handleEditQuestion = (questionId: string) => {
    const question = currentQuestions.find(q => q.id === questionId);
    if (question) {
      setEditingQuestionId(questionId);
      setEditingText(question.text);
    }
  };

  const handleSaveEdit = async () => {
    if (editingQuestionId && editingText.trim()) {
      const newQuestions = currentQuestions.map(q => 
        q.id === editingQuestionId 
          ? { ...q, text: editingText.trim() }
          : q
      );
      setCurrentQuestions(newQuestions);
      setEditingQuestionId(null);
      setEditingText("");
      onDataChange?.(newQuestions);
      await saveQuestionsToDatabase(newQuestions);
    }
  };

  const handleCancelEdit = () => {
    setEditingQuestionId(null);
    setEditingText("");
  };

  const handleDeleteQuestion = async (questionId: string) => {
    const newQuestions = currentQuestions.filter(q => q.id !== questionId);
    setCurrentQuestions(newQuestions);
    onDataChange?.(newQuestions);
    await saveQuestionsToDatabase(newQuestions);
  };

  // Sub-question handlers
  const handleAddSubQuestion = async (parentId: string) => {
    if (newSubQuestionText.trim()) {
      const newSubQuestion: ScreeningQuestion = {
        id: Date.now().toString(),
        text: newSubQuestionText.trim(),
        subQuestions: []
      };
      
      const newQuestions = currentQuestions.map(q => {
        if (q.id === parentId) {
          return {
            ...q,
            subQuestions: [...(q.subQuestions || []), newSubQuestion]
          };
        }
        return q;
      });
      
      setCurrentQuestions(newQuestions);
      setNewSubQuestionText("");
      setAddingSubQuestionTo(null);
      onDataChange?.(newQuestions);
      await saveQuestionsToDatabase(newQuestions);
    }
  };

  const handleEditSubQuestionStart = (parentId: string, subQuestionId: string) => {
    // Find the parent question
    const parentQuestion = currentQuestions.find(q => q.id === parentId);
    if (parentQuestion) {
      // Find the sub-question within the parent
      const subQuestion = parentQuestion.subQuestions?.find(sq => sq.id === subQuestionId);
      if (subQuestion) {
        setEditingQuestionId(subQuestionId);
        setEditingText(subQuestion.text);
      }
    }
  };

  const handleEditSubQuestion = async (parentId: string, subQuestionId: string, newText: string) => {
    const newQuestions = currentQuestions.map(q => {
      if (q.id === parentId) {
        return {
          ...q,
          subQuestions: (q.subQuestions || []).map(sq => 
            sq.id === subQuestionId ? { ...sq, text: newText } : sq
          )
        };
      }
      return q;
    });
    
    setCurrentQuestions(newQuestions);
    onDataChange?.(newQuestions);
    await saveQuestionsToDatabase(newQuestions);
  };

  const handleDeleteSubQuestion = async (parentId: string, subQuestionId: string) => {
    const newQuestions = currentQuestions.map(q => {
      if (q.id === parentId) {
        return {
          ...q,
          subQuestions: (q.subQuestions || []).filter(sq => sq.id !== subQuestionId)
        };
      }
      return q;
    });
    
    setCurrentQuestions(newQuestions);
    onDataChange?.(newQuestions);
    await saveQuestionsToDatabase(newQuestions);
  };

  return (
    <div className="card h-full w-full flex flex-col overflow-hidden pb-0 px-3 pt-3">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-title font-semibold text-light-text dark:text-dark-text">
          Screening questions
        </h3>
        {loading && (
          <span className="text-sm text-light-text-secondary dark:text-dark-text-secondary">
            Saving...
          </span>
        )}
      </div>

      <div className="flex-1 min-h-0 overflow-auto px-1 p-1">
        {/* Add Question Input */}
        <div className="flex justify-between gap-2 mb-2">
          <input
            type="text"
            value={newQuestionText}
            onChange={(e) => setNewQuestionText(e.target.value)}
            placeholder="Enter your question..."
            className="w-full px-2 py-1 text-body  dark:bg-dark-background-secondary border border-light-border dark:border-dark-border rounded-md text-light-text dark:text-dark-text placeholder-light-text-tertiary dark:placeholder-dark-text-tertiary focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            onKeyPress={(e) => {
              if (e.key === "Enter") {
                handleAddQuestion();
              }
            }}
          />
          
          {/* Add another question button */}
          <button
            onClick={handleAddQuestion}
            disabled={!newQuestionText.trim()}
            className="flex items-center gap-2 px-3 py-2 border border-light-border dark:border-dark-border bg-primary-500 hover:bg-primary-600 text-white text-xs rounded transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Plus className="w-4 h-4" />
          </button>
        </div>
        <div className="space-y-3">
          {/* Existing Questions */}
          {currentQuestions.map((question) => (
            <div 
              key={question.id} 
              className="group relative space-y-2"
              onMouseEnter={() => setHoveredQuestionId(question.id)}
              onMouseLeave={() => setHoveredQuestionId(null)}
            >
              <div>
                {editingQuestionId === question.id ? (
                  // Edit mode
                  <div className="p-1 dark:bg-dark-background-secondary rounded-md dark:border-dark-border">
                    <input
                      type="text"
                      value={editingText}
                      onChange={(e) => setEditingText(e.target.value)}
                      className="w-full px-2 py-1 text-body  dark:bg-dark-background-secondary border border-light-border dark:border-dark-border rounded-md text-light-text dark:text-dark-text focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      onKeyPress={(e) => {
                        if (e.key === "Enter") {
                          handleSaveEdit();
                        } else if (e.key === "Escape") {
                          handleCancelEdit();
                        }
                      }}
                      autoFocus
                    />
                    <div className="flex gap-2 mt-2">
                      <button
                        onClick={handleSaveEdit}
                        className="px-2 py-1 bg-primary-500 hover:bg-primary-600 text-white text-xs rounded transition-colors"
                      >
                        Save
                      </button>
                      <button
                        onClick={handleCancelEdit}
                        className="px-2 py-1 bg-gray-500 hover:bg-gray-600 text-white text-xs rounded transition-colors"
                      >
                        Cancel
                      </button>
                    </div>
                  </div>
                ) : (
                  // Display mode
                  <div className="p-1 rounded-md dark:border-dark-border group/parent relative">
                    <div className="flex items-start gap-2">
                      <Circle className="w-3.5 h-3.5 mt-1 text-primary-500 flex-shrink-0" />
                      <p className="text-body-md text-light-text dark:text-dark-text">
                        {question.text}
                      </p>
                    </div>
                    {/* Hover buttons - only when hovering parent question area */}
                    <div className="absolute top-1 right-1 opacity-0 group-hover/parent:opacity-100 transition-opacity duration-200 flex gap-1">
                      <button
                        onClick={() => handleEditQuestion(question.id)}
                        className="p-2 bg-blue-500 hover:bg-blue-600 text-white rounded transition-colors"
                        title="Edit question"
                      >
                        <Edit2 className="w-3 h-3" />
                      </button>
                      <button
                        onClick={() => handleDeleteQuestion(question.id)}
                        className="p-2 bg-red-500 hover:bg-red-600 text-white rounded transition-colors"
                        title="Delete question"
                      >
                        <Trash2 className="w-3 h-3" />
                      </button>
                    </div>
                    
                    {/* Add Sub-Question Button moved below sub-questions for top-to-bottom flow */}
                  </div>
                )}
              </div>

              {/* Sub-Questions */}
              {question.subQuestions && question.subQuestions.length > 0 && (
                <div className="ml-4 border-l-2 border-light-border dark:border-dark-border pl-3">
                  {question.subQuestions.map((subQuestion) => (
                    <div key={subQuestion.id} className="group/subq relative">
                      {editingQuestionId === subQuestion.id ? (
                        // Edit mode for sub-question
                        <div className="p-1 rounded-md">
                          <input
                            type="text"
                            value={editingText}
                            onChange={(e) => setEditingText(e.target.value)}
                            className="w-full px-2 py-1 text-body-sm dark:bg-dark-background-secondary border border-light-border dark:border-dark-border rounded-md text-light-text dark:text-dark-text focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                            onKeyPress={(e) => {
                              if (e.key === "Enter") {
                                handleEditSubQuestion(question.id, subQuestion.id, editingText);
                                setEditingQuestionId(null);
                                setEditingText("");
                              } else if (e.key === "Escape") {
                                handleCancelEdit();
                              }
                            }}
                            autoFocus
                          />
                          <div className="flex gap-2 mt-2">
                            <button
                              onClick={() => {
                                handleEditSubQuestion(question.id, subQuestion.id, editingText);
                                setEditingQuestionId(null);
                                setEditingText("");
                              }}
                              className="px-2 py-1 bg-primary-500 hover:bg-primary-600 text-white text-xs rounded transition-colors"
                            >
                              Save
                            </button>
                            <button
                              onClick={handleCancelEdit}
                              className="px-2 py-1 bg-gray-500 hover:bg-gray-600 text-white text-xs rounded transition-colors"
                            >
                              Cancel
                            </button>
                          </div>
                        </div>
                      ) : (
                        // Display mode for sub-question
                        <div className="p-1 rounded-md relative">
                          <div className="flex items-start gap-2">
                            <Dot className="w-4 h-4 mt-0.5 text-primary-400 flex-shrink-0" />
                            <p className="text-body-sm text-light-text-secondary dark:text-dark-text-secondary">
                              {subQuestion.text}
                            </p>
                          </div>
                          {/* Hover buttons for sub-questions - only when hovering sub-question line */}
                          <div className="absolute top-1 right-1 opacity-0 group-hover/subq:opacity-100 transition-opacity duration-200 flex gap-1">
                            <button
                              onClick={() => handleEditSubQuestionStart(question.id, subQuestion.id)}
                              className="p-1.5 bg-blue-500 hover:bg-blue-600 text-white rounded transition-colors"
                              title="Edit sub-question"
                            >
                              <Edit2 className="w-2.5 h-2.5" />
                            </button>
                            <button
                              onClick={() => handleDeleteSubQuestion(question.id, subQuestion.id)}
                              className="p-1.5 bg-red-500 hover:bg-red-600 text-white rounded transition-colors"
                              title="Delete sub-question"
                            >
                              <Trash2 className="w-2.5 h-2.5" />
                            </button>
                          </div>
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              )}

              {/* Add Sub-Question Button placed below the list (visible on hover across the whole block) */}
              {hoveredQuestionId === question.id && addingSubQuestionTo !== question.id && (
                <div className="ml-6 pl-3 mt-1">
                  <button
                    onClick={() => setAddingSubQuestionTo(question.id)}
                    className="flex items-center gap-1 px-2 py-1 text-xs text-primary-500 dark:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded transition-colors"
                  >
                    <Plus className="w-3 h-3" />
                    Add Sub-Question
                  </button>
                </div>
              )}

              {/* Add Sub-Question Input */}
              {addingSubQuestionTo === question.id && (
                <div className="ml-6 border-l-2 border-light-border dark:border-dark-border pl-3">
                  <div className="space-y-2 p-2 rounded-md">
                    <input
                      type="text"
                      value={newSubQuestionText}
                      onChange={(e) => setNewSubQuestionText(e.target.value)}
                      placeholder="Enter sub-question..."
                      className="w-full px-2 py-1 text-body-sm dark:bg-dark-background-secondary border border-light-border dark:border-dark-border rounded-md text-light-text dark:text-dark-text placeholder-light-text-tertiary dark:placeholder-dark-text-tertiary focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      onKeyPress={(e) => {
                        if (e.key === "Enter") {
                          handleAddSubQuestion(question.id);
                        } else if (e.key === "Escape") {
                          setAddingSubQuestionTo(null);
                          setNewSubQuestionText("");
                        }
                      }}
                      autoFocus
                    />
                    <div className="flex gap-2">
                      <button
                        onClick={() => handleAddSubQuestion(question.id)}
                        disabled={!newSubQuestionText.trim()}
                        className="px-2 py-1 bg-primary-500 hover:bg-primary-600 text-white text-xs rounded transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                      >
                        Add
                      </button>
                      <button
                        onClick={() => {
                          setAddingSubQuestionTo(null);
                          setNewSubQuestionText("");
                        }}
                        className="px-2 py-1 bg-gray-500 hover:bg-gray-600 text-white text-xs rounded transition-colors"
                      >
                        Cancel
                      </button>
                    </div>
                  </div>
                </div>
              )}
            </div>
          ))}

        </div>
      </div>
    </div>
  );
}
