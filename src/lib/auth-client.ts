// Client-side auth utilities (safe for frontend)
// Helper function to get auth headers for API requests
export function authHeaders(): Record<string, string> {
  if (typeof window === 'undefined') {
    return {};
  }
  
  try {
    const token = localStorage.getItem("jwt");
    if (token) {
      return {
        Authorization: `Bearer ${token}`,
      };
    }
  } catch (error) {
    // localStorage not available
    console.warn("Failed to get auth token from localStorage:", error);
  }
  
  return {};
}

