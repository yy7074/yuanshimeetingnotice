import { useEffect, useState } from 'react';
import { Table, Button, Card, Space, Tag, Modal, Form, Input, Select, InputNumber, message, Popconfirm, Typography } from 'antd';
import { PlusOutlined, EditOutlined, DeleteOutlined, DownloadOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { eventsApi, materialsApi } from '../services/api';

export default function Materials() {
  const { t } = useTranslation();
  const [events, setEvents] = useState<any[]>([]);
  const [selectedEventId, setSelectedEventId] = useState('');
  const [materials, setMaterials] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [form] = Form.useForm();

  useEffect(() => {
    eventsApi.list().then(r => setEvents(r.data)).catch(() => {});
  }, []);

  useEffect(() => {
    if (selectedEventId) fetchMaterials();
  }, [selectedEventId]);

  const fetchMaterials = async () => {
    if (!selectedEventId) return;
    setLoading(true);
    try { const { data } = await materialsApi.list(selectedEventId); setMaterials(data); } catch {}
    setLoading(false);
  };

  const openCreate = () => { setEditing(null); form.resetFields(); setModalOpen(true); };
  const openEdit = (r: any) => {
    setEditing(r);
    form.setFieldsValue({ ...r, visibleTo: r.visibleTo?.join(',') || 'attendee,speaker,vip,admin' });
    setModalOpen(true);
  };

  const handleSave = async () => {
    try {
      const values = await form.validateFields();
      const payload = {
        ...values,
        visibleTo: values.visibleTo ? values.visibleTo.split(',').map((s: string) => s.trim()) : ['attendee', 'speaker', 'vip', 'admin'],
      };
      if (editing) {
        await materialsApi.update(selectedEventId, editing.id, payload);
        message.success('Material updated');
      } else {
        await materialsApi.create(selectedEventId, payload);
        message.success('Material created');
      }
      setModalOpen(false);
      fetchMaterials();
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Failed');
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await materialsApi.delete(selectedEventId, id);
      message.success('Deleted');
      fetchMaterials();
    } catch {}
  };

  const typeIcons: Record<string, string> = { pdf: '📄', ppt: '📊', image: '🖼️', other: '📎' };

  const formatSize = (bytes: number) => {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  };

  const columns = [
    {
      title: 'Type', dataIndex: 'type', key: 'type', width: 60,
      render: (t: string) => <span style={{ fontSize: 20 }}>{typeIcons[t] || '📎'}</span>,
    },
    { title: 'Name (EN)', dataIndex: 'nameEn', key: 'nameEn' },
    { title: '名称', dataIndex: 'nameZh', key: 'nameZh' },
    { title: 'Size', dataIndex: 'fileSize', key: 'size', width: 100, render: (v: number) => formatSize(v) },
    { title: 'Downloads', dataIndex: 'downloadCount', key: 'downloads', width: 100 },
    {
      title: 'Visible To', dataIndex: 'visibleTo', key: 'visible', width: 200,
      render: (v: string[]) => v?.map(r => <Tag key={r}>{r}</Tag>),
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
      title={<Typography.Title level={4} style={{ margin: 0 }}>资料管理 / Materials</Typography.Title>}
      extra={
        <Space>
          <Select
            placeholder="Select Event / 选择会议"
            style={{ width: 300 }}
            value={selectedEventId || undefined}
            onChange={setSelectedEventId}
            options={events.map(e => ({ value: e.id, label: `${e.titleZh} (${e.titleEn})` }))}
          />
          <Button type="primary" icon={<PlusOutlined />} disabled={!selectedEventId} onClick={openCreate}>
            {t('common.create')}
          </Button>
        </Space>
      }
    >
      {!selectedEventId ? (
        <div style={{ textAlign: 'center', padding: 48, color: '#999' }}>
          请先选择一个会议 / Please select an event first
        </div>
      ) : (
        <Table dataSource={materials} columns={columns} rowKey="id" loading={loading} />
      )}

      <Modal
        title={editing ? 'Edit Material / 编辑资料' : 'Create Material / 添加资料'}
        open={modalOpen} onOk={handleSave} onCancel={() => setModalOpen(false)} width={600}
        okText={t('common.save')} cancelText={t('common.cancel')}
      >
        <Form form={form} layout="vertical">
          <Form.Item label="Name (EN)" name="nameEn" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item label="名称 (ZH)" name="nameZh" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item label="File URL" name="fileUrl" rules={[{ required: true }]}><Input placeholder="/files/document.pdf" /></Form.Item>
          <Space style={{ width: '100%' }} size="large">
            <Form.Item label="Type" name="type" initialValue="pdf">
              <Select style={{ width: 150 }} options={[
                { value: 'pdf', label: 'PDF' },
                { value: 'ppt', label: 'PPT/PPTX' },
                { value: 'image', label: 'Image' },
                { value: 'other', label: 'Other' },
              ]} />
            </Form.Item>
            <Form.Item label="File Size (bytes)" name="fileSize" initialValue={0}>
              <InputNumber min={0} style={{ width: 180 }} />
            </Form.Item>
          </Space>
          <Form.Item label="Visible To (comma separated)" name="visibleTo" initialValue="attendee,speaker,vip,admin">
            <Input placeholder="attendee,speaker,vip,admin" />
          </Form.Item>
        </Form>
      </Modal>
    </Card>
  );
}
