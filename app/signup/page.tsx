import { useState, useEffect } from 'react';
import { signUp } from '@/lib/auth/better-auth-client';
import { useNavigate, Link } from 'react-router-dom';
import { UserPlus, Mail } from 'lucide-react';

/**
 * Signup Page (Better Auth)
 *
 * Allows users to create a new account with email/password or SSO (Google, Microsoft).
 */
export default function SignupPage() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');

  // Force dark mode for signup page
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

  const handleEmailSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    if (!email || !password || !name) {
      setError('Please fill in all fields.');
      setLoading(false);
      return;
    }

    if (password.length < 8) {
      setError('Password must be at least 8 characters long.');
      setLoading(false);
      return;
    }

    try {
      console.log('Attempting signup with:', { email, name });

      // Better Auth signUp.email returns { data, error }
      const { data, error } = await signUp.email({
        email,
        password,
        name,
      });

      console.log('Signup result:', { data, error });

      if (error) {
        console.error('Signup error:', error);
        setError(error.message || 'Failed to create account.');
        setLoading(false);
      } else if (data) {
        // Success - redirect to dashboard
        navigate('/dashboard');
      }
    } catch (err: unknown) {
      console.error('Signup failed:', err);
      const errorMessage = err instanceof Error ? err.message : 'Failed to create account. Please try again.';
      setError(errorMessage);
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-dark-background">
      <div className="w-full max-w-md space-y-6 px-6">
        {/* Logo/Title */}
        <div className="text-center">
          <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-primary-500/10">
            <UserPlus className="h-8 w-8 text-primary-500" />
          </div>
          <h1 className="mt-4 text-3xl font-bold text-light-text dark:text-dark-text">
            Create Account
          </h1>
          <p className="mt-2 text-light-text-secondary dark:text-dark-text-secondary">
            Get started with Expert Networks Module
          </p>
        </div>

        {/* Error Message */}
        {error && (
          <div className="rounded-lg border border-red-500/20 bg-red-500/10 p-4">
            <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
          </div>
        )}

        {/* Email/Password Signup Form */}
        <form onSubmit={handleEmailSignup} className="space-y-4">
          <div>
            <label htmlFor="name" className="block text-sm font-medium text-light-text dark:text-dark-text mb-2">
              Full Name
            </label>
            <input
              id="name"
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="John Doe"
              disabled={loading}
              className="w-full rounded-lg border border-light-border dark:border-dark-border bg-white dark:bg-dark-surface px-4 py-3 text-sm text-light-text dark:text-dark-text placeholder:text-light-text-secondary dark:placeholder:text-dark-text-secondary focus:outline-none focus:ring-2 focus:ring-primary-500 disabled:opacity-50 disabled:cursor-not-allowed"
            />
          </div>

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
            <p className="mt-1 text-xs text-light-text-secondary dark:text-dark-text-secondary">
              Must be at least 8 characters
            </p>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="flex w-full items-center justify-center gap-3 rounded-lg bg-primary-500 px-4 py-3 text-sm font-medium text-white transition-colors hover:bg-primary-600 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Mail className="h-5 w-5" />
            {loading ? 'Creating account...' : 'Create Account'}
          </button>
        </form>

        {/* Login Link */}
        <p className="text-center text-sm text-light-text-secondary dark:text-dark-text-secondary">
          Already have an account?{' '}
          <Link
            to="/login"
            className="font-medium text-primary-500 hover:text-primary-600 transition-colors"
          >
            Sign in
          </Link>
        </p>

        {/* Footer */}
        <p className="text-center text-xs text-light-text-secondary dark:text-dark-text-secondary">
          By creating an account, you agree to our Terms of Service and Privacy Policy.
        </p>
      </div>
    </div>
  );
}
