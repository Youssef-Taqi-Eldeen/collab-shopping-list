import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/size_config.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/cart_state.dart';
import '../../model/cart_model.dart';
import 'cart_screen.dart';
import 'address_screen.dart';


class CartsListScreen extends StatefulWidget {
  const CartsListScreen({super.key});

  @override
  State<CartsListScreen> createState() => _CartsListScreenState();
}

class _CartsListScreenState extends State<CartsListScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("My Carts", style: Styles.bold20(context)),
      ),

      body: BlocBuilder<CartsCubit, CartsState>(
        builder: (context, state) {
          if (state is CartsLoading || state is CartsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartsError) {
            return Center(
              child: Text(state.message, style: Styles.body16(context)),
            );
          }

          if (state is CartsLoaded) {
            final carts = state.carts;

            if (carts.isEmpty) {
              return Center(
                child: Text("No carts created yet", style: Styles.body16(context)),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(getResponsiveSize(context, size: 16)),
              physics: const BouncingScrollPhysics(),
              itemCount: carts.length,
              itemBuilder: (context, index) {
                final cart = carts[index];
                return _cartTile(context, cart);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _cartTile(BuildContext context, CartModel cart) {
    final total = cart.products.fold(
      0.0,
      (sum, item) => sum + (item.price * item.qty),
    );

    return Container(
      margin: EdgeInsets.only(bottom: getResponsiveSize(context, size: 8)),
      padding: EdgeInsets.all(getResponsiveSize(context, size: 14)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          getResponsiveRadius(context, radius: 14),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartDetailScreen(cartId: cart.id),
                ),
              );
            },
            borderRadius:
                BorderRadius.circular(getResponsiveRadius(context, radius: 14)),
            child: Row(
              children: [
                // Icon box
                Container(
                  height: getResponsiveSize(context, size: 46),
                  width: getResponsiveSize(context, size: 46),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.15), // ignore: deprecated_member_use
                    borderRadius: BorderRadius.circular(
                        getResponsiveRadius(context, radius: 12)),
                  ),
                  child: Icon(
                    Icons.shopping_bag,
                    color: AppColors.primary,
                    size: getResponsiveSize(context, size: 26),
                  ),
                ),

                SizedBox(width: getResponsiveSize(context, size: 12)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cart.name,
                        style: Styles.bold20(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: getResponsiveSize(context, size: 4)),
                      Text(
                        "${cart.products.length} products • ${cart.collaborators.length} collaborators",
                        style: Styles.body12Grey(context),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios,
                  size: getResponsiveSize(context, size: 16),
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),

          if (cart.products.isNotEmpty) ...[
            SizedBox(height: getResponsiveSize(context, size: 12)),
            const Divider(height: 1),
            SizedBox(height: getResponsiveSize(context, size: 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: Styles.body16(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(
                  height: getResponsiveSize(context, size: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddressScreen(
                            cartId: cart.id,
                            totalAmount: total,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          getResponsiveRadius(context, radius: 20),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: getResponsiveSize(context, size: 20),
                      ),
                    ),
                    child: Text(
                      'Checkout',
                      style: Styles.button16(context).copyWith(
                        fontSize: getResponsiveText(context, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
