import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import '../controllers/auth_controller.dart';
import '../controllers/event_controller.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class DigitalCheckInScreen extends StatefulWidget {
  const DigitalCheckInScreen({super.key});

  @override
  State<DigitalCheckInScreen> createState() => _DigitalCheckInScreenState();
}

class _DigitalCheckInScreenState extends State<DigitalCheckInScreen> {
  int _secondsRemaining = 30;
  Timer? _timer;
  String _qrData = '';
  String _qrError = '';
  String? _selectedEventId;
  List<Map<String, dynamic>> _checkInHistory = [];
  int _qrRequestVersion = 0;

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
      _qrError = '';
      if (mounted) setState(() {});
      return;
    }

    final requestVersion = ++_qrRequestVersion;
    try {
      final eventId = _selectedEventId!;

      final api = Get.find<ApiService>();
      final res = await api.generateQr(eventId);
      if (!mounted ||
          requestVersion != _qrRequestVersion ||
          eventId != _selectedEventId) {
        return;
      }
      if ((res.statusCode == 201 || res.statusCode == 200) &&
          res.body?['qrCode'] != null) {
        _qrData = res.body['qrCode'];
        _qrError = '';
      } else {
        _qrData = '';
        _qrError = _isZh
            ? 'Unable to generate check-in QR code right now.'
            : 'Unable to generate QR code right now';
      }
    } catch (_) {
      if (!mounted || requestVersion != _qrRequestVersion) {
        return;
      }
      _qrData = '';
      _qrError = _isZh
          ? 'Network error. Unable to load check-in QR code.'
          : 'Network error. Unable to fetch QR code';
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

  bool get _isZh => Get.locale?.languageCode == '__zh_disabled__';

  void _goBackToMain() {
    if (Get.key.currentState?.canPop() == true) {
      Get.back();
    } else {
      Get.offAllNamed('/main');
    }
  }

  Widget _buildCheckInHistory(bool isZh, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isZh ? 'Check-in History' : 'Check-in History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
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
                    isZh
                        ? 'No check-in records yet'
                        : 'No check-in records yet',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          else
            ...(_checkInHistory.map((record) {
              final eventTitle = record['eventTitleEn'] ?? '';
              final checkedInAt = record['checkedInAt'] as String?;
              String timeStr = '';
              if (checkedInAt != null) {
                final dt = DateTime.tryParse(checkedInAt);
                if (dt != null) {
                  timeStr =
                      '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
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
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (timeStr.isNotEmpty)
                            Text(
                              timeStr,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      isZh ? 'Checked In' : 'Checked In',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade600,
                      ),
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
    const Color primaryColor = AppColors.primary;
    const Color accentColor = AppColors.accentSoft;
    const Color surfaceContainerColor = AppColors.surfaceBlue;

    final auth = Get.find<AuthController>();
    final eventCtrl = Get.find<EventController>();

    return Scaffold(
      backgroundColor: AppColors.background,
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
                    onPressed: _goBackToMain,
                  ),
                  Text(
                    _isZh ? 'DIGITAL PASS' : 'DIGITAL PASS',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the close button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Obx(() {
                  final user = auth.currentUser.value;
                  final myEvents = eventCtrl.myEvents;
                  final hasSelectedEvent =
                      _selectedEventId != null &&
                      myEvents.any((event) => event.id == _selectedEventId);

                  if (_selectedEventId == null && myEvents.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted ||
                          _selectedEventId != null ||
                          myEvents.isEmpty) {
                        return;
                      }
                      setState(() {
                        _selectedEventId = myEvents.first.id;
                        _secondsRemaining = 30;
                      });
                      _generateQr();
                      _loadCheckInHistory();
                    });
                  } else if (_selectedEventId != null && !hasSelectedEvent) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      setState(() {
                        _selectedEventId = myEvents.isEmpty
                            ? null
                            : myEvents.first.id;
                        _secondsRemaining = _selectedEventId == null ? 0 : 30;
                      });
                      _generateQr();
                      _loadCheckInHistory();
                    });
                  }
                  // Find selected event
                  final selectedEvent = myEvents.isNotEmpty
                      ? myEvents.firstWhereOrNull(
                              (e) => e.id == _selectedEventId,
                            ) ??
                            myEvents.first
                      : null;

                  return Column(
                    children: [
                      // Event selector if multiple events
                      if (myEvents.length > 1) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedEventId ?? myEvents.first.id,
                              items: myEvents
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(
                                        e.titleEn,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Role Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(user?.role.name ?? 'attendee').toUpperCase()} ACCESS',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: accentColor,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${(user?.id ?? '').length > 8 ? user!.id.substring(0, 8).toUpperCase() : user?.id.toUpperCase() ?? ''}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withAlpha(153),
                                      letterSpacing: 0,
                                    ),
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
                                      border: Border.all(
                                        color: surfaceContainerColor,
                                        width: 3,
                                      ),
                                      color: Colors.grey.shade100,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: user?.avatarUrl.isNotEmpty == true
                                        ? Image.network(
                                            user!.avatarUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.person,
                                                      size: 48,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 48,
                                            color: Colors.grey.shade400,
                                          ),
                                  ),
                                  const SizedBox(height: 16),
                                  // User Name
                                  Text(
                                    user?.nameEn.isNotEmpty == true
                                        ? user!.nameEn
                                        : user?.email ?? 'Guest Delegate',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  // User Title
                                  Text(
                                    user?.titleEn ?? '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                      letterSpacing: 0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 32),

                                  // QR Code
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [accentColor, AppColors.accent],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: _qrData.isEmpty
                                          ? SizedBox(
                                              width: 160,
                                              height: 160,
                                              child: Center(
                                                child: Text(
                                                  _qrError.isNotEmpty
                                                      ? _qrError
                                                      : (_isZh
                                                            ? 'No QR code available'
                                                            : 'No QR code available'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : QrImageView(
                                              data: _qrData,
                                              version: QrVersions.auto,
                                              size: 160,
                                              gapless: true,
                                            ),
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  // Event Info
                                  if (selectedEvent != null) ...[
                                    Text(
                                      selectedEvent.titleEn,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Divider(),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'DATE',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade500,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                selectedEvent.dateRangeStr,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'VENUE',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade500,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _isZh
                                                    ? selectedEvent.locationZh
                                                    : selectedEvent.locationEn,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: primaryColor,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    Text(
                                      _isZh
                                          ? 'Subscribe to an event first'
                                          : 'Please subscribe to an event first',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 32),

                                  // Refresh Timer
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceBlue,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.sync,
                                          size: 16,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _isZh
                                              ? 'QR refresh countdown: '
                                              : 'CODE REFRESHES IN: ',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        Text(
                                          _selectedEventId == null
                                              ? (_isZh
                                                    ? 'DISABLED'
                                                    : 'DISABLED')
                                              : '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
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
                            ? (_isZh
                                  ? 'Subscribe to an event before generating a check-in code.'
                                  : 'Subscribe to an event before generating a check-in code')
                            : (_isZh
                                  ? 'Show this QR code at the entrance for check-in.'
                                  : 'Show this QR code at the entrance to check in'),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
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
