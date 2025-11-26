import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/provider/shopping_list_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/models/shopping_list_model.dart';
import '../../../home/presnetation/view/list_details_screen.dart';
import '../../../home/presnetation/view/home_screen.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onHomePressed;
  
  const CartScreen({super.key, this.onHomePressed});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (onHomePressed != null) {
          onHomePressed!();
          return false;
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
          return false;
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.home_outlined, color: AppColors.textDark),
          tooltip: 'Back to Home',
          onPressed: onHomePressed ?? () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: Text(
          "My Shopping Lists",
          style: Styles.bold20(context),
        ),
      ),
      body: Consumer<ShoppingListProvider>(
        builder: (context, provider, child) {
          return StreamBuilder<List<ShoppingListModel>>(
            stream: provider.myLists,
            builder: (context, snapshot) {
              // Show loading only on initial connection
              if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Handle errors gracefully
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading lists',
                        style: Styles.body16(context).copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              
              // Get lists with null safety
              final lists = snapshot.data ?? [];

              if (lists.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.playlist_add, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        "No lists yet. Create one!",
                        style: Styles.body16(context).copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final list = lists[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        list.name,
                        style: Styles.body16(context).copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${list.items.length} items • ${list.collaborators.length} collaborators",
                        style: Styles.body14(context).copyWith(color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListDetailsScreen(list: list),
                          ),
                        );
                        // Screen will rebuild automatically when we return
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showCreateListDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      ),
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("New List"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "List Name"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ShoppingListProvider>().createList(controller.text.trim());
                Navigator.pop(dialogContext);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}
