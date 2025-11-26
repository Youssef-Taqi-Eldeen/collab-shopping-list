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
    final state = parentContext.read<CartsCubit>().state;

    if (state is! CartsLoaded) return;

    final carts = state.carts;

    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _ChooseCartContent(
          parentContext: parentContext,
          carts: carts,
          product: product,
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

    showDialog(
      context: parentContext,
      builder: (_) => AlertDialog(
        title: const Text("Create Cart"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Cart name",
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(parentContext),
          ),
          ElevatedButton(
            child: const Text("Create"),
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              await parentContext.read<CartsCubit>().createCart(name);


              final newState =
              parentContext.read<CartsCubit>().state as CartsLoaded;

              final newCart = newState.carts.last;

              await parentContext.read<CartsCubit>().addProductToCart(
                cartId: newCart.id,
                product: product,
              );

              Navigator.pop(parentContext);

              ScaffoldMessenger.of(parentContext).showSnackBar(
                SnackBar(
                  content: Text("Added to $name"),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
