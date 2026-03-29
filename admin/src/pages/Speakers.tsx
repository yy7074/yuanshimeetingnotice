import { useEffect, useState } from 'react';
import { Table, Button, Card, Space, Tag, Modal, Form, Input, Select, message, Popconfirm, Avatar, Typography } from 'antd';
import { PlusOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { speakersApi } from '../services/api';

const { TextArea } = Input;

export default function Speakers() {
  const { t } = useTranslation();
  const [speakers, setSpeakers] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [form] = Form.useForm();

  const fetch = async () => {
    setLoading(true);
    try { const { data } = await speakersApi.list(); setSpeakers(data); } catch {}
    setLoading(false);
  };

  useEffect(() => { fetch(); }, []);

  const openCreate = () => { setEditing(null); form.resetFields(); setModalOpen(true); };
  const openEdit = (r: any) => { setEditing(r); form.setFieldsValue(r); setModalOpen(true); };

  const handleSave = async () => {
    try {
      const values = await form.validateFields();
      if (editing) {
        await speakersApi.update(editing.id, values);
        message.success('Speaker updated');
      } else {
        await speakersApi.create(values);
        message.success('Speaker created');
      }
      setModalOpen(false);
      fetch();
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Failed');
    }
  };

  const handleDelete = async (id: string) => {
    try { await speakersApi.delete(id); message.success('Deleted'); fetch(); } catch {}
  };

  const categoryColors: Record<string, string> = { keynote: 'gold', vip_guest: 'purple', research: 'blue', workshop: 'green' };

  const columns = [
    {
      title: 'Avatar', dataIndex: 'avatarUrl', key: 'avatar', width: 60,
      render: (url: string) => <Avatar src={url} />,
    },
    { title: 'Name (EN)', dataIndex: 'nameEn', key: 'nameEn' },
    { title: '姓名', dataIndex: 'nameZh', key: 'nameZh' },
    { title: 'Organization', dataIndex: 'organizationEn', key: 'org' },
    {
      title: 'Category', dataIndex: 'category', key: 'cat',
      render: (c: string) => <Tag color={categoryColors[c] || 'default'}>{c}</Tag>,
    },
    {
      title: t('common.actions'), key: 'actions', width: 120,
      render: (_: any, r: any) => (
        <Space>
          <Button icon={<EditOutlined />} size="small" onClick={() => openEdit(r)} />
          <Popconfirm title="Delete?" onConfirm={() => handleDelete(r.id)}>
            <Button icon={<DeleteOutlined />} size="small" danger />
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <Card
      title={<Typography.Title level={4} style={{ margin: 0 }}>{t('menu.speakers')}</Typography.Title>}
      extra={<Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>{t('common.create')}</Button>}
    >
      <Table dataSource={speakers} columns={columns} rowKey="id" loading={loading} />

      <Modal
        title={editing ? 'Edit Speaker / 编辑嘉宾' : 'Create Speaker / 添加嘉宾'}
        open={modalOpen} onOk={handleSave} onCancel={() => setModalOpen(false)} width={600}
        okText={t('common.save')} cancelText={t('common.cancel')}
      >
        <Form form={form} layout="vertical">
          <Form.Item label="Name (EN)" name="nameEn" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item label="姓名 (ZH)" name="nameZh" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item label="Title (EN)" name="titleEn"><Input /></Form.Item>
          <Form.Item label="头衔 (ZH)" name="titleZh"><Input /></Form.Item>
          <Form.Item label="Organization (EN)" name="organizationEn"><Input /></Form.Item>
          <Form.Item label="机构 (ZH)" name="organizationZh"><Input /></Form.Item>
          <Form.Item label="Bio (EN)" name="bioEn"><TextArea rows={2} /></Form.Item>
          <Form.Item label="简介 (ZH)" name="bioZh"><TextArea rows={2} /></Form.Item>
          <Form.Item label="Avatar URL" name="avatarUrl"><Input /></Form.Item>
          <Form.Item label="Category" name="category" initialValue="keynote">
            <Select options={[
              { value: 'keynote', label: 'Keynote / 主旨演讲' },
              { value: 'vip_guest', label: 'VIP Guest / 特邀嘉宾' },
              { value: 'research', label: 'Research / 学术研究' },
              { value: 'workshop', label: 'Workshop / 工作坊' },
            ]} />
          </Form.Item>
        </Form>
      </Modal>
    </Card>
  );
}
