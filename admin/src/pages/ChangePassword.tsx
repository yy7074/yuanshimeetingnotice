import { useState } from 'react';
import { Form, Input, Button, Card, message, Typography, Space } from 'antd';
import { LockOutlined, LogoutOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { authApi } from '../services/api';

const { Title, Paragraph } = Typography;

export default function ChangePassword() {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [form] = Form.useForm<{
    currentPassword: string;
    newPassword: string;
    confirmPassword: string;
  }>();
  const [submitting, setSubmitting] = useState(false);

  const rawUser = localStorage.getItem('user');
  const currentUser = rawUser ? JSON.parse(rawUser) : null;

  const onFinish = async (values: {
    currentPassword: string;
    newPassword: string;
    confirmPassword: string;
  }) => {
    if (values.newPassword !== values.confirmPassword) {
      message.error(t('changePassword.mismatch'));
      return;
    }
    if (values.newPassword === values.currentPassword) {
      message.error(t('changePassword.mustDiffer'));
      return;
    }
    try {
      setSubmitting(true);
      await authApi.changePassword({
        currentPassword: values.currentPassword,
        newPassword: values.newPassword,
      });
      message.success(t('changePassword.success'));
      // Old JWT is now revoked; force a fresh login.
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      navigate('/login', { replace: true });
    } catch (err: any) {
      message.error(
        err.response?.data?.message || t('changePassword.failed'),
      );
    } finally {
      setSubmitting(false);
    }
  };

  const onLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    navigate('/login', { replace: true });
  };

  return (
    <div
      style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        minHeight: '100vh',
        background: '#f0f2f5',
      }}
    >
      <Card style={{ width: 460, boxShadow: '0 4px 12px rgba(0,0,0,0.1)' }}>
        <Space direction="vertical" size="small" style={{ marginBottom: 24 }}>
          <Title level={3} style={{ margin: 0 }}>
            {t('changePassword.title')}
          </Title>
          {currentUser?.mustChangePassword && (
            <Paragraph type="warning" style={{ margin: 0 }}>
              {t('changePassword.forcedNotice')}
            </Paragraph>
          )}
          {currentUser?.email && (
            <Paragraph type="secondary" style={{ margin: 0 }}>
              {currentUser.email}
            </Paragraph>
          )}
        </Space>
        <Form form={form} onFinish={onFinish} layout="vertical" size="large">
          <Form.Item
            name="currentPassword"
            label={t('changePassword.current')}
            rules={[{ required: true, min: 8 }]}
          >
            <Input.Password
              prefix={<LockOutlined />}
              placeholder={t('changePassword.current')}
            />
          </Form.Item>
          <Form.Item
            name="newPassword"
            label={t('changePassword.new')}
            rules={[{ required: true, min: 8 }]}
          >
            <Input.Password
              prefix={<LockOutlined />}
              placeholder={t('changePassword.new')}
            />
          </Form.Item>
          <Form.Item
            name="confirmPassword"
            label={t('changePassword.confirm')}
            dependencies={['newPassword']}
            rules={[
              { required: true, min: 8 },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue('newPassword') === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(new Error(t('changePassword.mismatch')));
                },
              }),
            ]}
          >
            <Input.Password
              prefix={<LockOutlined />}
              placeholder={t('changePassword.confirm')}
            />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" loading={submitting} block>
              {t('changePassword.submit')}
            </Button>
          </Form.Item>
        </Form>
        <Button
          type="link"
          icon={<LogoutOutlined />}
          onClick={onLogout}
          block
        >
          {t('common.logout')}
        </Button>
      </Card>
    </div>
  );
}
