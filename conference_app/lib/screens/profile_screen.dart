import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSimplifiedProfileInfo(Color primaryColor, Color textVariantColor, Color badgeColor, Color badgeTextColor) {
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
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop'),
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
                        Get.locale?.languageCode == 'zh' ? '艾利斯泰尔·索恩博士' : 'Dr. Alistair Thorne',
                        style: TextStyle(
                          fontFamily: 'Noto Serif',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'vip_delegate'.tr,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  Get.locale?.languageCode == 'zh' ? '高级肿瘤学研究员' : 'Senior Oncology Curator',
                  style: TextStyle(
                    fontSize: 14,
                    color: textVariantColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.business, size: 14, color: textVariantColor.withAlpha((0.7 * 255).round())),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        Get.locale?.languageCode == 'zh' ? '圣裘德医学研究中心' : 'ST. JUDE\'S MEDICAL RESEARCH CENTER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: textVariantColor.withAlpha((0.8 * 255).round()),
                          letterSpacing: 0.5,
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
  }

  Widget _buildQuickActions(Color primaryColor, Color surfaceContainerColor, Color textVariantColor) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/digital_check_in');
      },
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
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Get.locale?.languageCode == 'zh' ? 'Digital Pass • 点击出示二维码' : 'Tap to show QR Code',
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

  Widget _buildRegisteredEvents(Color primaryColor, Color textVariantColor, Color surfaceLowColor) {
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
                fontFamily: 'Noto Serif',
                fontSize: 24,
                fontStyle: FontStyle.italic,
                color: primaryColor,
              ),
            ),
            Text(
              'registered_events_count'.tr,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textVariantColor,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 24),
        _buildEventItem(
          primaryColor: primaryColor,
          textVariantColor: textVariantColor,
          date: 'OCT 24',
          day: 'THURSDAY',
          tag: 'Keynote',
          titleEn: 'Innovations in Targeted Immunotherapy',
          titleZh: '靶向免疫疗法的创新',
          location: 'Grand Ballroom A',
          time: '09:00 — 10:30',
          tagColor: const Color(0xFFCFE6F2),
          tagTextColor: const Color(0xFF526772),
          borderColor: primaryColor,
        ),
        const SizedBox(height: 32),
        _buildEventItem(
          primaryColor: primaryColor,
          textVariantColor: textVariantColor,
          date: 'OCT 25',
          day: 'FRIDAY',
          tag: 'Panel Discussion',
          titleEn: 'Ethics of AI in Clinical Diagnosis',
          titleZh: '人工智能在临床诊断中的伦理问题',
          location: 'Summit Hall 3',
          time: '14:00 — 15:30',
          tagColor: const Color(0xFFDBF1FE),
          tagTextColor: const Color(0xFF526772),
          borderColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
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
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
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
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: borderColor, width: 2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontFamily: 'Noto Serif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                day,
                style: TextStyle(
                  fontSize: 10,
                  color: textVariantColor,
                  letterSpacing: -0.5,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                    letterSpacing: 1,
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
              const SizedBox(height: 4),
              Text(
                titleZh,
                style: TextStyle(
                  fontSize: 13,
                  color: textVariantColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: textVariantColor),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(fontSize: 12, color: textVariantColor),
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

  Widget _buildPreferences(Color primaryColor, Color textVariantColor, Color surfaceLowColor) {
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
              fontFamily: 'Noto Serif',
              fontSize: 22,
              fontStyle: FontStyle.italic,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Get.locale?.languageCode == 'zh' ? 'Preferences & Security' : '偏好与安全设置',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textVariantColor,
              letterSpacing: 1,
            ),
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
            trailing: Container(
              width: 48,
              height: 24,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Align(
                alignment: Alignment.centerRight,
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
          ),
        ],
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
              const SizedBox(height: 2),
              Text(
                titleZh,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
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
