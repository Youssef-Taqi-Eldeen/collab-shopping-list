import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class LogoIconWidget extends StatelessWidget {
  const LogoIconWidget({super.key, required this.iconPath});

  final String iconPath;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SvgPicture.asset(
        iconPath,
        height: 25,
        width: 25,
      ),
    );
  }
}
