import 'package:flutter/widgets.dart';

class SizeConfig {
  static const double mobileWidth = 450;
  static const double tabletWidth = 900;
  static const double desktopWidth = 1400;
}

double getScaleFactor(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;

  if (width <= SizeConfig.mobileWidth) {
    return width / 400;     // Base for mobile
  } else if (width <= SizeConfig.tabletWidth) {
    return width / 800;     // Base for tablet
  } else {
    return width / 1200;    // Base for desktop
  }
}

/// Responsive text scaling (keeps variation limited to prevent ugly sizes)
double getResponsiveText(BuildContext context, {required double fontSize}) {
  double scaled = getScaleFactor(context) * fontSize;
  return scaled.clamp(fontSize * 0.8, fontSize * 1.2);
}

/// Responsive spacing (padding, margins)
double getResponsiveSize(BuildContext context, {required double size}) {
  double scaled = getScaleFactor(context) * size;
  return scaled.clamp(size * 0.7, size * 1.3);
}

/// Responsive radius
double getResponsiveRadius(BuildContext context, {required double radius}) {
  double scaled = getScaleFactor(context) * radius;
  return scaled.clamp(radius * 0.8, radius * 1.2);
}
