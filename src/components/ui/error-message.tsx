import { AlertCircle, X } from 'lucide-react';
import { cn } from '../../lib/utils';

export interface ErrorMessageProps {
  error: string | Error | null;
  onDismiss?: () => void;
  className?: string;
  variant?: 'default' | 'compact';
}

export function ErrorMessage({ 
  error, 
  onDismiss, 
  className,
  variant = 'default'
}: ErrorMessageProps) {
  if (!error) return null;

  const errorText = error instanceof Error ? error.message : error;

  if (variant === 'compact') {
    return (
      <div className={cn('flex items-center gap-2 text-sm text-red-600 dark:text-red-400', className)}>
        <AlertCircle className="w-4 h-4 flex-shrink-0" />
        <span>{errorText}</span>
        {onDismiss && (
          <button
            onClick={onDismiss}
            className="ml-auto hover:opacity-70"
            aria-label="Dismiss error"
          >
            <X className="w-4 h-4" />
          </button>
        )}
      </div>
    );
  }

  return (
    <div
      className={cn(
        'flex items-start gap-3 p-4 rounded-lg border',
        'bg-red-50 dark:bg-red-950/20',
        'border-red-200 dark:border-red-800',
        'text-red-800 dark:text-red-300',
        className
      )}
      role="alert"
    >
      <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
      <div className="flex-1">
        <p className="font-medium">Error</p>
        <p className="text-sm mt-1">{errorText}</p>
      </div>
      {onDismiss && (
        <button
          onClick={onDismiss}
          className="flex-shrink-0 hover:opacity-70 transition-opacity"
          aria-label="Dismiss error"
        >
          <X className="w-5 h-5" />
        </button>
      )}
    </div>
  );
}

