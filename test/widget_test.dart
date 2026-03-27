import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legal_quest/main.dart';

void main() {
  testWidgets('Legal Quest app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LegalQuestApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
