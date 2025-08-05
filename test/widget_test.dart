// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:biztracker/main.dart';

void main() {
  testWidgets('BizTracker app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BizTrackerApp());

    // Verify that the app title is displayed
    expect(find.text('BizTracker'), findsOneWidget);
    expect(find.text('Your Business, Simplified'), findsOneWidget);

    // Verify that the splash screen is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
