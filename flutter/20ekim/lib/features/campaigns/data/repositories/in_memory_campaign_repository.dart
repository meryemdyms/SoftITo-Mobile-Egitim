import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/mock/mock_data_seed.dart';
import '../../domain/entities/campaign.dart';
import '../../domain/repositories/campaign_repository.dart';

class InMemoryCampaignRepository implements CampaignRepository {
  final List<Campaign> _campaigns = List.from(MockDataSeed.initialCampaigns);

  @override
  Future<List<Campaign>> getActiveCampaigns() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final now = DateTime.now();
    return _campaigns
        .where(
          (c) =>
              c.active && !now.isAfter(c.validTo) && !now.isBefore(c.validFrom),
        )
        .toList();
  }

  @override
  Future<List<Campaign>> getCompanyCampaigns(String companyId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _campaigns.where((c) => c.companyId == companyId).toList();
  }

  @override
  Future<Campaign> addCampaign(
    Campaign campaign, {
    required String actorCompanyId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    if (campaign.companyId != actorCompanyId) {
      throw const PermissionDeniedException(
        'Yalnızca kendi firmanıza kampanya ekleyebilirsiniz.',
      );
    }

    _campaigns.add(campaign);
    return campaign;
  }

  @override
  Future<Campaign> updateCampaign(
    Campaign campaign, {
    required String actorCompanyId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    if (campaign.companyId != actorCompanyId) {
      throw const PermissionDeniedException(
        'Yalnızca kendi firmanıza ait kampanyayı düzenleyebilirsiniz.',
      );
    }

    final index = _campaigns.indexWhere((c) => c.id == campaign.id);
    if (index < 0) {
      throw const NotFoundException('Kampanya bulunamadı.');
    }

    _campaigns[index] = campaign;
    return campaign;
  }
}
