import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/event_controller.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = AppColors.primary;
    const Color backgroundColor = AppColors.background;
    const Color surfaceLowColor = AppColors.surfaceBlue;
    const Color surfaceContainerColor = AppColors.surfaceBlue;
    const Color textVariantColor = AppColors.inkSoft;
    const Color tertiaryFixedColor = AppColors.accentSoft;
    const Color onTertiaryVariantColor = AppColors.ink;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(primaryColor),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSimplifiedProfileInfo(
                      primaryColor,
                      textVariantColor,
                      tertiaryFixedColor,
                      onTertiaryVariantColor,
                    ),
                    const SizedBox(height: 32),
                    _buildQuickActions(
                      primaryColor,
                      surfaceContainerColor,
                      textVariantColor,
                    ),
                    const SizedBox(height: 48),
                    _buildRegisteredEvents(
                      primaryColor,
                      textVariantColor,
                      surfaceLowColor,
                    ),
                    const SizedBox(height: 48),
                    _buildPreferences(
                      primaryColor,
                      textVariantColor,
                      surfaceLowColor,
                    ),
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
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSimplifiedProfileInfo(
    Color primaryColor,
    Color textVariantColor,
    Color badgeColor,
    Color badgeTextColor,
  ) {
    final auth = Get.find<AuthController>();
    return Obx(() {
      final user = auth.currentUser.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.03 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                color: Colors.grey.shade100,
              ),
              clipBehavior: Clip.antiAlias,
              child: user?.avatarUrl.isNotEmpty == true
                  ? Image.network(
                      user!.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : Icon(Icons.person, size: 40, color: Colors.grey.shade400),
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
                          (user?.nameEn.isNotEmpty ?? false)
                              ? user!.nameEn
                              : 'Guest Delegate',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            height: 1.1,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getRoleBadgeText(user?.role.name ?? 'attendee'),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: badgeTextColor,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => user == null
                                ? Get.toNamed('/login')
                                : Get.toNamed('/profile_edit'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                user == null ? 'SIGN IN' : 'edit'.tr,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (user?.titleEn.isNotEmpty ?? false)
                        ? user!.titleEn
                        : 'APSCVIR 2026 Attendee',
                    style: TextStyle(fontSize: 14, color: textVariantColor),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 14,
                        color: textVariantColor.withAlpha((0.7 * 255).round()),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          (user?.organizationEn.isNotEmpty ?? false)
                              ? user!.organizationEn
                              : 'APSCVIR 2026',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: textVariantColor.withAlpha(
                              (0.8 * 255).round(),
                            ),
                            letterSpacing: 0,
                          ),
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

  Widget _buildQuickActions(
    Color primaryColor,
    Color surfaceContainerColor,
    Color textVariantColor,
  ) {
    return GestureDetector(
      onTap: () => Get.toNamed('/digital_check_in'),
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withAlpha((0.3 * 255).round()),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
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
                  Text(
                    'digital_pass'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to show QR Code',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha((0.8 * 255).round()),
                    ),
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

  Widget _buildRegisteredEvents(
    Color primaryColor,
    Color textVariantColor,
    Color surfaceLowColor,
  ) {
    final eventCtrl = Get.find<EventController>();
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
              Text(
                'registered_events'.tr,
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: primaryColor,
                ),
              ),
              Text(
                'REGISTERED (${myEvents.length})',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: textVariantColor,
                  letterSpacing: 0,
                ),
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
                  'No subscribed events',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            )
          else
            ...myEvents.asMap().entries.map((entry) {
              final index = entry.key;
              final event = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < myEvents.length - 1 ? 32 : 0,
                ),
                child: _buildEventItem(
                  primaryColor: primaryColor,
                  textVariantColor: textVariantColor,
                  date:
                      '${_monthNameShort(event.startDate.month)} ${event.startDate.day}',
                  day: _weekDayName(event.startDate.weekday),
                  tag: event.isFeatured ? 'Featured' : 'Conference',
                  titleEn: event.titleEn,
                  location: event.locationEn,
                  time: event.dateRangeStr,
                  tagColor: AppColors.surfaceBlueDeep,
                  tagTextColor: AppColors.muted,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'explore_schedule'.tr,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  String _getRoleBadgeText(String role) {
    switch (role) {
      case 'admin':
        return 'ADMIN';
      case 'vip':
        return 'VIP DELEGATE';
      case 'speaker':
        return 'SPEAKER';
      default:
        return 'ATTENDEE';
    }
  }

  String _monthNameShort(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }

  String _weekDayName(int weekday) {
    const days = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY',
    ];
    return days[weekday - 1];
  }

  Widget _buildEventItem({
    required Color primaryColor,
    required Color textVariantColor,
    required String date,
    required String day,
    required String tag,
    required String titleEn,
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
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: borderColor, width: 2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                day,
                style: TextStyle(
                  fontSize: 10,
                  color: textVariantColor,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: tagTextColor,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                titleEn,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: textVariantColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(fontSize: 12, color: textVariantColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.schedule, size: 16, color: textVariantColor),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: textVariantColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferences(
    Color primaryColor,
    Color textVariantColor,
    Color surfaceLowColor,
  ) {
    final storage = Get.find<StorageService>();
    final notifService = Get.find<NotificationService>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceLowColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'preferences_security'.tr,
            style: TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Preferences & Security',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textVariantColor,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 32),
          _buildPreferenceItem(
            icon: Icons.notifications,
            titleEn: 'push_notifications'.tr,
            trailing: StatefulBuilder(
              builder: (context, setState) {
                bool enabled = storage.pushEnabled;
                return GestureDetector(
                  onTap: () async {
                    final nextValue = !enabled;
                    await notifService.updatePushSettings(nextValue);
                    setState(() {
                      enabled = nextValue;
                    });
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
                      alignment: enabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
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
    return Obx(() {
      final isLoggedIn = auth.isLoggedIn;
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            if (!isLoggedIn) {
              Get.toNamed('/login');
              return;
            }
            Get.dialog(
              AlertDialog(
                title: const Text('Log Out'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      auth.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            );
          },
          icon: Icon(
            isLoggedIn ? Icons.logout : Icons.login,
            color: Colors.red,
          ),
          label: Text(
            isLoggedIn ? 'Log Out' : 'Sign In',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPreferenceItem({
    required IconData icon,
    required String titleEn,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleEn,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
