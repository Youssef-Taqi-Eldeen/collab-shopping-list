
import 'package:depi_project/features/auth/presentation/view/login_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const String kAuthView = '/';
  // static const String kAuthView = '/AuthView';

  static GoRouter router = GoRouter(
    routes: [
      // GoRoute(
      //   name: kSplashView,
      //   path: kSplashView,
      //   builder: (context, state) => const SplashView(),
      // ),
      GoRoute(
        name: kAuthView,
        path: kAuthView,
        builder: (context, state) {
          return const LoginView();
        },
      ),

    ],
  );
}
