import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/size_config.dart';

import 'users_provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Add User", style: Styles.bold20(context)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(getResponsiveSize(context, size: 16)),
        child: Column(
          children: [
            // ---------- INPUT FIELD ----------
            TextField(
              controller: userController,
              decoration: InputDecoration(
                labelText: "Enter username",
                labelStyle: Styles.body14(context).copyWith(
                  color: AppColors.textLight,
                ),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      getResponsiveRadius(context, radius: 12)),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      getResponsiveRadius(context, radius: 12)),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.4),
                ),
              ),
            ),

            SizedBox(height: getResponsiveSize(context, size: 20)),

            // ---------- ADD USER BUTTON ----------
            SizedBox(
              width: double.infinity,
              height: getResponsiveSize(context, size: 55),
              child: ElevatedButton(
                onPressed: () {
                  if (userController.text.isNotEmpty) {
                    usersProvider.addUser(userController.text);
                    userController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("User Added"),
                        duration: const Duration(seconds: 1),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        getResponsiveRadius(context, radius: 14)),
                  ),
                ),
                child: Text(
                  "Add User",
                  style: Styles.button16(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
