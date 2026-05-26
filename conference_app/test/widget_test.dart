import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:conference_app/controllers/auth_controller.dart';
import 'package:conference_app/controllers/event_controller.dart';
import 'package:conference_app/controllers/schedule_controller.dart';
import 'package:conference_app/controllers/speaker_controller.dart';
import 'package:conference_app/models/site_content_model.dart';
import 'package:conference_app/screens/apscvir_content_screen.dart';
import 'package:conference_app/screens/apscvir_maps_screen.dart';
import 'package:conference_app/screens/main_navigation_screen.dart';
import 'package:conference_app/services/api_service.dart';
import 'package:conference_app/services/notification_service.dart';
import 'package:conference_app/services/storage_service.dart';
import 'package:conference_app/theme/app_theme.dart';
import 'package:conference_app/utils/translations.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    Get.reset();

    final storage = await StorageService().init();
    Get.put(storage);
    Get.put(ApiService());
    Get.put(NotificationService());
    Get.put(AuthController());
    Get.put(EventController());
    Get.put(ScheduleController());
    Get.put(SpeakerController());
    addTearDown(Get.reset);

    await tester.pumpWidget(
      GetMaterialApp(
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        theme: AppTheme.light,
        home: const MainNavigationScreen(),
      ),
    );
    for (var i = 0; i < 20 && !tester.any(find.text('Info')); i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify the main APSCVIR shell renders.
    expect(find.text('Info'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('ISMIO'), findsOneWidget);
  });

  testWidgets('Maps screen renders local map image on mobile', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    Get.reset();
    addTearDown(Get.reset);

    tester.view.physicalSize = const Size(1080, 2160);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: ApscvirMapsScreen(
          manifestFuture: Future.value(
            _testManifest(
              pages: [
                _testPage(id: '1520613', title: 'Venue'),
                _testPage(id: '1520615', title: 'Transportation'),
                _testPage(id: '1520616', title: 'About Suzhou'),
                _testPage(id: '1520614', title: 'Touring'),
              ],
            ),
          ),
        ),
      ),
    );
    for (var i = 0; i < 20 && !tester.any(find.text('Download')); i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(tester.takeException(), isNull);
    expect(find.text('Conference Address'), findsOneWidget);
    expect(find.text('Copy Address'), findsOneWidget);
    expect(find.text('Navigation'), findsOneWidget);
    expect(find.text('Venue Map Image'), findsOneWidget);
    expect(find.text('Download'), findsOneWidget);
  });

  testWidgets('Program at a glance renders on mobile', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    Get.reset();
    addTearDown(Get.reset);

    final manifest = _testManifest();
    final page = SitePage(
      id: '1814796',
      title: 'Program-at-a-Glance',
      url: 'https://www.apscvir2026.com/en/minisite/program-view/29839',
      htmlAsset: '',
      color: AppColors.primary,
      images: const [],
      downloads: const [],
      blocks: const [],
      plainText: '',
    );

    tester.view.physicalSize = const Size(1080, 2160);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: ApscvirContentScreen(page: page, manifest: manifest),
      ),
    );
    await tester.pump();

    expect(find.text('Program-at-a-Glance'), findsWidgets);
    expect(find.text('A1-A101'), findsOneWidget);
    expect(find.text('EVAR and TEVAR 1'), findsOneWidget);

    await tester.tap(find.text('EVAR and TEVAR 1'));
    await tester.pump();
    for (var i = 0; i < 20 && !tester.any(find.text('Session Details')); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('Session Details'), findsOneWidget);
    expect(find.text('14:00 - 15:30'), findsWidgets);
    expect(find.textContaining('program_id=1199392'), findsOneWidget);
    expect(find.text('Faculty'), findsOneWidget);

    Get.back();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('12'));
    await tester.pump();

    expect(find.text('Loading sessions for this date...'), findsOneWidget);
  });

  testWidgets('Visa page renders complete policy regions', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    Get.reset();
    addTearDown(Get.reset);

    final manifest = _testManifest();
    final page = SitePage(
      id: '1411158',
      title: 'Visa',
      url: 'https://www.apscvir2026.com/en/minisite/content/29839?m=1411158',
      htmlAsset: '',
      color: AppColors.primary,
      images: const [],
      downloads: const [],
      blocks: const [],
      plainText: '',
    );

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: ApscvirContentScreen(page: page, manifest: manifest),
      ),
    );
    await tester.pump();

    expect(find.text('Visa'), findsWidgets);
    expect(
      find.text(
        'China’s 240-hour Visa-Free Transit Policy Coverage to 55 Countries',
      ),
      findsOneWidget,
    );
    expect(find.text('North America (2 countries)'), findsOneWidget);
    expect(find.text('South America (4 countries)'), findsOneWidget);
    expect(find.text('Asia (7 countries)'), findsOneWidget);
    expect(find.text('Open Official Visa Policy'), findsOneWidget);
  });

  testWidgets('Download Center renders downloadable template entries', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    Get.reset();
    addTearDown(Get.reset);

    final page = SitePage(
      id: '1411172',
      title: 'Download Center',
      url: 'https://www.apscvir2026.com/en/minisite/list/29839?m=1411172',
      htmlAsset: '',
      color: AppColors.primary,
      images: const [],
      downloads: const [],
      blocks: const [],
      plainText: '',
    );

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: ApscvirContentScreen(page: page, manifest: _testManifest()),
      ),
    );
    await tester.pump();

    expect(find.text('Download Center'), findsWidgets);
    expect(find.text('Poster Template Download'), findsOneWidget);
    expect(find.text('PowerPoint Templates Download'), findsOneWidget);
    expect(find.text('Download PPTX'), findsNWidgets(2));
  });
}

SiteManifest _testManifest({List<SitePage> pages = const []}) {
  return SiteManifest(
    conference: ConferenceInfo(
      title:
          '20th Annual Scientific Meeting of Asia Pacific Society of Cardiovascular and Interventional Radiology',
      shortTitle: 'APSCVIR 2026',
      date: 'June 11-14, 2026',
      venue: 'Suzhou International Expo Centre',
      location: 'Suzhou, China',
      sourceUrl: 'https://www.apscvir2026.com',
      theme: SiteTheme(
        primary: AppColors.primary,
        primaryDark: AppColors.primaryDark,
        background: AppColors.background,
      ),
    ),
    homeImages: const [],
    menu: const [],
    pages: pages,
  );
}

SitePage _testPage({required String id, required String title}) {
  return SitePage(
    id: id,
    title: title,
    url: '',
    htmlAsset: '',
    color: AppColors.primary,
    images: const [],
    downloads: const [],
    blocks: const [],
    plainText: '',
  );
}
