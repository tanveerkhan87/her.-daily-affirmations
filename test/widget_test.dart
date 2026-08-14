import 'package:flutter_test/flutter_test.dart';
import 'package:her_daily_affirmations/main.dart';

void main() {
  testWidgets('App smoke test — renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const HerApp());
    await tester.pump();
    expect(find.text('Her.'), findsWidgets);
  });
}
