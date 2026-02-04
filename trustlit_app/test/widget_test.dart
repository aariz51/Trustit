// This is a basic Flutter widget test for TrustLit app.

import 'package:flutter_test/flutter_test.dart';

import 'package:trustlit_app/main.dart';

void main() {
  testWidgets('TrustLit app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TrustLitApp());

    // Verify the app renders without errors
    expect(find.byType(TrustLitApp), findsOneWidget);
  });
}
