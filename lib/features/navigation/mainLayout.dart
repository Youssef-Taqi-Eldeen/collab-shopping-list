import 'package:depi_project/features/navigation/widgets/carved_button_nav_bar.dart';
import 'package:flutter/material.dart';

import '../cart/presentation/view/cart_screen.dart';
import '../home/presnetation/view/home_screen.dart';
import '../profile/presentation/view/profile_screen.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  List<Widget> get screens => [
    const HomeScreen(),
    CartScreen(
      onHomePressed: () {
        setState(() => currentIndex = 0);
      },
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If not on home tab, go to home tab first
        if (currentIndex != 0) {
          setState(() => currentIndex = 0);
          return false; // Don't exit app
        }
        return true; // Exit app if already on home tab
      },
      child: Scaffold(
        extendBody: true,
        body: screens[currentIndex],

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
