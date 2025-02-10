// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_viewer/main.dart';
import 'package:note_viewer/providers/activity_provider.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/courses_provider.dart';
import 'package:note_viewer/providers/dashboard_provider.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/units_provider.dart';
import 'package:note_viewer/providers/uploads_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create mock instances of the required providers
    final authProvider = AuthProvider();
    final toggleProvider = TogglesProvider();
    final coursesProvider = CoursesProvider();
    final unitsProvider = UnitsProvider();
    final userProvider = UserProvider();
    final lessonsProvider = LessonsProvider();
    final uploadsProvider = UploadsProvider();
    final dashboardProvider = DashboardProvider();
    final activityProvider = ActivityProvider();

    // Initialize providers with default values if necessary
    await authProvider.checkLogin();
    await toggleProvider.loadRememberSelection();

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(
      authProvider: authProvider,
      toggleProvider: toggleProvider,
      coursesProvider: coursesProvider,
      unitsProvider: unitsProvider,
      userProvider: userProvider,
      lessonsProvider: lessonsProvider,
      uploadsProvider: uploadsProvider,
      dashboardProvider: dashboardProvider,
      activityProvider: activityProvider,
    ));

    // Verify that our counter starts at 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
