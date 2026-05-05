import { useRef, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Card, Button, Select, Table, Typography, Space, message } from 'antd';
import { DownloadOutlined, FilePdfOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { usersApi, eventsApi, checkInApi } from '../services/api';
import { qk } from '../lib/queryKeys';
import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';

type PdfPayload = {
  title: string;
  headers: string[];
  rows: string[][];
};

export default function DataExport() {
  const { t } = useTranslation();
  const [selectedEventId, setSelectedEventId] = useState('');
  const [loading, setLoading] = useState(false);
  const [pdfPayload, setPdfPayload] = useState<PdfPayload | null>(null);
  const pdfRef = useRef<HTMLDivElement>(null);

  const { data: events = [] } = useQuery({
    queryKey: qk.events.list(),
    queryFn: async () => (await eventsApi.list()).data,
  });
  const { data: users = [] } = useQuery({
    queryKey: qk.users.export(),
    queryFn: async () => (await usersApi.exportUsers()).data,
  });
  const { data: checkIns = [] } = useQuery({
    queryKey: qk.checkin.records(selectedEventId),
    queryFn: async () => (await checkInApi.records(selectedEventId)).data,
    enabled: !!selectedEventId,
  });

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

  const renderAndDownloadPdf = async (filename: string) => {
    const el = pdfRef.current;
    if (!el) return;
    const canvas = await html2canvas(el, {
      scale: 2,
      backgroundColor: '#ffffff',
      logging: false,
      useCORS: true,
    });
    const imgData = canvas.toDataURL('image/jpeg', 0.95);
    const pdf = new jsPDF({ orientation: 'portrait', unit: 'pt', format: 'a4' });
    const pageWidth = pdf.internal.pageSize.getWidth();
    const pageHeight = pdf.internal.pageSize.getHeight();
    const margin = 24;
    const usableWidth = pageWidth - margin * 2;
    const imgWidth = usableWidth;
    const imgHeight = (canvas.height * imgWidth) / canvas.width;

    if (imgHeight <= pageHeight - margin * 2) {
      pdf.addImage(imgData, 'JPEG', margin, margin, imgWidth, imgHeight);
    } else {
      const pageContentHeight = pageHeight - margin * 2;
      let renderedHeight = 0;
      let pageIdx = 0;
      while (renderedHeight < imgHeight) {
        if (pageIdx > 0) pdf.addPage();
        pdf.addImage(
          imgData,
          'JPEG',
          margin,
          margin - renderedHeight,
          imgWidth,
          imgHeight,
        );
        // Mask any overflow above margin / below page
        pdf.setFillColor(255, 255, 255);
        pdf.rect(0, 0, pageWidth, margin, 'F');
        pdf.rect(0, pageHeight - margin, pageWidth, margin, 'F');
        renderedHeight += pageContentHeight;
        pageIdx += 1;
        if (pageIdx > 200) break; // safety: cap at 200 pages
      }
    }
    pdf.save(`${filename}.pdf`);
  };

  const triggerPdf = async (payload: PdfPayload, filename: string) => {
    setLoading(true);
    setPdfPayload(payload);
    try {
      // Wait one paint so the hidden node is in the DOM with full layout.
      await new Promise<void>((resolve) =>
        requestAnimationFrame(() => requestAnimationFrame(() => resolve())),
      );
      await renderAndDownloadPdf(filename);
      message.success(`${filename}.pdf`);
    } catch (e: any) {
      message.error(e?.message || t('common.error'));
    } finally {
      setPdfPayload(null);
      setLoading(false);
    }
  };

  const exportAttendeesPdf = async () => {
    try {
      const res = await usersApi.exportUsers();
      const userList: any[] = res.data || [];
      const headers = ['Email', t('speakers.nameEn'), t('speakers.nameZh'), t('users.role'), t('users.organization')];
      const rows = userList.map((u) => [
        String(u.email ?? ''),
        String(u.nameEn ?? ''),
        String(u.nameZh ?? ''),
        String(u.role ?? ''),
        String(u.organizationEn ?? ''),
      ]);
      await triggerPdf({ title: t('export.attendees'), headers, rows }, 'attendees');
    } catch {
      message.error(t('common.error'));
    }
  };

  const exportCheckInsPdf = async () => {
    const headers = ['Email', 'Name', 'Checked In', 'Time'];
    const rows = checkIns.map((r: any) => [
      String(r.user?.email ?? '-'),
      String(r.user?.nameEn ?? '-'),
      r.checkedIn ? 'Yes' : 'No',
      r.checkedInAt ? new Date(r.checkedInAt).toLocaleString() : '-',
    ]);
    await triggerPdf({ title: t('export.checkin'), headers, rows }, 'check-in-records');
  };

  return (
    <div>
      <Typography.Title level={4}>数据导出 / Data Export</Typography.Title>

      <Space direction="vertical" style={{ width: '100%' }} size="large">
        <Card title="参会者名单导出 / Attendee List Export">
          <p>Total: {users.length} users</p>
          <Space>
            <Button type="primary" icon={<DownloadOutlined />} onClick={exportUsers}>
              导出参会者 Excel / Export Attendees
            </Button>
            <Button icon={<FilePdfOutlined />} loading={loading} onClick={exportAttendeesPdf}>
              {t('export.pdf')}
            </Button>
          </Space>
        </Card>

        <Card title="签到记录导出 / Check-in Records Export">
          <Space style={{ marginBottom: 16 }}>
            <Select
              placeholder="Select Event / 选择会议"
              style={{ width: 300 }}
              value={selectedEventId || undefined}
              onChange={setSelectedEventId}
              options={events.map((e: any) => ({ value: e.id, label: e.titleZh }))}
            />
            <Button type="primary" icon={<DownloadOutlined />} disabled={!selectedEventId || checkIns.length === 0} onClick={exportCheckIns}>
              导出签到 Excel / Export Check-ins
            </Button>
            <Button icon={<FilePdfOutlined />} loading={loading} disabled={!selectedEventId || checkIns.length === 0} onClick={exportCheckInsPdf}>
              {t('export.pdf')}
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

      {pdfPayload && (
        <div
          style={{
            position: 'fixed',
            left: -10000,
            top: 0,
            width: 794,
            background: '#ffffff',
            padding: 24,
            fontFamily: '"PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", Arial, sans-serif',
            color: '#222',
          }}
        >
          <div ref={pdfRef}>
            <h1 style={{ color: '#196EE6', fontSize: 20, margin: '0 0 8px' }}>
              {pdfPayload.title}
            </h1>
            <p style={{ color: '#666', fontSize: 12, margin: '0 0 16px' }}>
              {t('export.generatedAt')}: {new Date().toLocaleString()}
            </p>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
              <thead>
                <tr>
                  {pdfPayload.headers.map((h, i) => (
                    <th
                      key={i}
                      style={{
                        background: '#196EE6',
                        color: '#fff',
                        padding: '8px 10px',
                        textAlign: 'left',
                        border: '1px solid #1a5ec0',
                      }}
                    >
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {pdfPayload.rows.map((row, ri) => (
                  <tr key={ri} style={{ background: ri % 2 === 0 ? '#fff' : '#f7f9fc' }}>
                    {row.map((cell, ci) => (
                      <td
                        key={ci}
                        style={{
                          padding: '6px 10px',
                          border: '1px solid #e5e7eb',
                          wordBreak: 'break-word',
                        }}
                      >
                        {cell || '-'}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
            <div style={{ marginTop: 24, color: '#999', fontSize: 10 }}>
              &copy; {new Date().getFullYear()} APSCVIR Conference
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
