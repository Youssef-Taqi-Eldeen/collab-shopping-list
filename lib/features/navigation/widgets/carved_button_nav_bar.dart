import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/size_config.dart';


class CurvedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CurvedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double padding = getResponsiveSize(context, size: 14);
    final double iconSize = getResponsiveSize(context, size: 26);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getResponsiveSize(context, size: 20),
        vertical: getResponsiveSize(context, size: 12),
      ),
      padding: EdgeInsets.symmetric(vertical: padding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          getResponsiveRadius(context, radius: 28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home_outlined, Icons.home, 0, iconSize),
          _navItem(context, Icons.shopping_cart_outlined, Icons.shopping_cart, 1, iconSize),
          _navItem(context, Icons.person_outline, Icons.person, 2, iconSize),
        ],
      ),
    );
  }

  Widget _navItem(
      BuildContext context,
      IconData inactiveIcon,
      IconData activeIcon,
      int index,
      double size,
      ) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,

        padding: EdgeInsets.all(isActive ? 6 : 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),

        child: Icon(
          isActive ? activeIcon : inactiveIcon,
          size: size,
          color: isActive ? AppColors.primary : Colors.grey,
        ),
      ),
    );
  }
}
