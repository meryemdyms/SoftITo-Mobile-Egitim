import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/models/museum_item_model.dart';

/// Cep Müzem — Eser Detay Alt Paneli (ArtworkSheet)
///
/// museum-detail ve museum-design-system yönergeleri doğrultusunda:
/// - 24dp üst radius ile yumuşak modal açılışı (DraggableScrollableSheet).
/// - Eser görseli (4:3 en boy oranı, traverten çerçeve).
/// - Eser başlığı ve hikâye/açıklama metni.
/// - Varsa sesli küratör rehberi simülatörü (oynat/duraklat/zamanlayıcı).
class ArtworkSheet extends StatefulWidget {
  /// İncelenen eser verisi
  final MuseumItemModel item;

  const ArtworkSheet({super.key, required this.item});

  /// Alt sayfayı modal bottom sheet olarak açan statik yardımcı fonksiyon
  static Future<void> show(BuildContext context, MuseumItemModel item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.museumWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.bottomSheetBorderRadius,
      ),
      builder: (context) => ArtworkSheet(item: item),
    );
  }

  @override
  State<ArtworkSheet> createState() => _ArtworkSheetState();
}

class _ArtworkSheetState extends State<ArtworkSheet> {
  /// Sesli notun oynatılma durumu
  bool _isPlaying = false;

  /// Geçen ses süresi (saniye)
  int _audioSeconds = 0;

  /// Ses oynatma simülasyonu için periyodik zamanlayıcı
  Timer? _audioTimer;

  @override
  void dispose() {
    _stopAudio();
    super.dispose();
  }

  /// Ses oynatmayı başlatır veya duraklatır
  void _toggleAudio() {
    if (_isPlaying) {
      _pauseAudio();
    } else {
      _startAudio();
    }
  }

  /// Sesli not simülasyonunu başlatır
  void _startAudio() {
    setState(() {
      _isPlaying = true;
    });
    _audioTimer?.cancel();
    _audioTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _audioSeconds++;
        // 45 saniyelik rehber simülasyonu bittiğinde durdur
        if (_audioSeconds >= 45) {
          _stopAudio();
        }
      });
    });
  }

  /// Sesli notu duraklatır (zamanlayıcıyı durdurur, süreyi korur)
  void _pauseAudio() {
    _audioTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  /// Sesli notu tamamen durdurur
  void _stopAudio() {
    _audioTimer?.cancel();
    _audioTimer = null;
    _isPlaying = false;
  }

  /// Saniye cinsinden süreyi "00:00" formatına dönüştürür
  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.museumWhite,
            borderRadius: AppDimensions.bottomSheetBorderRadius,
          ),
          child: Column(
            children: [
              // 1. Üst Sürükleme Tutamacı (Drag handle)
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.museumStone,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),

              // 2. Üst Bar: Eser İnceleme Rozeti ve Kapatma Butonu
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space20,
                  vertical: AppDimensions.space8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.parchment,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.museumStone),
                      ),
                      child: Text(
                        'Eser İnceleme',
                        style: AppTypography.museumBadge,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.deepWalnut,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Kapat',
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: AppColors.museumStone),

              // 3. İçerik Kaydırma Listesi
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space20,
                    vertical: AppDimensions.space16,
                  ),
                  children: [
                    // A. Eser Başlığı
                    Text(
                      item.title,
                      style: AppTypography.pageTitle.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: AppDimensions.space16),

                    // B. Eser Görseli (4:3 AspectRatio ile zarif çerçeve)
                    if (item.imageUrls.isNotEmpty)
                      ClipRRect(
                        borderRadius: AppDimensions.cardBorderRadius,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.museumStone),
                            borderRadius: AppDimensions.cardBorderRadius,
                          ),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image.network(
                              item.imageUrls.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: AppColors.parchment,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 48,
                                      color: AppColors.antiqueBronze,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: AppDimensions.space16),

                    // C. Sesli Küratör Rehberi Oynatıcı (Sadece ses kaydı tanımlıysa görünür)
                    if (item.audioUrl != null) ...[
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.space12),
                        decoration: BoxDecoration(
                          color: AppColors.parchment,
                          borderRadius: AppDimensions.buttonBorderRadius,
                          border: Border.all(
                            color: AppColors.antiqueBronze.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Oynat / Duraklat Dairesel Buton
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _toggleAudio,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: AppColors.deepWalnut,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: AppColors.museumWhite,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.space12),
                            // Ses Durumu ve Süre Metinleri
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sesli Küratör Notu',
                                    style: AppTypography.caption.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deepWalnut,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _isPlaying
                                        ? 'Dinleniyor: ${_formatDuration(_audioSeconds)} / 00:45'
                                        : 'Dinlemek için dokunun (00:45)',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                            // Oynarken gösterilen ekolayzır simgesi
                            if (_isPlaying)
                              const Icon(
                                Icons.graphic_eq,
                                color: AppColors.antiqueBronze,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space16),
                    ],

                    // D. Eser Hikayesi ve Açıklaması
                    Text(
                      'Eser Hikâyesi & Açıklama',
                      style: AppTypography.cardTitle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    Text(item.description, style: AppTypography.body),
                    const SizedBox(height: AppDimensions.space32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

