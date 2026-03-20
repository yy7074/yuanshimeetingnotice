import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  int _selectedDateIndex = 1; // Default to Tuesday, Oct 13
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
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
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future<void> _showNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      id: title.hashCode, // Notification ID
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
    const Color primaryColor = Color(0xFF196EE6);
    const Color backgroundColor = Color(0xFFF6F7F8);
    const Color textColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(textColor),
            _buildDateNavigation(primaryColor),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                children: [
                  _buildDayHeader(primaryColor, textColor),
                  const SizedBox(height: 24),
                  _buildTimelineItem(
                    icon: Icons.schedule,
                    iconColor: Colors.white,
                    iconBgColor: primaryColor,
                    title: Get.locale?.languageCode == 'zh' ? '主旨演讲：精准医疗与AI诊断' : 'Keynote: Precision Medicine & AI',
                    location: Get.locale?.languageCode == 'zh' ? '第一学术报告厅 • 09:00 AM - 10:30 AM' : 'Lecture Hall 1 • 09:00 AM - 10:30 AM',
                    avatarUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop',
                    speakerName: Get.locale?.languageCode == 'zh' ? 'Aris Thorne 博士' : 'Dr. Aris Thorne',
                    isBookmarked: true,
                    primaryColor: primaryColor,
                  ),
                  _buildTimelineItem(
                    icon: Icons.biotech,
                    iconColor: Colors.grey.shade600,
                    iconBgColor: Colors.grey.shade200,
                    title: Get.locale?.languageCode == 'zh' ? '临床研讨会：新型靶向免疫疗法' : 'Clinical Workshop: Targeted Immunotherapy',
                    location: Get.locale?.languageCode == 'zh' ? '实验教学中心 • 11:00 AM - 12:30 PM' : 'Lab Center • 11:00 AM - 12:30 PM',
                    avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=200&auto=format&fit=crop',
                    speakerName: 'Elena Rodriguez, MD',
                    isBookmarked: true,
                    primaryColor: primaryColor,
                  ),
                  _buildBreakItem(),
                  _buildTimelineItem(
                    icon: Icons.science,
                    iconColor: Colors.grey.shade600,
                    iconBgColor: Colors.grey.shade200,
                    title: Get.locale?.languageCode == 'zh' ? '基因组学数据在罕见病中的应用' : 'Genomic Data in Rare Diseases',
                    location: Get.locale?.languageCode == 'zh' ? '医学数据实验室 • 02:15 PM - 03:45 PM' : 'Medical Data Lab • 02:15 PM - 03:45 PM',
                    avatarUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=200&auto=format&fit=crop',
                    speakerName: 'Prof. Marcus Chen',
                    isBookmarked: true,
                    primaryColor: primaryColor,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Center(
        child: Text(
          'my_schedule_title'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDateNavigation(Color primaryColor) {
    final isZh = Get.locale?.languageCode == 'zh';
    final dates = [
      {'day': isZh ? '周一' : 'Mon', 'date': isZh ? '10/12' : 'Oct 12'},
      {'day': isZh ? '周二' : 'Tue', 'date': isZh ? '10/13' : 'Oct 13'},
      {'day': isZh ? '周三' : 'Wed', 'date': isZh ? '10/14' : 'Oct 14'},
      {'day': isZh ? '周四' : 'Thu', 'date': isZh ? '10/15' : 'Oct 15'},
      {'day': isZh ? '周五' : 'Fri', 'date': isZh ? '10/16' : 'Oct 16'},
    ];

    return Container(
      color: Colors.white,
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          bool isSelected = _selectedDateIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDateIndex = index;
              });
            },
            child: Container(
              width: 72,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dates[index]['day']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? primaryColor : Colors.grey.shade500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dates[index]['date']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primaryColor : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayHeader(Color primaryColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Get.locale?.languageCode == 'zh' ? '10月13日，星期二' : 'Tuesday, October 13',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: -0.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            Get.locale?.languageCode == 'zh' ? '3 个收藏' : '3 FAVORITES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String location,
    required String avatarUrl,
    required String speakerName,
    required bool isBookmarked,
    required Color primaryColor,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
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
          // Content
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
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (isBookmarked)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                final Event event = Event(
                                  title: title,
                                  description: 'Medical conference session: $title',
                                  location: location,
                                  startDate: DateTime.now().add(const Duration(days: 1)),
                                  endDate: DateTime.now().add(const Duration(days: 1, hours: 1, minutes: 30)),
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
                                  Get.locale?.languageCode == 'zh' ? '日程提醒' : 'Schedule Reminder',
                                  Get.locale?.languageCode == 'zh' ? '您的会议 "$title" 即将开始，地点：$location' : 'Your session "$title" is starting soon at $location.',
                                );
                                Get.snackbar(
                                  Get.locale?.languageCode == 'zh' ? '提醒已设置' : 'Reminder Set',
                                  Get.locale?.languageCode == 'zh' ? '我们将在会议开始前提醒您' : 'We will notify you before the session starts',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: primaryColor,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(16),
                                );
                              },
                              child: Icon(Icons.notifications_active, color: primaryColor, size: 24),
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
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(avatarUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        speakerName,
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

  Widget _buildBreakItem() {
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
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Icon(Icons.restaurant, color: Colors.grey.shade500, size: 20),
                ),
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
              padding: const EdgeInsets.only(bottom: 32.0, top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'networking_lunch'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(
                        Get.locale?.languageCode == 'zh' ? '主会场 • 01:00 PM - 02:00 PM' : 'Main Hall • 01:00 PM - 02:00 PM',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
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
}
