import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'event_portal_screen.dart';
import 'my_schedule_screen.dart';
import 'speakers_screen.dart';
import 'profile_screen.dart';
import '../services/notification_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const EventPortalScreen(),
    const MyScheduleScreen(),
    const SpeakersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF196EE6);
    const Color unselectedColor = Color(0xFF94A3B8);

    final notifService = Get.find<NotificationService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('APSCVIR', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Color(0xFF0F172A))),
        actions: [
          Obx(() {
            final count = notifService.unreadCount.value;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Color(0xFF0F172A)),
                  onPressed: () async {
                    await Get.toNamed('/notifications');
                    notifService.refreshUnreadCount();
                  },
                ),
                if (count > 0)
                  Positioned(
                    right: 8, top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text('$count', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.9 * 255).round()),
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: primaryColor,
            unselectedItemColor: unselectedColor,
            selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.5),
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.calendar_month_outlined), activeIcon: const Icon(Icons.calendar_month), label: 'nav_events'.tr),
              BottomNavigationBarItem(icon: const Icon(Icons.schedule_outlined), activeIcon: const Icon(Icons.schedule), label: 'nav_schedule'.tr),
              BottomNavigationBarItem(icon: const Icon(Icons.groups_outlined), activeIcon: const Icon(Icons.groups), label: 'nav_speakers'.tr),
              BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: 'nav_profile'.tr),
            ],
          ),
        ),
      ),
    );
  }
}
