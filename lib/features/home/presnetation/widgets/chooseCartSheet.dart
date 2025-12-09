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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Choose Cart",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),

          Expanded(
            child: ListView.separated(
              itemCount: carts.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white,thickness: 0,),
              itemBuilder: (_, i) {
                final cart = carts[i];

                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag,
                        color: AppColors.primary, size: 30),
                    title: Text(cart.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    onTap: () {
                      parentContext.read<CartsCubit>().addProductToCart(
                            cartId: cart.id,
                            product: product,
                          );

                      Navigator.pop(context);

                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(
                          content: Text("Added to ${cart.name}"),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            width: 300,
            height: 50,
            margin: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: () => _showCreateCartDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), // Same rounded style
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              icon: const Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
              ),
              label: const Text(
                "Create New Cart",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
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
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
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
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.grey)),
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