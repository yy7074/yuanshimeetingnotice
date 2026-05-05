import { useState } from 'react';
import { Table, Button, Card, Space, Tag, Modal, Form, Input, Select, InputNumber, DatePicker, message, Popconfirm, Typography } from 'antd';
import { PlusOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { eventsApi, sessionsApi, speakersApi } from '../services/api';
import { qk } from '../lib/queryKeys';
import dayjs from 'dayjs';

export default function Sessions() {
  const { t } = useTranslation();
  const queryClient = useQueryClient();
  const [selectedEventId, setSelectedEventId] = useState('');
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [form] = Form.useForm();

  const { data: events = [] } = useQuery({
    queryKey: qk.events.list(),
    queryFn: async () => (await eventsApi.list()).data,
  });
  const { data: speakers = [] } = useQuery({
    queryKey: qk.speakers.list(),
    queryFn: async () => (await speakersApi.list()).data,
  });
  const {
    data: sessions = [],
    isFetching: loading,
  } = useQuery({
    queryKey: qk.sessions.listByEvent(selectedEventId),
    queryFn: async () => (await sessionsApi.list(selectedEventId)).data,
    enabled: !!selectedEventId,
  });
  const invalidateSessions = () =>
    queryClient.invalidateQueries({ queryKey: qk.sessions.listByEvent(selectedEventId) });

  const openCreate = () => { setEditing(null); form.resetFields(); setModalOpen(true); };
  const openEdit = (r: any) => {
    setEditing(r);
    form.setFieldsValue({
      ...r,
      speakerId: r.speakerId || r.speaker?.id,
      timeRange: [dayjs(r.startTime), dayjs(r.endTime)],
    });
    setModalOpen(true);
  };

  const handleSpeakerSelect = (speakerId?: string) => {
    if (!speakerId) return;
    const speaker = speakers.find((item: any) => item.id === speakerId);
    if (!speaker) return;

    form.setFieldsValue({
      speakerId: speaker.id,
      speakerName: speaker.nameEn || speaker.nameZh || '',
      speakerTitleEn: speaker.titleEn || '',
      speakerTitleZh: speaker.titleZh || '',
      speakerAvatarUrl: speaker.avatarUrl || '',
    });
  };

  const handleSave = async () => {
    try {
      const values = await form.validateFields();
      const { timeRange, ...rest } = values;
      const payload = {
        ...rest,
        startTime: timeRange[0].toISOString(),
        endTime: timeRange[1].toISOString(),
      };
      if (editing) {
        await sessionsApi.update(selectedEventId, editing.id, payload);
        message.success('Session updated');
      } else {
        await sessionsApi.create(selectedEventId, payload);
        message.success('Session created');
      }
      setModalOpen(false);
      invalidateSessions();
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Failed');
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await sessionsApi.delete(selectedEventId, id);
      message.success('Deleted');
      invalidateSessions();
    } catch {
      message.error('Failed to delete session');
    }
  };

  const typeColors: Record<string, string> = {
    keynote: 'gold', research_paper: 'blue', workshop: 'green', panel: 'purple', break: 'default',
  };

  const columns = [
    { title: 'Day', dataIndex: 'dayIndex', key: 'day', width: 60, render: (v: number) => `Day ${v + 1}` },
    { title: 'Title (EN)', dataIndex: 'titleEn', key: 'titleEn', width: 200 },
    { title: '标题', dataIndex: 'titleZh', key: 'titleZh', width: 200 },
    {
      title: 'Time', key: 'time', width: 160,
      render: (_: any, r: any) => `${dayjs(r.startTime).format('HH:mm')} - ${dayjs(r.endTime).format('HH:mm')}`,
    },
    { title: 'Room', dataIndex: 'roomEn', key: 'room', width: 120 },
    {
      title: 'Type', dataIndex: 'type', key: 'type', width: 120,
      render: (t: string) => <Tag color={typeColors[t] || 'default'}>{t.replace('_', ' ').toUpperCase()}</Tag>,
    },
    { title: 'Speaker', dataIndex: 'speakerName', key: 'speaker', width: 150 },
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
      title={<Typography.Title level={4} style={{ margin: 0 }}>议程管理 / Sessions</Typography.Title>}
      extra={
        <Space>
          <Select
            placeholder="Select Event / 选择会议"
            style={{ width: 300 }}
            value={selectedEventId || undefined}
            onChange={setSelectedEventId}
            options={events.map((e: any) => ({ value: e.id, label: `${e.titleZh} (${e.titleEn})` }))}
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
        <Table
          dataSource={sessions}
          columns={columns}
          rowKey="id"
          loading={loading}
          scroll={{ x: 1200 }}
          locale={{ emptyText: 'No sessions found' }}
        />
      )}

      <Modal
        title={editing ? 'Edit Session / 编辑议程' : 'Create Session / 添加议程'}
        open={modalOpen} onOk={handleSave} onCancel={() => setModalOpen(false)} width={700}
        okText={t('common.save')} cancelText={t('common.cancel')}
      >
        <Form form={form} layout="vertical">
          <Form.Item label="Title (EN)" name="titleEn" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item label="标题 (ZH)" name="titleZh" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item label="Time Range / 时间" name="timeRange" rules={[{ required: true }]}>
            <DatePicker.RangePicker showTime format="YYYY-MM-DD HH:mm" style={{ width: '100%' }} />
          </Form.Item>
          <Space style={{ width: '100%' }} size="large">
            <Form.Item label="Room (EN)" name="roomEn" style={{ flex: 1 }}><Input /></Form.Item>
            <Form.Item label="教室 (ZH)" name="roomZh" style={{ flex: 1 }}><Input /></Form.Item>
          </Space>
          <Space style={{ width: '100%' }} size="large">
            <Form.Item label="Type / 类型" name="type" initialValue="keynote">
              <Select style={{ width: 200 }} options={[
                { value: 'keynote', label: 'Keynote / 主旨演讲' },
                { value: 'research_paper', label: 'Research Paper / 学术论文' },
                { value: 'workshop', label: 'Workshop / 工作坊' },
                { value: 'panel', label: 'Panel / 圆桌论坛' },
                { value: 'break', label: 'Break / 休息' },
              ]} />
            </Form.Item>
            <Form.Item label="Day Index" name="dayIndex" initialValue={0}>
              <InputNumber min={0} />
            </Form.Item>
          </Space>
          <Form.Item label="Speaker / 嘉宾" name="speakerId">
            <Select
              allowClear
              showSearch
              placeholder="Select existing speaker / 选择已创建嘉宾"
              optionFilterProp="label"
              onChange={handleSpeakerSelect}
              options={speakers.map((speaker: any) => ({
                value: speaker.id,
                label: `${speaker.nameEn || speaker.nameZh} (${speaker.organizationEn || speaker.organizationZh || 'No organization'})`,
              }))}
            />
          </Form.Item>
          <Form.Item label="Speaker Name" name="speakerName"><Input /></Form.Item>
          <Space style={{ width: '100%' }} size="large">
            <Form.Item label="Speaker Title (EN)" name="speakerTitleEn" style={{ flex: 1 }}><Input /></Form.Item>
            <Form.Item label="嘉宾头衔 (ZH)" name="speakerTitleZh" style={{ flex: 1 }}><Input /></Form.Item>
          </Space>
          <Form.Item label="Speaker Avatar URL" name="speakerAvatarUrl"><Input /></Form.Item>
          <Form.Item label="Description (EN)" name="descriptionEn"><Input.TextArea rows={2} /></Form.Item>
          <Form.Item label="描述 (ZH)" name="descriptionZh"><Input.TextArea rows={2} /></Form.Item>
        </Form>
      </Modal>
    </Card>
  );
}
