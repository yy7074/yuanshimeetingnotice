import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'event_portal_screen.dart';
import 'my_schedule_screen.dart';
import 'speakers_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0; // Default to Events tab

  final List<Widget> _screens = [
    const EventPortalScreen(),
    const MyScheduleScreen(),
    const SpeakersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF196EE6);
    const Color unselectedColor = Color(0xFF94A3B8); // slate-400

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.9 * 255).round()),
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: primaryColor,
            unselectedItemColor: unselectedColor,
            selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.5),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month_outlined),
                activeIcon: const Icon(Icons.calendar_month),
                label: 'nav_events'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.schedule_outlined),
                activeIcon: const Icon(Icons.schedule),
                label: 'nav_schedule'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.groups_outlined),
                activeIcon: const Icon(Icons.groups),
                label: 'nav_speakers'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: 'nav_profile'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
