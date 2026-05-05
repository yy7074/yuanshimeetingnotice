import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Card, Form, Input, Select, Button, Switch, message, Typography, Space, Divider, Alert } from 'antd';
import { SendOutlined, NotificationOutlined } from '@ant-design/icons';
import { eventsApi, notificationsApi, usersApi } from '../services/api';
import { qk } from '../lib/queryKeys';

const { TextArea } = Input;

export default function SendNotification() {
  const [sending, setSending] = useState(false);
  const [mode, setMode] = useState<'single' | 'broadcast'>('broadcast');
  const [form] = Form.useForm();

  const { data: events = [] } = useQuery({
    queryKey: qk.events.list(),
    queryFn: async () => (await eventsApi.list()).data,
  });
  const { data: users = [] } = useQuery({
    queryKey: qk.users.list(),
    queryFn: async () => {
      const { data } = await usersApi.list();
      return Array.isArray(data) ? data : (data?.items ?? []);
    },
  });

  const handleSend = async () => {
    setSending(true);
    try {
      const values = await form.validateFields();

      const request = {
        ...values,
        type: values.type || 'system',
        sendPush: values.sendPush ?? true,
        sendEmail: values.sendEmail ?? false,
      };
      const { data } = mode === 'single'
        ? await notificationsApi.send(request)
        : await notificationsApi.broadcast(request);

      message.success(`Notification sent! ${data.sent ? `(${data.sent} recipients)` : ''}`);
      form.resetFields();
    } catch (err: any) {
      if (err?.errorFields) {
        setSending(false);
        return;
      }
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
            <>
              <Form.Item label="Target User / 目标用户" name="userId" rules={[{ required: true }]}>
                <Select
                  showSearch
                  placeholder="Select user..."
                  optionFilterProp="label"
                  options={users.map((u: any) => ({
                    value: u.id,
                    label: `${u.email} (${u.nameEn || u.nameZh || 'No name'})`,
                  }))}
                />
              </Form.Item>
              <Form.Item
                label="Related Event / 关联会议"
                name="eventId"
                help="Optional. Recommended for event updates, material updates, and reminders."
              >
                <Select
                  allowClear
                  placeholder="Select event / 选择会议"
                  options={events.map((e: any) => ({ value: e.id, label: `${e.titleZh} (${e.titleEn})` }))}
                />
              </Form.Item>
            </>
          )}

          {mode === 'broadcast' && (
            <>
              <Alert
                type="info"
                showIcon
                style={{ marginBottom: 16 }}
                message="Leave all filters empty to send to all active users. If only an event is selected, the message goes to event subscribers. If role, status, search, or selected users are set, those filters take precedence."
              />
              <Form.Item label="Scope / 范围" name="eventId" help="Optional related event. Without user filters, this targets event subscribers.">
                <Select
                  allowClear
                  placeholder="All users / 全部用户 (or select event)"
                  options={events.map((e: any) => ({ value: e.id, label: `${e.titleZh} (${e.titleEn})` }))}
                />
              </Form.Item>
              <div style={{ display: 'flex', gap: 16 }}>
                <Form.Item label="Recipient Role / 用户角色" name="role" style={{ flex: 1 }}>
                  <Select
                    allowClear
                    placeholder="All roles / 全部角色"
                    options={[
                      { value: 'attendee', label: 'Attendee / 参会者' },
                      { value: 'speaker', label: 'Speaker / 演讲者' },
                      { value: 'vip', label: 'VIP' },
                      { value: 'admin', label: 'Admin / 管理员' },
                    ]}
                  />
                </Form.Item>
                <Form.Item label="Recipient Status / 用户状态" name="isActive" style={{ flex: 1 }}>
                  <Select
                    allowClear
                    placeholder="Active users / 活跃用户"
                    options={[
                      { value: true, label: 'Active / 启用' },
                      { value: false, label: 'Inactive / 停用' },
                    ]}
                  />
                </Form.Item>
              </div>
              <Form.Item
                label="Search Users / 搜索用户"
                name="search"
                help="Matches email, English name, or Chinese name."
              >
                <Input placeholder="alice@example.com / Alice / 张三" />
              </Form.Item>
              <Form.Item label="Specific Users / 指定用户" name="userIds">
                <Select
                  mode="multiple"
                  allowClear
                  showSearch
                  optionFilterProp="label"
                  placeholder="Optional. Further narrows the recipients."
                  options={users.map((u: any) => ({
                    value: u.id,
                    label: `${u.email} (${u.nameEn || u.nameZh || 'No name'})`,
                  }))}
                />
              </Form.Item>
            </>
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
