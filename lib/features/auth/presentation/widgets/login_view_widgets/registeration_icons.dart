import 'package:flutter/cupertino.dart';

import '../../../../../core/utils/app_images.dart';
import 'logo_icon_widget.dart';

class RegisterationIcons extends StatelessWidget {
  const RegisterationIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LogoIconWidget(iconPath: Assets.appleLogoIcon),
        LogoIconWidget(iconPath: Assets.googleLogoIconSvg),
        LogoIconWidget(iconPath: Assets.facebookIconSvg),
      ],
    );
  }
}
