import 'dart:math';
import 'package:flutter/material.dart';

/// Sanat Eserlerinin Vektörel Çizim Motoru (CustomPainter).
///
/// `project.md` 7. Gizli Yapboz Sistemi ve 10. Başarı Koleksiyonu için harici görsel
/// bağımlılığı olmadan, saf Flutter Canvas API'si kullanarak yüksek çözünürlüklü,
/// estetik ve vektörel manzaralar çizer.
///
/// Desteklenen temalar:
/// - `forest`: Zümrüt orman, güneş huzmeleri ve çam ağaçları
/// - `starry`: Gece gökyüzü, hilal ve yıldızlar
/// - `sunrise`: Sıcak gün doğumu ve katmanlı dağlar
/// - `lake`: Dingin göl yüzeyi ve dağ yansımaları
/// - `antique`: Sarmaşıklı antik taş kemer
/// - `lighthouse`: Alacakaranlıkta ışık saçan deniz feneri
class ArtworkPainter extends CustomPainter {
  /// Çizilecek sanat eserinin tema anahtarı
  final String themeKey;

  ArtworkPainter({required this.themeKey});

  @override
  void paint(Canvas canvas, Size size) {
    switch (themeKey) {
      case 'forest':
        _paintForest(canvas, size);
        break;
      case 'starry':
        _paintStarry(canvas, size);
        break;
      case 'sunrise':
        _paintSunrise(canvas, size);
        break;
      case 'lake':
        _paintLake(canvas, size);
        break;
      case 'antique':
        _paintAntique(canvas, size);
        break;
      case 'lighthouse':
      default:
        _paintLighthouse(canvas, size);
        break;
    }
  }

  /// 'Ormanın Şarkısı' (forest) temasını çizer: Doğal yeşil tonları ve çam ağaçları.
  void _paintForest(Canvas canvas, Size size) {
    // 1. Arka plan gradyanı: Açık zümrütten koyu çam yeşiline geçiş
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8FBC8F), Color(0xFF2E4F3E), Color(0xFF1B3327)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Güneş ışığı huzmesi (Bulanık daire)
    final sunPaint = Paint()
      ..color = const Color(0x33FFE89E)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.25), size.width * 0.3, sunPaint);

    // 3. Uzak dağ silüeti
    final mountainPaint = Paint()..color = const Color(0x55254A37);
    final mPath = Path()
      ..moveTo(0, size.height * 0.6)
      ..lineTo(size.width * 0.35, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.55)
      ..lineTo(size.width, size.height * 0.42)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(mPath, mountainPaint);

    // 4. Ağaç gövdeleri ve yaprak dokusu
    final treePaint = Paint()..color = const Color(0xFF152A20);
    final trunkPaint = Paint()
      ..color = const Color(0xFF3B271A)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    // Belirli yatay noktalara çam ağaçları yerleştir
    final treeXPositions = [0.15, 0.3, 0.48, 0.68, 0.85];
    for (int i = 0; i < treeXPositions.length; i++) {
      final x = size.width * treeXPositions[i];
      final baseY = size.height * 0.95;
      final trunkTop = baseY - size.height * 0.35;
      canvas.drawLine(Offset(x, baseY), Offset(x, trunkTop), trunkPaint);

      // Üçgen çam yaprakları
      final foliagePath = Path();
      final treeTop = trunkTop - size.height * 0.25;
      foliagePath.moveTo(x, treeTop);
      foliagePath.lineTo(x - size.width * 0.12, trunkTop + size.height * 0.08);
      foliagePath.lineTo(x + size.width * 0.12, trunkTop + size.height * 0.08);
      foliagePath.close();
      canvas.drawPath(foliagePath, treePaint);
    }
  }

  /// 'Yıldızlı Düşler' (starry) temasını çizer: Gece göğü, hilal ve rastgele yıldızlar.
  void _paintStarry(Canvas canvas, Size size) {
    // Gece gökyüzü gradyanı
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Ay ve hilal gölgesi
    final moonPaint = Paint()..color = const Color(0xFFFDE68A);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.2), size.width * 0.12, moonPaint);
    final moonShadow = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.19), size.width * 0.11, moonShadow);

    // Rastgele parıldayan yıldızlar
    final starPaint = Paint()..color = Colors.white;
    final rand = Random(42); // Sabit tohum ile her çizimde aynı yıldız dağılımı
    for (int i = 0; i < 40; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height * 0.65;
      final radius = rand.nextDouble() * 2 + 1;
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }

    // Tepe silüeti
    final hillPaint = Paint()..color = const Color(0xFF0B1120);
    final hillPath = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.65, size.width, size.height * 0.75)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillPath, hillPaint);
  }

  /// 'Gündoğumu Tepesi' (sunrise) temasını çizer: Sıcak şafak renkleri ve ufuk dağları.
  void _paintSunrise(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE07A5F), Color(0xFFF4A261), Color(0xFFF6BD60), Color(0xFF84A59D)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Doğan Güneş diski
    final sunPaint = Paint()..color = const Color(0xFFFFF3B0);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.45), size.width * 0.18, sunPaint);

    // 1. Dağ Katmanı
    final mountain1 = Paint()..color = const Color(0x886B705C);
    final path1 = Path()
      ..moveTo(0, size.height * 0.58)
      ..lineTo(size.width * 0.35, size.height * 0.42)
      ..lineTo(size.width * 0.75, size.height * 0.52)
      ..lineTo(size.width, size.height * 0.45)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path1, mountain1);

    // 2. Dağ Katmanı (Ön plan)
    final mountain2 = Paint()..color = const Color(0xFF3F4E4F);
    final path2 = Path()
      ..moveTo(0, size.height * 0.68)
      ..lineTo(size.width * 0.55, size.height * 0.55)
      ..lineTo(size.width, size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path2, mountain2);
  }

  /// 'Sessiz Göl Kıyısı' (lake) temasını çizer: Ayna gibi sakin su ve yansımalar.
  void _paintLake(Canvas canvas, Size size) {
    // Gökyüzü yarısı
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF90E0EF), Color(0xFFCAF0F8)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.5));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.5), skyPaint);

    // Göl suyu yarısı
    final lakePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0077B6), Color(0xFF03045E)],
      ).createShader(Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5));
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5), lakePaint);

    // Ufuktaki dağ silüetleri
    final mountainPaint = Paint()..color = const Color(0xFF4A5568);
    final mPath = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.25, size.height * 0.35)
      ..lineTo(size.width * 0.6, size.height * 0.48)
      ..lineTo(size.width * 0.85, size.height * 0.38)
      ..lineTo(size.width, size.height * 0.5)
      ..close();
    canvas.drawPath(mPath, mountainPaint);

    // Su dalgalanma ve ışık yansıma çizgileri
    final ripplePaint = Paint()
      ..color = const Color(0x44CAF0F8)
      ..strokeWidth = 2;
    for (int i = 1; i <= 6; i++) {
      final y = size.height * 0.5 + (i * size.height * 0.07);
      canvas.drawLine(
        Offset(size.width * 0.2, y),
        Offset(size.width * 0.8, y),
        ripplePaint,
      );
    }
  }

  /// 'Sarmaşıklı Avlu' (antique) temasını çizer: Antik taş kemer ve sarmaşık yaprakları.
  void _paintAntique(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE9DAC1);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Taş Kemer yayı
    final archPaint = Paint()
      ..color = const Color(0xFF54BAB9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12;

    final rect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.5),
      width: size.width * 0.65,
      height: size.height * 0.75,
    );
    canvas.drawArc(rect, pi, pi, false, archPaint);

    // Kemer etrafındaki sarmaşık yaprakları
    final ivyPaint = Paint()..color = const Color(0xFF18978F);
    final rand = Random(12);
    for (int i = 0; i < 24; i++) {
      final angle = pi + (i / 24.0) * pi;
      final cx = size.width * 0.5 + (size.width * 0.34) * cos(angle);
      final cy = size.height * 0.5 + (size.height * 0.38) * sin(angle);
      canvas.drawCircle(Offset(cx, cy), rand.nextDouble() * 8 + 6, ivyPaint);
    }
  }

  /// 'Işık Kulesi' (lighthouse) temasını çizer: Deniz feneri, ışık huzmesi ve kayalıklar.
  void _paintLighthouse(Canvas canvas, Size size) {
    // Alacakaranlık gökyüzü gradyanı
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1D2D44), Color(0xFF3E5C76), Color(0xFF748CAB)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Fenerden çıkan ışık huzmesi (üçgen gradyan)
    final lightPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0x99F0EBD8), Color(0x00F0EBD8)],
      ).createShader(Rect.fromLTWH(size.width * 0.45, size.height * 0.25, size.width * 0.55, size.height * 0.3));

    final lightBeam = Path()
      ..moveTo(size.width * 0.45, size.height * 0.28)
      ..lineTo(size.width, size.height * 0.15)
      ..lineTo(size.width, size.height * 0.42)
      ..close();
    canvas.drawPath(lightBeam, lightPaint);

    // Fener kulesi gövdesi
    final towerPaint = Paint()..color = const Color(0xFFF0EBD8);
    final towerPath = Path()
      ..moveTo(size.width * 0.4, size.height * 0.75)
      ..lineTo(size.width * 0.43, size.height * 0.28)
      ..lineTo(size.width * 0.47, size.height * 0.28)
      ..lineTo(size.width * 0.5, size.height * 0.75)
      ..close();
    canvas.drawPath(towerPath, towerPaint);

    // Kırmızı dekoratif şerit
    final redStripe = Paint()..color = const Color(0xFFC04B44);
    final stripePath = Path()
      ..moveTo(size.width * 0.415, size.height * 0.45)
      ..lineTo(size.width * 0.422, size.height * 0.38)
      ..lineTo(size.width * 0.478, size.height * 0.38)
      ..lineTo(size.width * 0.485, size.height * 0.45)
      ..close();
    canvas.drawPath(stripePath, redStripe);

    // Fener çatısı
    final roofPaint = Paint()..color = const Color(0xFF0D1321);
    final roofPath = Path()
      ..moveTo(size.width * 0.41, size.height * 0.28)
      ..lineTo(size.width * 0.45, size.height * 0.22)
      ..lineTo(size.width * 0.49, size.height * 0.28)
      ..close();
    canvas.drawPath(roofPath, roofPaint);

    // Deniz kayalığı kaidesi
    final rockPaint = Paint()..color = const Color(0xFF0D1321);
    final rockPath = Path()
      ..moveTo(0, size.height * 0.82)
      ..lineTo(size.width * 0.3, size.height * 0.72)
      ..lineTo(size.width * 0.65, size.height * 0.76)
      ..lineTo(size.width, size.height * 0.85)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(rockPath, rockPaint);
  }

  /// Tema anahtarı değiştiğinde yeniden çizim yapılması gerektiğini belirtir.
  @override
  bool shouldRepaint(covariant ArtworkPainter oldDelegate) =>
      oldDelegate.themeKey != themeKey;
}
