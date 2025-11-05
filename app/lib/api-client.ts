/**
 * API Client for Expert Networks Backend
 * 
 * Handles all API calls to the Python FastAPI backend.
 * Backend URL: http://localhost:8000
 * User ID: demo-user-123 (hardcoded as per requirements)
 */

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';
const DEMO_USER_ID = 'demo-user-123';

// Helper to safely extract string from error value
function extractString(value: unknown): string | null {
  if (value === null || value === undefined) return null;
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  if (Array.isArray(value)) {
    return value.map(item => extractString(item) || String(item)).join(', ');
  }
  if (typeof value === 'object' && value !== null) {
    // Try to extract common error fields
    const obj = value as Record<string, unknown>;
    if (obj.detail) return extractString(obj.detail);
    if (obj.message) return extractString(obj.message);
    if (obj.error) return extractString(obj.error);
    if (obj.msg) return extractString(obj.msg);
    // If all else fails, stringify
    try {
      return JSON.stringify(value);
    } catch {
      return String(value);
    }
  }
  return String(value);
}

// Helper function to handle API responses
async function handleResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    let errorMessage = `HTTP ${response.status}`;
    let responseText = '';
    let errorData: unknown = null;
    
    // Safely try to get response properties
    const status = response.status;
    const statusText = response.statusText || 'Unknown';
    const url = response.url || 'Unknown';
    
    // Clone response to read it without consuming it
    try {
      const responseClone = response.clone();
      responseText = await responseClone.text();
      
      if (responseText && responseText.trim()) {
        try {
          // Try to parse as JSON
          errorData = JSON.parse(responseText);
          
          // Try to extract error message from various fields
          const extracted = extractString(errorData.detail) || 
                           extractString(errorData.message) || 
                           extractString(errorData.error) || 
                           extractString(errorData.msg) ||
                           extractString(errorData);
          
          if (extracted && extracted.trim()) {
            errorMessage = extracted;
          } else if (responseText.trim()) {
            errorMessage = responseText.trim().substring(0, 200); // Limit length
          } else {
            errorMessage = `${statusText}: ${url}`;
          }
        } catch {
          // Not JSON, use text as-is (limit length)
          if (responseText.trim()) {
            errorMessage = responseText.trim().substring(0, 200);
          } else {
            errorMessage = `${statusText}: ${url}`;
          }
        }
      } else {
        // Empty response body
        errorMessage = `${statusText}: ${url}`;
      }
    } catch (e: unknown) {
      // If reading fails, use status
      console.warn('Failed to read error response:', e);
      errorMessage = `${statusText}: ${url}`;
    }
    
    // Log detailed error information
    const errorDetails = {
      status: status,
      statusText: statusText,
      url: url,
      message: errorMessage,
      responseText: responseText ? responseText.substring(0, 500) : '(empty)',
      errorData: errorData
    };
    
    console.error('API Error Details:', JSON.stringify(errorDetails, null, 2));
    
    // Also log raw response info for debugging
    try {
      console.error('Raw Response Info:', {
        ok: response.ok,
      status: response.status,
      statusText: response.statusText,
        type: response.type,
      url: response.url,
        redirected: response.redirected
    });
    } catch (e) {
      console.error('Could not access response properties:', e);
    }
    
    throw new Error(errorMessage);
  }
  
  // Handle 204 No Content responses (common for DELETE operations)
  if (response.status === 204) {
    // No content body for 204 responses
    return {} as T;
  }
  
  // Check content-length header first
  const contentLength = response.headers.get('content-length');
  if (contentLength === '0') {
    return {} as T;
  }
  
  // Try to parse as JSON, but handle empty responses gracefully
  try {
    const text = await response.text();
    
    // If no content, return empty object
    if (!text || text.trim() === '') {
      return {} as T;
    }
    
    // Try to parse as JSON
    try {
      return JSON.parse(text) as T;
    } catch (parseError) {
      // If parsing fails, log warning and return empty object
      const contentType = response.headers.get('content-type');
      if (contentType && contentType.includes('application/json')) {
        console.warn('Failed to parse JSON response:', parseError, 'Response text:', text.substring(0, 100));
      }
      return {} as T;
    }
  } catch (readError) {
    // If reading the response fails, return empty object
    console.warn('Failed to read response body:', readError);
    return {} as T;
  }
}

// Helper function to remove undefined values from an object (for cleaner JSON)
function removeUndefined(obj: unknown): unknown {
  if (obj === null || obj === undefined) {
    return obj;
  }
  if (Array.isArray(obj)) {
    return obj.map(removeUndefined);
  }
  if (typeof obj === 'object' && obj !== null) {
    const cleaned: Record<string, unknown> = {};
    for (const [key, value] of Object.entries(obj)) {
      if (value !== undefined) {
        cleaned[key] = removeUndefined(value);
      }
    }
    return cleaned;
  }
  return obj;
}

// Helper function to make API requests
async function apiRequest<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<T> {
  const url = `${API_BASE_URL}${endpoint}`;
  
  try {
    // Clean the body if it exists (remove undefined values)
    const cleanedOptions = { ...options };
    if (options.body && typeof options.body === 'string') {
      try {
        const parsed = JSON.parse(options.body);
        const cleaned = removeUndefined(parsed);
        cleanedOptions.body = JSON.stringify(cleaned);
        
        // Log request for debugging (only in development)
        if (process.env.NODE_ENV === 'development') {
          console.log(`[API Request] ${options.method || 'GET'} ${url}`, {
            body: cleaned,
            headers: {
              'Content-Type': 'application/json',
              'X-User-Id': DEMO_USER_ID
            }
          });
        }
      } catch (parseError) {
        // If parsing fails, use body as-is
        console.warn('Failed to parse request body:', parseError);
      }
    }
    
    // Pass demo user ID in header when auth is disabled
    // The backend will use this when auth is disabled
    const response = await fetch(url, {
      ...cleanedOptions,
      headers: {
        'Content-Type': 'application/json',
        'X-User-Id': DEMO_USER_ID, // Pass demo user ID
        ...cleanedOptions.headers,
      },
    });

    return handleResponse<T>(response);
  } catch (error) {
    // Handle network errors (backend not running, CORS issues, etc.)
    if (error instanceof TypeError && error.message === 'Failed to fetch') {
      throw new Error(
        `Unable to connect to backend API at ${API_BASE_URL}. ` +
        `Please ensure the backend server is running on port 8000. ` +
        `Error: ${error.message}`
      );
    }
    throw error;
  }
}

// ============================================================================
// VENDORS API
// ============================================================================

export interface Vendor {
  id: string;
  name: string;
  logo_url: string;
  location: string;
  overall_score: number;
  avg_cost_per_call_min: number;
  avg_cost_per_call_max: number;
  description: string;
  tags: string[];
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export async function getVendors(): Promise<Vendor[]> {
  return apiRequest<Vendor[]>('/api/vendors');
}

export async function getVendor(vendorId: string): Promise<Vendor> {
  return apiRequest<Vendor>(`/api/vendors/${vendorId}`);
}

// ============================================================================
// PROJECTS API
// ============================================================================

export interface Project {
  id: string;
  user_id: string;
  project_name: string;
  project_code: string | null;
  client_name: string | null;
  start_date: string | null;
  end_date: string | null;
  description: string | null;
  display_order: number;
  campaign_count: number;
  created_at: string;
  updated_at: string;
}

export interface ProjectCreate {
  project_name: string;
  project_code?: string;
  client_name?: string;
  start_date?: string;
  end_date?: string;
  description?: string;
}

export interface ProjectUpdate {
  project_name?: string;
  project_code?: string;
  client_name?: string;
  start_date?: string;
  end_date?: string;
  description?: string;
  display_order?: number;
}

export async function getProjects(): Promise<Project[]> {
  return apiRequest<Project[]>('/api/projects');
}

export async function getProject(projectId: string): Promise<Project> {
  return apiRequest<Project>(`/api/projects/${projectId}`);
}

export async function createProject(data: ProjectCreate): Promise<Project> {
  return apiRequest<Project>('/api/projects', {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

export async function updateProject(projectId: string, data: ProjectUpdate): Promise<Project> {
  return apiRequest<Project>(`/api/projects/${projectId}`, {
    method: 'PATCH',
    body: JSON.stringify(data),
  });
}

export async function deleteProject(projectId: string): Promise<void> {
  await apiRequest<{ success: boolean }>(`/api/projects/${projectId}`, {
    method: 'DELETE',
  });
}

// ============================================================================
// CAMPAIGNS API
// ============================================================================

export interface Campaign {
  id: string;
  user_id: string;
  project_id: string | null;
  project_name: string | null;
  project_code: string | null;
  campaign_name: string;
  industry_vertical: string;
  custom_industry: string | null;
  brief_description: string | null;
  expanded_description: string | null;
  start_date: string;
  target_completion_date: string;
  target_regions: string[];
  custom_regions: string | null;
  min_calls: number | null;
  max_calls: number | null;
  expert_count: number;
  interview_count: number;
  vendor_enrollment_count: number;
  created_at: string;
  updated_at: string;
}

export interface CampaignListResponse {
  campaigns: Campaign[];
  total: number;
}

export interface CampaignCreate {
  project_id?: string;
  campaign_name: string;
  industry_vertical: string;
  custom_industry?: string;
  brief_description?: string;
  expanded_description?: string;
  start_date: string;
  target_completion_date: string;
  target_regions?: string[];
  custom_regions?: string;
  min_calls?: number;
  max_calls?: number;
}

export interface CampaignUpdate {
  project_id?: string | null;
  campaign_name?: string;
  industry_vertical?: string;
  custom_industry?: string;
  brief_description?: string;
  expanded_description?: string;
  start_date?: string;
  target_completion_date?: string;
  target_regions?: string[];
  custom_regions?: string;
  min_calls?: number;
  max_calls?: number;
}

export async function getCampaigns(): Promise<CampaignListResponse> {
  return apiRequest<CampaignListResponse>('/api/campaigns');
}

export async function getCampaign(campaignId: string): Promise<Campaign> {
  return apiRequest<Campaign>(`/api/campaigns/${campaignId}`);
}

export async function createCampaign(data: CampaignCreate): Promise<Campaign> {
  return apiRequest<Campaign>('/api/campaigns', {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

export async function updateCampaign(campaignId: string, data: CampaignUpdate): Promise<Campaign> {
  return apiRequest<Campaign>(`/api/campaigns/${campaignId}`, {
    method: 'PATCH',
    body: JSON.stringify(data),
  });
}

export async function deleteCampaign(campaignId: string): Promise<void> {
  await apiRequest<{ success: boolean }>(`/api/campaigns/${campaignId}`, {
    method: 'DELETE',
  });
}

// ============================================================================
// EXPERTS API
// ============================================================================

export interface Expert {
  id: string;
  campaign_id: string;
  vendor_platform_id: string;
  vendor_name: string;
  expert_name: string;
  current_company: string | null;
  current_title: string | null;
  location: string | null;
  linkedin_url: string | null;
  email: string | null;
  phone: string | null;
  years_experience: number | null;
  expertise_areas: string[];
  bio: string | null;
  work_history: string | null;
  avatar_url: string | null;
  hourly_rate: number | null;
  rating: number | null;
  status: 'proposed' | 'reviewed' | 'approved' | 'rejected' | 'scheduled';
  internal_notes: string | null;
  relevance_score: number | null;
  interview_count: number;
  created_at: string;
  updated_at: string;
}

export interface ExpertListResponse {
  experts: Expert[];
  total: number;
}

export interface ExpertScreeningResponse {
  id: string;
  expert_id: string;
  question_id: string;
  question_text: string;
  response_text: string;
  rating: number | null;
  created_at: string;
}

export async function getExperts(params: {
  campaign_id: string;
  status?: string;
  vendor_id?: string;
}): Promise<ExpertListResponse> {
  const queryParams = new URLSearchParams({
    campaign_id: params.campaign_id,
    ...(params.status && { status: params.status }),
    ...(params.vendor_id && { vendor_id: params.vendor_id }),
  });
  return apiRequest<ExpertListResponse>(`/api/experts?${queryParams}`);
}

export async function getExpert(expertId: string): Promise<Expert> {
  return apiRequest<Expert>(`/api/experts/${expertId}`);
}

export async function getExpertScreening(expertId: string): Promise<ExpertScreeningResponse[]> {
  return apiRequest<ExpertScreeningResponse[]>(`/api/experts/${expertId}/screening`);
}

// ============================================================================
// SCREENING QUESTIONS API
// ============================================================================

export interface ScreeningQuestion {
  id: string;
  campaign_id: string;
  parent_question_id: string | null;
  question_text: string;
  question_type: string;
  options: Record<string, unknown> | null;
  display_order: number;
  created_at: string;
  updated_at: string;
  sub_questions?: ScreeningQuestion[];
}

export interface ScreeningQuestionCreate {
  campaign_id: string; // Required by backend, but will be set from URL path
  parent_question_id?: string | null;
  question_text: string;
  question_type?: string;
  options?: Record<string, unknown> | null;
  display_order?: number;
}

export interface ScreeningQuestionUpdate {
  question_text?: string;
  question_type?: string;
  options?: Record<string, unknown> | null;
  display_order?: number;
}

export async function getScreeningQuestions(campaignId: string): Promise<ScreeningQuestion[]> {
  return apiRequest<ScreeningQuestion[]>(`/api/campaigns/${campaignId}/screening-questions`);
}

export async function createScreeningQuestion(
  campaignId: string,
  data: ScreeningQuestionCreate
): Promise<ScreeningQuestion> {
  return apiRequest<ScreeningQuestion>(`/api/campaigns/${campaignId}/screening-questions`, {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

export async function updateScreeningQuestion(
  campaignId: string,
  questionId: string,
  data: ScreeningQuestionUpdate
): Promise<ScreeningQuestion> {
  return apiRequest<ScreeningQuestion>(`/api/campaigns/${campaignId}/screening-questions/${questionId}`, {
    method: 'PATCH',
    body: JSON.stringify(data),
  });
}

export async function deleteScreeningQuestion(campaignId: string, questionId: string): Promise<void> {
  await apiRequest<void>(`/api/campaigns/${campaignId}/screening-questions/${questionId}`, {
    method: 'DELETE',
  });
}

// ============================================================================
// INTERVIEWS API
// ============================================================================

export interface Interview {
  id: string;
  campaign_id: string;
  expert_id: string;
  expert_name: string;
  expert_company: string | null;
  expert_avatar_url: string | null;
  vendor_name: string;
  scheduled_date: string;
  duration_minutes: number;
  status: 'scheduled' | 'completed' | 'cancelled' | 'no_show';
  interview_notes: string | null;
  key_insights: string | null;
  recording_url: string | null;
  transcript_text: string | null;
  interviewer_name: string | null;
  created_at: string;
  updated_at: string;
}

export interface InterviewListResponse {
  interviews: Interview[];
  total: number;
}

export interface InterviewCreate {
  campaign_id: string;
  expert_id: string;
  scheduled_date: string;
  duration_minutes: number;
  status?: 'scheduled' | 'completed' | 'cancelled' | 'no_show';
  interviewer_name?: string;
}

export interface InterviewUpdate {
  scheduled_date?: string;
  duration_minutes?: number;
  status?: 'scheduled' | 'completed' | 'cancelled' | 'no_show';
  interview_notes?: string;
  key_insights?: string;
  recording_url?: string;
  transcript_text?: string;
  interviewer_name?: string;
}

export async function getInterviews(params: {
  campaign_id: string;
  status?: string;
}): Promise<InterviewListResponse> {
  const queryParams = new URLSearchParams({
    campaign_id: params.campaign_id,
    ...(params.status && { status: params.status }),
  });
  return apiRequest<InterviewListResponse>(`/api/interviews?${queryParams}`);
}

export async function getInterview(interviewId: string): Promise<Interview> {
  return apiRequest<Interview>(`/api/interviews/${interviewId}`);
}

export async function createInterview(data: InterviewCreate): Promise<Interview> {
  return apiRequest<Interview>('/api/interviews', {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

export async function updateInterview(interviewId: string, data: InterviewUpdate): Promise<Interview> {
  return apiRequest<Interview>(`/api/interviews/${interviewId}`, {
    method: 'PATCH',
    body: JSON.stringify(data),
  });
}

export async function deleteInterview(interviewId: string): Promise<void> {
  await apiRequest<{ success: boolean }>(`/api/interviews/${interviewId}`, {
    method: 'DELETE',
  });
}

// ============================================================================
// VENDOR ENROLLMENTS API
// ============================================================================

export interface VendorEnrollment {
  id: string;
  campaign_id: string;
  vendor_platform_id: string;
  vendor_name: string;
  vendor_logo_url: string;
  status: string;
  experts_proposed_count: number;
  experts_reviewed_count: number;
  interviews_scheduled_count: number;
  created_at: string;
  updated_at: string;
}

export async function getCampaignVendors(campaignId: string): Promise<VendorEnrollment[]> {
  return apiRequest<VendorEnrollment[]>(`/api/campaigns/${campaignId}/vendors`);
}

export async function enrollVendor(campaignId: string, vendorId: string): Promise<VendorEnrollment> {
  return apiRequest<VendorEnrollment>(`/api/campaigns/${campaignId}/vendors`, {
    method: 'POST',
    body: JSON.stringify({ vendor_platform_id: vendorId }),
  });
}

export async function removeVendor(campaignId: string, vendorId: string): Promise<void> {
  await apiRequest<{ success: boolean }>(`/api/campaigns/${campaignId}/vendors/${vendorId}`, {
    method: 'DELETE',
  });
}

// ============================================================================
// TEAM MEMBERS API
// ============================================================================

export interface TeamMember {
  id: string;
  user_id: string;
  name: string;
  email: string | null;
  designation: string;
  avatar_url: string | null;
  created_at: string;
}

export interface TeamMemberCreate {
  name: string;
  email?: string | null;
  designation: string;
  avatar_url?: string | null;
}

export interface TeamMemberUpdate {
  name?: string;
  email?: string | null;
  designation?: string;
  avatar_url?: string | null;
}

export async function getTeamMembers(): Promise<TeamMember[]> {
  return apiRequest<TeamMember[]>('/api/team-members');
}

export async function getTeamMember(memberId: string): Promise<TeamMember> {
  return apiRequest<TeamMember>(`/api/team-members/${memberId}`);
}

export async function createTeamMember(data: TeamMemberCreate): Promise<TeamMember> {
  return apiRequest<TeamMember>('/api/team-members', {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

export async function updateTeamMember(memberId: string, data: TeamMemberUpdate): Promise<TeamMember> {
  return apiRequest<TeamMember>(`/api/team-members/${memberId}`, {
    method: 'PATCH',
    body: JSON.stringify(data),
  });
}

export async function deleteTeamMember(memberId: string): Promise<void> {
  await apiRequest<void>(`/api/team-members/${memberId}`, {
    method: 'DELETE',
  });
}

export async function getCampaignTeamMembers(campaignId: string): Promise<TeamMember[]> {
  return apiRequest<TeamMember[]>(`/api/team-members/campaigns/${campaignId}`);
}

export async function assignTeamMemberToCampaign(campaignId: string, memberId: string): Promise<void> {
  await apiRequest<void>(`/api/team-members/campaigns/${campaignId}/assign/${memberId}`, {
    method: 'POST',
  });
}

export async function unassignTeamMemberFromCampaign(campaignId: string, memberId: string): Promise<void> {
  await apiRequest<void>(`/api/team-members/campaigns/${campaignId}/assign/${memberId}`, {
    method: 'DELETE',
  });
}

