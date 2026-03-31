import { useState } from 'react';
import { Layout, Menu, Button, Dropdown, Space, Typography } from 'antd';
import {
  DashboardOutlined, CalendarOutlined,
  UserOutlined, LogoutOutlined, GlobalOutlined,
  SoundOutlined, FileTextOutlined, ScheduleOutlined,
  CheckCircleOutlined, ImportOutlined, ExportOutlined, NotificationOutlined,
} from '@ant-design/icons';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

const { Header, Sider, Content } = Layout;

export default function AdminLayout() {
  const [collapsed, setCollapsed] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();
  const { t, i18n } = useTranslation();

  const user = JSON.parse(localStorage.getItem('user') || '{}');

  const menuItems = [
    { key: '/', icon: <DashboardOutlined />, label: t('menu.dashboard') },
    { key: '/events', icon: <CalendarOutlined />, label: t('menu.events') },
    { key: '/sessions', icon: <ScheduleOutlined />, label: t('menu.sessions') },
    { key: '/speakers', icon: <SoundOutlined />, label: t('menu.speakers') },
    { key: '/materials', icon: <FileTextOutlined />, label: t('menu.materials') },
    { key: '/users', icon: <UserOutlined />, label: t('menu.users') },
    { key: '/import', icon: <ImportOutlined />, label: '导入名单 / Import' },
    { key: '/checkin', icon: <CheckCircleOutlined />, label: t('menu.checkin') },
    { key: '/notifications', icon: <NotificationOutlined />, label: '通知推送 / Push' },
    { key: '/export', icon: <ExportOutlined />, label: '数据导出 / Export' },
  ];

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    navigate('/login');
  };

  const toggleLang = () => {
    const newLang = i18n.language === 'zh' ? 'en' : 'zh';
    i18n.changeLanguage(newLang);
    localStorage.setItem('admin_lang', newLang);
  };

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Sider collapsible collapsed={collapsed} onCollapse={setCollapsed} theme="dark" width={260}>
        <div style={{ height: 64, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <Typography.Text style={{ color: '#fff', fontWeight: 'bold', fontSize: collapsed ? 14 : 22 }}>
            {collapsed ? 'A' : 'APSCVIR'}
          </Typography.Text>
        </div>
        <Menu
          theme="dark"
          selectedKeys={[location.pathname]}
          items={menuItems}
          onClick={({ key }) => navigate(key)}
          style={{ fontSize: 16 }}
        />
      </Sider>
      <Layout>
        <Header style={{ background: '#fff', padding: '0 24px', display: 'flex', justifyContent: 'space-between', alignItems: 'center', boxShadow: '0 1px 4px rgba(0,0,0,0.08)' }}>
          <Typography.Text strong>{t('app.title')}</Typography.Text>
          <Space>
            <Button icon={<GlobalOutlined />} onClick={toggleLang}>
              {i18n.language === 'zh' ? 'EN' : '中文'}
            </Button>
            <Dropdown menu={{
              items: [
                { key: 'logout', icon: <LogoutOutlined />, label: t('common.logout'), onClick: handleLogout },
              ],
            }}>
              <Button type="text">
                <Space>
                  <UserOutlined />
                  {user.nameEn || user.email || 'Admin'}
                </Space>
              </Button>
            </Dropdown>
          </Space>
        </Header>
        <Content style={{ margin: 24, padding: 24, background: '#fff', borderRadius: 8, minHeight: 360 }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  );
}
