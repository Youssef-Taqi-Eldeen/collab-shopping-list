import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_colors.dart';
import 'users_provider.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UsersProvider>(context).users;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Users'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: users.isEmpty
          ? Center(child: Text('No users added yet'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 70,
                  width: double.infinity,
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    child: ListTile(
                      leading: Icon(Icons.person, color: AppColors.primary),
                      title: Text(users[index]),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Provider.of<UsersProvider>(
                            context,
                            listen: false,
                          ).removeUser(users[index]);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("User Deleted"),
                              duration: const Duration(seconds: 1),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
