import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/provider/auth_app.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

import '../../../auth/presentation/view/forgot_password_view.dart';
import '../../data/cubit/profile_cubit.dart';
import 'about_screen.dart';
import 'account_setting_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Profile', style: Styles.bold20(context)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textDark),
            onPressed: () {
              // go_router redirect will handle navigation
              context.read<AuthProvider>().signOut();
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // ---------------- USER PROFILE CARD ----------------
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _getInitial(currentUser?.displayName, currentUser?.email),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.displayName ?? "Unnamed User",
                        style: Styles.bold20(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentUser?.email ?? "No email",
                        style: Styles.body14(context)
                            .copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "UID: ${currentUser?.uid ?? ''}",
                        style: Styles.body12Grey(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- SETTINGS / ACCOUNT OPTIONS ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _menuTile(
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                ),
                _menuTile(
                  icon: Icons.settings_outlined,
                  title: "Account Settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ProfileBloc>(),
                          child: const AccountSettingsScreen(),
                        ),
                      ),
                    );
                  },
                ),

                _menuTile(
                  icon: Icons.info_outline,
                  title: "App Information",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AboutAppScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------- Helpers -------------

  String _getInitial(String? name, String? email) {
    if (name != null && name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return "U";
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
