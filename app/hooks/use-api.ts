import { useState, useCallback, useEffect } from 'react';
import { useAsync, UseAsyncOptions } from './use-async';

export interface UseApiOptions<T> extends UseAsyncOptions<T> {
  enabled?: boolean;
  refetchInterval?: number;
}

export interface UseApiReturn<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
  refetch: () => Promise<T | null>;
  reset: () => void;
}

/**
 * Custom hook for API calls with automatic refetching and error handling
 */
export function useApi<T>(
  apiFunction: () => Promise<T>,
  options: UseApiOptions<T> = {}
): UseApiReturn<T> {
  const { enabled = true, refetchInterval, ...asyncOptions } = options;
  
  const { data, loading, error, execute, reset } = useAsync(apiFunction, {
    ...asyncOptions,
    immediate: enabled,
  });

  useEffect(() => {
    if (!refetchInterval || !enabled) return;

    const interval = setInterval(() => {
      execute();
    }, refetchInterval);

    return () => clearInterval(interval);
  }, [refetchInterval, enabled, execute]);

  const refetch = useCallback(() => {
    return execute();
  }, [execute]);

  return { data, loading, error, refetch, reset };
}

