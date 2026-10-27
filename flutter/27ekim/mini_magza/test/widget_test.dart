import 'package:flutter_test/flutter_test.dart';
import 'package:mini_magza/main.dart';

void main() {
  testWidgets('MiniMagazaUygulamasi test', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniMagazaUygulamasi());
    await tester.pumpAndSettle();
    expect(find.byType(MiniMagazaUygulamasi), findsOneWidget);
  });
}
