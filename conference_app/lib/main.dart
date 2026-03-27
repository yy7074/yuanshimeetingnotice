import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/translations.dart';
import 'services/storage_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/event_controller.dart';
import 'controllers/schedule_controller.dart';
import 'controllers/speaker_controller.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/event_portal_screen.dart';
import 'screens/event_agenda_screen.dart';
import 'screens/my_schedule_screen.dart';
import 'screens/digital_check_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storage = await StorageService().init();
  Get.put(storage);

  // Initialize controllers
  Get.put(AuthController());
  Get.put(EventController());
  Get.put(ScheduleController());
  Get.put(SpeakerController());

  // Restore saved language
  final locale = storage.languageCode == 'en'
      ? const Locale('en', 'US')
      : const Locale('zh', 'CN');

  runApp(ConferenceApp(initialLocale: locale));
}

class ConferenceApp extends StatelessWidget {
  final Locale initialLocale;
  const ConferenceApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'APSCVIR',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: initialLocale,
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
