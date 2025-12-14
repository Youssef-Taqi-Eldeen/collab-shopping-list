import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

import '../../data/cubit/profile_cubit.dart';
import 'edit_profile_screen.dart';
import 'payment_screen.dart';
import 'address_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Account Settings", style: Styles.bold20(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _tile(
              context: context,
              title: "Edit Profile",
              screen: const EditProfileScreen(),
            ),
            _tile(
             context:  context,
              title: "Payment Information",
              screen: const PaymentScreen(),
            ),
            _tile(
              title: "Address",
              screen: const AddressScreen(), context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required BuildContext context,
    required String title,
    required Widget screen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title, style: Styles.body16(context)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ProfileBloc>(),
                child: screen,
              ),
            ),
          );
        },
      ),
    );
  }
}
