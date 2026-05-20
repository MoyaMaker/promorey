import 'package:go_router/go_router.dart';
import 'package:promorey/providers/auth_provider.dart';
import 'package:promorey/screens/login_screen.dart';
import 'package:promorey/screens/register_screen.dart';
import 'package:promorey/screens/main_shell.dart';
import 'package:promorey/screens/promotions_tab.dart';
import 'package:promorey/screens/my_promotions_tab.dart';
import 'package:promorey/screens/profile_tab.dart';
import 'package:promorey/screens/promotion_form_screen.dart';
import 'package:promorey/screens/promotion_detail_screen.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/promotions',
    redirect: (context, state) {
      final isLoggedIn = authProvider.user != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/promotions';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/promotions',
                builder: (_, __) => const PromotionsTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-promotions',
                builder: (_, __) => const MyPromotionsTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfileTab(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/create',
        builder: (_, __) => const PromotionFormScreen(),
      ),
      GoRoute(
        path: '/edit/:id',
        builder: (_, state) => PromotionFormScreen(
          promotionId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (_, state) => PromotionDetailScreen(
          promotionId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}
