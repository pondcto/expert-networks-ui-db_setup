import { betterAuth } from "better-auth";
import { Pool } from "pg";

// Create PostgreSQL pool for Better Auth
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const auth = betterAuth({
  database: {
    provider: "postgres",
    connection: pool,
  },
  emailAndPassword: {
    enabled: true,
    requireEmailVerification: false, // Set to true in production
  },
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID || "",
      clientSecret: process.env.GOOGLE_CLIENT_SECRET || "",
      enabled: !!process.env.GOOGLE_CLIENT_ID,
    },
    microsoft: {
      clientId: process.env.MICROSOFT_CLIENT_ID || "",
      clientSecret: process.env.MICROSOFT_CLIENT_SECRET || "",
      enabled: !!process.env.MICROSOFT_CLIENT_ID,
    },
  },
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24, // 1 day
  },
  trustedOrigins: [
    "http://localhost:3010",
    "http://localhost:3009",
    "http://localhost:3003",
  ],
});

export type Session = typeof auth.$Infer.Session;

/**
 * Get authentication headers for API requests
 * Uses JWT token from localStorage if available, otherwise returns empty headers
 */
export function authHeaders(): Record<string, string> {
  if (typeof window === 'undefined') {
    return {};
  }
  
  try {
    const token = localStorage.getItem('jwt');
    if (token) {
      return {
        'Authorization': `Bearer ${token}`,
      };
    }
  } catch {
    // localStorage not available
  }
  
  return {};
}
