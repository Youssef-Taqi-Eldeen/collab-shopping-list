import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../data/cubit/profile_cubit.dart';
import '../../data/cubit/profile_event.dart';
import '../../data/cubit/profile_state.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Payment Information", style: Styles.bold20(context)),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is! ProfileLoaded) return const SizedBox();

          final cardCtrl =
          TextEditingController(text: state.profile.cardNumber);
          final holderCtrl =
          TextEditingController(text: state.profile.cardHolder);
          final expiryCtrl =
          TextEditingController(text: state.profile.expiryDate);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _field("Card Number", cardCtrl),
                _field("Card Holder", holderCtrl),
                _field("Expiry Date", expiryCtrl),
                const SizedBox(height: 24),
                _saveButton(context, () {
                  context.read<ProfileBloc>().add(
                    UpdatePayment(
                      cardCtrl.text,
                      holderCtrl.text,
                      expiryCtrl.text,
                    ),
                  );
                  Navigator.pop(context);
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _saveButton(BuildContext context, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text("Save", style: Styles.button16(context)),
      ),
    );
  }
}
