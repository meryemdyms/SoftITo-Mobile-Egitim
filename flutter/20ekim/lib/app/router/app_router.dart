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

class AppRouter {
  AppRouter._();

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

        // 1. Company route guard
        if (isCompanyRoute) {
          if (!isAuth) {
            return '/auth/login?returnTo=$path';
          }
          if (!isCompany) {
            return '/';
          }
        }

        // 2. Customer protected route guard
        if (isCustomerProtectedRoute) {
          if (!isAuth) {
            return '/auth/login?returnTo=$path';
          }
          if (isCompany) {
            return '/company/dashboard';
          }
        }

        return null;
      },
      routes: [
        // Stateful Shell for Guest & Customer tabs
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return CustomerShellView(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const SearchHomeView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/map',
                  builder: (context, state) => const MapDiscoveryView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/campaigns',
                  builder: (context, state) => const CampaignsView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/my-bookings',
                  builder: (context, state) => const MyBookingsView(),
                ),
              ],
            ),
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

        // Vehicle details
        GoRoute(
          path: '/vehicles/:id',
          builder: (context, state) =>
              VehicleDetailsView(vehicleId: state.pathParameters['id']!),
        ),

        // Company Storefront
        GoRoute(
          path: '/companies/:id',
          builder: (context, state) =>
              CompanyStorefrontView(companyId: state.pathParameters['id']!),
        ),

        // Booking Checkout (Protected)
        GoRoute(
          path: '/booking/checkout/:id',
          builder: (context, state) =>
              BookingCheckoutView(vehicleId: state.pathParameters['id']!),
        ),

        // Auth routes
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

        // Company Panel Routes (Protected)
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
