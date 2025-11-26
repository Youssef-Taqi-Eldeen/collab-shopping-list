import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/size_config.dart';

import 'users_provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

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
    final usersProvider = Provider.of<UsersProvider>(context);
    final users = usersProvider.users;

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

      body: users.isEmpty
          ? Center(
        child: Text(
          "No collaborators yet",
          style: Styles.body14(context),
        ),
      )
          : ListView.builder(
        itemCount: users.length,
        padding: EdgeInsets.all(getResponsiveSize(context, size: 12)),
        itemBuilder: (context, index) {
          final username = users[index];
          return _userTile(context, username, usersProvider);
        },
      ),
    );
  }

  // ----------- USER TILE (swipe delete + avatar + dialog) -----------
  Widget _userTile(
      BuildContext context, String username, UsersProvider provider) {
    return Dismissible(
      key: Key(username),
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
        return await _confirmDeleteDialog(context, username);
      },
      onDismissed: (direction) {
        provider.removeUser(username);
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
              username[0].toUpperCase(),
              style: Styles.bold20(context).copyWith(color: Colors.white),
            ),
          ),

          title: Text(
            username,
            style: Styles.body16(context).copyWith(fontWeight: FontWeight.bold),
          ),

          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () async {
              bool? confirmed = await _confirmDeleteDialog(context, username);
              if (confirmed == true) provider.removeUser(username);
            },
          ),
        ),
      ),
    );
  }

  // ----------- DELETE CONFIRMATION DIALOG -----------
  Future<bool?> _confirmDeleteDialog(
      BuildContext context, String username) async {
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
