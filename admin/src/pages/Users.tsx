import { useState } from 'react';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { qk } from '../lib/queryKeys';
import {
  Table,
  Card,
  Tag,
  Select,
  Input,
  message,
  Avatar,
  Typography,
  Switch,
  Space,
  Button,
  Modal,
  Form,
  Descriptions,
  Divider,
  List,
  Statistic,
  Alert,
} from 'antd';
import {
  EditOutlined,
  KeyOutlined,
  MailOutlined,
  PlusOutlined,
} from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { usersApi } from '../services/api';

export default function Users() {
  const { t } = useTranslation();
  const queryClient = useQueryClient();
  const [search, setSearch] = useState('');
  const [role, setRole] = useState<string>();
  const [isActive, setIsActive] = useState<string>();
  const [mutatingUserId, setMutatingUserId] = useState<string>();
  const [selectedUserIds, setSelectedUserIds] = useState<React.Key[]>([]);
  const [modalOpen, setModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<any>(null);
  const [overview, setOverview] = useState<any>(null);
  const [savingProfile, setSavingProfile] = useState(false);
  const [passwordModalOpen, setPasswordModalOpen] = useState(false);
  const [resettingPassword, setResettingPassword] = useState(false);
  const [roleModalOpen, setRoleModalOpen] = useState(false);
  const [inviteModalOpen, setInviteModalOpen] = useState(false);
  const [sendingInvitations, setSendingInvitations] = useState(false);
  const [form] = Form.useForm();
  const [passwordForm] = Form.useForm();
  const [roleForm] = Form.useForm();
  const [inviteForm] = Form.useForm();

  const params: Record<string, string> = {};
  if (search) params.search = search;
  if (role) params.role = role;
  if (isActive) params.isActive = isActive;

  const {
    data: users = [],
    isFetching: loading,
  } = useQuery({
    queryKey: qk.users.list(params),
    queryFn: async () => {
      const { data } = await usersApi.list(params);
      // Backend returns array when no pagination; {items,total,page,pageSize} when paginated.
      return Array.isArray(data) ? data : (data?.items ?? []);
    },
    placeholderData: (prev) => prev,
  });
  const invalidateUsers = () =>
    queryClient.invalidateQueries({ queryKey: qk.users.all });
  const fetch = invalidateUsers;

  const handleRoleChange = async (userId: string, nextRole: string) => {
    try {
      setMutatingUserId(userId);
      await usersApi.updateRole(userId, nextRole);
      message.success(t('users.roleUpdated'));
      fetch();
    } catch {
      message.error(t('users.roleUpdateFailed'));
    } finally {
      setMutatingUserId(undefined);
    }
  };

  const handleActiveChange = async (userId: string, nextValue: boolean) => {
    try {
      setMutatingUserId(userId);
      await usersApi.updateActive(userId, nextValue);
      message.success(t('users.statusUpdated'));
      fetch();
    } catch (err: any) {
      message.error(err.response?.data?.message || t('users.statusUpdateFailed'));
    } finally {
      setMutatingUserId(undefined);
    }
  };

  const openEdit = async (record: any) => {
    try {
      const [{ data }, { data: overviewData }] = await Promise.all([
        usersApi.get(record.id),
        usersApi.overview(record.id),
      ]);
      setEditingUser(data);
      setOverview(overviewData);
      form.setFieldsValue({
        email: data.email,
        password: undefined,
        nameEn: data.nameEn,
        nameZh: data.nameZh,
        titleEn: data.titleEn,
        titleZh: data.titleZh,
        organizationEn: data.organizationEn,
        organizationZh: data.organizationZh,
        avatarUrl: data.avatarUrl,
        role: data.role,
        language: data.language,
        isActive: data.isActive,
        pushEnabled: data.pushEnabled,
      });
      setModalOpen(true);
    } catch {
      message.error(t('users.profileUpdateFailed'));
    }
  };

  const openCreate = () => {
    setEditingUser(null);
    setOverview(null);
    form.resetFields();
    form.setFieldsValue({
      role: 'attendee',
      language: 'zh',
      isActive: true,
      pushEnabled: true,
    });
    setModalOpen(true);
  };

  const handleSaveProfile = async () => {
    try {
      const values = await form.validateFields();
      setSavingProfile(true);
      if (editingUser) {
        await usersApi.update(editingUser.id, values);
        message.success(t('users.profileUpdated'));
      } else {
        await usersApi.create(values);
        message.success(t('users.createSuccess'));
      }
      setModalOpen(false);
      setEditingUser(null);
      setOverview(null);
      fetch();
    } catch (err: any) {
      if (err?.errorFields) return;
      message.error(
        err.response?.data?.message ||
          (editingUser ? t('users.profileUpdateFailed') : t('users.createFailed')),
      );
    } finally {
      setSavingProfile(false);
    }
  };

  const openResetPassword = (record: any) => {
    setEditingUser(record);
    passwordForm.resetFields();
    setPasswordModalOpen(true);
  };

  const handleResetPassword = async () => {
    try {
      const values = await passwordForm.validateFields();
      setResettingPassword(true);
      await usersApi.resetPassword(editingUser.id, values.newPassword);
      message.success(t('users.passwordResetSuccess'));
      setPasswordModalOpen(false);
    } catch (err: any) {
      if (err?.errorFields) return;
      message.error(err.response?.data?.message || t('users.passwordResetFailed'));
    } finally {
      setResettingPassword(false);
    }
  };

  const handleBulkStatusChange = async (nextValue: boolean) => {
    try {
      setMutatingUserId('__batch__');
      await usersApi.updateActiveBatch(
        selectedUserIds.map(String),
        nextValue,
      );
      message.success(t('users.bulkStatusSuccess'));
      setSelectedUserIds([]);
      fetch();
    } catch (err: any) {
      message.error(
        err.response?.data?.message || t('users.bulkStatusFailed'),
      );
    } finally {
      setMutatingUserId(undefined);
    }
  };

  const handleBulkRoleChange = async () => {
    try {
      const values = await roleForm.validateFields();
      setMutatingUserId('__batch__');
      await usersApi.updateRoleBatch(selectedUserIds.map(String), values.role);
      message.success(t('users.bulkRoleSuccess'));
      setRoleModalOpen(false);
      roleForm.resetFields();
      setSelectedUserIds([]);
      fetch();
    } catch (err: any) {
      if (err?.errorFields) return;
      message.error(err.response?.data?.message || t('users.bulkRoleFailed'));
    } finally {
      setMutatingUserId(undefined);
    }
  };

  const handleBulkInvite = async () => {
    try {
      const values = await inviteForm.validateFields();
      setSendingInvitations(true);
      await usersApi.sendInvitations({
        userIds: selectedUserIds.map(String),
        subject: values.subject || undefined,
        content: values.content || undefined,
      });
      message.success(t('users.inviteSuccess'));
      setInviteModalOpen(false);
      inviteForm.resetFields();
      setSelectedUserIds([]);
    } catch (err: any) {
      if (err?.errorFields) return;
      message.error(err.response?.data?.message || t('users.inviteFailed'));
    } finally {
      setSendingInvitations(false);
    }
  };

  const columns = [
    {
      title: '',
      dataIndex: 'avatarUrl',
      key: 'avatar',
      width: 50,
      render: (url: string) => <Avatar src={url} />,
    },
    { title: t('users.email'), dataIndex: 'email', key: 'email' },
    { title: 'Name (EN)', dataIndex: 'nameEn', key: 'nameEn' },
    { title: '姓名', dataIndex: 'nameZh', key: 'nameZh' },
    {
      title: t('users.organization'),
      dataIndex: 'organizationEn',
      key: 'org',
      ellipsis: true,
    },
    {
      title: t('users.role'),
      dataIndex: 'role',
      key: 'role',
      width: 150,
      render: (value: string, record: any) => (
        <Select
          value={value}
          size="small"
          style={{ width: 120 }}
          loading={mutatingUserId === record.id}
          onChange={(nextRole) => handleRoleChange(record.id, nextRole)}
          options={[
            { value: 'attendee', label: t('users.role.attendee') },
            { value: 'speaker', label: t('users.role.speaker') },
            { value: 'vip', label: t('users.role.vip') },
            { value: 'admin', label: t('users.role.admin') },
          ]}
        />
      ),
    },
    {
      title: t('common.status'),
      dataIndex: 'isActive',
      key: 'active',
      width: 160,
      render: (value: boolean, record: any) => (
        <Space size={8}>
          <Switch
            checked={value}
            loading={mutatingUserId === record.id}
            onChange={(checked) => handleActiveChange(record.id, checked)}
          />
          <Tag color={value ? 'green' : 'red'}>
            {value ? t('common.active') : t('common.inactive')}
          </Tag>
        </Space>
      ),
    },
    {
      title: t('common.actions'),
      key: 'actions',
      width: 90,
      render: (_: any, record: any) => (
        <Space>
          <Button
            icon={<EditOutlined />}
            size="small"
            onClick={() => openEdit(record)}
          />
          <Button
            icon={<KeyOutlined />}
            size="small"
            onClick={() => openResetPassword(record)}
          />
        </Space>
      ),
    },
  ];

  return (
    <Card
      title={
        <Typography.Title level={4} style={{ margin: 0 }}>
          {t('menu.users')}
        </Typography.Title>
      }
      extra={
        <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>
          {t('users.createUser')}
        </Button>
      }
    >
      <Space size={12} wrap style={{ marginBottom: 16 }}>
        <Input.Search
          placeholder={t('users.searchPlaceholder')}
          style={{ width: 300 }}
          onSearch={setSearch}
          allowClear
        />
        <Select
          allowClear
          placeholder={t('users.roleFilter')}
          style={{ width: 160 }}
          value={role}
          onChange={setRole}
          options={[
            { value: 'attendee', label: t('users.role.attendee') },
            { value: 'speaker', label: t('users.role.speaker') },
            { value: 'vip', label: t('users.role.vip') },
            { value: 'admin', label: t('users.role.admin') },
          ]}
        />
        <Select
          allowClear
          placeholder={t('users.statusFilter')}
          style={{ width: 160 }}
          value={isActive}
          onChange={setIsActive}
          options={[
            { value: 'true', label: t('common.active') },
            { value: 'false', label: t('common.inactive') },
          ]}
        />
      </Space>
      {selectedUserIds.length > 0 && (
        <Alert
          type="info"
          showIcon
          style={{ marginBottom: 16 }}
          message={`${t('users.bulkSelection')} ${selectedUserIds.length}`}
          action={
            <Space wrap>
              <Button
                size="small"
                loading={mutatingUserId === '__batch__'}
                onClick={() => handleBulkStatusChange(true)}
              >
                {t('users.bulkActivate')}
              </Button>
              <Button
                size="small"
                danger
                loading={mutatingUserId === '__batch__'}
                onClick={() => handleBulkStatusChange(false)}
              >
                {t('users.bulkDeactivate')}
              </Button>
              <Button
                size="small"
                loading={mutatingUserId === '__batch__'}
                onClick={() => setRoleModalOpen(true)}
              >
                {t('users.bulkRole')}
              </Button>
              <Button
                size="small"
                icon={<MailOutlined />}
                onClick={() => setInviteModalOpen(true)}
              >
                {t('users.bulkInvite')}
              </Button>
            </Space>
          }
        />
      )}
      <Table
        dataSource={users}
        columns={columns}
        rowKey="id"
        loading={loading}
        rowSelection={{
          selectedRowKeys: selectedUserIds,
          onChange: setSelectedUserIds,
        }}
        scroll={{ x: 900 }}
        locale={{
          emptyText:
            search || role || isActive
              ? t('users.emptyFiltered')
              : t('users.empty'),
        }}
      />
      <Modal
        title={editingUser ? t('users.editProfile') : t('users.createUser')}
        open={modalOpen}
        onOk={handleSaveProfile}
        onCancel={() => {
          setModalOpen(false);
          setEditingUser(null);
          setOverview(null);
        }}
        confirmLoading={savingProfile}
        okText={t('common.save')}
        cancelText={t('common.cancel')}
        width={680}
      >
        <Form form={form} layout="vertical">
          <Form.Item name="email" label={t('users.email')} rules={[{ required: true, type: 'email' }]}>
            <Input />
          </Form.Item>
          {!editingUser && (
            <Form.Item
              name="password"
              label={t('users.password')}
              rules={[{ required: true, min: 8 }]}
            >
              <Input.Password />
            </Form.Item>
          )}
          <Form.Item name="nameEn" label={t('users.nameEn')}>
            <Input />
          </Form.Item>
          <Form.Item name="nameZh" label={t('users.nameZh')}>
            <Input />
          </Form.Item>
          <Form.Item name="titleEn" label={t('users.titleEn')}>
            <Input />
          </Form.Item>
          <Form.Item name="titleZh" label={t('users.titleZh')}>
            <Input />
          </Form.Item>
          <Form.Item name="organizationEn" label={t('users.organizationEn')}>
            <Input />
          </Form.Item>
          <Form.Item name="organizationZh" label={t('users.organizationZh')}>
            <Input />
          </Form.Item>
          <Form.Item name="avatarUrl" label={t('users.avatarUrl')}>
            <Input />
          </Form.Item>
          {!editingUser && (
            <Form.Item name="role" label={t('users.roleLabel')}>
              <Select
                options={[
                  { value: 'attendee', label: t('users.role.attendee') },
                  { value: 'speaker', label: t('users.role.speaker') },
                  { value: 'vip', label: t('users.role.vip') },
                  { value: 'admin', label: t('users.role.admin') },
                ]}
              />
            </Form.Item>
          )}
          <Form.Item name="language" label={t('users.language')}>
            <Select
              options={[
                { value: 'zh', label: t('users.language.zh') },
                { value: 'en', label: t('users.language.en') },
              ]}
            />
          </Form.Item>
          {!editingUser && (
            <Form.Item name="isActive" label={t('users.statusLabel')} valuePropName="checked">
              <Switch />
            </Form.Item>
          )}
          <Form.Item name="pushEnabled" label={t('users.pushEnabled')} valuePropName="checked">
            <Switch />
          </Form.Item>
        </Form>
        {editingUser && overview && (
          <>
            <Divider>{t('users.overview')}</Divider>
            <Space size={24} wrap style={{ marginBottom: 16 }}>
              <Statistic
                title={t('users.stats.subscribed')}
                value={overview.stats?.subscribedEventsCount || 0}
              />
              <Statistic
                title={t('users.stats.checkins')}
                value={overview.stats?.checkInCount || 0}
              />
              <Statistic
                title={t('users.stats.unread')}
                value={overview.stats?.unreadNotificationCount || 0}
              />
            </Space>
            <Descriptions bordered size="small" column={1}>
              <Descriptions.Item label={t('users.subscribedEvents')}>
                {(overview.subscribedEvents || []).length > 0 ? (
                  <List
                    size="small"
                    dataSource={overview.subscribedEvents}
                    renderItem={(item: any) => (
                      <List.Item>
                        {item.titleZh || item.titleEn}
                      </List.Item>
                    )}
                  />
                ) : t('users.noRelatedData')}
              </Descriptions.Item>
              <Descriptions.Item label={t('users.checkInHistory')}>
                {(overview.recentCheckIns || []).length > 0 ? (
                  <List
                    size="small"
                    dataSource={overview.recentCheckIns}
                    renderItem={(item: any) => (
                      <List.Item>
                        {(item.eventTitleZh || item.eventTitleEn) || item.eventId}
                      </List.Item>
                    )}
                  />
                ) : t('users.noRelatedData')}
              </Descriptions.Item>
              <Descriptions.Item label={t('users.notificationHistory')}>
                {(overview.recentNotifications || []).length > 0 ? (
                  <List
                    size="small"
                    dataSource={overview.recentNotifications}
                    renderItem={(item: any) => (
                      <List.Item>
                        <Space>
                          <span>{item.titleZh || item.titleEn}</span>
                          <Tag color={item.isRead ? 'default' : 'blue'}>
                            {item.isRead ? t('common.read') : t('common.unread')}
                          </Tag>
                        </Space>
                      </List.Item>
                    )}
                  />
                ) : t('users.noRelatedData')}
              </Descriptions.Item>
            </Descriptions>
          </>
        )}
      </Modal>
      <Modal
        title={t('users.resetPassword')}
        open={passwordModalOpen}
        onOk={handleResetPassword}
        onCancel={() => setPasswordModalOpen(false)}
        confirmLoading={resettingPassword}
        okText={t('common.save')}
        cancelText={t('common.cancel')}
      >
        <Form form={passwordForm} layout="vertical">
          <Form.Item
            name="newPassword"
            label={t('users.newPassword')}
            rules={[{ required: true, min: 8 }]}
          >
            <Input.Password />
          </Form.Item>
          <Form.Item
            name="confirmPassword"
            label={t('users.confirmPassword')}
            dependencies={['newPassword']}
            rules={[
              { required: true, min: 8 },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue('newPassword') === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(new Error(t('users.passwordMismatch')));
                },
              }),
            ]}
          >
            <Input.Password />
          </Form.Item>
        </Form>
      </Modal>
      <Modal
        title={t('users.bulkRole')}
        open={roleModalOpen}
        onOk={handleBulkRoleChange}
        onCancel={() => {
          setRoleModalOpen(false);
          roleForm.resetFields();
        }}
        confirmLoading={mutatingUserId === '__batch__'}
        okText={t('common.save')}
        cancelText={t('common.cancel')}
      >
        <Form
          form={roleForm}
          layout="vertical"
          initialValues={{ role: 'attendee' }}
        >
          <Form.Item
            name="role"
            label={t('users.selectRole')}
            rules={[{ required: true }]}
          >
            <Select
              options={[
                { value: 'attendee', label: t('users.role.attendee') },
                { value: 'speaker', label: t('users.role.speaker') },
                { value: 'vip', label: t('users.role.vip') },
                { value: 'admin', label: t('users.role.admin') },
              ]}
            />
          </Form.Item>
        </Form>
      </Modal>
      <Modal
        title={t('users.bulkInvite')}
        open={inviteModalOpen}
        onOk={handleBulkInvite}
        onCancel={() => setInviteModalOpen(false)}
        confirmLoading={sendingInvitations}
        okText={t('common.submit')}
        cancelText={t('common.cancel')}
      >
        <Form form={inviteForm} layout="vertical">
          <Form.Item name="subject" label={t('users.inviteSubject')}>
            <Input />
          </Form.Item>
          <Form.Item name="content" label={t('users.inviteContent')}>
            <Input.TextArea rows={4} />
          </Form.Item>
        </Form>
      </Modal>
    </Card>
  );
}
