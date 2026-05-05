import { useState } from 'react';
import { Table, Button, Card, Space, Tag, Modal, Form, Input, DatePicker, Select, Switch, message, Popconfirm, Typography } from 'antd';
import { PlusOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { eventsApi, notificationsApi } from '../services/api';
import { qk } from '../lib/queryKeys';
import dayjs from 'dayjs';

const { TextArea } = Input;

export default function Events() {
  const { t } = useTranslation();
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingEvent, setEditingEvent] = useState<any>(null);
  const [form] = Form.useForm();

  const {
    data: events = [],
    isFetching: loading,
  } = useQuery({
    queryKey: qk.events.list(),
    queryFn: async () => (await eventsApi.list()).data,
  });

  const invalidateEvents = () =>
    queryClient.invalidateQueries({ queryKey: qk.events.all });

  const openCreate = () => {
    setEditingEvent(null);
    form.resetFields();
    setModalOpen(true);
  };

  const openEdit = (record: any) => {
    setEditingEvent(record);
    form.setFieldsValue({
      ...record,
      dateRange: [dayjs(record.startDate), dayjs(record.endDate)],
      tags: Array.isArray(record.tags) ? record.tags.join(', ') : record.tags,
    });
    setModalOpen(true);
  };

  const handleSave = async () => {
    try {
      const values = await form.validateFields();
      const { dateRange, ...rest } = values;
      const payload = {
        ...rest,
        startDate: dateRange[0].toISOString(),
        endDate: dateRange[1].toISOString(),
        tags: values.tags ? values.tags.split(',').map((t: string) => t.trim()) : [],
      };

      let res: any = null;
      if (editingEvent) {
        await eventsApi.update(editingEvent.id, payload);
        message.success('Event updated');
      } else {
        res = await eventsApi.create(payload);
        message.success('Event created');
      }
      setModalOpen(false);
      invalidateEvents();

      // After successful save, check if status is 'published'
      if (values.status === 'published') {
        Modal.confirm({
          title: t('notifyOnPublish'),
          content: t('notifyOnPublishDesc'),
          okText: t('sendNotification'),
          cancelText: t('skipNotification'),
          onOk: async () => {
            try {
              await notificationsApi.broadcast({
                titleEn: `New Event: ${values.titleEn}`,
                titleZh: `新会议发布: ${values.titleZh}`,
                bodyEn: `${values.titleEn} has been published. Check it out!`,
                bodyZh: `${values.titleZh} 已发布，快来查看！`,
                type: 'event_update',
                eventId: editingEvent?.id || res?.data?.id,
              });
              message.success(t('notificationSent'));
            } catch {
              message.warning(t('notificationFailed'));
            }
          },
        });
      }
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Failed');
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await eventsApi.delete(id);
      message.success('Event deleted');
      invalidateEvents();
    } catch {
      message.error('Failed to delete event');
    }
  };

  const columns = [
    { title: 'Title (EN)', dataIndex: 'titleEn', key: 'titleEn', width: 200 },
    { title: '标题', dataIndex: 'titleZh', key: 'titleZh', width: 200 },
    { title: 'Location', dataIndex: 'locationEn', key: 'location', width: 200 },
    {
      title: t('common.status'), dataIndex: 'status', key: 'status', width: 100,
      render: (s: string) => <Tag color={s === 'published' ? 'green' : s === 'draft' ? 'orange' : 'default'}>{s}</Tag>,
    },
    { title: 'Featured', dataIndex: 'isFeatured', key: 'featured', width: 80, render: (v: boolean) => v ? <Tag color="blue">Yes</Tag> : '-' },
    {
      title: t('common.actions'), key: 'actions', width: 150,
      render: (_: any, record: any) => (
        <Space>
          <Button icon={<EditOutlined />} size="small" onClick={() => openEdit(record)} />
          <Popconfirm title="Delete this event?" onConfirm={() => handleDelete(record.id)}>
            <Button icon={<DeleteOutlined />} size="small" danger />
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <Card
      title={<Typography.Title level={4} style={{ margin: 0 }}>{t('menu.events')}</Typography.Title>}
      extra={<Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>{t('common.create')}</Button>}
    >
      <Table
        dataSource={events}
        columns={columns}
        rowKey="id"
        loading={loading}
        scroll={{ x: 900 }}
        locale={{ emptyText: 'No events found' }}
      />

      <Modal
        title={editingEvent ? 'Edit Event / 编辑会议' : 'Create Event / 创建会议'}
        open={modalOpen}
        onOk={handleSave}
        onCancel={() => setModalOpen(false)}
        width={700}
        okText={t('common.save')}
        cancelText={t('common.cancel')}
      >
        <Form form={form} layout="vertical">
          <Form.Item label="Title (EN)" name="titleEn" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label="标题 (ZH)" name="titleZh" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label="Date Range / 日期" name="dateRange" rules={[{ required: true }]}>
            <DatePicker.RangePicker style={{ width: '100%' }} />
          </Form.Item>
          <Form.Item label="Location (EN)" name="locationEn">
            <Input />
          </Form.Item>
          <Form.Item label="地点 (ZH)" name="locationZh">
            <Input />
          </Form.Item>
          <Form.Item label="Description (EN)" name="descriptionEn">
            <TextArea rows={3} />
          </Form.Item>
          <Form.Item label="描述 (ZH)" name="descriptionZh">
            <TextArea rows={3} />
          </Form.Item>
          <Form.Item label="Image URL" name="imageUrl">
            <Input />
          </Form.Item>
          <Form.Item label="Tags (comma separated)" name="tags">
            <Input placeholder="Oncology, AI, Innovation" />
          </Form.Item>
          <Form.Item label="Max Attendees" name="maxAttendees">
            <Input type="number" />
          </Form.Item>
          <Form.Item label="Status" name="status" initialValue="draft">
            <Select options={[
              { value: 'draft', label: 'Draft / 草稿' },
              { value: 'published', label: 'Published / 已发布' },
              { value: 'ended', label: 'Ended / 已结束' },
            ]} />
          </Form.Item>
          <Form.Item label="Featured" name="isFeatured" valuePropName="checked">
            <Switch />
          </Form.Item>
        </Form>
      </Modal>
    </Card>
  );
}
