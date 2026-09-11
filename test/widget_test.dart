import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paw_rakshak/main.dart';

void main() {
  testWidgets('PawRakshak landing page and live dashboard smoke test', (WidgetTester tester) async {
    // Build PawRakshak app
    await tester.pumpWidget(const PawRakshakApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Landing Page elements
    expect(find.text('PawRakshak'), findsWidgets);
    expect(find.text('OVER 1,400 ACTIVE VOLUNTEERS IN GUJARAT'), findsOneWidget);
    expect(find.text('Enter Live Rescue Dashboard'), findsOneWidget);

    // Tap to switch to Live Dashboard
    await tester.tap(find.text('Enter Live Rescue Dashboard'));
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Live Dashboard elements
    expect(find.text('Live Rescue Dashboard'), findsOneWidget);
    expect(find.text('Active Cases'), findsOneWidget);
    expect(find.text('Vets Online'), findsOneWidget);
    expect(find.text('Care Fund'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget); // Search bar
  });
}
