import { useEffect, useMemo, useRef, useState, type ChangeEvent } from 'react';
import { Card, Button, Input, Select, Table, Tag, message, Typography, Space, Statistic, Row, Col, Modal, Alert } from 'antd';
import { ScanOutlined, CheckCircleOutlined, CameraOutlined, UploadOutlined } from '@ant-design/icons';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { BrowserMultiFormatReader, type IScannerControls } from '@zxing/browser';
import { BarcodeFormat, DecodeHintType } from '@zxing/library';
import { eventsApi, checkInApi } from '../services/api';
import { qk } from '../lib/queryKeys';

type CameraDevice = { deviceId: string; label: string };

export default function CheckIn() {
  const queryClient = useQueryClient();
  const [selectedEventId, setSelectedEventId] = useState('');
  const [qrInput, setQrInput] = useState('');
  const [verifyResult, setVerifyResult] = useState<any>(null);
  const [scannerOpen, setScannerOpen] = useState(false);
  const [scannerSupported, setScannerSupported] = useState(true);
  const [scannerStatus, setScannerStatus] = useState('正在启动摄像头… / Starting camera…');
  const [cameras, setCameras] = useState<CameraDevice[]>([]);
  const [activeDeviceId, setActiveDeviceId] = useState<string>('');
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const readerRef = useRef<BrowserMultiFormatReader | null>(null);
  const controlsRef = useRef<IScannerControls | null>(null);
  const fileInputRef = useRef<HTMLInputElement | null>(null);
  // Avoid double-verify if zxing fires the success callback more than once
  // before we have a chance to stop the scan loop.
  const verifiedRef = useRef(false);

  const isSecureContext = useMemo(() => {
    if (typeof window === 'undefined') return true;
    if (window.isSecureContext) return true;
    const host = window.location.hostname;
    return host === 'localhost' || host === '127.0.0.1' || host === '::1';
  }, []);

  const { data: events = [] } = useQuery({
    queryKey: qk.events.list(),
    queryFn: async () => (await eventsApi.list()).data,
  });
  const {
    data: records = [],
    isFetching: loading,
  } = useQuery({
    queryKey: qk.checkin.records(selectedEventId),
    queryFn: async () => (await checkInApi.records(selectedEventId)).data,
    enabled: !!selectedEventId,
  });
  const { data: stats = { checkedInCount: 0, totalSubscribers: 0, rate: 0 } } =
    useQuery({
      queryKey: qk.checkin.stats(selectedEventId),
      queryFn: async () => (await checkInApi.stats(selectedEventId)).data,
      enabled: !!selectedEventId,
    });

  useEffect(() => {
    if (scannerOpen) {
      verifiedRef.current = false;
      void startScanner();
      return;
    }
    stopScanner();
  }, [scannerOpen]);

  // When the operator picks a different camera mid-session, restart with the
  // new device id.
  useEffect(() => {
    if (!scannerOpen || !activeDeviceId) return;
    void restartWithDevice(activeDeviceId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeDeviceId]);

  useEffect(() => () => stopScanner(), []);

  const refreshCheckIn = () => {
    if (!selectedEventId) return;
    queryClient.invalidateQueries({ queryKey: qk.checkin.records(selectedEventId) });
    queryClient.invalidateQueries({ queryKey: qk.checkin.stats(selectedEventId) });
  };

  const createQrReader = () => {
    const hints = new Map();
    hints.set(DecodeHintType.POSSIBLE_FORMATS, [BarcodeFormat.QR_CODE]);
    return new BrowserMultiFormatReader(hints);
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
      refreshCheckIn();
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Verification failed');
      setVerifyResult({ message: 'Failed', error: true });
    }
  };

  const stopScanner = () => {
    try {
      controlsRef.current?.stop();
    } catch {
      // zxing throws if already stopped — ignore.
    }
    controlsRef.current = null;
    readerRef.current = null;

    if (videoRef.current) {
      const stream = videoRef.current.srcObject as MediaStream | null;
      stream?.getTracks().forEach((t) => t.stop());
      videoRef.current.pause();
      videoRef.current.srcObject = null;
    }
  };

  const onDecodeResult = (text: string) => {
    if (verifiedRef.current) return;
    verifiedRef.current = true;
    setQrInput(text);
    setScannerStatus('已识别二维码，正在核验… / QR captured, verifying…');
    setScannerOpen(false);
    setTimeout(() => {
      void handleVerifyWithValue(text);
    }, 0);
  };

  const beginDecodeFromDevice = async (deviceId: string) => {
    if (!videoRef.current) return;
    const reader = readerRef.current;
    if (!reader) return;
    controlsRef.current = await reader.decodeFromVideoDevice(
      deviceId || undefined,
      videoRef.current,
      (result, err, controls) => {
        if (result) {
          const text = result.getText().trim();
          if (text) {
            controls.stop();
            onDecodeResult(text);
          }
        }
        // err is a NotFoundException for every empty frame — that's normal,
        // ignore it. Only surface unexpected errors.
        if (err && err.name && err.name !== 'NotFoundException' && err.name !== 'NotFoundException2') {
          // eslint-disable-next-line no-console
          console.warn('[scanner] decode error', err);
        }
      },
    );
  };

  const restartWithDevice = async (deviceId: string) => {
    try {
      controlsRef.current?.stop();
    } catch {
      // ignore
    }
    controlsRef.current = null;
    if (!readerRef.current) return;
    setScannerStatus('正在切换摄像头… / Switching camera…');
    try {
      await beginDecodeFromDevice(deviceId);
      setScannerStatus('摄像头已就绪，请把二维码对准画面 / Camera ready — point the QR at the frame');
    } catch (e: unknown) {
      handleStartFailure(e);
    }
  };

  const handleStartFailure = (e: unknown) => {
    setScannerSupported(false);
    const err = e as { name?: string; message?: string };
    if (!isSecureContext) {
      setScannerStatus(
        '⚠ 浏览器不允许在 HTTP/IP 直连下调用摄像头。请用 HTTPS 域名或 localhost 访问，或继续使用粘贴模式。 / Browsers block camera over plain HTTP — use HTTPS or localhost.',
      );
      return;
    }
    switch (err?.name) {
      case 'NotAllowedError':
      case 'SecurityError':
        setScannerStatus(
          '摄像头权限被拒绝，请在浏览器地址栏的权限设置里允许后重试。 / Camera permission denied — allow it in the address-bar site settings.',
        );
        break;
      case 'NotFoundError':
      case 'OverconstrainedError':
        setScannerStatus(
          '未检测到可用摄像头，请检查设备或换一台带摄像头的电脑。 / No camera detected on this device.',
        );
        break;
      case 'NotReadableError':
        setScannerStatus(
          '摄像头被其他应用占用，请关闭占用程序后重试。 / Camera is in use by another app.',
        );
        break;
      default:
        setScannerStatus(
          `无法启动摄像头：${err?.message || err?.name || 'unknown error'}。可继续使用粘贴模式。`,
        );
    }
  };

  const startScanner = async () => {
    if (!navigator.mediaDevices?.getUserMedia) {
      setScannerSupported(false);
      setScannerStatus(
        '当前浏览器不支持摄像头访问 API（navigator.mediaDevices）。请改用 Chrome/Edge，或继续使用粘贴模式。',
      );
      return;
    }
    if (!isSecureContext) {
      setScannerSupported(false);
      setScannerStatus(
        '⚠ 浏览器只允许在 HTTPS 或 localhost 下访问摄像头。当前页面是 HTTP/IP，请用 HTTPS 域名或本机访问后再试。',
      );
      return;
    }

    setScannerSupported(true);
    setScannerStatus('正在启动摄像头… / Starting camera…');

    try {
      // First trigger a permission prompt with a generic constraint so that
      // listVideoInputDevices() can return labeled devices afterwards.
      const probe = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: { ideal: 'environment' } },
        audio: false,
      });
      probe.getTracks().forEach((t) => t.stop());

      const devices = await BrowserMultiFormatReader.listVideoInputDevices();
      const cams: CameraDevice[] = devices.map((d) => ({
        deviceId: d.deviceId,
        label: d.label || '未命名摄像头 / Unnamed camera',
      }));
      setCameras(cams);
      if (cams.length === 0) {
        setScannerSupported(false);
        setScannerStatus('未找到摄像头设备 / No camera found');
        return;
      }
      const back = cams.find((d) => /back|rear|environment|后置|背|外置/i.test(d.label));
      const chosen = back?.deviceId ?? cams[0].deviceId;
      setActiveDeviceId(chosen);

      const hints = new Map();
      hints.set(DecodeHintType.POSSIBLE_FORMATS, [BarcodeFormat.QR_CODE]);
      readerRef.current = new BrowserMultiFormatReader(hints);

      await beginDecodeFromDevice(chosen);
      setScannerStatus('摄像头已就绪，请把二维码对准画面 / Camera ready — point the QR at the frame');
    } catch (e) {
      handleStartFailure(e);
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
      refreshCheckIn();
    } catch (err: any) {
      message.error(err.response?.data?.message || 'Verification failed');
      setVerifyResult({ message: 'Failed', error: true });
    }
  };

  const handleQrImageSelected = async (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    event.target.value = '';
    if (!file) return;
    if (!file.type.startsWith('image/')) {
      message.warning('请选择二维码图片 / Please choose a QR image');
      return;
    }

    const url = URL.createObjectURL(file);
    try {
      const result = await createQrReader().decodeFromImageUrl(url);
      const text = result.getText().trim();
      if (!text) {
        throw new Error('Empty QR result');
      }
      setQrInput(text);
      await handleVerifyWithValue(text);
    } catch {
      message.error('未能识别二维码，请换一张清晰图片或手动粘贴二维码内容');
      setVerifyResult({ message: 'Failed to decode QR image', error: true });
    } finally {
      URL.revokeObjectURL(url);
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
              {!isSecureContext && (
                <Alert
                  type="warning"
                  showIcon
                  message="当前 HTTP/IP 地址不能直接调用浏览器摄像头。请使用“拍照/上传识别”或粘贴二维码内容；实时摄像头扫码需要 HTTPS 域名。"
                />
              )}
              <Input.TextArea
                rows={3}
                placeholder="Paste QR code content here / 在此粘贴QR码内容..."
                value={qrInput}
                onChange={e => setQrInput(e.target.value)}
                onPressEnter={handleVerify}
              />
              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                capture="environment"
                style={{ display: 'none' }}
                onChange={handleQrImageSelected}
              />
              <Space wrap>
                <Button icon={<CameraOutlined />} size="large" onClick={() => setScannerOpen(true)}>
                  摄像头扫码
                </Button>
                <Button icon={<UploadOutlined />} size="large" onClick={() => fileInputRef.current?.click()}>
                  拍照/上传识别
                </Button>
                <Button type="primary" icon={<ScanOutlined />} size="large" onClick={handleVerify}>
                  验证签到
                </Button>
              </Space>
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
              options={events.map((e: any) => ({ value: e.id, label: `${e.titleZh}` }))}
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
        width={560}
      >
        <Space direction="vertical" size="middle" style={{ width: '100%' }}>
          <Alert
            type={scannerSupported ? 'info' : 'warning'}
            showIcon
            message={scannerStatus}
          />
          {cameras.length > 1 && (
            <Select
              style={{ width: '100%' }}
              value={activeDeviceId || undefined}
              placeholder="选择摄像头 / Choose a camera"
              onChange={(v) => setActiveDeviceId(v)}
              options={cameras.map((c) => ({ value: c.deviceId, label: c.label }))}
            />
          )}
          <div style={{ borderRadius: 12, overflow: 'hidden', background: '#000', aspectRatio: '4 / 3' }}>
            <video
              ref={videoRef}
              muted
              playsInline
              autoPlay
              style={{ width: '100%', height: '100%', objectFit: 'cover' }}
            />
          </div>
          {!scannerSupported && (
            <Button
              type="primary"
              onClick={() => {
                setScannerSupported(true);
                void startScanner();
              }}
            >
              重试 / Retry
            </Button>
          )}
          <Typography.Text type="secondary" style={{ fontSize: 12 }}>
            将参会者 App 上的动态二维码对准画面中央，识别后会自动核验。若浏览器仍提示不支持，请检查访问地址是 HTTPS、并在浏览器站点权限里允许摄像头。
          </Typography.Text>
        </Space>
      </Modal>
    </div>
  );
}
