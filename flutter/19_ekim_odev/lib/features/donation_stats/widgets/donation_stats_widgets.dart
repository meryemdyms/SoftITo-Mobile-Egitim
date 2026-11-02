import 'package:flutter/material.dart';
import '../models/donation_stats_model.dart';

/// İstatistik özet kutucuğu (Metrik başlığı, sayısal değeri ve ikon gösterimi).
class StatMetricTile extends StatelessWidget {
  const StatMetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  /// Metrik başlığı (örn: 'Kurtarılan Can')
  final String title;

  /// Sayısal değer (örn: '12')
  final String value;

  /// Gösterilecek ikon
  final IconData icon;

  /// İkon ve arka plan dairesinin tema rengi
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İkonu çevreleyen şeffaf dairesel arka plan
            CircleAvatar(
              radius: 18,
              backgroundColor: iconColor.withValues(alpha: 0.15),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            // Büyük sayısal değer
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Açıklayıcı metin etiketi
            Text(title, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Geri sayım kartının üst başlık satırı (Uygunluk ikonu, durum metni ve kalan gün).
class _CountdownHeader extends StatelessWidget {
  const _CountdownHeader({required this.stats});

  final DonationStats stats;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Donör uygunsa yeşil/ikincil renk, bekleme süresindeyse birincil kırmızı ton
    final statusColor = stats.isEligible ? colorScheme.secondary : colorScheme.primary;

    return Row(
      children: [
        Icon(
          stats.isEligible ? Icons.verified : Icons.timelapse,
          color: statusColor,
        ),
        const SizedBox(width: 8),
        Text(
          stats.isEligible ? 'Bağış Yapabilirsiniz' : 'Sonraki Bağışa Kalan',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          stats.isEligible ? '0 Gün' : '${stats.daysUntilNextDonation} Gün',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: statusColor,
          ),
        ),
      ],
    );
  }
}

/// Geri sayım kartının ilerleme çubuğu ve bilgilendirici açıklama metni.
class _CountdownProgress extends StatelessWidget {
  const _CountdownProgress({required this.stats});

  final DonationStats stats;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 90 günlük önerilen bağış aralığına göre ilerleme oranı hesaplanır (0.0 - 1.0)
    final progress = stats.daysSinceLastDonation / 90.0;
    final clampedProgress = progress > 1.0 ? 1.0 : progress;
    final barColor = stats.isEligible ? colorScheme.secondary : colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: clampedProgress,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
          color: barColor,
        ),
        const SizedBox(height: 8),
        Text(
          'Son bağıştan bu yana ${stats.daysSinceLastDonation} gün geçti (Önerilen ara: 90 gün).',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// Sonraki bağışa kalan gün ve ilerleme durumunu gösteren özet kart bileşeni.
class NextDonationCountdownCard extends StatelessWidget {
  const NextDonationCountdownCard({super.key, required this.stats});

  final DonationStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CountdownHeader(stats: stats),
            const SizedBox(height: 12),
            _CountdownProgress(stats: stats),
          ],
        ),
      ),
    );
  }
}

/// Kan akış grafiğinin üst başlık ve canlı akış rozeti bölümü.
class _ChartHeader extends StatelessWidget {
  const _ChartHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.waves, color: colorScheme.primary, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aylık Kan Bağış Akışı',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Kan Akış ve Nabız Takibi (Son 6 Ay)',
                style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
              ),
            ],
          ),
        ),
        // Canlı akış etiketi (Pulse efekti hissi verir)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop, size: 14, color: colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                'Canlı Akış',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Kan akış çizgisini sürekli dalgalanır şekilde canlandıran StatefulWidget alanı.
class _BloodFlowChartArea extends StatefulWidget {
  const _BloodFlowChartArea({required this.stats});

  final DonationStats stats;

  @override
  State<_BloodFlowChartArea> createState() => _BloodFlowChartAreaState();
}

class _BloodFlowChartAreaState extends State<_BloodFlowChartArea>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    // Sıvı kan akış hareketini simüle etmek için sonsuz döngülü animasyon kontrolcüsü
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(double.infinity, 175),
          painter: _BloodFlowLinePainter(
            distribution: widget.stats.monthlyDistribution,
            bloodColor: colorScheme.primary,
            textColor: colorScheme.onSurface,
            gridColor: colorScheme.outline.withValues(alpha: 0.18),
            flowPhase: _animController.value,
          ),
        );
      },
    );
  }
}

/// Kan akıyor hissi veren animasyonlu eğri çizgi grafiği kartı.
class BloodFlowLineChartCard extends StatelessWidget {
  const BloodFlowLineChartCard({super.key, required this.stats});

  final DonationStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ChartHeader(),
            const SizedBox(height: 18),
            _BloodFlowChartArea(stats: stats),
          ],
        ),
      ),
    );
  }
}

/// Özel çizim (CustomPainter) ile kan damarı ve akış eğrisini çizen sınıf.
class _BloodFlowLinePainter extends CustomPainter {
  const _BloodFlowLinePainter({
    required this.distribution,
    required this.bloodColor,
    required this.textColor,
    required this.gridColor,
    required this.flowPhase,
  });

  /// Aylık bağış dağılımı verisi
  final List<DonationMonthStat> distribution;

  /// Kan rengi (birincil tema rengi)
  final Color bloodColor;

  /// Metin rengi
  final Color textColor;

  /// Arka plan ızgara çizgisi rengi
  final Color gridColor;

  /// Dalga animasyonu döngü evresi (0.0 ile 1.0 arası)
  final double flowPhase;

  @override
  void paint(Canvas canvas, Size size) {
    if (distribution.isEmpty) return;

    const bottomPadding = 26.0;
    const sidePadding = 20.0;
    final chartHeight = size.height - bottomPadding;
    final availableWidth = size.width - (sidePadding * 2);
    final stepX = availableWidth / (distribution.length - 1);

    // Taban ızgara çizgisini çizer
    _drawGrid(canvas, size, chartHeight, sidePadding);

    // Her ay için koordinat noktalarını dalga ofseti ile hesaplar
    final points = <Offset>[];
    for (int i = 0; i < distribution.length; i++) {
      final x = sidePadding + (i * stepX);
      final count = distribution[i].donationCount;
      final rawY = chartHeight - 20 - (count > 0 ? (count / 2.0) * (chartHeight - 55) : 0);
      final waveOffset = 2.5 * (1 - (i % 2 * 2)) * flowPhase;
      final y = (rawY + waveOffset).clamp(18.0, chartHeight - 6);
      points.add(Offset(x, y));
    }

    // Sıvı kan akış hattını ve dolgusunu çizer
    _drawBloodStream(canvas, points, chartHeight);
    // Bağış noktalarını (damlaları) ve ay yazılarını çizer
    _drawNodesAndLabels(canvas, points, chartHeight);
  }

  /// Taban referans ızgara çizgisini çizer.
  void _drawGrid(Canvas canvas, Size size, double chartHeight, double sidePadding) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(sidePadding, chartHeight),
      Offset(size.width - sidePadding, chartHeight),
      gridPaint,
    );
  }

  /// Yumuşak kübik Bezier eğrileriyle sıvı kan akış hattını, ışımasını ve gradyan dolgusunu çizer.
  void _drawBloodStream(Canvas canvas, List<Offset> points, double chartHeight) {
    final splinePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      splinePath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }

    // Eğrinin altını dolduran kan gradyanı
    final fillPath = Path.from(splinePath)
      ..lineTo(points.last.dx, chartHeight)
      ..lineTo(points.first.dx, chartHeight)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          bloodColor.withValues(alpha: 0.38),
          bloodColor.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, points.last.dx, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    // Dış ışıma (glow) çizgisi
    final glowPaint = Paint()
      ..color = bloodColor.withValues(alpha: 0.28)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(splinePath, glowPaint);

    // Ana damar kan akış çizgisi
    final linePaint = Paint()
      ..color = bloodColor
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(splinePath, linePaint);
  }

  /// Veri noktalarındaki damlacıkları, nabız halkalarını ve ay etiketlerini çizer.
  void _drawNodesAndLabels(Canvas canvas, List<Offset> points, double chartHeight) {
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      final count = distribution[i].donationCount;

      if (count > 0) {
        // Dış nabız halkası
        final pulsePaint = Paint()
          ..color = bloodColor.withValues(alpha: 0.22)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, 8.0, pulsePaint);

        // Kan damlası merkezi
        final beadPaint = Paint()..color = bloodColor;
        canvas.drawCircle(pt, 4.5, beadPaint);

        // Beyaz parlama noktası
        final highlightPaint = Paint()..color = Colors.white;
        canvas.drawCircle(pt, 1.5, highlightPaint);

        // Bağış sayısı etiketi
        _paintText(
          canvas,
          '$count',
          Offset(pt.dx, pt.dy - 18),
          TextStyle(color: bloodColor, fontSize: 11, fontWeight: FontWeight.bold),
        );
      } else {
        // Bağış yapılmayan ay için minik dinlenme noktası
        final restingPaint = Paint()
          ..color = bloodColor.withValues(alpha: 0.4)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, 2.5, restingPaint);
      }

      // Ay adı etiketi (Oca, Şub vb.)
      _paintText(
        canvas,
        distribution[i].monthLabel,
        Offset(pt.dx, chartHeight + 7),
        TextStyle(color: textColor.withValues(alpha: 0.75), fontSize: 11),
      );
    }
  }

  /// Canvas üzerine merkezlenmiş metin yazdıran yardımcı fonksiyon.
  void _paintText(Canvas canvas, String text, Offset center, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - (textPainter.width / 2), center.dy),
    );
  }

  @override
  bool shouldRepaint(covariant _BloodFlowLinePainter oldDelegate) {
    // Animasyon akışının her karede yeniden çizilmesi gerekir
    return true;
  }
}

