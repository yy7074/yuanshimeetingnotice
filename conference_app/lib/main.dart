import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/translations.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/event_portal_screen.dart';
import 'screens/event_agenda_screen.dart';
import 'screens/my_schedule_screen.dart';
import 'screens/digital_check_in_screen.dart';

void main() {
  runApp(const ConferenceApp());
}

class ConferenceApp extends StatelessWidget {
  const ConferenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'APSCVIR',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('zh', 'CN'), // Default language
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/main', page: () => const MainNavigationScreen()),
        GetPage(name: '/event_portal', page: () => const EventPortalScreen()),
        GetPage(name: '/event_agenda', page: () => const EventAgendaScreen()),
        GetPage(name: '/my_schedule', page: () => const MyScheduleScreen()),
        GetPage(name: '/digital_check_in', page: () => const DigitalCheckInScreen()),
      ],
    );
  }
}
