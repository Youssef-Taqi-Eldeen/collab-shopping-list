import 'package:depi_project/core/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class Styles {
  static TextStyle styleBold30AppbarText(BuildContext context) {
    return TextStyle(
        fontSize: getResponsiveText(context, fontSize: 16),
        color: Color(0xFFFFFFFF),
        letterSpacing: 3.0,
        fontWeight: FontWeight.bold
    );
  }

  static TextStyle styleSemiBold48(BuildContext context) {
    return TextStyle(
      color: Colors.black,
      fontSize: getResponsiveText(context, fontSize: 48),
      fontWeight: FontWeight.w600,
    );
  }


}

double getResponsiveText(BuildContext context, {required double fontSize}) {
  double responsiveText = getScaleFactor(context) * fontSize;
  return responsiveText.clamp(fontSize * .8, fontSize * 1.2);
}

double getScaleFactor(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;
  if (width <= SizeConfig.mobileWidth) {
    return width / 400;
  } else if (width <= SizeConfig.tabletWidth) {
    return width / 800;
  } else {
    return width / 1200;
  }
}
