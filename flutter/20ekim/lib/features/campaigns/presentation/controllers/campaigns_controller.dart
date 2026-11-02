import 'package:flutter/foundation.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/campaign.dart';
import '../../domain/repositories/campaign_repository.dart';

/// Tüm aktif kampanyaların listelenmesini ve durumunu yöneten ChangeNotifier ViewModel.
class CampaignsController extends ChangeNotifier {
  final CampaignRepository _campaignRepository;

  List<Campaign> _activeCampaigns = [];
  bool _isLoading = false;
  String? _errorMessage;

  CampaignsController({required CampaignRepository campaignRepository})
    : _campaignRepository = campaignRepository;

  /// Geçerli aktif kampanyalar listesi.
  List<Campaign> get activeCampaigns => _activeCampaigns;

  /// Yüklenme durumu.
  bool get isLoading => _isLoading;

  /// Hata mesajı (varsa).
  String? get errorMessage => _errorMessage;

  /// Tüm geçerli aktif kampanyaları yükler.
  Future<void> loadCampaigns() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activeCampaigns = await _campaignRepository.getActiveCampaigns();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Kampanyalar yüklenirken bir hata oluştu.';
      notifyListeners();
    }
  }
}
