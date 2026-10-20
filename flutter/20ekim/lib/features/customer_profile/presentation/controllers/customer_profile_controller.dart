import 'package:flutter/foundation.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/customer_profile.dart';
import '../../domain/repositories/customer_profile_repository.dart';

class CustomerProfileController extends ChangeNotifier {
  final CustomerProfileRepository _profileRepository;

  CustomerProfile? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  CustomerProfileController({
    required CustomerProfileRepository profileRepository,
  }) : _profileRepository = profileRepository;

  CustomerProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _profileRepository.getProfile(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Profil yüklenirken bir hata oluştu.';
      notifyListeners();
    }
  }

  Future<bool> updateProfile(
    CustomerProfile updatedProfile,
    String actorUserId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _profileRepository.saveProfile(
        updatedProfile,
        actorUserId: actorUserId,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Profil güncellenirken bir hata oluştu.';
      notifyListeners();
      return false;
    }
  }
}
