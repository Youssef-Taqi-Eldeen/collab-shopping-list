import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/services/api_services.dart';
import 'core/services/local_cart_repositort.dart';
import 'core/utils/app_router.dart';

import 'features/cart/cubit/cart_cubit.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/cart/presentation/view/users_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsersProvider(),
        ),

        // BLoC providers
        BlocProvider(
          create: (_) => HomeCubit(ApiService()),
        ),
        BlocProvider(
          create: (_) => CartsCubit(LocalCartsRepository(), "demoUser1")..loadCarts(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
