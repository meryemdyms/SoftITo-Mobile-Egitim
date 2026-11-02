import '../entities/company.dart';

/// Araç kiralama firmalarını listeleme, detay getirme ve profil güncelleme sözleşmesi.
abstract class CompanyRepository {
  /// Sistemdeki tüm firmaları listeler (varsayılan: yalnızca aktif olanlar).
  Future<List<Company>> getAllCompanies({bool activeOnly = true});

  /// ID'ye göre tek bir firma bilgisini getirir.
  Future<Company?> getCompanyById(String id);

  /// Firma sahibi kullanıcı ID'sine göre firmanın kaydını getirir.
  Future<Company?> getCompanyByOwnerUserId(String ownerUserId);

  /// Firmanın profil bilgilerini günceller (actorUserId ile sahiplik denetimi yapılır).
  Future<Company> updateCompany(Company company, {required String actorUserId});
}
