import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import '../controllers/schedule_controller.dart';
import '../models/session_model.dart';

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    // Refresh sessions when screen loads
    final scheduleCtrl = Get.find<ScheduleController>();
    scheduleCtrl.refreshSessions();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      id: title.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('schedule_reminders', 'Schedule Reminders', channelDescription: 'Reminders for upcoming conference sessions', importance: Importance.max, priority: Priority.high),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF196EE6);
    const Color backgroundColor = Color(0xFFF6F7F8);
    const Color textColor = Color(0xFF0F172A);
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          Get.locale?.languageCode == 'zh' ? '暂无日程安排' : 'No schedule yet',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Get.locale?.languageCode == 'zh' ? '在会议详情中添加议程到我的日程' : 'Add sessions from event details to your schedule',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Get.offAllNamed('/main'),
                          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                          child: Text(Get.locale?.languageCode == 'zh' ? '浏览会议' : 'Browse Events'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Expanded(
                child: Column(
                  children: [
                    _buildDateNavigation(primaryColor, scheduleCtrl, days),
                    Expanded(
                      child: Obx(() {
                        final sessions = scheduleCtrl.sessionsForSelectedDay;
                        if (sessions.isEmpty) {
                          return Center(
                            child: Text(
                              Get.locale?.languageCode == 'zh' ? '该日暂无收藏的议程' : 'No saved sessions for this day',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          );
                        }
                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                          children: [
                            _buildDayHeader(primaryColor, textColor, scheduleCtrl, days),
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

  Widget _buildHeader(Color textColor, Color primaryColor) {
    final scheduleCtrl = Get.find<ScheduleController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48), // balance
          Text('my_schedule_title'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -0.5)),
          Obx(() {
            if (scheduleCtrl.savedSessionIds.isEmpty) return const SizedBox(width: 48);
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

  Widget _buildDateNavigation(Color primaryColor, ScheduleController ctrl, List<DateTime> days) {
    final isZh = Get.locale?.languageCode == 'zh';
    final weekDaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekDaysZh = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

    return Container(
      color: Colors.white,
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          bool isSelected = ctrl.selectedDayIndex.value == index;
          final day = days[index];
          final dayName = isZh ? weekDaysZh[day.weekday - 1] : weekDaysEn[day.weekday - 1];
          final dateStr = isZh ? '${day.month}/${day.day}' : '${_monthName(day.month)} ${day.day}';

          return GestureDetector(
            onTap: () => ctrl.selectedDayIndex.value = index,
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isSelected ? primaryColor : Colors.transparent, width: 2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dayName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? primaryColor : Colors.grey.shade500, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(dateStr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? primaryColor : Colors.grey.shade800)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildDayHeader(Color primaryColor, Color textColor, ScheduleController ctrl, List<DateTime> days) {
    final isZh = Get.locale?.languageCode == 'zh';
    final idx = ctrl.selectedDayIndex.value;
    if (idx >= days.length) return const SizedBox.shrink();
    final day = days[idx];
    final count = ctrl.sessionsForSelectedDay.length;

    final weekDaysEn = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final monthsEn = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    final dateText = isZh
        ? '${day.month}月${day.day}日，${['周一', '周二', '周三', '周四', '周五', '周六', '周日'][day.weekday - 1]}'
        : '${weekDaysEn[day.weekday - 1]}, ${monthsEn[day.month - 1]} ${day.day}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(dateText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -0.5)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: primaryColor.withAlpha((0.1 * 255).round()), borderRadius: BorderRadius.circular(20)),
          child: Text(
            isZh ? '$count 个收藏' : '$count FAVORITES',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: primaryColor, letterSpacing: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required SessionModel session,
    required bool isFirst,
    required bool isLast,
    required Color primaryColor,
  }) {
    final isZh = Get.locale?.languageCode == 'zh';
    final isKeynote = session.type == SessionType.keynote;
    final locationStr = isZh
        ? '${session.roomZh} • ${session.timeRangeStr}'
        : '${session.roomEn} • ${session.timeRangeStr}';

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
                    child: Container(width: 2, color: Colors.grey.shade200, margin: const EdgeInsets.only(top: 8)),
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
                          isZh ? session.titleZh : session.titleEn,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.2),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              final event = Event(
                                title: isZh ? session.titleZh : session.titleEn,
                                description: 'Medical conference session',
                                location: isZh ? session.roomZh : session.roomEn,
                                startDate: session.startTime,
                                endDate: session.endTime,
                                iosParams: const IOSParams(reminder: Duration(minutes: 30)),
                              );
                              Add2Calendar.addEvent2Cal(event);
                            },
                            child: Icon(Icons.calendar_month, color: primaryColor, size: 24),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              _showNotification(
                                isZh ? '日程提醒' : 'Schedule Reminder',
                                isZh ? '您的会议 "${session.titleZh}" 即将开始' : 'Your session "${session.titleEn}" is starting soon',
                              );
                              Get.snackbar(
                                isZh ? '提醒已设置' : 'Reminder Set',
                                isZh ? '我们将在会议开始前提醒您' : 'We will notify you before the session starts',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: primaryColor,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                              );
                            },
                            child: Icon(Icons.notifications_active, color: primaryColor, size: 24),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              final scheduleCtrl = Get.find<ScheduleController>();
                              Get.dialog(
                                AlertDialog(
                                  title: Text(isZh ? '移除议程' : 'Remove Session'),
                                  content: Text(
                                    isZh
                                        ? '确定要从日程中移除 "${session.titleZh}" 吗？'
                                        : 'Remove "${session.titleEn}" from your schedule?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text(isZh ? '取消' : 'Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        scheduleCtrl.toggleSession(session.id);
                                        Get.snackbar(
                                          isZh ? '已移除' : 'Removed',
                                          isZh ? '议程已从日程中移除' : 'Session removed from schedule',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: primaryColor,
                                          colorText: Colors.white,
                                          margin: const EdgeInsets.all(16),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white),
                                      child: Text(isZh ? '移除' : 'Remove'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 22),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(locationStr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
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
                            image: DecorationImage(image: NetworkImage(session.speakerAvatarUrl), fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(session.speakerName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
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

  void _exportAllToCalendar(ScheduleController scheduleCtrl, Color primaryColor) {
    final isZh = Get.locale?.languageCode == 'zh';
    final sessions = scheduleCtrl.allSavedSessions;

    if (sessions.isEmpty) {
      Get.snackbar(
        isZh ? '暂无日程' : 'No Schedule',
        isZh ? '请先添加议程到我的日程' : 'Please add sessions to your schedule first',
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
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Icon(Icons.calendar_month, size: 48, color: primaryColor),
            const SizedBox(height: 16),
            Text(
              isZh ? '导出到系统日历' : 'Export to Calendar',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isZh ? '将 ${sessions.length} 个议程添加到系统日历' : 'Add ${sessions.length} sessions to your calendar',
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isZh ? '导出全部 (${sessions.length})' : 'Export All (${sessions.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isZh ? '仅导出当天' : 'Export Current Day Only',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _doExportAll(List<SessionModel> sessions, Color primaryColor) {
    final isZh = Get.locale?.languageCode == 'zh';
    int count = 0;
    for (final session in sessions) {
      final event = Event(
        title: isZh ? session.titleZh : session.titleEn,
        description: '${session.speakerName} - ${isZh ? session.speakerTitleZh : session.speakerTitleEn}',
        location: isZh ? session.roomZh : session.roomEn,
        startDate: session.startTime,
        endDate: session.endTime,
        iosParams: const IOSParams(reminder: Duration(minutes: 15)),
      );
      Add2Calendar.addEvent2Cal(event);
      count++;
    }
    Get.snackbar(
      isZh ? '导出成功' : 'Export Complete',
      isZh ? '已将 $count 个议程添加到系统日历' : '$count sessions exported to calendar',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: primaryColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
