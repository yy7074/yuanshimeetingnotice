import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || '/api/v1',
  timeout: 10000,
});

// Auth interceptor
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (res) => res,
  (err) => {
    if (err.response?.status === 401) {
      localStorage.removeItem('token');
      if (!window.location.pathname.startsWith('/login')) {
        window.location.href = '/login';
      }
    } else if (
      err.response?.status === 403 &&
      (err.response?.data?.message?.code === 'PASSWORD_CHANGE_REQUIRED' ||
        err.response?.data?.error === 'PASSWORD_CHANGE_REQUIRED')
    ) {
      if (!window.location.pathname.startsWith('/change-password')) {
        window.location.href = '/change-password';
      }
    }
    return Promise.reject(err);
  },
);

// Auth
export const authApi = {
  login: (data: { email: string; password: string }) => api.post('/auth/login', data),
  forgotPassword: (email: string) => api.post('/auth/forgot-password', { email }),
  resetPassword: (data: { email: string; code: string; newPassword: string }) =>
    api.post('/auth/reset-password', data),
  profile: () => api.get('/auth/profile'),
  changePassword: (data: { currentPassword: string; newPassword: string }) =>
    api.post('/users/change-password', data),
};

// Events
export const eventsApi = {
  list: (params?: any) => api.get('/events', { params }),
  get: (id: string) => api.get(`/events/${id}`),
  create: (data: any) => api.post('/events', data),
  update: (id: string, data: any) => api.put(`/events/${id}`, data),
  delete: (id: string) => api.delete(`/events/${id}`),
  stats: () => api.get('/events/stats'),
};

// Sessions
export const sessionsApi = {
  list: (eventId: string) => api.get(`/events/${eventId}/sessions`),
  create: (eventId: string, data: any) => api.post(`/events/${eventId}/sessions`, data),
  update: (eventId: string, id: string, data: any) => api.put(`/events/${eventId}/sessions/${id}`, data),
  delete: (eventId: string, id: string) => api.delete(`/events/${eventId}/sessions/${id}`),
  popular: (limit = 10) => api.get('/sessions/popular', { params: { limit } }),
};

// Speakers
export const speakersApi = {
  list: (params?: any) => api.get('/speakers', { params }),
  get: (id: string) => api.get(`/speakers/${id}`),
  create: (data: any) => api.post('/speakers', data),
  update: (id: string, data: any) => api.put(`/speakers/${id}`, data),
  delete: (id: string) => api.delete(`/speakers/${id}`),
};

// Users
export const usersApi = {
  create: (data: any) => api.post('/users', data),
  list: (params?: any) => api.get('/users', { params }),
  get: (id: string) => api.get(`/users/${id}`),
  overview: (id: string) => api.get(`/users/${id}/overview`),
  update: (id: string, data: any) => api.put(`/users/${id}`, data),
  resetPassword: (id: string, newPassword: string) =>
    api.post(`/users/${id}/reset-password`, { newPassword }),
  updateRoleBatch: (userIds: string[], role: string) =>
    api.put('/users/batch/role', { userIds, role }),
  updateActiveBatch: (userIds: string[], isActive: boolean) =>
    api.put('/users/batch/active', { userIds, isActive }),
  updateRole: (id: string, role: string) => api.put(`/users/${id}/role`, { role }),
  updateActive: (id: string, isActive: boolean) =>
    api.put(`/users/${id}/active`, { isActive }),
  stats: () => api.get('/users/stats'),
  importAttendees: (attendees: any[]) => api.post('/users/import', { attendees }),
  exportUsers: () => api.post('/users/export'),
  sendInvitations: (data: { userIds?: string[]; eventId?: string; subject?: string; content?: string }) =>
    api.post('/users/send-invitations', data),
};

// Materials
export const materialsApi = {
  list: (eventId: string) => api.get(`/events/${eventId}/materials`),
  create: (eventId: string, data: any) => api.post(`/events/${eventId}/materials`, data),
  update: (eventId: string, id: string, data: any) => api.put(`/events/${eventId}/materials/${id}`, data),
  delete: (eventId: string, id: string) => api.delete(`/events/${eventId}/materials/${id}`),
};

// Check-in
export const checkInApi = {
  verify: (qrCode: string) => api.post('/check-in/verify', { qrCode }),
  records: (eventId: string) => api.get(`/check-in/event/${eventId}`),
  stats: (eventId: string) => api.get(`/check-in/stats/${eventId}`),
};

// Notifications
export const notificationsApi = {
  send: (data: any) => api.post('/notifications/send', data),
  broadcast: (data: any) => api.post('/notifications/broadcast', data),
};

export default api;
