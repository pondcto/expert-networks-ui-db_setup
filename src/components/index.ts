// Barrel exports for cleaner imports
export { AppSidebar } from './app-sidebar';
export { default as AuthGate } from './AuthGate';
export { ErrorBoundary } from './ErrorBoundary';
export { default as Logo } from './Logo';
export { default as UserMenu } from './UserMenu';
export { default as NewProjectModal } from './NewProjectModal';

// Layout components
export { default as ResizablePanel } from './layout/ResizablePanel';
export { default as WorkspaceHeader } from './layout/WorkspaceHeader';

// Shared components
export { default as ExpertCard } from './shared/ExpertCard';
export { default as StarRating } from './shared/StarRating';
export { default as ToggleSwitch } from './shared/ToggleSwitch';
export { default as ResizableDivider } from './shared/ResizableDivider';

// UI components
export { Button } from './ui/button';
export { Input } from './ui/input';
export { LoadingSpinner } from './ui/loading-spinner';
export { ErrorMessage } from './ui/error-message';
export { EmptyState } from './ui/empty-state';
export { Toaster } from './ui/toaster';
export { useToast } from './ui/use-toast';
export * from './ui/toast';

// Assistant components
export { AssistantProvider, FloatingAssistant } from './assistant';

