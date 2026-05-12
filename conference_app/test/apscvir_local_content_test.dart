import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:conference_app/controllers/schedule_controller.dart';
import 'package:conference_app/services/apscvir_site_service.dart';
import 'package:conference_app/services/data_service.dart';
import 'package:conference_app/services/storage_service.dart';
import 'package:conference_app/utils/apscvir_external_links.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('APSCVIR local content manifest has loadable pages and files', () async {
    final manifest = await ApscvirSiteService.loadManifest();

    expect(manifest.conference.shortTitle, contains('APSCVIR'));
    expect(manifest.flattenedMenu.length, greaterThan(8));

    final pagesById = manifest.pageById;
    for (final item in manifest.flattenedMenu) {
      expect(pagesById[item.id], isNotNull, reason: item.title);
    }

    final representativePageIds = {'1411156', '1814797', '1411178', '1411172'};
    for (final pageId in representativePageIds) {
      final page = pagesById[pageId];
      expect(page, isNotNull, reason: pageId);
      final html = await rootBundle.loadString(page!.htmlAsset);
      expect(html.trim(), isNotEmpty, reason: page.title);
    }

    final downloads = manifest.pages.expand((page) => page.downloads).toList();
    expect(downloads, isNotEmpty);
    for (final item in downloads) {
      final bytes = await rootBundle.load(item.asset);
      expect(bytes.lengthInBytes, greaterThan(0), reason: item.label);
    }

    final mapBytes = await rootBundle.load(
      'assets/apscvir2026/images/apscvir-venue-map.png',
    );
    expect(mapBytes.lengthInBytes, greaterThan(0));

    const downloadCenterAssets = [
      'assets/apscvir2026/images/download-center-01-2026012114135281027954163-85d88862d0.png',
      'assets/apscvir2026/images/download-center-02-2025090813425917869531024-ace71f351d.jpg',
      'assets/apscvir2026/files/abstract-results-file-12-2026011612540371016584932-cdb76d459a.pptx',
      'assets/apscvir2026/files/abstract-results-file-11-2026011523030913765941028-dd610fbb04.pptx',
    ];
    for (final asset in downloadCenterAssets) {
      final bytes = await rootBundle.load(asset);
      expect(bytes.lengthInBytes, greaterThan(0), reason: asset);
    }

    final venuePage = pagesById['1520613'];
    expect(venuePage, isNotNull);
    expect(isApscvirVenuePage(venuePage!), isTrue);
    expect(
      apscvirVenueExternalUrl,
      'https://en.suzhouexpo.com/index.aspx#section-1',
    );
  });

  test(
    'APSCVIR faculty page has local speaker data and avatar assets',
    () async {
      final manifest = await ApscvirSiteService.loadManifest();
      final facultyPage = manifest.pageById['1411179'];
      expect(facultyPage, isNotNull);

      final html = await rootBundle.loadString(facultyPage!.htmlAsset);
      final facultyItems = RegExp(
        r'<li\b(?=[^>]*mui-indexed-list-item)([\s\S]*?)</li>',
      ).allMatches(html);

      expect(facultyItems.length, greaterThan(300));
      expect(html, contains('AbdulRahman Alvi'));
      expect(html, contains('Bulent Arslan'));
      expect(html, contains('Rush University Medical Center in Chicago, USA'));
      expect(facultyPage.images.length, greaterThan(300));

      final firstAvatar = facultyPage.images.firstWhere(
        (image) => image.asset.contains('faculty-'),
      );
      final bytes = await rootBundle.load(firstAvatar.asset);
      expect(bytes.lengthInBytes, greaterThan(0));
    },
  );

  test(
    'APSCVIR hotel reservation page has third-party booking links',
    () async {
      final manifest = await ApscvirSiteService.loadManifest();
      final hotelPage = manifest.pageById['1411162'];
      expect(hotelPage, isNotNull);

      final html = await rootBundle.loadString(hotelPage!.htmlAsset);
      final bookingLinks = RegExp(
        r'<a\b(?=[^>]*book-button)[^>]*href="([^"]+)"',
      ).allMatches(html).map((match) => match.group(1) ?? '').toList();

      expect(bookingLinks.length, 5);
      expect(html, contains('InterContinental Suzhou'));
      expect(html, contains('Hyatt Regency Suzhou'));
      expect(html, contains('Shangri-La Suzhou, SIP'));
      expect(html, contains('AC Hotel By Marriott Suzhou SIP'));
      expect(html, contains('Suzhou Kempinski Hotel'));
      expect(bookingLinks.any((url) => url.contains('ihg.com')), isTrue);
      expect(bookingLinks.any((url) => url.contains('hyatt.com')), isTrue);
      expect(bookingLinks.any((url) => url.contains('shangri-la.com')), isTrue);
      expect(bookingLinks.any((url) => url.contains('marriott.com')), isTrue);
      expect(bookingLinks.any((url) => url.contains('kempinski.com')), isTrue);
    },
  );

  test('APSCVIR detailed program can populate My Schedule locally', () async {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    Get.reset();
    addTearDown(Get.reset);

    final storage = await StorageService().init();
    Get.put(storage);
    final scheduleCtrl = Get.put(ScheduleController());

    final sessions = await DataService.getDetailedSessions(
      DataService.apscvir2026EventId,
    );
    final uniqueSessionIds = sessions.map((session) => session.id).toSet();
    expect(sessions.length, greaterThan(100));
    expect(uniqueSessionIds.length, sessions.length);
    expect(
      sessions.any(
        (session) =>
            session.dayIndex == 1 && session.titleEn == 'Opening Ceremony',
      ),
      isTrue,
    );
    final tasks = await DataService.getProgramTasks(
      DataService.apscvir2026EventId,
    );
    expect(tasks.length, greaterThan(300));
    expect(
      tasks.any(
        (session) =>
            session.speakerName == 'Ning Ai' &&
            session.parentSessionTitle ==
                'Executive Master of Interventional Radiology 3' &&
            session.roomEn == 'A1-A108',
      ),
      isTrue,
    );
    expect(
      tasks.any(
        (session) =>
            session.speakerName == 'Chang Liu' &&
            session.taskRole.toLowerCase().contains('moderator'),
      ),
      isTrue,
    );

    await scheduleCtrl.toggleSessionModel(sessions.first);
    expect(
      storage.subscribedEventIds,
      contains(DataService.apscvir2026EventId),
    );
    expect(storage.savedSessionIds, contains(sessions.first.id));
    expect(storage.hydratedScheduleEventIds, isEmpty);

    final added = await scheduleCtrl.addAllSessionsFromEvent(
      DataService.apscvir2026EventId,
    );
    expect(added, isTrue);
    expect(
      storage.hydratedScheduleEventIds,
      contains(DataService.apscvir2026EventId),
    );
    expect(storage.savedSessionIds.length, uniqueSessionIds.length);
  });
}
