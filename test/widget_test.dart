// This is a basic Flutter widget test for our Timer app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:your_timer/main.dart';

void main() {
  testWidgets('Timer app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: const MyApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('Time is Money'), findsOneWidget);
    expect(find.text('Never lose track of time'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
