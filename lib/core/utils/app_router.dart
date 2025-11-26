import 'package:depi_project/core/provider/auth_app.dart';
import 'package:depi_project/features/auth/presentation/view/login_view.dart';
import 'package:go_router/go_router.dart';

import '../../features/navigation/mainLayout.dart';

abstract class AppRouter {
  static const String kAuthView = '/';
  static const String kHomeView = '/home';

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final bool isLoggedIn = authProvider.currentUser != null;
        final bool isLoggingIn = state.matchedLocation == kAuthView;

        if (!isLoggedIn && !isLoggingIn) {
          return kAuthView;
        }

        if (isLoggedIn && isLoggingIn) {
          return kHomeView;
        }

        return null;
      },
      routes: [
        GoRoute(
          name: kAuthView,
          path: kAuthView,
          builder: (context, state) {
            return const LoginScreen();
          },
        ),

        GoRoute(
          name: kHomeView,
          path: kHomeView,
          builder: (context, state) => const MainLayout(),
        ),
      ],
    );
  }
}
