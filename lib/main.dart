import 'package:depi_project/core/provider/auth_app.dart';
import 'package:depi_project/core/provider/shopping_list_provider.dart';
import 'package:depi_project/features/cart/presentation/view/users_provider.dart';
import 'package:depi_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/services/api_services.dart';
import 'core/utils/app_router.dart';

import 'features/home/cubit/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
      ],
      child: MultiBlocProvider(
        providers: [BlocProvider(create: (_) => HomeCubit(ApiService()))],
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.createRouter(authProvider),
            );
          },
        ),
      ),
    );
  }
}
