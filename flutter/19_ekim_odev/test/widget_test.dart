import 'package:flutter_test/flutter_test.dart';
import 'package:kirmizi_cagri/core/theme/theme_controller.dart';
import 'package:kirmizi_cagri/main.dart';

void main() {
  testWidgets('Kırmızı Çağrı app smoke test and initial render', (WidgetTester tester) async {
    final themeController = ThemeController();

    await tester.pumpWidget(KirmiziCagriApp(themeController: themeController));
    await tester.pumpAndSettle();

    expect(find.text('Kırmızı Çağrı'), findsOneWidget);
    expect(find.text('Acil Kan Çağrıları'), findsOneWidget);
    expect(find.text('Çağrılar'), findsOneWidget);
    expect(find.text('Geçmiş'), findsOneWidget);
    expect(find.text('İstatistik'), findsOneWidget);
    expect(find.text('Profilim'), findsOneWidget);
  });
}
