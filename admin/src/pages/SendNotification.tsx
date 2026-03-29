import { useEffect, useState } from 'react';
import { Card, Form, Input, Select, Button, Switch, message, Typography, Space, Divider } from 'antd';
import { SendOutlined, NotificationOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { eventsApi, usersApi } from '../services/api';
import api from '../services/api';

const { TextArea } = Input;

export default function SendNotification() {
  const { t } = useTranslation();
  const [events, setEvents] = useState<any[]>([]);
  const [users, setUsers] = useState<any[]>([]);
  const [sending, setSending] = useState(false);
  const [mode, setMode] = useState<'single' | 'broadcast'>('broadcast');
  const [form] = Form.useForm();

  useEffect(() => {
    eventsApi.list().then(r => setEvents(r.data)).catch(() => {});
    usersApi.list().then(r => setUsers(r.data)).catch(() => {});
  }, []);

  const handleSend = async () => {
    try {
      const values = await form.validateFields();
      setSending(true);

      const endpoint = mode === 'single' ? '/notifications/send' : '/notifications/broadcast';
      const { data } = await api.post(endpoint, {
        ...values,
        type: values.type || 'system',
        sendPush: values.sendPush ?? true,
        sendEmail: values.sendEmail ?? false,
      });

      message.success(`Notification sent! ${data.sent ? `(${data.sent} recipients)` : ''}`);
      form.resetFields();
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Failed to send');
    }
    setSending(false);
  };

  return (
    <div>
      <Typography.Title level={4}>
        <NotificationOutlined /> 发送通知 / Send Notifications
      </Typography.Title>

      <Card>
        <Space style={{ marginBottom: 24 }}>
          <Button
            type={mode === 'broadcast' ? 'primary' : 'default'}
            onClick={() => setMode('broadcast')}
          >
            广播通知 / Broadcast
          </Button>
          <Button
            type={mode === 'single' ? 'primary' : 'default'}
            onClick={() => setMode('single')}
          >
            单人通知 / Single User
          </Button>
        </Space>

        <Form form={form} layout="vertical" initialValues={{ sendPush: true, sendEmail: false }}>
          {mode === 'single' && (
            <Form.Item label="Target User / 目标用户" name="userId" rules={[{ required: true }]}>
              <Select
                showSearch
                placeholder="Select user..."
                optionFilterProp="label"
                options={users.map(u => ({
                  value: u.id,
                  label: `${u.email} (${u.nameEn || u.nameZh || 'No name'})`,
                }))}
              />
            </Form.Item>
          )}

          {mode === 'broadcast' && (
            <Form.Item label="Scope / 范围" name="eventId" help="Leave empty to broadcast to all users">
              <Select
                allowClear
                placeholder="All users / 全部用户 (or select event)"
                options={events.map(e => ({ value: e.id, label: `${e.titleZh} (${e.titleEn})` }))}
              />
            </Form.Item>
          )}

          <Divider>Notification Content / 通知内容</Divider>

          <Space style={{ width: '100%' }} size="large" direction="vertical">
            <div style={{ display: 'flex', gap: 16 }}>
              <Form.Item label="Title (EN)" name="titleEn" rules={[{ required: true }]} style={{ flex: 1 }}>
                <Input placeholder="Session Starting Soon" />
              </Form.Item>
              <Form.Item label="标题 (ZH)" name="titleZh" rules={[{ required: true }]} style={{ flex: 1 }}>
                <Input placeholder="议程即将开始" />
              </Form.Item>
            </div>
            <div style={{ display: 'flex', gap: 16 }}>
              <Form.Item label="Body (EN)" name="bodyEn" rules={[{ required: true }]} style={{ flex: 1 }}>
                <TextArea rows={3} placeholder="Your session starts in 15 minutes..." />
              </Form.Item>
              <Form.Item label="内容 (ZH)" name="bodyZh" rules={[{ required: true }]} style={{ flex: 1 }}>
                <TextArea rows={3} placeholder="您的议程将于15分钟后开始..." />
              </Form.Item>
            </div>
          </Space>

          <Form.Item label="Type / 类型" name="type" initialValue="system">
            <Select style={{ width: 250 }} options={[
              { value: 'system', label: 'System / 系统通知' },
              { value: 'event_update', label: 'Event Update / 会议更新' },
              { value: 'schedule_reminder', label: 'Schedule Reminder / 日程提醒' },
              { value: 'material_update', label: 'Material Update / 资料更新' },
            ]} />
          </Form.Item>

          <Divider>Delivery Channels / 推送渠道</Divider>

          <Space size="large">
            <Form.Item label="Push Notification / 推送通知" name="sendPush" valuePropName="checked">
              <Switch defaultChecked />
            </Form.Item>
            <Form.Item label="Email / 邮件通知" name="sendEmail" valuePropName="checked">
              <Switch />
            </Form.Item>
          </Space>

          <Form.Item>
            <Button
              type="primary"
              icon={<SendOutlined />}
              size="large"
              loading={sending}
              onClick={handleSend}
            >
              {mode === 'broadcast' ? '发送广播 / Send Broadcast' : '发送通知 / Send Notification'}
            </Button>
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
}
