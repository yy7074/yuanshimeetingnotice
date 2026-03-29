import { useEffect, useState } from 'react';
import { Card, Button, Select, Table, Typography, Space, message } from 'antd';
import { DownloadOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { usersApi, eventsApi, checkInApi } from '../services/api';
import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';

export default function DataExport() {
  const { t } = useTranslation();
  const [events, setEvents] = useState<any[]>([]);
  const [users, setUsers] = useState<any[]>([]);
  const [selectedEventId, setSelectedEventId] = useState('');
  const [checkIns, setCheckIns] = useState<any[]>([]);

  useEffect(() => {
    eventsApi.list().then(r => setEvents(r.data)).catch(() => {});
    usersApi.list().then(r => setUsers(r.data)).catch(() => {});
  }, []);

  useEffect(() => {
    if (selectedEventId) {
      checkInApi.records(selectedEventId).then(r => setCheckIns(r.data)).catch(() => {});
    }
  }, [selectedEventId]);

  const exportToExcel = (data: any[], filename: string, headers: Record<string, string>) => {
    const mapped = data.map(row => {
      const obj: any = {};
      Object.entries(headers).forEach(([key, label]) => {
        const keys = key.split('.');
        let val = row;
        for (const k of keys) val = val?.[k];
        obj[label] = val ?? '';
      });
      return obj;
    });
    const ws = XLSX.utils.json_to_sheet(mapped);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
    const buf = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
    saveAs(new Blob([buf], { type: 'application/octet-stream' }), `${filename}.xlsx`);
    message.success(`Exported ${filename}.xlsx`);
  };

  const exportUsers = () => {
    exportToExcel(users, 'attendees', {
      'email': 'Email',
      'nameEn': 'Name (EN)',
      'nameZh': '姓名',
      'role': 'Role',
      'organizationEn': 'Organization',
      'organizationZh': '机构',
      'isActive': 'Active',
      'createdAt': 'Created At',
    });
  };

  const exportCheckIns = () => {
    exportToExcel(checkIns, 'check-in-records', {
      'user.email': 'Email',
      'user.nameEn': 'Name',
      'checkedIn': 'Checked In',
      'checkedInAt': 'Time',
    });
  };

  return (
    <div>
      <Typography.Title level={4}>数据导出 / Data Export</Typography.Title>

      <Space direction="vertical" style={{ width: '100%' }} size="large">
        <Card title="参会者名单导出 / Attendee List Export">
          <p>Total: {users.length} users</p>
          <Button type="primary" icon={<DownloadOutlined />} onClick={exportUsers}>
            导出参会者 Excel / Export Attendees
          </Button>
        </Card>

        <Card title="签到记录导出 / Check-in Records Export">
          <Space style={{ marginBottom: 16 }}>
            <Select
              placeholder="Select Event / 选择会议"
              style={{ width: 300 }}
              value={selectedEventId || undefined}
              onChange={setSelectedEventId}
              options={events.map(e => ({ value: e.id, label: e.titleZh }))}
            />
            <Button type="primary" icon={<DownloadOutlined />} disabled={!selectedEventId || checkIns.length === 0} onClick={exportCheckIns}>
              导出签到 Excel / Export Check-ins
            </Button>
          </Space>
          {selectedEventId && (
            <Table
              dataSource={checkIns}
              columns={[
                { title: 'Email', key: 'email', render: (_: any, r: any) => r.user?.email || '-' },
                { title: 'Name', key: 'name', render: (_: any, r: any) => r.user?.nameEn || '-' },
                { title: 'Time', dataIndex: 'checkedInAt', key: 'time', render: (v: string) => new Date(v).toLocaleString() },
              ]}
              rowKey="id"
              size="small"
            />
          )}
        </Card>
      </Space>
    </div>
  );
}
