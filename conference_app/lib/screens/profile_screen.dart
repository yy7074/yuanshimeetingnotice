import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/event_controller.dart';
import '../services/storage_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF000666);
    const Color backgroundColor = Color(0xFFF3FAFF);
    const Color surfaceLowColor = Color(0xFFE6F6FF);
    const Color surfaceContainerColor = Color(0xFFDBF1FE);
    const Color textVariantColor = Color(0xFF454652);
    const Color tertiaryFixedColor = Color(0xFFFFDEA5);
    const Color onTertiaryVariantColor = Color(0xFF5D4201);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(primaryColor),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSimplifiedProfileInfo(primaryColor, textVariantColor, tertiaryFixedColor, onTertiaryVariantColor),
                    const SizedBox(height: 32),
                    _buildQuickActions(primaryColor, surfaceContainerColor, textVariantColor),
                    const SizedBox(height: 48),
                    _buildRegisteredEvents(primaryColor, textVariantColor, surfaceLowColor),
                    const SizedBox(height: 48),
                    _buildPreferences(primaryColor, textVariantColor, surfaceLowColor),
                    const SizedBox(height: 32),
                    _buildLogoutButton(primaryColor),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Center(
        child: Text(
          Get.locale?.languageCode == 'zh' ? '个人中心' : 'Profile',
          style: TextStyle(fontFamily: 'Noto Serif', fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildSimplifiedProfileInfo(Color primaryColor, Color textVariantColor, Color badgeColor, Color badgeTextColor) {
    final auth = Get.find<AuthController>();
    final isZh = Get.locale?.languageCode == 'zh';

    return Obx(() {
      final user = auth.currentUser.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 2),
                image: DecorationImage(
                  image: NetworkImage(user?.avatarUrl ?? 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          isZh ? (user?.nameZh ?? '') : (user?.nameEn ?? ''),
                          style: TextStyle(fontFamily: 'Noto Serif', fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor, height: 1.1),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              _getRoleBadgeText(user?.role.name ?? 'attendee'),
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeTextColor, letterSpacing: 1.0),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Get.toNamed('/profile_edit'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: primaryColor.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                              child: Text('edit'.tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: primaryColor, letterSpacing: 1.0)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isZh ? (user?.titleZh ?? '') : (user?.titleEn ?? ''),
                    style: TextStyle(fontSize: 14, color: textVariantColor),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.business, size: 14, color: textVariantColor.withAlpha((0.7 * 255).round())),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          isZh ? (user?.organizationZh ?? '') : (user?.organizationEn ?? ''),
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textVariantColor.withAlpha((0.8 * 255).round()), letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuickActions(Color primaryColor, Color surfaceContainerColor, Color textVariantColor) {
    return GestureDetector(
      onTap: () => Get.toNamed('/digital_check_in'),
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: primaryColor.withAlpha((0.3 * 255).round()), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            const Icon(Icons.qr_code_2, color: Colors.white, size: 48),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('digital_pass'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(
                    Get.locale?.languageCode == 'zh' ? 'Digital Pass • 点击出示二维码' : 'Tap to show QR Code',
                    style: TextStyle(fontSize: 12, color: Colors.white.withAlpha((0.8 * 255).round())),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white70, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisteredEvents(Color primaryColor, Color textVariantColor, Color surfaceLowColor) {
    final eventCtrl = Get.find<EventController>();
    final isZh = Get.locale?.languageCode == 'zh';

    return Obx(() {
      final myEvents = eventCtrl.myEvents;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('registered_events'.tr, style: TextStyle(fontFamily: 'Noto Serif', fontSize: 24, fontStyle: FontStyle.italic, color: primaryColor)),
              Text(
                '${isZh ? '已登记' : 'REGISTERED'} (${myEvents.length})',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textVariantColor, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 24),
          if (myEvents.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  isZh ? '暂未订阅任何会议' : 'No subscribed events',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            )
          else
            ...myEvents.asMap().entries.map((entry) {
              final index = entry.key;
              final event = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: index < myEvents.length - 1 ? 32 : 0),
                child: _buildEventItem(
                  primaryColor: primaryColor,
                  textVariantColor: textVariantColor,
                  date: '${_monthNameShort(event.startDate.month)} ${event.startDate.day}',
                  day: _weekDayName(event.startDate.weekday),
                  tag: event.isFeatured ? 'Featured' : 'Conference',
                  titleEn: event.titleEn,
                  titleZh: event.titleZh,
                  location: isZh ? event.locationZh : event.locationEn,
                  time: event.dateRangeStr,
                  tagColor: const Color(0xFFCFE6F2),
                  tagTextColor: const Color(0xFF526772),
                  borderColor: index == 0 ? primaryColor : Colors.grey.shade300,
                ),
              );
            }),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to events tab
                Get.offAllNamed('/main');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: surfaceLowColor,
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('explore_schedule'.tr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
          ),
        ],
      );
    });
  }

  String _getRoleBadgeText(String role) {
    final isZh = Get.locale?.languageCode == 'zh';
    switch (role) {
      case 'admin': return isZh ? '管理员' : 'ADMIN';
      case 'vip': return isZh ? '贵宾代表' : 'VIP DELEGATE';
      case 'speaker': return isZh ? '演讲嘉宾' : 'SPEAKER';
      default: return isZh ? '参会者' : 'ATTENDEE';
    }
  }

  String _monthNameShort(int month) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month - 1];
  }

  String _weekDayName(int weekday) {
    const days = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
    return days[weekday - 1];
  }

  Widget _buildEventItem({
    required Color primaryColor,
    required Color textVariantColor,
    required String date,
    required String day,
    required String tag,
    required String titleEn,
    required String titleZh,
    required String location,
    required String time,
    required Color tagColor,
    required Color tagTextColor,
    required Color borderColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.only(left: 12, top: 4),
          decoration: BoxDecoration(border: Border(left: BorderSide(color: borderColor, width: 2))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontFamily: 'Noto Serif', fontSize: 18, fontWeight: FontWeight.bold)),
              Text(day, style: TextStyle(fontSize: 10, color: textVariantColor, letterSpacing: -0.5)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(12)),
                child: Text(tag.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: tagTextColor, letterSpacing: 1)),
              ),
              const SizedBox(height: 12),
              Text(titleEn, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3)),
              const SizedBox(height: 4),
              Text(titleZh, style: TextStyle(fontSize: 13, color: textVariantColor, fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: textVariantColor),
                  const SizedBox(width: 4),
                  Expanded(child: Text(location, style: TextStyle(fontSize: 12, color: textVariantColor), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 16),
                  Icon(Icons.schedule, size: 16, color: textVariantColor),
                  const SizedBox(width: 4),
                  Text(time, style: TextStyle(fontSize: 12, color: textVariantColor)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferences(Color primaryColor, Color textVariantColor, Color surfaceLowColor) {
    final storage = Get.find<StorageService>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: surfaceLowColor, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('preferences_security'.tr, style: TextStyle(fontFamily: 'Noto Serif', fontSize: 22, fontStyle: FontStyle.italic, color: primaryColor)),
          const SizedBox(height: 4),
          Text(
            Get.locale?.languageCode == 'zh' ? 'Preferences & Security' : '偏好与安全设置',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textVariantColor, letterSpacing: 1),
          ),
          const SizedBox(height: 32),
          _buildPreferenceItem(
            icon: Icons.translate,
            titleEn: 'language_selection'.tr,
            titleZh: Get.locale?.languageCode == 'zh' ? 'Language Selection: English / 中文' : '语言选择: English / 中文',
            trailing: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.5 * 255).round()),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.updateLocale(const Locale('en', 'US'));
                      storage.saveLanguage('en');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Get.locale?.languageCode != 'zh' ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('EN', style: TextStyle(color: Get.locale?.languageCode != 'zh' ? Colors.white : textVariantColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.updateLocale(const Locale('zh', 'CN'));
                      storage.saveLanguage('zh');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Get.locale?.languageCode == 'zh' ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('CN', style: TextStyle(color: Get.locale?.languageCode == 'zh' ? Colors.white : textVariantColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildPreferenceItem(
            icon: Icons.notifications,
            titleEn: 'push_notifications'.tr,
            titleZh: Get.locale?.languageCode == 'zh' ? 'Push Notifications' : '推送通知',
            trailing: StatefulBuilder(
              builder: (context, setState) {
                bool enabled = storage.pushEnabled;
                return GestureDetector(
                  onTap: () {
                    storage.setPushEnabled(!enabled);
                    setState(() {});
                  },
                  child: Container(
                    width: 48,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: enabled ? primaryColor : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                      alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(Color primaryColor) {
    final auth = Get.find<AuthController>();
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: Text(Get.locale?.languageCode == 'zh' ? '退出登录' : 'Log Out'),
              content: Text(Get.locale?.languageCode == 'zh' ? '确定要退出登录吗？' : 'Are you sure you want to log out?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(Get.locale?.languageCode == 'zh' ? '取消' : 'Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    auth.logout();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  child: Text(Get.locale?.languageCode == 'zh' ? '退出' : 'Log Out'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(
          Get.locale?.languageCode == 'zh' ? '退出登录' : 'Log Out',
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildPreferenceItem({
    required IconData icon,
    required String titleEn,
    required String titleZh,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titleEn, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(titleZh, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
