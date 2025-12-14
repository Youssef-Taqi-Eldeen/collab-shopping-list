import 'package:depi_project/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class Styles {

  // Appbar Title
  static TextStyle appBarTitle(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveText(context, fontSize: 18),
      color: AppColors.textDark,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    );
  }

  // Large Bold Title
  static TextStyle bold26(BuildContext context) {
    return TextStyle(
      color: AppColors.textDark,
      fontSize: getResponsiveText(context, fontSize: 26),
      fontWeight: FontWeight.w700,
    );
  }

  // Medium Bold Title
  static TextStyle bold20(BuildContext context) {
    return TextStyle(
      color: AppColors.textDark,
      fontSize: getResponsiveText(context, fontSize: 20),
      fontWeight: FontWeight.w600,
    );
  }

  // Body Text Large
  static TextStyle body16(BuildContext context) {
    return TextStyle(
      color: AppColors.textDark,
      fontSize: getResponsiveText(context, fontSize: 16),
      fontWeight: FontWeight.w500,
    );
  }

  // Normal Paragraph
  static TextStyle body14(BuildContext context) {
    return TextStyle(
      color: AppColors.textDark,
      fontSize: getResponsiveText(context, fontSize: 14),
      fontWeight: FontWeight.w400,
    );
  }

  // Grey small text
  static TextStyle body12Grey(BuildContext context) {
    return TextStyle(
      color: AppColors.textLight,
      fontSize: getResponsiveText(context, fontSize: 12),
    );
  }

  static TextStyle body12(BuildContext context) {
    return TextStyle(
      color: AppColors.textDark,
      fontSize: getResponsiveText(context, fontSize: 12),
      fontWeight: FontWeight.w400,
    );
  }

  //Button Text
  static TextStyle button16(BuildContext context) {
    return TextStyle(
      color: Colors.white,
      fontSize: getResponsiveText(context, fontSize: 16),
      fontWeight: FontWeight.w600,
    );
  }

}
