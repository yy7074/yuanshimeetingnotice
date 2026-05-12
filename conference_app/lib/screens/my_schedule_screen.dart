import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import '../controllers/event_controller.dart';
import '../controllers/schedule_controller.dart';
import '../models/session_model.dart';
import '../services/data_service.dart';
import '../utils/ics_exporter.dart';
import '../theme/app_theme.dart';

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    // Refresh sessions when screen loads
    final scheduleCtrl = Get.find<ScheduleController>();
    scheduleCtrl.refreshSessions();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future<void> _showNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      id: title.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_reminders',
          'Schedule Reminders',
          channelDescription: 'Reminders for upcoming conference sessions',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = AppColors.primary;
    const Color backgroundColor = AppColors.background;
    const Color textColor = AppColors.ink;
    final scheduleCtrl = Get.find<ScheduleController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(textColor, primaryColor),
            Obx(() {
              final days = scheduleCtrl.availableDays;
              if (days.isEmpty) {
                return Expanded(
                  child: _buildEmptyScheduleState(scheduleCtrl, primaryColor),
                );
              }
              return Expanded(
                child: Column(
                  children: [
                    _buildDateNavigation(primaryColor, scheduleCtrl, days),
                    Expanded(
                      child: Obx(() {
                        final sessions = scheduleCtrl.sessionsForSelectedDay;
                        final selectedDayIndex =
                            scheduleCtrl.selectedDayIndex.value;
                        if (sessions.isEmpty) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 260),
                            transitionBuilder: _daySwitchTransition,
                            child: Center(
                              key: ValueKey('empty-$selectedDayIndex'),
                              child: Text(
                                'No saved sessions for this day',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ),
                          );
                        }
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: _daySwitchTransition,
                          child: ListView(
                            key: ValueKey('day-$selectedDayIndex'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 24.0,
                            ),
                            children: [
                              _buildDayHeader(
                                primaryColor,
                                textColor,
                                scheduleCtrl,
                                days,
                              ),
                              const SizedBox(height: 24),
                              ...sessions.asMap().entries.map((entry) {
                                final index = entry.key;
                                final session = entry.value;
                                return _buildTimelineItem(
                                  session: session,
                                  isFirst: index == 0,
                                  isLast: index == sessions.length - 1,
                                  primaryColor: primaryColor,
                                );
                              }),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyScheduleState(
    ScheduleController scheduleCtrl,
    Color primaryColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No schedule yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add APSCVIR 2026 sessions to build your personal agenda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _addApscvirProgram(scheduleCtrl),
              icon: const Icon(Icons.playlist_add_check, size: 20),
              label: const Text('Add APSCVIR Program'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(240, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _openApscvirProgram,
              icon: const Icon(Icons.event_note_outlined, size: 18),
              label: const Text('Browse Program'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor.withAlpha(120)),
                minimumSize: const Size(240, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addApscvirProgram(ScheduleController scheduleCtrl) async {
    final success = await scheduleCtrl.addAllSessionsFromEvent(
      DataService.apscvir2026EventId,
    );
    if (success) {
      _markApscvirEventSubscribed();
    }
    if (!mounted) return;

    Get.snackbar(
      success ? 'Added' : 'No Sessions Available',
      success
          ? 'APSCVIR 2026 sessions were added to My Schedule.'
          : 'The local APSCVIR program could not be loaded.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? AppColors.primary : Colors.orange.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> _openApscvirProgram() async {
    if (Get.isRegistered<EventController>()) {
      final eventCtrl = Get.find<EventController>();
      if (eventCtrl.allEvents.isEmpty) {
        await eventCtrl.loadEvents();
      }
      await eventCtrl.selectEvent(DataService.apscvir2026EventId);
    }
    if (!mounted) return;
    Get.toNamed(
      '/event_agenda',
      arguments: {'eventId': DataService.apscvir2026EventId, 'initialTab': 1},
    );
  }

  void _markApscvirEventSubscribed() {
    if (!Get.isRegistered<EventController>()) return;
    final eventCtrl = Get.find<EventController>();
    if (!eventCtrl.subscribedEventIds.contains(
      DataService.apscvir2026EventId,
    )) {
      eventCtrl.subscribedEventIds.add(DataService.apscvir2026EventId);
    }
  }

  Widget _buildHeader(Color textColor, Color primaryColor) {
    final scheduleCtrl = Get.find<ScheduleController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: primaryColor),
            onPressed: _goBackToMain,
            tooltip: 'Back',
          ),
          Text(
            'my_schedule_title'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 0,
            ),
          ),
          Obx(() {
            if (scheduleCtrl.savedSessionIds.isEmpty) {
              return const SizedBox(width: 48);
            }
            return GestureDetector(
              onTap: () => _exportAllToCalendar(scheduleCtrl, primaryColor),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: Icon(Icons.ios_share, color: primaryColor, size: 22),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _goBackToMain() {
    if (Get.key.currentState?.canPop() == true) {
      Get.back();
    } else {
      Get.offAllNamed('/main');
    }
  }

  Widget _buildDateNavigation(
    Color primaryColor,
    ScheduleController ctrl,
    List<DateTime> days,
  ) {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    final weekDaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekDaysZh = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      color: Colors.white,
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          final day = days[index];
          final dayIndex = _dayIndexForDate(ctrl, day, index);
          final isSelected = _isSameDay(_selectedDate(ctrl, days), day);
          final dayName = isZh
              ? weekDaysZh[day.weekday - 1]
              : weekDaysEn[day.weekday - 1];
          final dateStr = isZh
              ? '${day.month}/${day.day}'
              : '${_monthName(day.month)} ${day.day}';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  if (ctrl.selectedDayIndex.value != dayIndex) {
                    ctrl.selectedDayIndex.value = dayIndex;
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withAlpha(22)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? primaryColor.withAlpha(90)
                          : Colors.transparent,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primaryColor.withAlpha(18),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : const [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: isSelected
                              ? primaryColor
                              : Colors.grey.shade500,
                          letterSpacing: 0,
                        ),
                        child: Text(dayName),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? primaryColor
                              : Colors.grey.shade800,
                          letterSpacing: 0,
                        ),
                        child: Text(dateStr),
                      ),
                      const SizedBox(height: 7),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        width: isSelected ? 28 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _daySwitchTransition(Widget child, Animation<double> animation) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.035, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildDayHeader(
    Color primaryColor,
    Color textColor,
    ScheduleController ctrl,
    List<DateTime> days,
  ) {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    if (days.isEmpty) return const SizedBox.shrink();
    final day = _selectedDate(ctrl, days);
    final count = ctrl.sessionsForSelectedDay.length;

    final weekDaysEn = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final monthsEn = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final dateText = isZh
        ? '${weekDaysEn[day.weekday - 1]}, ${monthsEn[day.month - 1]} ${day.day}'
        : '${weekDaysEn[day.weekday - 1]}, ${monthsEn[day.month - 1]} ${day.day}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dateText,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: 0,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isZh ? '$count FAVORITES' : '$count FAVORITES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: primaryColor,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }

  DateTime _selectedDate(ScheduleController ctrl, List<DateTime> days) {
    final selectedSession = ctrl.mySessions.firstWhereOrNull(
      (session) => session.dayIndex == ctrl.selectedDayIndex.value,
    );
    if (selectedSession != null) {
      return DateTime(
        selectedSession.startTime.year,
        selectedSession.startTime.month,
        selectedSession.startTime.day,
      );
    }

    final index = ctrl.selectedDayIndex.value;
    if (index >= 0 && index < days.length) return days[index];
    return days.first;
  }

  int _dayIndexForDate(
    ScheduleController ctrl,
    DateTime day,
    int fallbackIndex,
  ) {
    final session = ctrl.mySessions.firstWhereOrNull(
      (item) => _isSameDay(item.startTime, day),
    );
    return session?.dayIndex ?? fallbackIndex;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildTimelineItem({
    required SessionModel session,
    required bool isFirst,
    required bool isLast,
    required Color primaryColor,
  }) {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    final isKeynote = session.type == SessionType.keynote;
    final locationStr = '${session.roomEn} • ${session.timeRangeStr}';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isKeynote ? primaryColor : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isKeynote ? Icons.schedule : Icons.biotech,
                    color: isKeynote ? Colors.white : Colors.grey.shade600,
                    size: 20,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey.shade200,
                      margin: const EdgeInsets.only(top: 8),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          session.titleEn,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              final event = Event(
                                title: session.titleEn,
                                description: 'Medical conference session',
                                location: session.roomEn,
                                startDate: session.startTime,
                                endDate: session.endTime,
                                iosParams: const IOSParams(
                                  reminder: Duration(minutes: 30),
                                ),
                              );
                              Add2Calendar.addEvent2Cal(event);
                            },
                            child: Icon(
                              Icons.calendar_month,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              _showNotification(
                                isZh
                                    ? 'Schedule Reminder'
                                    : 'Schedule Reminder',
                                isZh
                                    ? 'Your session "${session.titleEn}" is starting soon'
                                    : 'Your session "${session.titleEn}" is starting soon',
                              );
                              Get.snackbar(
                                isZh ? 'Reminder Set' : 'Reminder Set',
                                isZh
                                    ? 'We will notify you before the session starts'
                                    : 'We will notify you before the session starts',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: primaryColor,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                              );
                            },
                            child: Icon(
                              Icons.notifications_active,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              final scheduleCtrl =
                                  Get.find<ScheduleController>();
                              Get.dialog(
                                AlertDialog(
                                  title: Text(
                                    isZh ? 'Remove Session' : 'Remove Session',
                                  ),
                                  content: Text(
                                    isZh
                                        ? 'Remove "${session.titleEn}" from your schedule?'
                                        : 'Remove "${session.titleEn}" from your schedule?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text(isZh ? 'Cancel' : 'Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        scheduleCtrl.toggleSession(session.id);
                                        Get.snackbar(
                                          isZh ? 'Removed' : 'Removed',
                                          isZh
                                              ? 'Session removed from schedule'
                                              : 'Session removed from schedule',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: primaryColor,
                                          colorText: Colors.white,
                                          margin: const EdgeInsets.all(16),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade400,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: Text(isZh ? 'Remove' : 'Remove'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade300,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          locationStr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (session.speakerAvatarUrl.isNotEmpty)
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            color: Colors.grey.shade100,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            session.speakerAvatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          session.speakerName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportAllToCalendar(
    ScheduleController scheduleCtrl,
    Color primaryColor,
  ) {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    final sessions = scheduleCtrl.allSavedSessions;

    if (sessions.isEmpty) {
      Get.snackbar(
        isZh ? 'No Schedule' : 'No Schedule',
        isZh
            ? 'Please add sessions to your schedule first'
            : 'Please add sessions to your schedule first',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(Icons.calendar_month, size: 48, color: primaryColor),
            const SizedBox(height: 16),
            Text(
              isZh ? 'Export to Calendar' : 'Export to Calendar',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isZh
                  ? 'Add ${sessions.length} sessions to your calendar'
                  : 'Add ${sessions.length} sessions to your calendar',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  _doExportAll(sessions, primaryColor);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isZh
                      ? 'Export All (${sessions.length})'
                      : 'Export All (${sessions.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                  final daySessions = scheduleCtrl.sessionsForSelectedDay;
                  _doExportAll(daySessions, primaryColor);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isZh ? 'Export Current Day Only' : 'Export Current Day Only',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                  _doShareIcs(sessions, primaryColor);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isZh
                      ? 'Share .ics Calendar File'
                      : 'Share .ics Calendar File',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _doShareIcs(
    List<SessionModel> sessions,
    Color primaryColor,
  ) async {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    try {
      await IcsExporter.share(
        sessions,
        isZh: isZh,
        subject: isZh ? 'APSCVIR My Schedule' : 'APSCVIR My Schedule',
      );
    } catch (e) {
      Get.snackbar(
        isZh ? 'Export Failed' : 'Export Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void _doExportAll(List<SessionModel> sessions, Color primaryColor) {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    int count = 0;
    for (final session in sessions) {
      final event = Event(
        title: session.titleEn,
        description: '${session.speakerName} - ${session.speakerTitleEn}',
        location: session.roomEn,
        startDate: session.startTime,
        endDate: session.endTime,
        iosParams: const IOSParams(reminder: Duration(minutes: 15)),
      );
      Add2Calendar.addEvent2Cal(event);
      count++;
    }
    Get.snackbar(
      isZh ? 'Export Complete' : 'Export Complete',
      isZh
          ? '$count sessions exported to calendar'
          : '$count sessions exported to calendar',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: primaryColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
