import 'package:depi_project/core/provider/auth_app.dart';
import 'package:depi_project/features/auth/presentation/view/login_view.dart';
import 'package:depi_project/features/splach/splach_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:depi_project/features/onboarding/presentation/view/onboarding_view.dart';
import '../../features/navigation/mainLayout.dart';

abstract class AppRouter {
  static const String kSplashView = '/splash';
  static const String kOnboardingView = '/onboarding';
  static const String kAuthView = '/';
  static const String kHomeView = '/home';

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: kSplashView,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final bool isLoggedIn = authProvider.currentUser != null;
        final bool isLoggingIn = state.matchedLocation == kAuthView;
        final bool isSplash = state.matchedLocation == kSplashView;
        final bool isOnboarding = state.matchedLocation == kOnboardingView;

        // If on splash, don't redirect yet (Splash screen handles navigation)
        if (isSplash) return null;

        if (!isLoggedIn && !isLoggingIn && !isOnboarding) {
          return kAuthView;
        }

        if (isLoggedIn && (isLoggingIn || isOnboarding)) {
          return kHomeView;
        }

        return null;
      },
      routes: [
        GoRoute(
           name: kSplashView,
           path: kSplashView,
           builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          name: kAuthView,
          path: kAuthView,
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          name: kOnboardingView,
          path: kOnboardingView,
          builder: (context, state) => const OnboardingView(),
        ),

        GoRoute(
          name: 'home',
          path: kHomeView,
          builder: (context, state) => const MainLayout(),
        ),
      ],
    );
  }
}
