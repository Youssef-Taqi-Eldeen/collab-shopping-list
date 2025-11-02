import 'package:depi_project/core/utils/app_colors.dart';
import 'package:depi_project/core/utils/app_styles.dart';
import 'package:depi_project/features/auth/presentation/widgets/login_view_widgets/registeration_icons.dart';
import 'package:depi_project/features/auth/presentation/widgets/login_view_widgets/text_button_widget.dart';
import 'package:depi_project/features/auth/presentation/widgets/login_view_widgets/text_field.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text(
          "Shopping List", style: Styles.styleBold30AppbarText(context)),
        centerTitle: true,
        backgroundColor: AppColors.appbarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Login",
              style: Styles.styleSemiBold48(context)),
            SizedBox(
              height: 60,
            ),
            CustomTextField(
                hintText: "example@gmail.com",
                prefixIcon: Icons.email_outlined,
            ),
            SizedBox(height: 20,),
            CustomTextField(
              hintText: "********",
              prefixIcon: Icons.lock_outline,
              suffixIcon: Icons.visibility_off,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You don't have an account,"),
                  CustomTextButton(
                      onPressed: (){},
                      text: "register now",
                      textColor: AppColors.appbarColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    color: AppColors.blackColor,
                    width: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                      color: AppColors.blackColor,
                    ),),
                  ),
                  Container(
                    height: 1,
                    color: AppColors.blackColor,
                    width: 60,
                  )
                ],
              ),
            ),
            RegisterationIcons(),
          ],
        ),
      ),
    );
  }
}
