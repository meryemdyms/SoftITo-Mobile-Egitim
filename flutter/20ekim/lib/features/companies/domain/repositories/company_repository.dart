import '../entities/company.dart';

abstract class CompanyRepository {
  Future<List<Company>> getAllCompanies({bool activeOnly = true});
  Future<Company?> getCompanyById(String id);
  Future<Company?> getCompanyByOwnerUserId(String ownerUserId);
  Future<Company> updateCompany(Company company, {required String actorUserId});
}
