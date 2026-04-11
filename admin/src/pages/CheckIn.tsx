import { useEffect, useRef, useState } from 'react';
import { Card, Button, Input, Select, Table, Tag, message, Typography, Space, Statistic, Row, Col, Modal, Alert } from 'antd';
import { ScanOutlined, CheckCircleOutlined, CameraOutlined } from '@ant-design/icons';
import { eventsApi, checkInApi } from '../services/api';

type SimpleBarcode = { rawValue?: string };
type BarcodeDetectorInstance = { detect: (source: ImageBitmapSource) => Promise<SimpleBarcode[]> };
type BarcodeDetectorCtor = new (options?: { formats?: string[] }) => BarcodeDetectorInstance;

export default function CheckIn() {
  const [events, setEvents] = useState<any[]>([]);
  const [selectedEventId, setSelectedEventId] = useState('');
  const [qrInput, setQrInput] = useState('');
  const [records, setRecords] = useState<any[]>([]);
  const [stats, setStats] = useState({ checkedInCount: 0, totalSubscribers: 0, rate: 0 });
  const [verifyResult, setVerifyResult] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [scannerOpen, setScannerOpen] = useState(false);
  const [scannerSupported, setScannerSupported] = useState(true);
  const [scannerStatus, setScannerStatus] = useState('Camera is starting...');
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const detectorRef = useRef<BarcodeDetectorInstance | null>(null);
  const scanFrameRef = useRef<number | null>(null);
  const isScanningRef = useRef(false);

  useEffect(() => {
    eventsApi.list().then(r => setEvents(r.data)).catch(() => {});
  }, []);

  useEffect(() => {
    if (scannerOpen) {
      void startScanner();
      return;
    }

    stopScanner();
  }, [scannerOpen]);

  useEffect(() => () => stopScanner(), []);

  useEffect(() => {
    if (selectedEventId) {
      fetchRecords();
      fetchStats();
    }
  }, [selectedEventId]);

  const fetchRecords = async () => {
    setLoading(true);
    try { const { data } = await checkInApi.records(selectedEventId); setRecords(data); } catch { message.error('Failed to load check-in records'); }
    setLoading(false);
  };

  const fetchStats = async () => {
    try { const { data } = await checkInApi.stats(selectedEventId); setStats(data); } catch { message.error('Failed to load check-in stats'); }
  };

  const handleVerify = async () => {
    if (!qrInput.trim()) {
      message.warning('Please enter or scan a QR code');
      return;
    }
    try {
      const { data } = await checkInApi.verify(qrInput.trim());
      setVerifyResult(data);
      message.success(data.message);
      setQrInput('');
      if (selectedEventId) {
        fetchRecords();
        fetchStats();
      }
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Verification failed');
      setVerifyResult({ message: 'Failed', error: true });
    }
  };

  const getBarcodeDetectorClass = () => {
    return (window as Window & { BarcodeDetector?: BarcodeDetectorCtor }).BarcodeDetector;
  };

  const stopScanner = () => {
    isScanningRef.current = false;

    if (scanFrameRef.current !== null) {
      cancelAnimationFrame(scanFrameRef.current);
      scanFrameRef.current = null;
    }

    streamRef.current?.getTracks().forEach((track) => track.stop());
    streamRef.current = null;

    if (videoRef.current) {
      videoRef.current.pause();
      videoRef.current.srcObject = null;
    }
  };

  const scanFrame = async () => {
    if (!isScanningRef.current || !videoRef.current || !detectorRef.current) {
      return;
    }

    const video = videoRef.current;
    if (video.readyState >= HTMLMediaElement.HAVE_CURRENT_DATA) {
      try {
        const results = await detectorRef.current.detect(video);
        const rawValue = results.find((item) => !!item.rawValue)?.rawValue?.trim();
        if (rawValue) {
          setQrInput(rawValue);
          setScannerStatus('QR code captured. Verifying...');
          setScannerOpen(false);
          setTimeout(() => {
            void handleVerifyWithValue(rawValue);
          }, 0);
          return;
        }
      } catch {
        setScannerStatus('Camera is active. Hold the QR code inside the frame.');
      }
    }

    scanFrameRef.current = requestAnimationFrame(() => {
      void scanFrame();
    });
  };

  const startScanner = async () => {
    const BarcodeDetectorClass = getBarcodeDetectorClass();
    if (!BarcodeDetectorClass || !navigator.mediaDevices?.getUserMedia) {
      setScannerSupported(false);
      setScannerStatus('This browser does not support camera QR scanning. Please paste the QR text manually.');
      return;
    }

    try {
      setScannerSupported(true);
      setScannerStatus('Camera is starting...');
      detectorRef.current = new BarcodeDetectorClass({ formats: ['qr_code'] });
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: 'environment' },
        audio: false,
      });

      streamRef.current = stream;
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        await videoRef.current.play();
      }

      isScanningRef.current = true;
      setScannerStatus('Camera is active. Hold the QR code inside the frame.');
      void scanFrame();
    } catch {
      setScannerSupported(false);
      setScannerStatus('Unable to access the camera. Please check browser permissions or paste the QR text manually.');
      stopScanner();
    }
  };

  const handleVerifyWithValue = async (value: string) => {
    if (!value.trim()) return;
    try {
      const { data } = await checkInApi.verify(value.trim());
      setVerifyResult(data);
      message.success(data.message);
      setQrInput('');
      if (selectedEventId) {
        fetchRecords();
        fetchStats();
      }
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Verification failed');
      setVerifyResult({ message: 'Failed', error: true });
    }
  };

  const columns = [
    { title: 'User', key: 'user', render: (_: any, r: any) => r.user ? `${r.user.nameEn || r.user.email}` : r.userId },
    { title: 'Email', key: 'email', render: (_: any, r: any) => r.user?.email || '-' },
    {
      title: 'Status', key: 'status',
      render: (_: any, r: any) => r.checkedIn ? <Tag color="green">Checked In</Tag> : <Tag>Pending</Tag>,
    },
    {
      title: 'Time', dataIndex: 'checkedInAt', key: 'time',
      render: (v: string) => new Date(v).toLocaleString(),
    },
  ];

  return (
    <div>
      <Typography.Title level={4}>签到管理 / Check-in Management</Typography.Title>

      <Row gutter={[16, 16]}>
        <Col xs={24} lg={12}>
          <Card title="扫码验证 / QR Verification">
            <Space direction="vertical" style={{ width: '100%' }} size="large">
              <Input.TextArea
                rows={3}
                placeholder="Paste QR code content here / 在此粘贴QR码内容..."
                value={qrInput}
                onChange={e => setQrInput(e.target.value)}
                onPressEnter={handleVerify}
              />
              <Space.Compact block>
                <Button icon={<CameraOutlined />} size="large" onClick={() => setScannerOpen(true)} style={{ width: '38%' }}>
                  打开摄像头 / Scan
                </Button>
                <Button type="primary" icon={<ScanOutlined />} size="large" style={{ width: '62%' }} onClick={handleVerify}>
                  验证签到 / Verify Check-in
                </Button>
              </Space.Compact>
              {verifyResult && (
                <div style={{
                  padding: 16, borderRadius: 8,
                  background: verifyResult.error ? '#fff2f0' : '#f6ffed',
                  border: `1px solid ${verifyResult.error ? '#ffccc7' : '#b7eb8f'}`,
                }}>
                  <Space>
                    <CheckCircleOutlined style={{ color: verifyResult.error ? '#ff4d4f' : '#52c41a', fontSize: 24 }} />
                    <span style={{ fontSize: 16, fontWeight: 'bold' }}>{verifyResult.message}</span>
                  </Space>
                </div>
              )}
            </Space>
          </Card>
        </Col>
        <Col xs={24} lg={12}>
          <Card title="签到统计 / Stats">
            <Select
              placeholder="Select Event / 选择会议"
              style={{ width: '100%', marginBottom: 16 }}
              value={selectedEventId || undefined}
              onChange={setSelectedEventId}
              options={events.map(e => ({ value: e.id, label: `${e.titleZh}` }))}
            />
            <Row gutter={[16, 16]}>
              <Col xs={24} md={8}>
                <Statistic title="已签到 / Checked In" value={stats.checkedInCount} prefix={<CheckCircleOutlined />} valueStyle={{ color: '#52c41a' }} />
              </Col>
              <Col xs={24} md={8}>
                <Statistic title="报名人数 / Subscribers" value={stats.totalSubscribers} />
              </Col>
              <Col xs={24} md={8}>
                <Statistic title="签到率 / Rate" value={stats.rate} suffix="%" />
              </Col>
            </Row>
          </Card>
        </Col>
      </Row>

      {selectedEventId && (
        <Card title="签到记录 / Records" style={{ marginTop: 16 }}>
          <Table
            dataSource={records}
            columns={columns}
            rowKey="id"
            loading={loading}
            locale={{ emptyText: 'No check-in records' }}
          />
        </Card>
      )}

      <Modal
        title="摄像头扫码 / Camera Scanner"
        open={scannerOpen}
        onCancel={() => setScannerOpen(false)}
        footer={null}
        destroyOnHidden
      >
        <Space direction="vertical" size="middle" style={{ width: '100%' }}>
          <Alert
            type={scannerSupported ? 'info' : 'warning'}
            showIcon
            message={scannerStatus}
          />
          <div style={{ borderRadius: 12, overflow: 'hidden', background: '#000', aspectRatio: '4 / 3' }}>
            <video
              ref={videoRef}
              muted
              playsInline
              style={{ width: '100%', height: '100%', objectFit: 'cover' }}
            />
          </div>
          <Typography.Text type="secondary">
            将动态二维码置于画面中央，识别后会自动完成核验。若浏览器不支持，请继续使用手动粘贴模式。
          </Typography.Text>
        </Space>
      </Modal>
    </div>
  );
}
