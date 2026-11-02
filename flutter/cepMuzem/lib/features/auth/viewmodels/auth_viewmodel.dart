import 'package:flutter/foundation.dart';

import '../../../shared/models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Kimlik doğrulama sürecinin olası durumları
enum AuthStatus {
  /// Başlangıç durumu
  initial,

  /// İşlem devam ediyor (yükleniyor)
  loading,

  /// Kullanıcı başarıyla oturum açtı
  authenticated,

  /// Oturum kapalı / misafir durumu
  unauthenticated,

  /// Hata oluştu
  error,
}

/// Cep Müzem — Kimlik Doğrulama ViewModel (AuthViewModel)
///
/// MVVM mimarisinde View ile Repository arasındaki köprüdür.
/// ChangeNotifier kullanarak arayüzü ve go_router yönlendirmelerini bilgilendirir.
class AuthViewModel extends ChangeNotifier {
  /// Veri katmanı repository arabirimi
  final AuthRepository authRepository;

  /// Mevcut oturum durumu
  AuthStatus _status = AuthStatus.initial;

  /// Aktif oturum kullanıcısı
  UserModel? _currentUser;

  /// Kullanıcıya gösterilecek hata mesajı
  String? _errorMessage;

  /// AuthViewModel yapıcısı; repository'deki oturum akışını dinlemeye başlar
  AuthViewModel({required this.authRepository}) {
    _currentUser = authRepository.currentUser;
    _status = _currentUser != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;

    // Repository'deki kullanıcı stream'i dinlenerek ViewModel durumu güncel tutulur
    authRepository.authStateChanges.listen((user) {
      _currentUser = user;
      _status = user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  // Dışa açık durum getter'ları
  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  /// Kullanıcının geçerli bir oturumu olup olmadığını bildirir
  bool get isAuthenticated =>
      _status == AuthStatus.authenticated && _currentUser != null;

  /// Yüklenme durumunda olup olmadığını bildirir
  bool get isLoading => _status == AuthStatus.loading;

  /// Repository'nin gerçek Firebase'e bağlı olup olmadığını bildirir
  bool get isFirebaseConfigured => authRepository.isFirebaseConfigured;

  /// E-posta ve şifre ile giriş işlemi
  ///
  /// Başarılı olursa `true`, hata durumunda `false` döner ve UI'ı bilgilendirir.
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading();
    try {
      _currentUser = await authRepository.signIn(
        email: email,
        password: password,
      );
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Ad, soyad, e-posta ve şifre ile yeni küratör kaydı işlemi
  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      _currentUser = await authRepository.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Oturumu sonlandırma işlemi
  Future<void> signOut() async {
    _setLoading();
    try {
      await authRepository.signOut();
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Ekrandaki hata mesajını temizler
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Yükleniyor durumuna geçirir ve hata mesajını sıfırlar
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }
}

