import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("About ShopSync", style: Styles.bold20(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "ShopSync is a collaborative shopping list app that helps families "
              "and teams plan, share, and manage shopping together in real time. "
              "It keeps everyone synchronized, reduces forgotten items, and "
              "makes shopping faster and more organized.",
          style: Styles.body14(context),
        ),
      ),
    );
  }
}
