import { useEffect, useState } from 'react';
import { Card, Col, Row, Statistic, Typography, Table, Tag } from 'antd';
import { CalendarOutlined, UserOutlined, CheckCircleOutlined, TeamOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { eventsApi, usersApi } from '../services/api';

const { Title } = Typography;

export default function Dashboard() {
  const { t } = useTranslation();
  const [eventStats, setEventStats] = useState({ total: 0, published: 0, draft: 0 });
  const [userStats, setUserStats] = useState({ total: 0, active: 0, vip: 0 });
  const [events, setEvents] = useState<any[]>([]);

  useEffect(() => {
    eventsApi.stats().then(r => setEventStats(r.data)).catch(() => {});
    usersApi.stats().then(r => setUserStats(r.data)).catch(() => {});
    eventsApi.list().then(r => setEvents(r.data)).catch(() => {});
  }, []);

  const columns = [
    { title: 'Title (EN)', dataIndex: 'titleEn', key: 'titleEn' },
    { title: '标题', dataIndex: 'titleZh', key: 'titleZh' },
    {
      title: t('common.status'), dataIndex: 'status', key: 'status',
      render: (s: string) => (
        <Tag color={s === 'published' ? 'green' : s === 'draft' ? 'orange' : 'default'}>
          {s.toUpperCase()}
        </Tag>
      ),
    },
    { title: 'Attendees', dataIndex: 'currentAttendees', key: 'attendees' },
  ];

  return (
    <div>
      <Title level={4}>{t('menu.dashboard')}</Title>
      <Row gutter={[16, 16]}>
        <Col xs={24} sm={12} lg={6}>
          <Card><Statistic title={t('dashboard.totalEvents')} value={eventStats.total} prefix={<CalendarOutlined />} /></Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card><Statistic title={t('dashboard.publishedEvents')} value={eventStats.published} prefix={<CheckCircleOutlined />} valueStyle={{ color: '#52c41a' }} /></Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card><Statistic title={t('dashboard.totalUsers')} value={userStats.total} prefix={<UserOutlined />} /></Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card><Statistic title={t('dashboard.activeUsers')} value={userStats.active} prefix={<TeamOutlined />} valueStyle={{ color: '#1890ff' }} /></Card>
        </Col>
      </Row>
      <Card title="Recent Events / 近期会议" style={{ marginTop: 24 }}>
        <Table dataSource={events} columns={columns} rowKey="id" pagination={false} />
      </Card>
    </div>
  );
}
