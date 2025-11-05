/**
 * Application-wide constants
 */

export const APP_CONFIG = {
  API_BASE_URL: import.meta.env.VITE_API_URL || 'http://localhost:8000',
  DEMO_USER_ID: 'demo-user-123',
  DEFAULT_PAGE_SIZE: 20,
  DEBOUNCE_DELAY: 500,
  REFETCH_INTERVAL: 30000, // 30 seconds
} as const;

export const COLOR_TAGS = {
  blue: 'bg-blue-100 dark:bg-blue-950/40 border-blue-400 dark:border-blue-700/50 text-blue-900 dark:text-blue-300',
  green: 'bg-green-100 dark:bg-green-950/40 border-green-400 dark:border-green-700/50 text-green-900 dark:text-green-300',
  purple: 'bg-purple-100 dark:bg-purple-950/40 border-purple-400 dark:border-purple-700/50 text-purple-900 dark:text-purple-300',
  orange: 'bg-orange-100 dark:bg-orange-950/40 border-orange-400 dark:border-orange-700/50 text-orange-900 dark:text-orange-300',
  red: 'bg-red-100 dark:bg-red-950/40 border-red-400 dark:border-red-700/50 text-red-900 dark:text-red-300',
  pink: 'bg-pink-100 dark:bg-pink-950/40 border-pink-400 dark:border-pink-700/50 text-pink-900 dark:text-pink-300',
  cyan: 'bg-cyan-100 dark:bg-cyan-950/40 border-cyan-400 dark:border-cyan-700/50 text-cyan-900 dark:text-cyan-300',
  yellow: 'bg-yellow-100 dark:bg-yellow-950/40 border-yellow-400 dark:border-yellow-700/50 text-yellow-900 dark:text-yellow-300',
  indigo: 'bg-indigo-100 dark:bg-indigo-950/40 border-indigo-400 dark:border-indigo-700/50 text-indigo-900 dark:text-indigo-300',
  gray: 'bg-gray-100 dark:bg-gray-900/40 border-gray-400 dark:border-gray-700/50 text-gray-900 dark:text-gray-300',
} as const;

export const COLOR_DOTS = {
  blue: 'bg-blue-500',
  green: 'bg-green-500',
  purple: 'bg-purple-500',
  orange: 'bg-orange-500',
  red: 'bg-red-500',
  pink: 'bg-pink-500',
  cyan: 'bg-cyan-500',
  yellow: 'bg-yellow-500',
  indigo: 'bg-indigo-500',
  gray: 'bg-gray-500',
} as const;

export type ColorTag = keyof typeof COLOR_TAGS;

export const INTERVIEW_STATUS_COLORS = {
  scheduled: 'bg-blue-100 dark:bg-blue-950/40 border-blue-400',
  confirmed: 'bg-green-100 dark:bg-green-950/40 border-green-400',
  pending: 'bg-yellow-100 dark:bg-yellow-950/40 border-yellow-400',
  cancelled: 'bg-red-100 dark:bg-red-950/40 border-red-400',
  completed: 'bg-green-100 dark:bg-green-950/40 border-green-400',
  no_show: 'bg-orange-100 dark:bg-orange-950/40 border-orange-400',
} as const;

export const VENDOR_STATUS = {
  NOT_ENROLLED: 'Not enrolled',
  PENDING: 'pending',
  ENROLLED: 'Enrolled',
} as const;

export const EXPERT_STATUS = {
  PROPOSED: 'proposed',
  REVIEWED: 'reviewed',
  REJECTED: 'rejected',
  SCHEDULING: 'scheduling',
  SCHEDULED: 'scheduled',
  COMPLETED: 'completed',
} as const;

