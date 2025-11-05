import { lazy, Suspense } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import ClientProviders from './providers/client-providers';
import { LoadingSpinner } from './components/ui/loading-spinner';

// Lazy load pages for code splitting
const HomePage = lazy(() => import('./pages/Home'));
const LoginPage = lazy(() => import('./pages/Login'));
const SignupPage = lazy(() => import('./pages/Signup'));
const NewCampaignPage = lazy(() => import('./pages/campaign/New'));
const CampaignPage = lazy(() => import('./pages/campaign/[campaign_id]'));
const CampaignSettingsPage = lazy(() => import('./pages/campaign/[campaign_id]/settings'));
const CampaignExpertsPage = lazy(() => import('./pages/campaign/[campaign_id]/experts'));
const CampaignInterviewsPage = lazy(() => import('./pages/campaign/[campaign_id]/interviews'));
const ProjectPage = lazy(() => import('./pages/project/[project_code]'));

// Loading fallback component
const PageLoader = () => (
  <div className="flex min-h-screen items-center justify-center">
    <LoadingSpinner size="lg" />
  </div>
);

function App() {
  return (
    <ClientProviders>
      <Suspense fallback={<PageLoader />}>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/signup" element={<SignupPage />} />
          <Route path="/" element={<HomePage />} />
          <Route path="/dashboard" element={<HomePage />} />
          <Route path="/campaign/new" element={<NewCampaignPage />} />
          <Route path="/campaign/:campaign_id" element={<CampaignPage />} />
          <Route path="/campaign/:campaign_id/settings" element={<CampaignSettingsPage />} />
          <Route path="/campaign/:campaign_id/experts" element={<CampaignExpertsPage />} />
          <Route path="/campaign/:campaign_id/interviews" element={<CampaignInterviewsPage />} />
          <Route path="/project/:project_code" element={<ProjectPage />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </Suspense>
    </ClientProviders>
  );
}

export default App;
