import { useQueries, useQuery } from '@tanstack/react-query';
import { Card, Col, Row, Statistic, Typography, Table, Tag, Progress, List, Space } from 'antd';
import {
  CalendarOutlined,
  UserOutlined,
  CheckCircleOutlined,
  TeamOutlined,
  FileOutlined,
  RiseOutlined,
} from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { eventsApi, usersApi, checkInApi, materialsApi } from '../services/api';
import { qk } from '../lib/queryKeys';

const { Title, Text } = Typography;

interface EventCheckIn {
  eventId: string;
  title: string;
  checkedIn: number;
  total: number;
  rate: number;
}

interface MaterialDownload {
  name: string;
  downloads: number;
  eventTitle: string;
}

export default function Dashboard() {
  const { t } = useTranslation();

  const { data: eventStats = { total: 0, published: 0, draft: 0 } } = useQuery({
    queryKey: qk.events.stats(),
    queryFn: async () => (await eventsApi.stats()).data,
  });
  const { data: userStats = { total: 0, active: 0, vip: 0 } } = useQuery({
    queryKey: qk.users.stats(),
    queryFn: async () => (await usersApi.stats()).data,
  });
  const { data: events = [] } = useQuery({
    queryKey: qk.events.list(),
    queryFn: async () => (await eventsApi.list()).data || [],
  });

  const topEvents = events.slice(0, 5);

  // Parallel fetches for each of the top 5 events' check-in stats and materials.
  const checkInQueries = useQueries({
    queries: topEvents.map((event: any) => ({
      queryKey: qk.checkin.stats(event.id),
      queryFn: async () => (await checkInApi.stats(event.id)).data,
    })),
  });
  const materialQueries = useQueries({
    queries: topEvents.map((event: any) => ({
      queryKey: qk.materials.listByEvent(event.id),
      queryFn: async () => (await materialsApi.list(event.id)).data,
    })),
  });

  const eventCheckIns: EventCheckIn[] = topEvents.map((event: any, i: number) => {
    const stats: any = checkInQueries[i]?.data || {};
    const checkedIn = stats.checkedInCount || stats.checkedIn || stats.totalCheckIns || 0;
    const total = stats.totalSubscribers || stats.totalAttendees || event.currentAttendees || 0;
    const rate = total > 0 ? Math.round((checkedIn / total) * 100) : 0;
    return {
      eventId: event.id,
      title: event.titleEn || event.titleZh || 'Untitled',
      checkedIn,
      total,
      rate,
    };
  });
  const totalCheckIns = eventCheckIns.reduce((sum, e) => sum + e.checkedIn, 0);
  const totalAttendees = eventCheckIns.reduce((sum, e) => sum + e.total, 0);
  const overallCheckInRate =
    totalAttendees > 0 ? Math.round((totalCheckIns / totalAttendees) * 100) : 0;

  const topMaterials: MaterialDownload[] = (() => {
    const all: MaterialDownload[] = [];
    topEvents.forEach((event: any, i: number) => {
      const mats = (materialQueries[i]?.data as any[]) || [];
      for (const mat of mats) {
        all.push({
          name: mat.nameEn || mat.nameZh || mat.titleEn || mat.titleZh || mat.name || 'Untitled',
          downloads: mat.downloads || mat.downloadCount || 0,
          eventTitle: event.titleEn || event.titleZh || '',
        });
      }
    });
    all.sort((a, b) => b.downloads - a.downloads);
    return all.slice(0, 5);
  })();

  const totalMaterialDownloads = topMaterials.reduce((sum, m) => sum + m.downloads, 0);

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

      {/* Row 1: Core Stats */}
      <Row gutter={[16, 16]}>
        <Col xs={24} sm={12} lg={8}>
          <Card>
            <Statistic
              title={t('dashboard.totalEvents')}
              value={eventStats.total}
              prefix={<CalendarOutlined />}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card>
            <Statistic
              title={t('dashboard.publishedEvents')}
              value={eventStats.published}
              prefix={<CheckCircleOutlined />}
              valueStyle={{ color: '#52c41a' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card>
            <Statistic
              title={t('dashboard.totalUsers')}
              value={userStats.total}
              prefix={<UserOutlined />}
            />
          </Card>
        </Col>
      </Row>

      {/* Row 2: Additional Stats */}
      <Row gutter={[16, 16]} style={{ marginTop: 16 }}>
        <Col xs={24} sm={12} lg={8}>
          <Card>
            <Statistic
              title={t('dashboard.activeUsers')}
              value={userStats.active}
              prefix={<TeamOutlined />}
              valueStyle={{ color: '#1890ff' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card>
            <Statistic
              title={t('dashboard.checkInRate')}
              value={overallCheckInRate}
              prefix={<RiseOutlined />}
              suffix="%"
              valueStyle={{ color: overallCheckInRate >= 50 ? '#52c41a' : '#faad14' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card>
            <Statistic
              title={t('dashboard.materialDownloads')}
              value={totalMaterialDownloads}
              prefix={<FileOutlined />}
              valueStyle={{ color: '#722ed1' }}
            />
          </Card>
        </Col>
      </Row>

      {/* Middle Section: Check-in Overview + Top Materials */}
      <Row gutter={[16, 16]} style={{ marginTop: 24 }}>
        <Col xs={24} lg={14}>
          <Card title={t('dashboard.checkInOverview')}>
            {eventCheckIns.length > 0 ? (
              <Row gutter={[24, 24]}>
                {eventCheckIns.map((item) => (
                  <Col xs={12} sm={8} key={item.eventId} style={{ textAlign: 'center' }}>
                    <Progress
                      type="circle"
                      percent={item.rate}
                      size={80}
                      strokeColor={item.rate >= 70 ? '#52c41a' : item.rate >= 40 ? '#1890ff' : '#faad14'}
                    />
                    <div style={{ marginTop: 8 }}>
                      <Text ellipsis style={{ maxWidth: 120, display: 'block', margin: '0 auto' }}>
                        {item.title}
                      </Text>
                      <Text type="secondary" style={{ fontSize: 12 }}>
                        {item.checkedIn} / {item.total}
                      </Text>
                    </div>
                  </Col>
                ))}
              </Row>
            ) : (
              <div style={{ textAlign: 'center', padding: '24px 0' }}>
                <Text type="secondary">{t('dashboard.noCheckInData')}</Text>
              </div>
            )}

            {/* Overall progress bar */}
            <div style={{ marginTop: 24, padding: '0 8px' }}>
              <Space style={{ width: '100%', justifyContent: 'space-between', marginBottom: 4 }}>
                <Text strong>{t('dashboard.overallCheckIn')}</Text>
                <Text>{totalCheckIns} {t('dashboard.totalCheckedIn')}</Text>
              </Space>
              <Progress
                percent={overallCheckInRate}
                strokeColor={{
                  '0%': '#108ee9',
                  '100%': '#87d068',
                }}
                status="active"
              />
            </div>
          </Card>
        </Col>

        <Col xs={24} lg={10}>
          <Card title={t('dashboard.topMaterials')}>
            {topMaterials.length > 0 ? (
              <List
                dataSource={topMaterials}
                renderItem={(item, index) => (
                  <List.Item>
                    <List.Item.Meta
                      avatar={
                        <div
                          style={{
                            width: 28,
                            height: 28,
                            borderRadius: '50%',
                            background: index === 0 ? '#f5222d' : index === 1 ? '#fa8c16' : index === 2 ? '#fadb14' : '#d9d9d9',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            color: index <= 1 ? '#fff' : '#333',
                            fontWeight: 'bold',
                            fontSize: 13,
                          }}
                        >
                          {index + 1}
                        </div>
                      }
                      title={<Text ellipsis>{item.name}</Text>}
                      description={<Text type="secondary" style={{ fontSize: 12 }}>{item.eventTitle}</Text>}
                    />
                    <Tag color="purple">{item.downloads} downloads</Tag>
                  </List.Item>
                )}
              />
            ) : (
              <div style={{ textAlign: 'center', padding: '24px 0' }}>
                <Text type="secondary">{t('dashboard.noMaterialData')}</Text>
              </div>
            )}
          </Card>
        </Col>
      </Row>

      {/* Bottom: Recent Events Table */}
      <Card title={t('dashboard.recentEvents')} style={{ marginTop: 24 }}>
        <Table dataSource={events} columns={columns} rowKey="id" pagination={false} />
      </Card>
    </div>
  );
}
