import 'package:flutter/material.dart';
import '../controllers/donor_profile_controller.dart';
import '../models/donor_profile_model.dart';
import '../widgets/donor_profile_widgets.dart';

/// Donörün profil bilgilerini, uygunluk durumunu, acil bağış müsaitlik anahtarını
/// ve kan grubu uyumluluk matrisini görüntüleyen ve düzenleyen ekran.
class DonorProfileView extends StatefulWidget {
  const DonorProfileView({super.key, this.controller});

  /// Dışarıdan enjekte edilebilen kontrolcü (AppShell üzerinden sağlanır)
  final DonorProfileController? controller;

  @override
  State<DonorProfileView> createState() => _DonorProfileViewState();
}

class _DonorProfileViewState extends State<DonorProfileView> {
  late final DonorProfileController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    // Dışarıdan controller iletilmemişse dahili bir controller başlatılır.
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = DonorProfileController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    // Dahili controller örneği varsa bellek sızıntısını önlemek için dispose edilir.
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bağışçı Profilim'),
      ),
      // Profil verisini reaktif olarak dinler
      body: ValueListenableBuilder<DonorProfile>(
        valueListenable: _controller.state,
        builder: (context, profile, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // Donör adı, kan grubu ve konum bilgisi kartı
              DonorAvatarCard(profile: profile),
              // Bağış uygunluğu, son bağış tarihi ve müsaitlik switch kartı
              DonorEligibilityCard(
                profile: profile,
                onAvailabilityChanged: _controller.toggleAvailability,
              ),
              // Kan grubu uyumluluk kartı (Kime kan verebilir / Kimden kan alabilir)
              DonorBloodCompatibilityCard(
                bloodGroup: profile.bloodGroup,
                onGroupCorrected: _controller.updateBloodGroup,
              ),
            ],
          );
        },
      ),
    );
  }
}

