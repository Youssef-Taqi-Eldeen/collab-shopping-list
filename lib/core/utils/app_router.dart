
import 'package:depi_project/features/auth/presentation/view/login_view.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presnetation/view/home_screen.dart';
import '../../features/navigation/mainLayout.dart';

abstract class AppRouter {
  static const String kAuthView = '/';
  // static const String kAuthView = '/AuthView';
  static const String kHomeView = '/home';


  static GoRouter router = GoRouter(
   // initialLocation: '/home',
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
      GoRoute(
        name: kHomeView,
        path: kHomeView,
        builder: (context, state) => const MainLayout(),
      ),


    ],
  );
}
