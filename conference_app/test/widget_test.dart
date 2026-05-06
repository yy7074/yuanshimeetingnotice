import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:conference_app/controllers/auth_controller.dart';
import 'package:conference_app/main.dart';
import 'package:conference_app/services/api_service.dart';
import 'package:conference_app/services/storage_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    Get.reset();

    final storage = await StorageService().init();
    Get.put(storage);
    Get.put(ApiService());
    Get.put(AuthController());
    addTearDown(Get.reset);

    await tester.pumpWidget(
      const ConferenceApp(initialLocale: Locale('en', 'US')),
    );
    await tester.pumpAndSettle();

    // Verify the login screen renders
    expect(find.text('APSCVIR'), findsOneWidget);
    expect(find.textContaining('Sign In'), findsWidgets);
  });
}
