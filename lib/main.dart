import 'package:depi_project/core/provider/auth_app.dart';
import 'package:depi_project/core/provider/shopping_list_provider.dart';
import 'package:depi_project/features/cart/presentation/view/users_provider.dart';
import 'package:depi_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/services/api_services.dart';
import 'core/services/firebase_service.dart';
import 'core/utils/app_router.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/cart/cubit/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HomeCubit(ApiService())),
          BlocProvider(
            create: (_) => CartsCubit(FirebaseService()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Initialize the router once to avoid recreating it on every build.
    // We access the AuthProvider here, which is available because MyApp
    // is now a child of the MultiProvider in main().
    final authProvider = context.read<AuthProvider>();
    _router = AppRouter.createRouter(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'ShopSync',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
