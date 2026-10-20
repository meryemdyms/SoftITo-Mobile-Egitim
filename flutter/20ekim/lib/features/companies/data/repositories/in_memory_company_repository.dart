import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/mock/mock_data_seed.dart';
import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';

class InMemoryCompanyRepository implements CompanyRepository {
  final List<Company> _companies = List.from(MockDataSeed.initialCompanies);

  @override
  Future<List<Company>> getAllCompanies({bool activeOnly = true}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (activeOnly) {
      return _companies.where((c) => c.active).toList();
    }
    return List.unmodifiable(_companies);
  }

  @override
  Future<Company?> getCompanyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _companies.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Company?> getCompanyByOwnerUserId(String ownerUserId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _companies.firstWhere((c) => c.ownerUserId == ownerUserId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Company> updateCompany(
    Company company, {
    required String actorUserId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    // Ownership validation: actor must own this company
    if (company.ownerUserId != actorUserId) {
      throw const PermissionDeniedException(
        'Yalnızca kendi firmanızı güncelleyebilirsiniz.',
      );
    }

    final index = _companies.indexWhere((c) => c.id == company.id);
    if (index >= 0) {
      _companies[index] = company;
    } else {
      _companies.add(company);
    }
    return company;
  }
}
