import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../cart/cubit/cart_cubit.dart';
import '../../../cart/cubit/cart_state.dart';
import '../../../home/model/product_model.dart';

class ChooseCartSheet {
  static void show({
    required BuildContext parentContext,
    required Product product,
  }) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocBuilder<CartsCubit, CartsState>(
          builder: (context, state) {
            if (state is CartsLoading || state is CartsInitial) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is CartsError) {
              return SizedBox(
                height: 200,
                child: Center(child: Text(state.message)),
              );
            }

            if (state is CartsLoaded) {
              return _ChooseCartContent(
                parentContext: parentContext,
                carts: state.carts,
                product: product,
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class _ChooseCartContent extends StatelessWidget {
  final BuildContext parentContext;
  final List carts;
  final Product product;

  const _ChooseCartContent({
    required this.parentContext,
    required this.carts,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "Choose Cart",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          Expanded(
            child: ListView.separated(
              itemCount: carts.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final cart = carts[i];

                return ListTile(
                  leading: Icon(Icons.shopping_bag, color: AppColors.primary),
                  title: Text(cart.name),
                  onTap: () {
                    parentContext.read<CartsCubit>().addProductToCart(
                      cartId: cart.id,
                      product: product,
                    );

                    Navigator.pop(context);

                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(
                        content: Text("Added to ${cart.name}"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _showCreateCartDialog(),
              child: const Text("Create New Cart"),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateCartDialog() {
    final controller = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create Cart"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Cart name",
                    ),
                  ),

                  if (isLoading) ...[
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(color: AppColors.primary),
                  ],
                ],
              ),
              actions: [
                if (!isLoading)
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),

                if (!isLoading)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                        "Create", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      final name = controller.text.trim();
                      if (name.isEmpty) return;

                      setState(() => isLoading = true);

                      try {
                        final newCartId =
                        await parentContext.read<CartsCubit>().createCart(name);

                        await parentContext.read<CartsCubit>().addProductToCart(
                          cartId: newCartId,
                          product: product,
                        );

                        await Future.delayed(const Duration(milliseconds: 200));
                        Navigator.pop(context);

                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            content: Text("Added to $name"),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      } catch (e) {
                        setState(() => isLoading = false);
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor:AppColors.danger,
                          ),
                        );
                      }
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}