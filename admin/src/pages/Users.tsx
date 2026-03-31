import { useEffect, useState } from 'react';
import { Table, Card, Tag, Select, Input, message, Avatar, Typography } from 'antd';
import { useTranslation } from 'react-i18next';
import { usersApi } from '../services/api';

export default function Users() {
  const { t } = useTranslation();
  const [users, setUsers] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState('');

  const fetch = async () => {
    setLoading(true);
    try { const { data } = await usersApi.list({ search }); setUsers(data); } catch {}
    setLoading(false);
  };

  useEffect(() => { fetch(); }, [search]);

  const handleRoleChange = async (userId: string, role: string) => {
    try {
      await usersApi.updateRole(userId, role);
      message.success('Role updated');
      fetch();
    } catch {}
  };

  const columns = [
    { title: '', dataIndex: 'avatarUrl', key: 'avatar', width: 50, render: (url: string) => <Avatar src={url} /> },
    { title: 'Email', dataIndex: 'email', key: 'email' },
    { title: 'Name (EN)', dataIndex: 'nameEn', key: 'nameEn' },
    { title: '姓名', dataIndex: 'nameZh', key: 'nameZh' },
    { title: 'Organization', dataIndex: 'organizationEn', key: 'org', ellipsis: true },
    {
      title: 'Role', dataIndex: 'role', key: 'role', width: 150,
      render: (role: string, record: any) => (
        <Select value={role} size="small" style={{ width: 120 }}
          onChange={(v) => handleRoleChange(record.id, v)}
          options={[
            { value: 'attendee', label: 'Attendee' },
            { value: 'speaker', label: 'Speaker' },
            { value: 'vip', label: 'VIP' },
            { value: 'admin', label: 'Admin' },
          ]}
        />
      ),
    },
    {
      title: 'Active', dataIndex: 'isActive', key: 'active', width: 80,
      render: (v: boolean) => <Tag color={v ? 'green' : 'red'}>{v ? 'Yes' : 'No'}</Tag>,
    },
  ];

  return (
    <Card title={<Typography.Title level={4} style={{ margin: 0 }}>{t('menu.users')}</Typography.Title>}>
      <Input.Search
        placeholder={t('common.search')}
        style={{ width: 300, marginBottom: 16 }}
        onSearch={setSearch}
        allowClear
      />
      <Table dataSource={users} columns={columns} rowKey="id" loading={loading} scroll={{ x: 800 }} />
    </Card>
  );
}
