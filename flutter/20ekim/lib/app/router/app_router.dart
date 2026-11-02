import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/views/company_register_view.dart';
import '../../features/auth/presentation/views/customer_register_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/bookings/presentation/views/booking_checkout_view.dart';
import '../../features/bookings/presentation/views/my_bookings_view.dart';
import '../../features/campaigns/presentation/views/campaigns_view.dart';
import '../../features/companies/presentation/views/company_storefront_view.dart';
import '../../features/company_dashboard/presentation/views/company_campaigns_view.dart';
import '../../features/company_dashboard/presentation/views/company_dashboard_view.dart';
import '../../features/company_dashboard/presentation/views/company_profile_editor_view.dart';
import '../../features/company_dashboard/presentation/views/company_reservations_view.dart';
import '../../features/company_dashboard/presentation/views/company_vehicles_view.dart';
import '../../features/customer_profile/presentation/views/customer_profile_view.dart';
import '../../features/customer_shell/presentation/views/customer_shell_view.dart';
import '../../features/map_discovery/presentation/views/map_discovery_view.dart';
import '../../features/search/presentation/views/search_home_view.dart';
import '../../features/vehicles/presentation/views/vehicle_details_view.dart';

/// Uygulamanın merkezi yönlendirme ve rota yapılandırma sınıfı.
///
/// Rol tabanlı erişim denetimleri (Route Guards), durum korumalı sekmeler (StatefulShellRoute)
/// ve derin bağlantı (deep-linking) desteği sunar.
class AppRouter {
  AppRouter._();

  /// AuthController dinleyicisi ile GoRouter örneğini oluşturur.
  ///
  /// Kullanıcı giriş yaptığında veya çıkış yaptığında `refreshListenable` tetiklenir
  /// ve yönlendirme (redirect) mantığı otomatik olarak yeniden değerlendirilir.
  static GoRouter createRouter(AuthController authController) {
    return GoRouter(
      refreshListenable: authController,
      initialLocation: '/',
      redirect: (context, state) {
        final path = state.uri.path;
        final isAuth = authController.isAuthenticated;
        final isCompany = authController.isCompany;

        final isCompanyRoute = path.startsWith('/company');
        final isCustomerProtectedRoute =
            path.startsWith('/booking/checkout') || path == '/my-bookings';

        // 1. Firma paneli koruması: Oturum yoksa login'e, müşteri ise ana sayfaya yönlendirilir.
        if (isCompanyRoute) {
          if (!isAuth) {
            return '/auth/login?returnTo=$path';
          }
          if (!isCompany) {
            return '/';
          }
        }

        // 2. Müşteri korumalı rotalar: Oturum yoksa login'e, firma hesabı ise dashboard'a yönlendirilir.
        if (isCustomerProtectedRoute) {
          if (!isAuth) {
            return '/auth/login?returnTo=$path';
          }
          if (isCompany) {
            return '/company/dashboard';
          }
        }

        // Korumalı olmayan rotalarda veya koşullar sağlandığında yönlendirme yapılmaz.
        return null;
      },
      routes: [
        // Misafir ve Müşteri için alt sekmeleri (Bottom Navigation) yöneten durum korumalı kabuk.
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return CustomerShellView(navigationShell: navigationShell);
          },
          branches: [
            // 0. Sekme: Araç Arama ve Ana Keşif Sayfası
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const SearchHomeView(),
                ),
              ],
            ),
            // 1. Sekme: Harita ile Firma ve Araç Keşfi
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/map',
                  builder: (context, state) => const MapDiscoveryView(),
                ),
              ],
            ),
            // 2. Sekme: Aktif Kampanyalar ve İndirimler
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/campaigns',
                  builder: (context, state) => const CampaignsView(),
                ),
              ],
            ),
            // 3. Sekme: Rezervasyonlarım (Müşteri oturumu gerektirir)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/my-bookings',
                  builder: (context, state) => const MyBookingsView(),
                ),
              ],
            ),
            // 4. Sekme: Müşteri Profili ve Oturum Yönetimi
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const CustomerProfileView(),
                ),
              ],
            ),
          ],
        ),

        // Araç detay sayfası: Seçilen aracın teknik özelliklerini ve kiralama adımlarını gösterir.
        GoRoute(
          path: '/vehicles/:id',
          builder: (context, state) =>
              VehicleDetailsView(vehicleId: state.pathParameters['id']!),
        ),

        // Firma vitrini: Firmanın iletişim bilgilerini, puanını ve tüm filosunu listeler.
        GoRoute(
          path: '/companies/:id',
          builder: (context, state) =>
              CompanyStorefrontView(companyId: state.pathParameters['id']!),
        ),

        // Rezervasyon tamamlama (Checkout): Tarih, ek sürücü, ehliyet ve fiyat döküm ekranı.
        GoRoute(
          path: '/booking/checkout/:id',
          builder: (context, state) =>
              BookingCheckoutView(vehicleId: state.pathParameters['id']!),
        ),

        // Kimlik doğrulama rotaları: Giriş, Müşteri Kayıt ve Firma Kayıt
        GoRoute(
          path: '/auth/login',
          builder: (context, state) =>
              LoginView(returnTo: state.uri.queryParameters['returnTo']),
        ),
        GoRoute(
          path: '/auth/register-customer',
          builder: (context, state) => const CustomerRegisterView(),
        ),
        GoRoute(
          path: '/auth/register-company',
          builder: (context, state) => const CompanyRegisterView(),
        ),

        // Firma Yönetim Paneli Rotaları (Yetki korumalı)
        GoRoute(
          path: '/company/dashboard',
          builder: (context, state) => const CompanyDashboardView(),
        ),
        GoRoute(
          path: '/company/vehicles',
          builder: (context, state) => const CompanyVehiclesView(),
        ),
        GoRoute(
          path: '/company/reservations',
          builder: (context, state) => const CompanyReservationsView(),
        ),
        GoRoute(
          path: '/company/campaigns',
          builder: (context, state) => const CompanyCampaignsView(),
        ),
        GoRoute(
          path: '/company/profile-editor',
          builder: (context, state) => const CompanyProfileEditorView(),
        ),
      ],
    );
  }
}
