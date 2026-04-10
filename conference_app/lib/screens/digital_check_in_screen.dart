import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import '../controllers/auth_controller.dart';
import '../controllers/event_controller.dart';
import '../services/api_service.dart';

class DigitalCheckInScreen extends StatefulWidget {
  const DigitalCheckInScreen({super.key});

  @override
  State<DigitalCheckInScreen> createState() => _DigitalCheckInScreenState();
}

class _DigitalCheckInScreenState extends State<DigitalCheckInScreen> {
  int _secondsRemaining = 30;
  Timer? _timer;
  String _qrData = '';
  String? _selectedEventId;
  List<Map<String, dynamic>> _checkInHistory = [];

  @override
  void initState() {
    super.initState();
    // Auto-select current event if available
    final eventCtrl = Get.find<EventController>();
    if (eventCtrl.myEvents.isNotEmpty) {
      _selectedEventId = eventCtrl.myEvents.first.id;
    }
    _generateQr();
    _startTimer();
    _loadCheckInHistory();
  }

  Future<void> _generateQr() async {
    if (_selectedEventId == null) {
      _qrData = '';
      if (mounted) setState(() {});
      return;
    }

    try {
      final auth = Get.find<AuthController>();
      final userId = auth.currentUser.value?.id ?? 'unknown';
      final eventId = _selectedEventId!;
      // Generate local QR data
      _qrData = '$userId:$eventId:local:${DateTime.now().millisecondsSinceEpoch}';

      // Try to get from server
      final api = Get.find<ApiService>();
      final res = await api.generateQr(eventId);
      if (res.statusCode == 201 && res.body?['qrCode'] != null) {
        _qrData = res.body['qrCode'];
      }
    } catch (_) {
      final auth = Get.find<AuthController>();
      _qrData = '${auth.currentUser.value?.id ?? "guest"}:${_selectedEventId!}:local:${DateTime.now().millisecondsSinceEpoch}';
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadCheckInHistory() async {
    try {
      final api = Get.find<ApiService>();
      // Load check-in records for subscribed events
      final eventCtrl = Get.find<EventController>();
      final history = <Map<String, dynamic>>[];
      for (final event in eventCtrl.myEvents) {
        try {
          final res = await api.getMyCheckIn(event.id);
          if (res.statusCode == 200 && res.body != null) {
            final record = Map<String, dynamic>.from(res.body);
            record['eventTitleEn'] = event.titleEn;
            record['eventTitleZh'] = event.titleZh;
            if (record['checkedIn'] == true) {
              history.add(record);
            }
          }
        } catch (_) {}
      }
      if (mounted) setState(() => _checkInHistory = history);
    } catch (_) {
      // Fallback: show demo data
      if (mounted) {
        setState(() => _checkInHistory = []);
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_selectedEventId == null) {
          _secondsRemaining = 0;
          return;
        }
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _secondsRemaining = 30;
          _generateQr();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _isZh => Get.locale?.languageCode == 'zh';

  Widget _buildCheckInHistory(bool isZh, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isZh ? '签到记录' : 'Check-in History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 12),
          if (_checkInHistory.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.history, size: 40, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text(
                    isZh ? '暂无签到记录' : 'No check-in records yet',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          else
            ...(_checkInHistory.map((record) {
              final eventTitle = isZh
                  ? (record['eventTitleZh'] ?? '')
                  : (record['eventTitleEn'] ?? '');
              final checkedInAt = record['checkedInAt'] as String?;
              String timeStr = '';
              if (checkedInAt != null) {
                final dt = DateTime.tryParse(checkedInAt);
                if (dt != null) {
                  timeStr = '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                }
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(eventTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (timeStr.isNotEmpty)
                            Text(timeStr, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    Text(
                      isZh ? '已签到' : 'Checked In',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade600),
                    ),
                  ],
                ),
              );
            })),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF000666);
    const Color accentColor = Color(0xFFFFDEA5);
    const Color surfaceContainerColor = Color(0xFFDBF1FE);

    final auth = Get.find<AuthController>();
    final eventCtrl = Get.find<EventController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: primaryColor),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    _isZh ? '数字通行证' : 'DIGITAL PASS',
                    style: const TextStyle(fontFamily: 'Noto Serif', fontSize: 16, fontWeight: FontWeight.w900, color: primaryColor, letterSpacing: 0.5),
                  ),
                  const SizedBox(width: 48), // Balance the close button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Obx(() {
                  final user = auth.currentUser.value;
                  final myEvents = eventCtrl.myEvents;
                  if (_selectedEventId == null && myEvents.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted || _selectedEventId != null || myEvents.isEmpty) return;
                      setState(() {
                        _selectedEventId = myEvents.first.id;
                        _secondsRemaining = 30;
                      });
                      _generateQr();
                      _loadCheckInHistory();
                    });
                  }
                  // Find selected event
                  final selectedEvent = myEvents.isNotEmpty
                      ? myEvents.firstWhereOrNull((e) => e.id == _selectedEventId) ?? myEvents.first
                      : null;

                  return Column(
                    children: [
                      // Event selector if multiple events
                      if (myEvents.length > 1) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedEventId ?? myEvents.first.id,
                              items: myEvents.map((e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(_isZh ? e.titleZh : e.titleEn, overflow: TextOverflow.ellipsis),
                              )).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedEventId = val;
                                  _secondsRemaining = val == null ? 0 : 30;
                                });
                                _generateQr();
                                _loadCheckInHistory();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Ticket Container
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 20, offset: const Offset(0, 10))],
                        ),
                        child: Column(
                          children: [
                            // Role Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(user?.role.name ?? 'attendee').toUpperCase()} ACCESS',
                                    style: TextStyle(fontFamily: 'Noto Serif', fontSize: 12, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 2.0),
                                  ),
                                  Text(
                                    'ID: ${(user?.id ?? '').length > 8 ? user!.id.substring(0, 8).toUpperCase() : user?.id.toUpperCase() ?? ''}',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withAlpha(153), letterSpacing: 1.0),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  // Profile Avatar
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: surfaceContainerColor, width: 3),
                                      image: user?.avatarUrl.isNotEmpty == true
                                          ? DecorationImage(image: NetworkImage(user!.avatarUrl), fit: BoxFit.cover)
                                          : null,
                                    ),
                                    child: user?.avatarUrl.isNotEmpty != true
                                        ? Icon(Icons.person, size: 48, color: Colors.grey.shade400)
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  // User Name
                                  Text(
                                    _isZh
                                        ? (user?.nameZh.isNotEmpty == true ? user!.nameZh : user?.nameEn ?? '')
                                        : (user?.nameEn.isNotEmpty == true ? user!.nameEn : user?.nameZh ?? ''),
                                    style: const TextStyle(fontFamily: 'Noto Serif', fontSize: 24, fontWeight: FontWeight.w900, color: primaryColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  // User Title
                                  Text(
                                    (_isZh ? user?.titleZh : user?.titleEn) ?? '',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade600, letterSpacing: 1.5),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 32),

                                  // QR Code
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [accentColor, Color(0xFFB6924C)]),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                      child: _qrData.isEmpty
                                          ? SizedBox(
                                              width: 160,
                                              height: 160,
                                              child: Center(
                                                child: Text(
                                                  _isZh ? '暂无可用二维码' : 'No QR code available',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                                                ),
                                              ),
                                            )
                                          : QrImageView(data: _qrData, version: QrVersions.auto, size: 160, gapless: true),
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  // Event Info
                                  if (selectedEvent != null) ...[
                                    Text(
                                      _isZh ? selectedEvent.titleZh : selectedEvent.titleEn,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontFamily: 'Noto Serif', fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                                    ),
                                    const SizedBox(height: 24),
                                    const Divider(),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('DATE / 日期', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1.0)),
                                              const SizedBox(height: 4),
                                              Text(selectedEvent.dateRangeStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('VENUE / 地点', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1.0)),
                                              const SizedBox(height: 4),
                                              Text(
                                                _isZh ? selectedEvent.locationZh : selectedEvent.locationEn,
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor),
                                                maxLines: 2, overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    Text(
                                      _isZh ? '请先订阅一个会议' : 'Please subscribe to an event first',
                                      style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                                    ),
                                  ],

                                  const SizedBox(height: 32),

                                  // Refresh Timer
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(24)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.sync, size: 16, color: primaryColor),
                                        const SizedBox(width: 8),
                                        Text(
                                          _isZh ? '二维码刷新倒计时: ' : 'CODE REFRESHES IN: ',
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.0),
                                        ),
                                        Text(
                                          _selectedEventId == null
                                              ? (_isZh ? '未启用' : 'DISABLED')
                                              : '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Instruction text
                      Text(
                        _selectedEventId == null
                            ? (_isZh ? '请先在会议详情页订阅会议后再生成签到码' : 'Subscribe to an event before generating a check-in code')
                            : (_isZh ? '请在入口处出示此二维码进行签到' : 'Show this QR code at the entrance to check in'),
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),

                      // Check-in history
                      _buildCheckInHistory(_isZh, primaryColor),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
