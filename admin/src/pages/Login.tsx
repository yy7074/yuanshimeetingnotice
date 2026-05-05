import { useState } from 'react';
import { Form, Input, Button, Card, message, Typography, Segmented } from 'antd';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { authApi } from '../services/api';

const { Title } = Typography;

export default function Login() {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [mode, setMode] = useState<'login' | 'reset'>('login');
  const [sendingCode, setSendingCode] = useState(false);
  const [resetting, setResetting] = useState(false);
  const [loginForm] = Form.useForm<{ email: string; password: string }>();
  const [resetForm] = Form.useForm<{
    email: string;
    code: string;
    newPassword: string;
  }>();

  const onFinish = async (values: { email: string; password: string }) => {
    try {
      const { data } = await authApi.login(values);
      if (data.user.role !== 'admin') {
        message.error(t('login.accessDenied'));
        return;
      }
      localStorage.setItem('token', data.token);
      localStorage.setItem('user', JSON.stringify(data.user));
      if (data.user.mustChangePassword) {
        message.warning(t('login.mustChangePassword'));
        navigate('/change-password');
        return;
      }
      message.success(t('login.success'));
      navigate('/');
    } catch (err: any) {
      message.error(err.response?.data?.message || t('login.failed'));
    }
  };

  const sendCode = async () => {
    try {
      const values = await resetForm.validateFields(['email']);
      setSendingCode(true);
      await authApi.forgotPassword(values.email);
      message.success(t('login.codeSent'));
    } catch (err: any) {
      if (err?.errorFields) return;
      message.error(err.response?.data?.message || t('login.failed'));
    } finally {
      setSendingCode(false);
    }
  };

  const onReset = async (values: {
    email: string;
    code: string;
    newPassword: string;
  }) => {
    try {
      setResetting(true);
      await authApi.resetPassword(values);
      message.success(t('login.resetSuccess'));
      loginForm.setFieldValue('email', values.email);
      resetForm.resetFields(['code', 'newPassword']);
      setMode('login');
    } catch (err: any) {
      message.error(err.response?.data?.message || t('login.failed'));
    } finally {
      setResetting(false);
    }
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
      <Card style={{ width: 420, boxShadow: '0 4px 12px rgba(0,0,0,0.1)' }}>
        <div style={{ textAlign: 'center', marginBottom: 32 }}>
          <Title level={3} style={{ margin: 0 }}>
            APSCVIR
          </Title>
          <p style={{ color: '#888' }}>{t('login.title')}</p>
        </div>
        <Segmented
          block
          value={mode}
          onChange={(value) => setMode(value as 'login' | 'reset')}
          options={[
            { label: t('login.mode.signIn'), value: 'login' },
            { label: t('login.mode.reset'), value: 'reset' },
          ]}
          style={{ marginBottom: 24 }}
        />
        {mode === 'login' ? (
          <Form form={loginForm} onFinish={onFinish} size="large">
            <Form.Item name="email" rules={[{ required: true, type: 'email' }]}>
              <Input placeholder={t('login.email')} />
            </Form.Item>
            <Form.Item name="password" rules={[{ required: true, min: 8 }]}>
              <Input.Password placeholder={t('login.password')} />
            </Form.Item>
            <Form.Item>
              <Button type="primary" htmlType="submit" block>
                {t('login.submit')}
              </Button>
            </Form.Item>
          </Form>
        ) : (
          <Form form={resetForm} onFinish={onReset} size="large" layout="vertical">
            <Form.Item
              name="email"
              label={t('login.email')}
              rules={[{ required: true, type: 'email' }]}
            >
              <Input placeholder={t('login.email')} />
            </Form.Item>
            <Form.Item>
              <Button onClick={sendCode} loading={sendingCode} block>
                {t('login.sendCode')}
              </Button>
            </Form.Item>
            <Form.Item name="code" label={t('login.code')} rules={[{ required: true }]}>
              <Input placeholder={t('login.code')} />
            </Form.Item>
            <Form.Item
              name="newPassword"
              label={t('login.newPassword')}
              rules={[{ required: true, min: 8 }]}
            >
              <Input.Password placeholder={t('login.newPassword')} />
            </Form.Item>
            <Form.Item style={{ marginBottom: 8 }}>
              <Button type="primary" htmlType="submit" loading={resetting} block>
                {t('login.mode.reset')}
              </Button>
            </Form.Item>
            <Button type="link" block onClick={() => setMode('login')}>
              {t('login.backToLogin')}
            </Button>
          </Form>
        )}
        <div style={{ textAlign: 'center', color: '#999', fontSize: 12 }}>
          {t('login.demo')}
        </div>
      </Card>
    </div>
  );
}
