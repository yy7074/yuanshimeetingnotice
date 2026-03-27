import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conference_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ConferenceApp(initialLocale: Locale('zh', 'CN')));
    await tester.pumpAndSettle();

    // Verify the login screen renders
    expect(find.text('APSCVIR'), findsOneWidget);
  });
}
