import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/shopping_list_model.dart';
import '../../../../core/provider/shopping_list_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import 'dart:async';

class ListDetailsScreen extends StatefulWidget {
  final ShoppingListModel list;

  const ListDetailsScreen({super.key, required this.list});

  @override
  State<ListDetailsScreen> createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  StreamSubscription<ShoppingListModel>? _listSubscription;
  ShoppingListModel? _currentList;

  @override
  void initState() {
    super.initState();
    _currentList = widget.list;
    _subscribeToList();
  }

  void _subscribeToList() {
    final provider = context.read<ShoppingListProvider>();
    _listSubscription = provider.getListStream(widget.list.id).listen(
      (list) {
        if (mounted) {
          setState(() {
            _currentList = list;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          debugPrint('Error loading list: $error');
        }
      },
    );
  }

  @override
  void dispose() {
    _listSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = _currentList;
    
    if (list == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(widget.list.name, style: Styles.bold20(context)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final items = list.items;
    final int totalItems = items.length;
    final double grandTotal = items.fold(0, (sum, item) => sum + ((item.price ?? 0) * item.quantity));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(list.name, style: Styles.bold20(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: AppColors.primary),
            onPressed: () => _showShareDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text("No items yet", style: Styles.body16(context).copyWith(color: Colors.grey)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final totalPrice = (item.price ?? 0) * item.quantity;
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05), // ignore: deprecated_member_use
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Area
                            Expanded(
                              flex: 3,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.05), // ignore: deprecated_member_use
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    ),
                                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                            child: Image.network(
                                              item.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.shopping_bag_outlined,
                                                    size: 40,
                                                    color: AppColors.primary.withOpacity(0.5), // ignore: deprecated_member_use
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                              size: 40,
                                              color: AppColors.primary.withOpacity(0.5), // ignore: deprecated_member_use
                                            ),
                                          ),
                                  ),
                                  // Checkbox overlay
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Transform.scale(
                                      scale: 0.9,
                                      child: Checkbox(
                                        value: item.isChecked,
                                        activeColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        onChanged: (val) {
                                          if (mounted) {
                                            context
                                                .read<ShoppingListProvider>()
                                                .toggleItem(list.id, item);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Content Area
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.body16(context).copyWith(
                                        fontWeight: FontWeight.bold,
                                        decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                        color: item.isChecked ? Colors.grey : Colors.black87,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Qty: ${item.quantity}",
                                          style: Styles.body14(context).copyWith(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 2),
                                        if (item.price != null)
                                          Text(
                                            "Total: \$${totalPrice.toStringAsFixed(2)}",
                                            style: Styles.body14(context).copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Summary Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // ignore: deprecated_member_use
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total Items",
                        style: Styles.body14(context).copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$totalItems",
                        style: Styles.bold20(context),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Grand Total",
                        style: Styles.body14(context).copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${grandTotal.toStringAsFixed(2)}",
                        style: Styles.bold20(context).copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Share List"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter email to invite collaborator:"),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email address"),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.trim().isNotEmpty) {
                final message = await context
                    .read<ShoppingListProvider>()
                    .shareList(widget.list.id, emailController.text.trim());
                
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                }
              }
            },
            child: const Text("Invite"),
          ),
        ],
      ),
    );
  }
}
