import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/size_config.dart';

import '../../cubit/cart_cubit.dart';
import '../../model/cart_model.dart';

class UsersScreen extends StatelessWidget {
  final String cartId;

  const UsersScreen({super.key, required this.cartId});

  // Generates a random soft avatar color
  Color _randomAvatarColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      180 + random.nextInt(60),
      180 + random.nextInt(60),
      180 + random.nextInt(60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Collaborators", style: Styles.bold20(context)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: StreamBuilder<CartModel?>(
        stream: context.read<CartsCubit>().streamCart(cartId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cart = snapshot.data!;
          final collaborators = cart.collaborators;

          if (collaborators.isEmpty) {
            return Center(
              child: Text(
                "No collaborators yet",
                style: Styles.body14(context),
              ),
            );
          }

          return ListView.builder(
            itemCount: collaborators.length,
            padding: EdgeInsets.all(getResponsiveSize(context, size: 12)),
            itemBuilder: (context, index) {
              final collaborator = collaborators[index];
              return _userTile(context, collaborator);
            },
          );
        },
      ),
    );
  }

  Widget _userTile(BuildContext context, CartCollaborator collaborator) {
    return Dismissible(
      key: Key(collaborator.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        return await _confirmDeleteDialog(context, collaborator.name);
      },
      onDismissed: (direction) {
        context.read<CartsCubit>().removeCollaborator(
          cartId: cartId,
          collaboratorId: collaborator.id,
        );
      },

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),

        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: getResponsiveSize(context, size: 16),
            vertical: getResponsiveSize(context, size: 6),
          ),

          leading: CircleAvatar(
            radius: getResponsiveSize(context, size: 22),
            backgroundColor: _randomAvatarColor(),
            child: Text(
              collaborator.name[0].toUpperCase(),
              style: Styles.bold20(context).copyWith(color: Colors.white),
            ),
          ),

          title: Text(
            collaborator.name,
            style: Styles.body16(context).copyWith(fontWeight: FontWeight.bold),
          ),

          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () async {
              bool? confirm = await _confirmDeleteDialog(context, collaborator.name);
              if (confirm == true) {
                context.read<CartsCubit>().removeCollaborator(
                  cartId: cartId,
                  collaboratorId: collaborator.id,
                );
              }
            },
          ),
        ),
      ),
    );
  }


  Future<bool?> _confirmDeleteDialog(BuildContext context, String username) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Remove collaborator?"),
        content: Text("Do you want to remove '$username' from this cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Remove",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
