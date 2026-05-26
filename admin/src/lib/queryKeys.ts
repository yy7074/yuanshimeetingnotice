// Central registry of query keys. Use factories so invalidation targets stay consistent.
// Prefer narrower keys for detail/stats; broader array prefixes invalidate whole groups.

export const qk = {
  events: {
    all: ['events'] as const,
    list: () => ['events', 'list'] as const,
    stats: () => ['events', 'stats'] as const,
    detail: (id: string) => ['events', 'detail', id] as const,
  },
  homeBanners: {
    all: ['home-banners'] as const,
    list: () => ['home-banners', 'list'] as const,
  },
  sessions: {
    all: ['sessions'] as const,
    listByEvent: (eventId: string) => ['sessions', 'list', eventId] as const,
    popular: (limit: number) => ['sessions', 'popular', limit] as const,
  },
  speakers: {
    all: ['speakers'] as const,
    list: () => ['speakers', 'list'] as const,
  },
  users: {
    all: ['users'] as const,
    list: (params?: Record<string, unknown>) =>
      ['users', 'list', params ?? {}] as const,
    stats: () => ['users', 'stats'] as const,
    detail: (id: string) => ['users', 'detail', id] as const,
    overview: (id: string) => ['users', 'overview', id] as const,
    export: () => ['users', 'export'] as const,
  },
  materials: {
    all: ['materials'] as const,
    listByEvent: (eventId: string) => ['materials', 'list', eventId] as const,
  },
  checkin: {
    all: ['checkin'] as const,
    records: (eventId: string) => ['checkin', 'records', eventId] as const,
    stats: (eventId: string) => ['checkin', 'stats', eventId] as const,
  },
};
