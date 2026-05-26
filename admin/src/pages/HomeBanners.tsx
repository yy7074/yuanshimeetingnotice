import { useMemo, useState } from 'react';
import {
  Button,
  Card,
  Form,
  Image,
  Input,
  InputNumber,
  message,
  Modal,
  Popconfirm,
  Space,
  Switch,
  Table,
  Tag,
  Typography,
  Upload,
} from 'antd';
import {
  DeleteOutlined,
  EditOutlined,
  InboxOutlined,
  PlusOutlined,
} from '@ant-design/icons';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { homeBannersApi } from '../services/api';
import { qk } from '../lib/queryKeys';

type HomeBanner = {
  id: string;
  title: string;
  subtitle: string;
  imageUrl: string;
  linkUrl: string;
  sortOrder: number;
  isActive: boolean;
};

const uploadBaseUrl = import.meta.env.VITE_API_URL || '/api/v1';
const uploadAction = `${uploadBaseUrl}/upload/file`;
const publicBaseUrl = uploadBaseUrl.replace(/\/api\/v1$/, '');

function absoluteUrl(url: string) {
  if (!url) return '';
  if (/^https?:\/\//i.test(url)) return url;
  return url.startsWith('/') ? `${publicBaseUrl}${url}` : url;
}

export default function HomeBanners() {
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<HomeBanner | null>(null);
  const [form] = Form.useForm();

  const { data: banners = [], isFetching } = useQuery({
    queryKey: qk.homeBanners.list(),
    queryFn: async () => (await homeBannersApi.listAdmin()).data,
  });

  const nextSortOrder = useMemo(
    () =>
      (banners as HomeBanner[]).reduce(
        (max, banner) => Math.max(max, Number(banner.sortOrder || 0)),
        0,
      ) + 1,
    [banners],
  );

  const invalidate = () =>
    queryClient.invalidateQueries({ queryKey: qk.homeBanners.all });

  const openCreate = () => {
    setEditing(null);
    form.resetFields();
    form.setFieldsValue({ sortOrder: nextSortOrder, isActive: true });
    setModalOpen(true);
  };

  const openEdit = (record: HomeBanner) => {
    setEditing(record);
    form.setFieldsValue(record);
    setModalOpen(true);
  };

  const handleSave = async () => {
    try {
      const values = await form.validateFields();
      const payload = {
        ...values,
        title: values.title || '',
        subtitle: values.subtitle || '',
        linkUrl: values.linkUrl || '',
        sortOrder: Number(values.sortOrder || 0),
        isActive: values.isActive !== false,
      };
      if (editing) {
        await homeBannersApi.update(editing.id, payload);
        message.success('Banner updated');
      } else {
        await homeBannersApi.create(payload);
        message.success('Banner created');
      }
      setModalOpen(false);
      invalidate();
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Save failed');
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await homeBannersApi.delete(id);
      message.success('Banner deleted');
      invalidate();
    } catch {
      message.error('Delete failed');
    }
  };

  const columns = [
    {
      title: 'Preview',
      dataIndex: 'imageUrl',
      key: 'preview',
      width: 180,
      render: (url: string) =>
        url ? (
          <Image
            src={absoluteUrl(url)}
            width={150}
            height={84}
            style={{ objectFit: 'cover', borderRadius: 6 }}
          />
        ) : (
          '-'
        ),
    },
    { title: 'Title', dataIndex: 'title', key: 'title' },
    { title: 'Subtitle', dataIndex: 'subtitle', key: 'subtitle' },
    {
      title: 'Sort',
      dataIndex: 'sortOrder',
      key: 'sortOrder',
      width: 80,
      sorter: (a: HomeBanner, b: HomeBanner) => a.sortOrder - b.sortOrder,
    },
    {
      title: 'Status',
      dataIndex: 'isActive',
      key: 'isActive',
      width: 100,
      render: (active: boolean) =>
        active ? <Tag color="green">Active</Tag> : <Tag>Inactive</Tag>,
    },
    {
      title: 'Actions',
      key: 'actions',
      width: 130,
      render: (_: any, record: HomeBanner) => (
        <Space>
          <Button icon={<EditOutlined />} size="small" onClick={() => openEdit(record)} />
          <Popconfirm title="Delete this banner?" onConfirm={() => handleDelete(record.id)}>
            <Button icon={<DeleteOutlined />} size="small" danger />
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <Card
      title={<Typography.Title level={4} style={{ margin: 0 }}>首页轮播图 / Home Carousel</Typography.Title>}
      extra={<Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>Add Banner</Button>}
    >
      <Typography.Paragraph type="secondary">
        Recommended image size: 1800 x 1000 px. Active banners are shown on the App home page in sort order.
      </Typography.Paragraph>
      <Table
        dataSource={banners}
        columns={columns}
        rowKey="id"
        loading={isFetching}
        scroll={{ x: 900 }}
      />

      <Modal
        title={editing ? 'Edit Banner / 编辑轮播图' : 'Add Banner / 新增轮播图'}
        open={modalOpen}
        onOk={handleSave}
        onCancel={() => setModalOpen(false)}
        width={720}
        okText="Save"
      >
        <Form form={form} layout="vertical">
          <Form.Item label="Image URL" name="imageUrl" rules={[{ required: true }]}>
            <Input placeholder="/uploads/banner.jpg or https://..." />
          </Form.Item>
          <Form.Item label="Upload Image">
            <Upload.Dragger
              action={uploadAction}
              accept=".png,.jpg,.jpeg,.webp"
              maxCount={1}
              headers={{ Authorization: `Bearer ${localStorage.getItem('token') || ''}` }}
              onChange={(info) => {
                if (info.file.status === 'done') {
                  form.setFieldValue('imageUrl', info.file.response?.url || '');
                  message.success('Upload successful');
                } else if (info.file.status === 'error') {
                  message.error('Upload failed');
                }
              }}
            >
              <p className="ant-upload-drag-icon"><InboxOutlined /></p>
              <p className="ant-upload-text">Click or drag carousel image to upload</p>
              <p className="ant-upload-hint">Use 1800 x 1000 px for best mobile display.</p>
            </Upload.Dragger>
          </Form.Item>
          <Form.Item label="Title" name="title">
            <Input />
          </Form.Item>
          <Form.Item label="Subtitle" name="subtitle">
            <Input />
          </Form.Item>
          <Form.Item label="Link URL" name="linkUrl">
            <Input placeholder="Optional" />
          </Form.Item>
          <Form.Item label="Sort Order" name="sortOrder" rules={[{ required: true }]}>
            <InputNumber min={0} style={{ width: '100%' }} />
          </Form.Item>
          <Form.Item label="Active" name="isActive" valuePropName="checked">
            <Switch />
          </Form.Item>
        </Form>
      </Modal>
    </Card>
  );
}
