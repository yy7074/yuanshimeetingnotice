import { useState } from 'react';
import { Card, Button, Upload, Table, Tag, message, Typography, Space, Alert } from 'antd';
import { UploadOutlined, ImportOutlined } from '@ant-design/icons';
import { usersApi } from '../services/api';
import * as XLSX from 'xlsx';

export default function ImportAttendees() {
  const [parsedData, setParsedData] = useState<any[]>([]);
  const [importing, setImporting] = useState(false);
  const [result, setResult] = useState<any>(null);

  const handleFile = (file: File) => {
    const reader = new FileReader();
    reader.onload = (e) => {
      try {
        const data = new Uint8Array(e.target?.result as ArrayBuffer);
        const workbook = XLSX.read(data, { type: 'array' });
        const sheet = workbook.Sheets[workbook.SheetNames[0]];
        const json = XLSX.utils.sheet_to_json<any>(sheet);

        // Map common column names
        const mapped = json.map((row: any) => ({
          email: row.email || row.Email || row['邮箱'] || '',
          nameEn: row.nameEn || row['Name'] || row['Name (EN)'] || '',
          nameZh: row.nameZh || row['姓名'] || row['Name (ZH)'] || '',
          role: row.role || row['Role'] || row['角色'] || 'attendee',
          organizationEn: row.organizationEn || row['Organization'] || '',
          organizationZh: row.organizationZh || row['机构'] || '',
        }));

        setParsedData(mapped);
        setResult(null);
        message.success(`Parsed ${mapped.length} rows`);
      } catch {
        message.error('Failed to parse file');
      }
    };
    reader.readAsArrayBuffer(file);
    return false; // prevent default upload
  };

  const handleImport = async () => {
    if (parsedData.length === 0) return;
    setImporting(true);
    try {
      await usersApi.list(); // Confirm auth before import to surface a clean 401 if needed.
      const res = await usersApi.importAttendees(parsedData);
      setResult(res.data);
      message.success(`Import complete: ${res.data.created} created, ${res.data.skipped} skipped`);
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Import failed');
    }
    setImporting(false);
  };

  const columns = [
    { title: 'Email', dataIndex: 'email', key: 'email' },
    { title: 'Name (EN)', dataIndex: 'nameEn', key: 'nameEn' },
    { title: '姓名', dataIndex: 'nameZh', key: 'nameZh' },
    {
      title: 'Role', dataIndex: 'role', key: 'role',
      render: (r: string) => <Tag color={r === 'vip' ? 'gold' : r === 'speaker' ? 'blue' : 'default'}>{r}</Tag>,
    },
    { title: 'Organization', dataIndex: 'organizationEn', key: 'org' },
  ];

  return (
    <div>
      <Typography.Title level={4}>导入参会者 / Import Attendees</Typography.Title>

      <Space direction="vertical" style={{ width: '100%' }} size="large">
        <Card>
          <Alert
            message="Excel/CSV 格式说明 / File Format"
            description="Required columns: email. Optional: nameEn, nameZh, role (attendee/speaker/vip), organizationEn, organizationZh. 必填列：email（邮箱）。可选列：姓名、角色、机构。"
            type="info"
            showIcon
            style={{ marginBottom: 16 }}
          />
          <Space>
            <Upload beforeUpload={handleFile} accept=".xlsx,.xls,.csv" showUploadList={false}>
              <Button icon={<UploadOutlined />} size="large">
                选择 Excel/CSV 文件 / Select File
              </Button>
            </Upload>
            <Button
              type="primary"
              icon={<ImportOutlined />}
              size="large"
              disabled={parsedData.length === 0}
              loading={importing}
              onClick={handleImport}
            >
              导入 {parsedData.length} 条记录 / Import
            </Button>
          </Space>
        </Card>

        {result && (
          <Alert
            message="Import Result / 导入结果"
            description={`Created: ${result.created} | Skipped (duplicate): ${result.skipped} | Errors: ${result.errors?.length || 0}`}
            type={result.errors?.length > 0 ? 'warning' : 'success'}
            showIcon
          />
        )}

        {parsedData.length > 0 && (
          <Card title={`Preview / 预览 (${parsedData.length} rows)`}>
            <Table dataSource={parsedData} columns={columns} rowKey={(_, i) => `${i}`} size="small" pagination={{ pageSize: 10 }} />
          </Card>
        )}
      </Space>
    </div>
  );
}
