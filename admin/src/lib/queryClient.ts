import { QueryClient } from '@tanstack/react-query';

// Shared client for the entire admin app. Tuned for a low-traffic admin console:
// - Keep stale data visible while revalidating (no white-flash when switching menus)
// - Auto refetch on window focus so long-open tabs catch up
// - One retry on transient errors; more would mask real failures
export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      gcTime: 5 * 60_000,
      refetchOnWindowFocus: true,
      refetchOnReconnect: true,
      retry: 1,
      retryDelay: (attempt) => Math.min(1000 * 2 ** attempt, 10_000),
    },
    mutations: {
      retry: 0,
    },
  },
});
