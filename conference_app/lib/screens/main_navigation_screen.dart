import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apscvir_home_screen.dart';
import 'apscvir_search_screen.dart' deferred as apscvir_search_screen;
import 'notification_screen.dart' deferred as notification_screen;
import 'profile_screen.dart' deferred as profile_screen;
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/deferred_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _selectIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  List<Widget> get _screens => [
    const ApscvirHomeScreen(),
    DeferredScreen(
      load: () async {
        await notification_screen.loadLibrary();
        return notification_screen.NotificationScreen(
          onBackToHome: () => _selectIndex(0),
        );
      },
    ),
    DeferredScreen(
      load: () async {
        await apscvir_search_screen.loadLibrary();
        return apscvir_search_screen.ApscvirSearchScreen(
          onBackToHome: () => _selectIndex(0),
        );
      },
    ),
    DeferredScreen(
      load: () async {
        await profile_screen.loadLibrary();
        return profile_screen.ProfileScreen();
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const Color unselectedColor = Colors.white70;

    final notifService = Get.find<NotificationService>();

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectedIndex != 0) {
          _selectIndex(0);
        }
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: AppColors.primary),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _selectIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.primary,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: unselectedColor,
              iconSize: 30,
              selectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(_ApscvirNavIcons.list),
                  activeIcon: Icon(_ApscvirNavIcons.list),
                  label: 'Info',
                ),
                BottomNavigationBarItem(
                  icon: Obx(
                    () => _AlertIcon(count: notifService.unreadCount.value),
                  ),
                  activeIcon: Obx(
                    () => _AlertIcon(count: notifService.unreadCount.value),
                  ),
                  label: 'Alerts',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(_ApscvirNavIcons.search),
                  activeIcon: Icon(_ApscvirNavIcons.search),
                  label: 'Search',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(_ApscvirNavIcons.cog),
                  activeIcon: Icon(_ApscvirNavIcons.cog),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertIcon extends StatelessWidget {
  final int count;

  const _AlertIcon({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(_ApscvirNavIcons.bell),
        if (count > 0)
          Positioned(
            right: -8,
            top: -8,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ApscvirNavIcons {
  static const String _fontFamily = 'ApscvirFontello';

  static const list = IconData(0xe809, fontFamily: _fontFamily);
  static const bell = IconData(0xe85a, fontFamily: _fontFamily);
  static const search = IconData(0xe81d, fontFamily: _fontFamily);
  static const cog = IconData(0xe8b2, fontFamily: _fontFamily);
}
