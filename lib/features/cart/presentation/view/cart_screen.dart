import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/size_config.dart';
import '../../cubit/cart_cubit.dart';
import '../../model/cart_model.dart';
import 'add_user_screen.dart';
import 'users_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/size_config.dart';
import '../../cubit/cart_cubit.dart';
import '../../model/cart_model.dart';
import 'add_user_screen.dart';
import 'users_screen.dart';

class CartDetailScreen extends StatelessWidget {
  final String cartId;

  const CartDetailScreen({super.key, required this.cartId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CartModel?>(
      // 🔥 FIXED STREAM HERE
      stream: context.read<CartsCubit>().firebase.streamCart(cartId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final cart = snapshot.data;

        if (cart == null) {
          return const Scaffold(
            body: Center(child: Text("Cart not found")),
          );
        }

        if (cart.products.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: _appBar(context, cart),
            body: Center(
              child: Text("Your cart is empty", style: Styles.body16(context)),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: _appBar(context, cart),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(getResponsiveSize(context, size: 8)),
                  itemCount: cart.products.length,
                  itemBuilder: (context, index) {
                    final product = cart.products[index];

                    return Dismissible(
                      key: Key(product.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: _deleteBg(context),
                      onDismissed: (_) {
                        context.read<CartsCubit>().removeProductFromCart(
                          cartId: cartId,
                          productId: product.id,
                        );
                      },
                      child: _cartItemCard(context, cart, product),
                    );
                  },
                ),
              ),

              _totalSection(context, cart),
              _checkoutButton(context),
            ],
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context, CartModel cart) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(cart.name, style: Styles.bold20(context)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_add_alt_1),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddUserScreen(cartId: cart.id),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.group),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UsersScreen(cartId: cart.id),
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DELETE BACKGROUND
  // ---------------------------------------------------------------------------

  Widget _deleteBg(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius:
        BorderRadius.circular(getResponsiveRadius(context, radius: 12)),
      ),
      alignment: Alignment.centerRight,
      child: const Icon(Icons.delete_outline_rounded,
          color: Colors.white, size: 30),
    );
  }


  Widget _cartItemCard(BuildContext context, CartModel cart, product) {
    return Container(
      height: getResponsiveSize(context, size: 100),
      margin:
      EdgeInsets.symmetric(vertical: getResponsiveSize(context, size: 6)),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(getResponsiveRadius(context, radius: 12)),
        ),
        child: Padding(
          padding: EdgeInsets.all(getResponsiveSize(context, size: 10)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(getResponsiveRadius(context, radius: 10)),
                child: Image.network(
                  product.thumbnail,
                  width: getResponsiveSize(context, size: 60),
                  height: getResponsiveSize(context, size: 60),
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: getResponsiveSize(context, size: 12)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(product.title,
                        style: Styles.body16(context).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      "\$${(product.price * product.qty).toStringAsFixed(2)}",
                      style: Styles.bold20(context).copyWith(
                        fontSize: getResponsiveText(context, fontSize: 16),
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (product.qty > 1) {
                        context.read<CartsCubit>().updateQuantity(
                          cartId: cart.id,
                          product: product,
                          increment: false,
                        );
                      }
                    },
                    child: const Icon(Icons.remove_circle_outline,
                        size: 26, color: AppColors.textDark),
                  ),

                  SizedBox(width: getResponsiveSize(context, size: 8)),

                  Text(product.qty.toString(), style: Styles.body16(context)),

                  SizedBox(width: getResponsiveSize(context, size: 8)),

                  GestureDetector(
                    onTap: () {
                      context.read<CartsCubit>().updateQuantity(
                        cartId: cart.id,
                        product: product,
                        increment: true,
                      );
                    },
                    child: const Icon(Icons.add_circle_outline,
                        size: 26, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _totalSection(BuildContext context, CartModel cart) {
    final total = cart.products.fold(
        0.0, (sum, item) => sum + (item.price * item.qty));

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getResponsiveSize(context, size: 16),
        vertical: getResponsiveSize(context, size: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Grand Total", style: Styles.bold20(context)),
          Text(
            "\$${total.toStringAsFixed(2)}",
            style: Styles.bold20(context),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CHECKOUT BUTTON
  // ---------------------------------------------------------------------------

  Widget _checkoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getResponsiveSize(context, size: 16),
        vertical: getResponsiveSize(context, size: 12),
      ),
      child: SizedBox(
        width: double.infinity,
        height: getResponsiveSize(context, size: 60),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(getResponsiveRadius(context, radius: 40)),
            ),
          ),
          child: Text("Checkout", style: Styles.button16(context)),
        ),
      ),
    );
  }
}
