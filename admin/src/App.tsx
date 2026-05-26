import { lazy, Suspense } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ConfigProvider, Flex, Spin } from 'antd';
import zhCN from 'antd/locale/zh_CN';
import { QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from './lib/queryClient';
import './locales/i18n';

const Login = lazy(() => import('./pages/Login'));
const ChangePassword = lazy(() => import('./pages/ChangePassword'));
const Dashboard = lazy(() => import('./pages/Dashboard'));
const HomeBanners = lazy(() => import('./pages/HomeBanners'));
const Events = lazy(() => import('./pages/Events'));
const Speakers = lazy(() => import('./pages/Speakers'));
const Users = lazy(() => import('./pages/Users'));
const Sessions = lazy(() => import('./pages/Sessions'));
const Materials = lazy(() => import('./pages/Materials'));
const CheckIn = lazy(() => import('./pages/CheckIn'));
const DataExport = lazy(() => import('./pages/DataExport'));
const ImportAttendees = lazy(() => import('./pages/ImportAttendees'));
const SendNotification = lazy(() => import('./pages/SendNotification'));
const AdminLayout = lazy(() => import('./layouts/AdminLayout'));

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const token = localStorage.getItem('token');
  if (!token) return <Navigate to="/login" replace />;
  return <>{children}</>;
}

function AppLoader() {
  return (
    <Flex align="center" justify="center" style={{ minHeight: '100vh' }}>
      <Spin size="large" />
    </Flex>
  );
}

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
    <ConfigProvider locale={zhCN} theme={{ token: { colorPrimary: '#000666' } }}>
      <BrowserRouter>
        <Suspense fallback={<AppLoader />}>
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route
              path="/change-password"
              element={
                <ProtectedRoute>
                  <ChangePassword />
                </ProtectedRoute>
              }
            />
            <Route path="/" element={<ProtectedRoute><AdminLayout /></ProtectedRoute>}>
              <Route index element={<Dashboard />} />
              <Route path="home-banners" element={<HomeBanners />} />
              <Route path="events" element={<Events />} />
              <Route path="sessions" element={<Sessions />} />
              <Route path="speakers" element={<Speakers />} />
              <Route path="materials" element={<Materials />} />
              <Route path="users" element={<Users />} />
              <Route path="import" element={<ImportAttendees />} />
              <Route path="checkin" element={<CheckIn />} />
              <Route path="notifications" element={<SendNotification />} />
              <Route path="export" element={<DataExport />} />
            </Route>
          </Routes>
        </Suspense>
      </BrowserRouter>
    </ConfigProvider>
    </QueryClientProvider>
  );
}
