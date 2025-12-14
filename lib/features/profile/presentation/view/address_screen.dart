import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../data/cubit/profile_cubit.dart';
import '../../data/cubit/profile_event.dart';
import '../../data/cubit/profile_state.dart';


class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Address", style: Styles.bold20(context)),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is! ProfileLoaded) return const SizedBox();

          final addressCtrl =
          TextEditingController(text: state.profile.address);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: addressCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Your Address",
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _saveButton(context, () {
                  context
                      .read<ProfileBloc>()
                      .add(UpdateAddress(addressCtrl.text));
                  Navigator.pop(context);
                }),
              ],
            ),
          );
        },
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
