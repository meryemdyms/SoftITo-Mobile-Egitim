import 'package:flutter_test/flutter_test.dart';
import 'package:car_rental_platform/app/app.dart';
import 'package:car_rental_platform/app/di/app_providers.dart';

void main() {
  testWidgets('Car Rental App launches and renders search discover view', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AppProviders(child: CarRentalApp()));

    // Initial pump
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify main screen elements
    expect(find.text('Araç Kirala'), findsOneWidget);
    expect(find.text('Keşfet'), findsOneWidget);
    expect(find.text('Harita'), findsOneWidget);
    expect(find.text('Fırsatlar'), findsOneWidget);
    expect(find.text('Rezervasyon'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
