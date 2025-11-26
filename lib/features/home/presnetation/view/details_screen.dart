import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../cart/presentation/view/cart_items.dart';
import '../../model/product_model.dart';
import '../../../cart/presentation/view/cart_screen.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int rating = 0;
  int qty = 1;
  int selectedSize = 1;
  bool isFavorite = false;

  void addToCart(Product product) {
    final existingIndex = cartItems.indexWhere((p) => p.id == product.id);

    if (existingIndex != -1) {
      cartItems[existingIndex].qty = (cartItems[existingIndex].qty ?? 1) + qty;
    } else {
      product.qty = qty;
      cartItems.add(product);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Product Added to Cart"),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Product Details", style: Styles.bold20(context)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CartScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                child: Center(
                  child: Image.network(widget.product.thumbnail, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      bool isSelected = index < rating;
                      return GestureDetector(
                        onTap: () { setState(() { rating = index + 1; }); },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.all(2),
                          child: Icon(Icons.star, size: 24, color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3)),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Text("(${rating.toStringAsFixed(1)})", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () { if (qty >= 1) setState(() { qty--; }); },
                          child: Icon(Icons.remove, size: 20, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Text("$qty", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () { setState(() { qty++; }); },
                          child: Icon(Icons.add, size: 20, color: AppColors.primary),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(widget.product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("\$${widget.product.price * (widget.product.qty ?? qty)}", style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey, thickness: .3),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Descriptions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(widget.product.description, style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey, thickness: .3),
              const SizedBox(height: 16),
              const Text("Select Size", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(4, (i) {
                  List sizes = ["S", "M", "L", "XL"];
                  bool isSelected = selectedSize == i;
                  return Padding(
                    padding: EdgeInsets.only(right: i == 3 ? 0 : 10),
                    child: GestureDetector(
                      onTap: () { setState(() => selectedSize = i); },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          sizes[i],
                          style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () { setState(() { isFavorite = !isFavorite; }); },
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.grey.shade300),
                          color: isFavorite ? AppColors.primary : Colors.transparent,
                        ),
                        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.white : Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () { addToCart(widget.product); },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 30),
                        label: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
