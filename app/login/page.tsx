'use client';

import { useState, useEffect } from 'react';
import { signIn } from '@/lib/auth/better-auth-client';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { LogIn, Mail } from 'lucide-react';

/**
 * Login Page (Better Auth)
 *
 * Allows users to sign in with email/password or SSO (Google, Microsoft).
 */
export default function LoginPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  // Force dark mode for login page
  useEffect(() => {
    document.documentElement.classList.add('dark');
    return () => {
      // Clean up if user navigates away
      const stored = localStorage.getItem('theme');
      if (stored !== 'dark') {
        document.documentElement.classList.remove('dark');
      }
    };
  }, []);

  const handleEmailLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    if (!email || !password) {
      setError('Please fill in all fields.');
      setLoading(false);
      return;
    }

    try {
      console.log('Attempting login with:', { email });

      // Better Auth signIn.email returns { data, error }
      const { data, error } = await signIn.email({
        email,
        password,
      });

      console.log('Login result:', { data, error });

      if (error) {
        console.error('Login error:', error);
        setError(error.message || 'Failed to sign in.');
        setLoading(false);
      } else if (data) {
        // Success - redirect to dashboard
        router.push('/dashboard');
      }
    } catch (err: any) {
      console.error('Login failed:', err);
      setError(err.message || 'Failed to sign in. Please check your credentials.');
      setLoading(false);
    }
  };

  const handleGoogleLogin = async () => {
    setLoading(true);
    setError(null);
    try {
      await signIn.social({
        provider: 'google',
        callbackURL: '/dashboard',
      });
    } catch (err: any) {
      console.error('Google login failed:', err);
      setError('Failed to sign in with Google. Please try again.');
      setLoading(false);
    }
  };

  const handleMicrosoftLogin = async () => {
    setLoading(true);
    setError(null);
    try {
      await signIn.social({
        provider: 'microsoft',
        callbackURL: '/dashboard',
      });
    } catch (err: any) {
      console.error('Microsoft login failed:', err);
      setError('Failed to sign in with Microsoft. Please try again.');
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-dark-background">
      <div className="w-full max-w-md space-y-6 px-6">
        {/* Logo/Title */}
        <div className="text-center">
          <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-primary-500/10">
            <LogIn className="h-8 w-8 text-primary-500" />
          </div>
          <h1 className="mt-4 text-3xl font-bold text-light-text dark:text-dark-text">
            Welcome Back
          </h1>
          <p className="mt-2 text-light-text-secondary dark:text-dark-text-secondary">
            Sign in to Expert Networks Module
          </p>
        </div>

        {/* Error Message */}
        {error && (
          <div className="rounded-lg border border-red-500/20 bg-red-500/10 p-4">
            <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
          </div>
        )}

        {/* Email/Password Login Form */}
        <form onSubmit={handleEmailLogin} className="space-y-4">
          <div>
            <label htmlFor="email" className="block text-sm font-medium text-light-text dark:text-dark-text mb-2">
              Email
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="your@email.com"
              disabled={loading}
              className="w-full rounded-lg border border-light-border dark:border-dark-border bg-white dark:bg-dark-surface px-4 py-3 text-sm text-light-text dark:text-dark-text placeholder:text-light-text-secondary dark:placeholder:text-dark-text-secondary focus:outline-none focus:ring-2 focus:ring-primary-500 disabled:opacity-50 disabled:cursor-not-allowed"
            />
          </div>

          <div>
            <label htmlFor="password" className="block text-sm font-medium text-light-text dark:text-dark-text mb-2">
              Password
            </label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              disabled={loading}
              className="w-full rounded-lg border border-light-border dark:border-dark-border bg-white dark:bg-dark-surface px-4 py-3 text-sm text-light-text dark:text-dark-text placeholder:text-light-text-secondary dark:placeholder:text-dark-text-secondary focus:outline-none focus:ring-2 focus:ring-primary-500 disabled:opacity-50 disabled:cursor-not-allowed"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="flex w-full items-center justify-center gap-3 rounded-lg bg-primary-500 px-4 py-3 text-sm font-medium text-white transition-colors hover:bg-primary-600 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Mail className="h-5 w-5" />
            {loading ? 'Signing in...' : 'Sign In'}
          </button>
        </form>

        {/* Divider */}
        <div className="relative">
          <div className="absolute inset-0 flex items-center">
            <div className="w-full border-t border-light-border dark:border-dark-border"></div>
          </div>
          <div className="relative flex justify-center text-sm">
            <span className="bg-light-bg dark:bg-dark-bg px-4 text-light-text-secondary dark:text-dark-text-secondary">
              Or continue with
            </span>
          </div>
        </div>

        {/* SSO Buttons */}
        <div className="space-y-3">
          {/* Google Sign In */}
          <button
            onClick={handleGoogleLogin}
            disabled={loading}
            className="flex w-full items-center justify-center gap-3 rounded-lg border border-light-border dark:border-dark-border bg-white dark:bg-dark-surface px-4 py-3 text-sm font-medium text-light-text dark:text-dark-text transition-colors hover:bg-light-surface-hover dark:hover:bg-dark-surface-hover disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <svg className="h-5 w-5" viewBox="0 0 24 24">
              <path
                fill="currentColor"
                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
              />
              <path
                fill="currentColor"
                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
              />
              <path
                fill="currentColor"
                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
              />
              <path
                fill="currentColor"
                d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
              />
            </svg>
            {loading ? 'Signing in...' : 'Continue with Google'}
          </button>

          {/* Microsoft Sign In */}
          <button
            onClick={handleMicrosoftLogin}
            disabled={loading}
            className="flex w-full items-center justify-center gap-3 rounded-lg border border-light-border dark:border-dark-border bg-white dark:bg-dark-surface px-4 py-3 text-sm font-medium text-light-text dark:text-dark-text transition-colors hover:bg-light-surface-hover dark:hover:bg-dark-surface-hover disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <svg className="h-5 w-5" viewBox="0 0 23 23">
              <path fill="#f35325" d="M0 0h11v11H0z" />
              <path fill="#81bc06" d="M12 0h11v11H12z" />
              <path fill="#05a6f0" d="M0 12h11v11H0z" />
              <path fill="#ffba08" d="M12 12h11v11H12z" />
            </svg>
            {loading ? 'Signing in...' : 'Continue with Microsoft'}
          </button>
        </div>

        {/* Signup Link */}
        <p className="text-center text-sm text-light-text-secondary dark:text-dark-text-secondary">
          Don't have an account?{' '}
          <Link
            href="/signup"
            className="font-medium text-primary-500 hover:text-primary-600 transition-colors"
          >
            Create account
          </Link>
        </p>

        {/* Footer */}
        <p className="text-center text-xs text-light-text-secondary dark:text-dark-text-secondary">
          By signing in, you agree to our Terms of Service and Privacy Policy.
        </p>
      </div>
    </div>
  );
}


