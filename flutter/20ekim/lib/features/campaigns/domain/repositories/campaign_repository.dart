import '../entities/campaign.dart';

/// Kampanya sorgulama, ekleme ve güncelleme işlemlerini tanımlayan sözleşme (Interface).
abstract class CampaignRepository {
  /// Sistemdeki geçerlilik süresi dolmamış aktif kampanyaları getirir.
  Future<List<Campaign>> getActiveCampaigns();

  /// Belirli bir firmaya ait tüm kampanyaları getirir.
  Future<List<Campaign>> getCompanyCampaigns(String companyId);

  /// Yeni bir indirim kampanyası ekler (actorCompanyId ile sahiplik doğrulanır).
  Future<Campaign> addCampaign(
    Campaign campaign, {
    required String actorCompanyId,
  });

  /// Mevcut bir kampanyayı günceller (actorCompanyId ile sahiplik doğrulanır).
  Future<Campaign> updateCampaign(
    Campaign campaign, {
    required String actorCompanyId,
  });
}
