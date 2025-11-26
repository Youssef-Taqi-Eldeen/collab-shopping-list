import 'package:depi_project/features/navigation/widgets/carved_button_nav_bar.dart';
import 'package:flutter/material.dart';
import '../cart/presentation/view/carts_list_screen.dart';
import '../home/presnetation/view/home_screen.dart';
import '../profile/presentation/view/profile_screen.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final screens = const [
    HomeScreen(),
    CartsListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],

      bottomNavigationBar: CurvedBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
