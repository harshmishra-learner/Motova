// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:motova/main.dart';
void main() {
  testWidgets('MotovaApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MotovaApp());

    // Confirms the theme-check screen from Day 1 renders correctly.
    expect(find.text('MOTOVA'), findsOneWidget);
  });
}