import 'package:depi_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {
        super.key,
        required this.hintText,
        required this.prefixIcon,
        this.suffixIcon,
        this.onPressedSuffixIcon,
        this.isPassword = false,
      }
      );

  final bool isPassword;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onPressedSuffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hint: Text(hintText, style: TextStyle(
          color: AppColors_old.hintGreyColor,
          fontSize: 16,
        ),),
        prefixIcon: Icon(prefixIcon),
        prefixIconColor: AppColors_old.blackColor,
        suffixIcon: IconButton(
            onPressed: onPressedSuffixIcon,
            icon: Icon(suffixIcon, color: AppColors_old.blackColor,))
      ),
    );
  }
}
