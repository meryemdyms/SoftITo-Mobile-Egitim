import 'package:flutter/foundation.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/campaign.dart';
import '../../domain/repositories/campaign_repository.dart';

class CampaignsController extends ChangeNotifier {
  final CampaignRepository _campaignRepository;

  List<Campaign> _activeCampaigns = [];
  bool _isLoading = false;
  String? _errorMessage;

  CampaignsController({required CampaignRepository campaignRepository})
    : _campaignRepository = campaignRepository;

  List<Campaign> get activeCampaigns => _activeCampaigns;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
