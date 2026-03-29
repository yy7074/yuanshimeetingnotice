import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ConfigProvider } from 'antd';
import zhCN from 'antd/locale/zh_CN';
import './locales/i18n';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Events from './pages/Events';
import Speakers from './pages/Speakers';
import Users from './pages/Users';
import Sessions from './pages/Sessions';
import Materials from './pages/Materials';
import CheckIn from './pages/CheckIn';
import DataExport from './pages/DataExport';
import ImportAttendees from './pages/ImportAttendees';
import SendNotification from './pages/SendNotification';
import AdminLayout from './layouts/AdminLayout';

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const token = localStorage.getItem('token');
  if (!token) return <Navigate to="/login" replace />;
  return <>{children}</>;
}

export default function App() {
  return (
    <ConfigProvider locale={zhCN} theme={{ token: { colorPrimary: '#000666' } }}>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/" element={<ProtectedRoute><AdminLayout /></ProtectedRoute>}>
            <Route index element={<Dashboard />} />
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
      </BrowserRouter>
    </ConfigProvider>
  );
}
