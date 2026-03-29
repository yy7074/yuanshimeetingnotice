import { useEffect, useState } from 'react';
import { Card, Button, Input, Select, Table, Tag, message, Typography, Space, Statistic, Row, Col } from 'antd';
import { ScanOutlined, CheckCircleOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { eventsApi, checkInApi } from '../services/api';

export default function CheckIn() {
  const { t } = useTranslation();
  const [events, setEvents] = useState<any[]>([]);
  const [selectedEventId, setSelectedEventId] = useState('');
  const [qrInput, setQrInput] = useState('');
  const [records, setRecords] = useState<any[]>([]);
  const [stats, setStats] = useState({ checkedInCount: 0 });
  const [verifyResult, setVerifyResult] = useState<any>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    eventsApi.list().then(r => setEvents(r.data)).catch(() => {});
  }, []);

  useEffect(() => {
    if (selectedEventId) {
      fetchRecords();
      fetchStats();
    }
  }, [selectedEventId]);

  const fetchRecords = async () => {
    setLoading(true);
    try { const { data } = await checkInApi.records(selectedEventId); setRecords(data); } catch {}
    setLoading(false);
  };

  const fetchStats = async () => {
    try { const { data } = await checkInApi.stats(selectedEventId); setStats(data); } catch {}
  };

  const handleVerify = async () => {
    if (!qrInput.trim()) {
      message.warning('Please enter or scan a QR code');
      return;
    }
    try {
      const { data } = await checkInApi.verify(qrInput.trim());
      setVerifyResult(data);
      message.success(data.message);
      setQrInput('');
      if (selectedEventId) {
        fetchRecords();
        fetchStats();
      }
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Verification failed');
      setVerifyResult({ message: 'Failed', error: true });
    }
  };

  const columns = [
    { title: 'User', key: 'user', render: (_: any, r: any) => r.user ? `${r.user.nameEn || r.user.email}` : r.userId },
    { title: 'Email', key: 'email', render: (_: any, r: any) => r.user?.email || '-' },
    {
      title: 'Status', key: 'status',
      render: (_: any, r: any) => r.checkedIn ? <Tag color="green">Checked In</Tag> : <Tag>Pending</Tag>,
    },
    {
      title: 'Time', dataIndex: 'checkedInAt', key: 'time',
      render: (v: string) => new Date(v).toLocaleString(),
    },
  ];

  return (
    <div>
      <Typography.Title level={4}>签到管理 / Check-in Management</Typography.Title>

      <Row gutter={[16, 16]}>
        <Col xs={24} lg={12}>
          <Card title="扫码验证 / QR Verification">
            <Space direction="vertical" style={{ width: '100%' }} size="large">
              <Input.TextArea
                rows={3}
                placeholder="Paste QR code content here / 在此粘贴QR码内容..."
                value={qrInput}
                onChange={e => setQrInput(e.target.value)}
                onPressEnter={handleVerify}
              />
              <Button type="primary" icon={<ScanOutlined />} size="large" block onClick={handleVerify}>
                验证签到 / Verify Check-in
              </Button>
              {verifyResult && (
                <div style={{
                  padding: 16, borderRadius: 8,
                  background: verifyResult.error ? '#fff2f0' : '#f6ffed',
                  border: `1px solid ${verifyResult.error ? '#ffccc7' : '#b7eb8f'}`,
                }}>
                  <Space>
                    <CheckCircleOutlined style={{ color: verifyResult.error ? '#ff4d4f' : '#52c41a', fontSize: 24 }} />
                    <span style={{ fontSize: 16, fontWeight: 'bold' }}>{verifyResult.message}</span>
                  </Space>
                </div>
              )}
            </Space>
          </Card>
        </Col>
        <Col xs={24} lg={12}>
          <Card title="签到统计 / Stats">
            <Select
              placeholder="Select Event / 选择会议"
              style={{ width: '100%', marginBottom: 16 }}
              value={selectedEventId || undefined}
              onChange={setSelectedEventId}
              options={events.map(e => ({ value: e.id, label: `${e.titleZh}` }))}
            />
            <Statistic title="已签到 / Checked In" value={stats.checkedInCount} prefix={<CheckCircleOutlined />} valueStyle={{ color: '#52c41a' }} />
          </Card>
        </Col>
      </Row>

      {selectedEventId && (
        <Card title="签到记录 / Records" style={{ marginTop: 16 }}>
          <Table dataSource={records} columns={columns} rowKey="id" loading={loading} />
        </Card>
      )}
    </div>
  );
}
