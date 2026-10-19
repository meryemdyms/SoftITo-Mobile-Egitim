import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım ana ekran ve tab bar duman testi', (WidgetTester tester) async {
    // Test ekran boyutunu ayarla
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    // Uygulama başlığı ve alt navigasyon öğeleri kontrolü
    expect(find.text('💧 Susadım - Su Takibi'), findsOneWidget);
    expect(find.text('Su Takibi'), findsOneWidget);
    expect(find.text('Egzersiz & Kalori'), findsOneWidget);

    // Hızlı su ekleme butonuna basılması (+200)
    final add200Button = find.widgetWithText(InkWell, '200');
    expect(add200Button, findsOneWidget);
    await tester.ensureVisible(add200Button);
    await tester.tap(add200Button);
    await tester.pumpAndSettle();

    // 200 ml eklenmiş olmalı ve listede gözükmeli
    expect(find.text('+200 ml'), findsOneWidget);

    // Egzersiz sekmesine geçiş
    await tester.tap(find.text('Egzersiz & Kalori'));
    await tester.pumpAndSettle();

    expect(find.text('⚡ Susadım - Egzersiz'), findsOneWidget);
    expect(find.text('Egzersiz Kaydet'), findsOneWidget);
  });

  testWidgets('Hedefe ulaşıldığında tebrikler popup diyaloğu gösterilmelidir', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    final add750Button = find.widgetWithText(InkWell, '750');
    final add500Button = find.widgetWithText(InkWell, '500');

    await tester.ensureVisible(add750Button);
    // 3 x 750 = 2250 ml (hedef 2500 henüz aşılmadı)
    await tester.tap(add750Button);
    await tester.pumpAndSettle();
    await tester.tap(add750Button);
    await tester.pumpAndSettle();
    await tester.tap(add750Button);
    await tester.pumpAndSettle();
    expect(find.text('Tebrikler! 🎉'), findsNothing);

    // 2250 + 500 = 2750 ml (hedef aşıldı, popup açılmalı)
    await tester.tap(add500Button);
    await tester.pumpAndSettle();

    expect(find.text('Tebrikler! 🎉'), findsOneWidget);
    expect(find.text('Günlük Su Hedefine Ulaştın'), findsOneWidget);
    expect(find.text('Harika! Devam Et'), findsOneWidget);

    // Diyaloğu kapat
    await tester.tap(find.text('Harika! Devam Et'));
    await tester.pumpAndSettle();
    expect(find.text('Tebrikler! 🎉'), findsNothing);
  });
}
