import '../entities/campaign.dart';

abstract class CampaignRepository {
  Future<List<Campaign>> getActiveCampaigns();
  Future<List<Campaign>> getCompanyCampaigns(String companyId);
  Future<Campaign> addCampaign(
    Campaign campaign, {
    required String actorCompanyId,
  });
  Future<Campaign> updateCampaign(
    Campaign campaign, {
    required String actorCompanyId,
  });
}
