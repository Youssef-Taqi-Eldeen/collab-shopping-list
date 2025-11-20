import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import 'cart_items.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("My Cart", style: Styles.bold20(context)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: const Center(child: Text("Your cart is empty")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Cart", style: Styles.bold20(context)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];

                return Dismissible(
                  key: Key(product.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 30),
                  ),
                  onDismissed: (direction) {
                    removeFromCart(index);
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    child: Card(
                      elevation: 8,
                      color: Colors.white,
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: product.images.isNotEmpty
                            ? Image.network(product.images[0], width: 50)
                            : const Icon(Icons.image_not_supported),
                        title: Text(product.title,style: TextStyle(fontWeight: FontWeight.w900),),
                        subtitle: Text(
                          "\$${(product.price * product.qty).toStringAsFixed(2)}",
                          style: Styles.bold20(context),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (product.qty > 1) {
                                    product.qty--;
                                  }
                                });
                              },
                              child: const Icon(Icons.remove_circle_outline, size: 28,color: Colors.black,),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              product.qty.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  product.qty++;
                                });
                              },
                              child: const Icon(Icons.add_circle_outline, size: 28,color: AppColors.primary),),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Grand Total",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${cartItems.fold(0.0, (sum, item) => sum + (item.price * item.qty)).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: Container(
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
