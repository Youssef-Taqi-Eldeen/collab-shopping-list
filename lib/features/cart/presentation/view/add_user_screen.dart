import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/size_config.dart';
import '../../cubit/cart_cubit.dart';
import '../../model/cart_model.dart';

class AddUserScreen extends StatefulWidget {
  final String cartId;

  const AddUserScreen({super.key, required this.cartId});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController userController = TextEditingController();
  bool isLoading = false;

  // ----------------------------------------------------
  // 🔵 Find user in Firestore by email
  // ----------------------------------------------------
  Future<CartCollaborator?> findUserByEmail(String email) async {
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    final data = snap.docs.first.data();
    final uid = snap.docs.first.id;

    return CartCollaborator(
      id: uid,
      name: data["name"] ?? email,
      email: data["email"] ?? email,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                labelText: "Enter user email",
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
                onPressed: isLoading ? null : () async {
                  final email = userController.text.trim();

                  if (email.isEmpty) {
                    _show("Please enter an email", isError: true);
                    return;
                  }

                  setState(() => isLoading = true);

                  // 1️⃣ Search for user
                  final collaborator = await findUserByEmail(email);

                  if (collaborator == null) {
                    setState(() => isLoading = false);
                    _show("No user found with this email", isError: true);
                    return;
                  }

                  // 2️⃣ Add collaborator to cart
                  await context.read<CartsCubit>().addCollaborator(
                    cartId: widget.cartId,
                    collaborator: collaborator,
                  );

                  setState(() => isLoading = false);
                  userController.clear();

                  _show("User Added Successfully!");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        getResponsiveRadius(context, radius: 14)),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Add User", style: Styles.button16(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _show(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : AppColors.primary,
      ),
    );
  }
}
