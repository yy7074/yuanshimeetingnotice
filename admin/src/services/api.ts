import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api/v1',
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
      window.location.href = '/login';
    }
    return Promise.reject(err);
  },
);

// Auth
export const authApi = {
  login: (data: { email: string; password: string }) => api.post('/auth/login', data),
  profile: () => api.get('/auth/profile'),
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
  list: (params?: any) => api.get('/users', { params }),
  updateRole: (id: string, role: string) => api.put(`/users/${id}/role`, { role }),
  stats: () => api.get('/users/stats'),
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

export default api;
