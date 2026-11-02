import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/models/museum_model.dart';
import '../../../shared/repositories/museum_repository.dart';

/// Cep Müzem — Harita ve Keşif Ekranı (MapView)
///
/// project.md Madde 15 ve map-visits skill'i gereksinimleri:
/// - Erişilebilir ve konumu tanımlı olan yayınlanmış müzeler haritada gösterilir.
/// - Konumu olmayan müzeler için harita pini gösterilmez.
/// - Harici ücretli Google Places API kullanılmaz (flutter_map + OpenStreetMap mimarisi).
/// - Pin seçimi doğrudan ziyaret sayılmaz; detay ekranına geçiş imkanı tanır.
class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  /// Sadece konumu tanımlı olan sergilerin listesi
  List<MuseumModel> _locationMuseums = [];

  /// Yükleniyor durumu
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  /// Konumlu müzeleri repository üzerinden filtreleyerek çeker
  Future<void> _loadLocations() async {
    final repo = Provider.of<MuseumRepository>(context, listen: false);
    final all = await repo.getExploreFeed();
    if (mounted) {
      setState(() {
        // Yalnızca location alanı null olmayan müzeler harita akışına eklenir
        _locationMuseums = all.where((m) => m.location != null).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Müze Haritası', style: AppTypography.pageTitle),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.antiqueBronze,
                ),
              )
            : Column(
                children: [
                  // 1. Harita Temsili / Görsel Keşif Alanı
                  // (Aşama 5'te flutter_map + OpenStreetMap etkileşimli katmanı ile zenginleştirilecek)
                  Container(
                    height: 220,
                    margin: const EdgeInsets.all(
                      AppDimensions.horizontalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2D9C8), // Harita parşömen/arşiv tonu
                      borderRadius: AppDimensions.cardBorderRadius,
                      border: Border.all(color: AppColors.museumStone),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: AppColors.museumWhite,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.map_outlined,
                                  size: 32,
                                  color: AppColors.antiqueBronze,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tarihi & Dijital Keşif Noktaları',
                                style: AppTypography.cardTitle,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_locationMuseums.length} kayıtlı konum pini',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Konumlu Sergiler Başlığı
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Konumlu Sergiler',
                          style: AppTypography.sectionTitle.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),

                  // 3. Konum Listesi (Kartlar üzerinden ilgili sergiye doğrudan geçiş)
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.horizontalPadding,
                        vertical: AppDimensions.space8,
                      ),
                      itemCount: _locationMuseums.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppDimensions.space8),
                      itemBuilder: (context, index) {
                        final m = _locationMuseums[index];
                        return ListTile(
                          tileColor: AppColors.museumWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppDimensions.buttonBorderRadius,
                            side: const BorderSide(
                              color: AppColors.museumStone,
                              width: 0.8,
                            ),
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.parchment,
                            child: Icon(
                              Icons.place,
                              color: AppColors.antiqueBronze,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            m.title,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            m.location ?? '',
                            style: AppTypography.caption,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppColors.deepWalnut,
                          ),
                          onTap: () {
                            // Serginin detay ekranına git
                            context.push('/museum/${m.id}');
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

