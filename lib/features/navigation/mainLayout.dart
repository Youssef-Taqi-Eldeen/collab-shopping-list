import 'package:depi_project/features/navigation/widgets/carved_button_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/provider/auth_app.dart';
import '../cart/presentation/view/carts_list_screen.dart';
import '../home/presnetation/view/home_screen.dart';
import '../profile/data/cubit/profile_cubit.dart';
import '../profile/data/cubit/profile_event.dart';
import '../profile/presentation/view/profile_screen.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;

    return BlocProvider(
      create: (_) => ProfileBloc()
        ..add(
          LoadInitialProfile(
            name: currentUser?.displayName ?? "User",
            email: currentUser?.email ?? "",
          ),
        ),
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: currentIndex,
          children: const [
            HomeScreen(),
            CartsListScreen(),
            ProfileScreen(), // ✅ NOW UNDER ProfileBloc
          ],
        ),
        bottomNavigationBar: CurvedBottomNav(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() => currentIndex = index);
          },
        ),
      ),
    );
  }
}
