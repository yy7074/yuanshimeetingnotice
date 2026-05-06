import { useMemo, useState } from 'react';
import { Table, Button, Card, Space, Tag, Modal, Form, Input, Select, InputNumber, message, Popconfirm, Typography, Upload, Image } from 'antd';
import type { UploadFile } from 'antd/es/upload/interface';
import { PlusOutlined, EditOutlined, DeleteOutlined, InboxOutlined, EyeOutlined, UploadOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { eventsApi, materialsApi, sessionsApi, usersApi } from '../services/api';
import { qk } from '../lib/queryKeys';

export default function Materials() {
  const { t } = useTranslation();
  const queryClient = useQueryClient();
  const [selectedEventId, setSelectedEventId] = useState('');
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [previewOpen, setPreviewOpen] = useState(false);
  const [previewItem, setPreviewItem] = useState<any>(null);
  const [batchOpen, setBatchOpen] = useState(false);
  const [batchUploading, setBatchUploading] = useState(false);
  const [batchFiles, setBatchFiles] = useState<UploadFile[]>([]);
  const [form] = Form.useForm();
  const [batchForm] = Form.useForm();

  const { data: events = [] } = useQuery({
    queryKey: qk.events.list(),
    queryFn: async () => (await eventsApi.list()).data,
  });
  const {
    data: materials = [],
    isFetching: loading,
  } = useQuery({
    queryKey: qk.materials.listByEvent(selectedEventId),
    queryFn: async () => (await materialsApi.list(selectedEventId)).data,
    enabled: !!selectedEventId,
  });
  const { data: sessions = [] } = useQuery({
    queryKey: qk.sessions.listByEvent(selectedEventId),
    queryFn: async () => (await sessionsApi.list(selectedEventId)).data,
    enabled: !!selectedEventId,
  });
  // Lightweight user list for the per-user visibility allow-list. Loaded
  // lazily on first form open via `enabled`.
  const [userPickerEnabled, setUserPickerEnabled] = useState(false);
  const { data: usersData = [] } = useQuery({
    queryKey: qk.users.list({ scope: 'material-visibility' }),
    queryFn: async () => {
      const res = await usersApi.list();
      return Array.isArray(res.data) ? res.data : (res.data?.items ?? []);
    },
    enabled: userPickerEnabled,
  });
  const userOptions = useMemo(
    () =>
      (usersData as any[]).map((u) => ({
        value: u.id,
        label: `${u.nameZh || u.nameEn || u.email} · ${u.email}`,
      })),
    [usersData],
  );
  const invalidateMaterials = () =>
    queryClient.invalidateQueries({ queryKey: qk.materials.listByEvent(selectedEventId) });
  const fetchMaterials = invalidateMaterials;

  const openCreate = () => {
    setEditing(null);
    form.resetFields();
    setUserPickerEnabled(true);
    setModalOpen(true);
  };
  const openEdit = (r: any) => {
    setEditing(r);
    form.setFieldsValue({
      ...r,
      visibleTo: r.visibleTo?.join(',') || 'attendee,speaker,vip,admin',
      visibleUserIds: Array.isArray(r.visibleUserIds) ? r.visibleUserIds : [],
    });
    setUserPickerEnabled(true);
    setModalOpen(true);
  };

  const handleSave = async () => {
    try {
      const values = await form.validateFields();
      const payload = {
        ...values,
        visibleTo: values.visibleTo ? values.visibleTo.split(',').map((s: string) => s.trim()) : ['attendee', 'speaker', 'vip', 'admin'],
        visibleUserIds: Array.isArray(values.visibleUserIds) ? values.visibleUserIds : [],
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
    } catch {
      message.error('Failed to delete material');
    }
  };

  const typeIcons: Record<string, string> = { pdf: '📄', ppt: '📊', image: '🖼️', other: '📎' };
  const uploadBaseUrl = import.meta.env.VITE_API_URL || '/api/v1';
  const uploadAction = `${uploadBaseUrl}/upload/file`;

  const openBatchUpload = () => {
    batchForm.resetFields();
    batchForm.setFieldsValue({
      visibleTo: 'attendee,speaker,vip,admin',
      visibleUserIds: [],
    });
    setBatchFiles([]);
    setUserPickerEnabled(true);
    setBatchOpen(true);
  };

  const formatSize = (bytes: number) => {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  };

  const openPreview = (record: any) => {
    setPreviewItem(record);
    setPreviewOpen(true);
  };

  const previewUrl = useMemo(() => {
    const url = previewItem?.fileUrl || '';
    if (!url) return '';
    if (/^https?:\/\//i.test(url)) return url;
    if (url.startsWith('/')) return `${uploadBaseUrl.replace(/\/api\/v1$/, '')}${url}`;
    return url;
  }, [previewItem, uploadBaseUrl]);

  const inferMaterialType = (filename: string) => {
    const lower = filename.toLowerCase();
    if (/\.(png|jpg|jpeg|gif|webp)$/i.test(lower)) return 'image';
    if (/\.pdf$/i.test(lower)) return 'pdf';
    if (/\.(ppt|pptx)$/i.test(lower)) return 'ppt';
    return 'other';
  };

  const stripExtension = (filename: string) => filename.replace(/\.[^/.]+$/, '');

  const uploadSingleFile = async (file: File) => {
    const formData = new FormData();
    formData.append('file', file);

    const res = await fetch(uploadAction, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token') || ''}`,
      },
      body: formData,
    });

    if (!res.ok) {
      const errorText = await res.text();
      throw new Error(errorText || 'Upload failed');
    }

    return res.json();
  };

  const handleBatchCreate = async () => {
    if (!selectedEventId) {
      message.warning('Please select an event first');
      return;
    }

    if (batchFiles.length === 0) {
      message.warning('Please choose files to upload');
      return;
    }

    const values = await batchForm.validateFields();
    const visibleTo = values.visibleTo
      ? values.visibleTo.split(',').map((item: string) => item.trim()).filter(Boolean)
      : ['attendee', 'speaker', 'vip', 'admin'];
    const visibleUserIds = Array.isArray(values.visibleUserIds)
      ? values.visibleUserIds
      : [];

    const files = batchFiles.flatMap((item) => (item.originFileObj ? [item.originFileObj] : []));

    setBatchUploading(true);

    let created = 0;
    let failed = 0;

    for (const file of files) {
      try {
        const uploaded = await uploadSingleFile(file);
        await materialsApi.create(selectedEventId, {
          nameEn: stripExtension(file.name),
          nameZh: stripExtension(file.name),
          fileUrl: uploaded.url,
          fileSize: uploaded.size || file.size,
          type: inferMaterialType(file.name),
          sessionId: values.sessionId || undefined,
          visibleTo,
          visibleUserIds,
        });
        created++;
      } catch {
        failed++;
      }
    }

    setBatchUploading(false);
    if (created > 0) {
      message.success(`Batch upload complete: ${created} created${failed > 0 ? `, ${failed} failed` : ''}`);
      setBatchOpen(false);
      setBatchFiles([]);
      fetchMaterials();
      return;
    }

    message.error('Batch upload failed');
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
      title: t('session'),
      dataIndex: 'sessionId',
      key: 'session',
      render: (sessionId: string) => {
        const s = sessions.find((s: any) => s.id === sessionId);
        return s ? (s.titleEn || s.titleZh) : '-';
      },
    },
    {
      title: t('common.actions'), key: 'actions', width: 120,
      render: (_: any, r: any) => (
        <Space>
          <Button icon={<EyeOutlined />} size="small" onClick={() => openPreview(r)} />
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
            options={events.map((e: any) => ({ value: e.id, label: `${e.titleZh} (${e.titleEn})` }))}
          />
          <Button icon={<UploadOutlined />} disabled={!selectedEventId} onClick={openBatchUpload}>
            批量上传 / Batch Upload
          </Button>
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
        <Table
          dataSource={materials}
          columns={columns}
          rowKey="id"
          loading={loading}
          locale={{ emptyText: 'No materials found' }}
        />
      )}

      <Modal
        title={editing ? 'Edit Material / 编辑资料' : 'Create Material / 添加资料'}
        open={modalOpen} onOk={handleSave} onCancel={() => setModalOpen(false)} width={600}
        okText={t('common.save')} cancelText={t('common.cancel')}
      >
        <Form form={form} layout="vertical">
          <Form.Item label="Name (EN)" name="nameEn" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item label="名称 (ZH)" name="nameZh" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item label={t('file')} name="fileUrl" rules={[{ required: true }]}>
            <Input placeholder={t('fileUrlOrUpload')} />
          </Form.Item>
          <Form.Item label={t('uploadFile')}>
            <Upload.Dragger
              name="file"
              action={uploadAction}
              headers={{ Authorization: `Bearer ${localStorage.getItem('token')}` }}
              maxCount={1}
              showUploadList={{ showRemoveIcon: true }}
              onChange={(info) => {
                if (info.file.status === 'done') {
                  const url = info.file.response?.url;
                  if (url) {
                    form.setFieldsValue({ fileUrl: url, fileSize: info.file.response?.size || 0 });
                    message.success(t('uploadSuccess'));
                  }
                } else if (info.file.status === 'error') {
                  message.error(t('uploadFailed'));
                }
              }}
              accept=".pdf,.ppt,.pptx,.doc,.docx,.xls,.xlsx,.csv,.png,.jpg,.jpeg,.gif,.webp"
            >
              <p className="ant-upload-drag-icon"><InboxOutlined /></p>
              <p className="ant-upload-text">{t('dragUploadText')}</p>
              <p className="ant-upload-hint">{t('dragUploadHint')}</p>
            </Upload.Dragger>
          </Form.Item>
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
          <Form.Item name="sessionId" label={t('session')}>
            <Select allowClear placeholder={t('selectSession')}>
              {sessions.map((s: any) => (
                <Select.Option key={s.id} value={s.id}>
                  {s.titleEn} / {s.titleZh}
                </Select.Option>
              ))}
            </Select>
          </Form.Item>
          <Form.Item label="Visible To (comma separated)" name="visibleTo" initialValue="attendee,speaker,vip,admin">
            <Input placeholder="attendee,speaker,vip,admin" />
          </Form.Item>
          <Form.Item
            label="指定可见名单 / Specific Users"
            name="visibleUserIds"
            tooltip="若设置，列表内用户将无视角色规则始终可见此资料"
          >
            <Select
              mode="multiple"
              allowClear
              showSearch
              placeholder="按邮箱或姓名搜索 / Search users by email or name"
              optionFilterProp="label"
              options={userOptions}
              maxTagCount="responsive"
            />
          </Form.Item>
        </Form>
      </Modal>

      <Modal
        title={previewItem ? `${previewItem.nameEn} / ${previewItem.nameZh}` : t('common.preview')}
        open={previewOpen}
        onCancel={() => setPreviewOpen(false)}
        footer={null}
        width={900}
      >
        {previewItem?.type === 'image' ? (
          <Image
            src={previewUrl}
            alt={previewItem?.nameEn}
            style={{ width: '100%' }}
          />
        ) : previewItem?.type === 'pdf' && previewUrl ? (
          <iframe
            title="material-preview"
            src={previewUrl}
            style={{ width: '100%', height: '72vh', border: 0 }}
          />
        ) : (
          <Space direction="vertical" style={{ width: '100%', textAlign: 'center', padding: '24px 0' }}>
            <Typography.Text type="secondary">
              {previewUrl ? t('common.preview') : t('fileUrlOrUpload')}
            </Typography.Text>
            {previewUrl && (
              <Button type="primary" href={previewUrl} target="_blank" rel="noreferrer">
                Open File / 打开文件
              </Button>
            )}
          </Space>
        )}
      </Modal>

      <Modal
        title="批量上传资料 / Batch Upload Materials"
        open={batchOpen}
        onCancel={() => setBatchOpen(false)}
        onOk={() => { void handleBatchCreate(); }}
        confirmLoading={batchUploading}
        okText="开始上传 / Start Upload"
        cancelText={t('common.cancel')}
        width={680}
      >
        <Form form={batchForm} layout="vertical">
          <Form.Item label={t('session')} name="sessionId">
            <Select allowClear placeholder={t('selectSession')}>
              {sessions.map((s: any) => (
                <Select.Option key={s.id} value={s.id}>
                  {s.titleEn} / {s.titleZh}
                </Select.Option>
              ))}
            </Select>
          </Form.Item>
          <Form.Item label="Visible To (comma separated)" name="visibleTo" initialValue="attendee,speaker,vip,admin">
            <Input placeholder="attendee,speaker,vip,admin" />
          </Form.Item>
          <Form.Item
            label="指定可见名单 / Specific Users"
            name="visibleUserIds"
            tooltip="批量上传的所有资料都将共用同一份名单"
          >
            <Select
              mode="multiple"
              allowClear
              showSearch
              placeholder="按邮箱或姓名搜索 / Search users by email or name"
              optionFilterProp="label"
              options={userOptions}
              maxTagCount="responsive"
            />
          </Form.Item>
          <Form.Item label="Files / 文件">
            <Upload.Dragger
              multiple
              beforeUpload={() => false}
              fileList={batchFiles}
              onChange={({ fileList }) => setBatchFiles(fileList)}
              accept=".pdf,.ppt,.pptx,.doc,.docx,.xls,.xlsx,.csv,.png,.jpg,.jpeg,.gif,.webp"
            >
              <p className="ant-upload-drag-icon"><InboxOutlined /></p>
              <p className="ant-upload-text">拖拽或选择多个文件 / Drag or select multiple files</p>
              <p className="ant-upload-hint">上传后会为每个文件自动创建一条资料记录，名称默认取文件名。</p>
            </Upload.Dragger>
          </Form.Item>
        </Form>
      </Modal>
    </Card>
  );
}
