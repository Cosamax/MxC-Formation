import 'package:flutter_test/flutter_test.dart';
import 'package:mxc_formations/main.dart';

void main() {
  testWidgets('MxC Formations app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MxCFormationsApp());
    expect(find.byType(MxCFormationsApp), findsOneWidget);
  });
}
