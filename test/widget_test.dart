// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_test/core/widgets/liquid_glass_card.dart';

void main() {
  testWidgets('LiquidGlassCard renders properly with child and styles', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LiquidGlassCard(
            blur: 15.0,
            borderRadius: 20.0,
            child: Text('Test Glass Card Content'),
          ),
        ),
      ),
    );

    expect(find.text('Test Glass Card Content'), findsOneWidget);
    expect(find.byType(LiquidGlassCard), findsOneWidget);
  });
}

