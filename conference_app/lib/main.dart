import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/translations.dart';
import 'services/storage_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/event_controller.dart';
import 'controllers/schedule_controller.dart';
import 'controllers/speaker_controller.dart';
import 'services/api_service.dart';
import 'services/apscvir_site_service.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/startup_screen.dart';
import 'screens/change_password_screen.dart' deferred as change_password_screen;
import 'screens/digital_check_in_screen.dart' deferred as digital_check_in_screen;
import 'screens/event_agenda_screen.dart' deferred as event_agenda_screen;
import 'screens/event_portal_screen.dart' deferred as event_portal_screen;
import 'screens/login_screen.dart' deferred as login_screen;
import 'screens/my_schedule_screen.dart' deferred as my_schedule_screen;
import 'screens/notification_screen.dart' deferred as notification_screen;
import 'screens/profile_edit_screen.dart' deferred as profile_edit_screen;
import 'screens/register_screen.dart' deferred as register_screen;
import 'screens/speaker_detail_screen.dart' deferred as speaker_detail_screen;
import 'screens/speakers_screen.dart' deferred as speakers_screen;
import 'widgets/deferred_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storage = await StorageService().init();
  Get.put(storage);

  // Initialize API service
  Get.put(ApiService());
  unawaited(ApscvirSiteService.refreshRemoteContent());

  // Register notification service (init lazily, don't block app startup)
  final notificationService = NotificationService();
  Get.put(notificationService);

  // Initialize controllers
  Get.put(AuthController());
  Get.put(EventController());
  Get.put(ScheduleController());
  Get.put(SpeakerController());

  await storage.saveLanguage('en');
  const locale = Locale('en', 'US');

  runApp(ConferenceApp(initialLocale: locale));

  // Initialize notification service after UI is running (non-blocking)
  unawaited(
    Future<void>(() async {
      try {
        await notificationService.init();
      } catch (e) {
        debugPrint('NotificationService init failed: $e');
      }
    }),
  );
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
      theme: AppTheme.light,
      initialRoute: '/startup',
      getPages: [
        GetPage(name: '/startup', page: () => const StartupScreen()),
        GetPage(
          name: '/login',
          page: () => DeferredScreen(
            load: () async {
              await login_screen.loadLibrary();
              return login_screen.LoginScreen();
            },
          ),
        ),
        GetPage(name: '/main', page: () => const MainNavigationScreen()),
        GetPage(
          name: '/event_portal',
          page: () => DeferredScreen(
            load: () async {
              await event_portal_screen.loadLibrary();
              return event_portal_screen.EventPortalScreen();
            },
          ),
        ),
        GetPage(
          name: '/event_agenda',
          page: () => DeferredScreen(
            load: () async {
              await event_agenda_screen.loadLibrary();
              return event_agenda_screen.EventAgendaScreen();
            },
          ),
        ),
        GetPage(
          name: '/my_schedule',
          page: () => DeferredScreen(
            load: () async {
              await my_schedule_screen.loadLibrary();
              return my_schedule_screen.MyScheduleScreen();
            },
          ),
        ),
        GetPage(
          name: '/digital_check_in',
          page: () => DeferredScreen(
            load: () async {
              await digital_check_in_screen.loadLibrary();
              return digital_check_in_screen.DigitalCheckInScreen();
            },
          ),
        ),
        GetPage(
          name: '/register',
          page: () => DeferredScreen(
            load: () async {
              await register_screen.loadLibrary();
              return register_screen.RegisterScreen();
            },
          ),
        ),
        GetPage(
          name: '/change_password',
          page: () => DeferredScreen(
            load: () async {
              await change_password_screen.loadLibrary();
              return change_password_screen.ChangePasswordScreen();
            },
          ),
        ),
        GetPage(
          name: '/notifications',
          page: () => DeferredScreen(
            load: () async {
              await notification_screen.loadLibrary();
              return notification_screen.NotificationScreen();
            },
          ),
        ),
        GetPage(
          name: '/profile_edit',
          page: () => DeferredScreen(
            load: () async {
              await profile_edit_screen.loadLibrary();
              return profile_edit_screen.ProfileEditScreen();
            },
          ),
        ),
        GetPage(
          name: '/speaker_detail',
          page: () => DeferredScreen(
            load: () async {
              await speaker_detail_screen.loadLibrary();
              return speaker_detail_screen.SpeakerDetailScreen();
            },
          ),
        ),
        GetPage(
          name: '/speakers',
          page: () => DeferredScreen(
            load: () async {
              await speakers_screen.loadLibrary();
              return speakers_screen.SpeakersScreen();
            },
          ),
        ),
      ],
    );
  }
}
