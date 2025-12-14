import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../cart/presentation/view/carts_list_screen.dart';
import '../../model/product_model.dart';
import '../widgets/chooseCartSheet.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int rating = 0;
  int qty = 1;
  int selectedSize = 0;
  bool isFavorite = false;

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
                    builder: (_) => const CartsListScreen(),
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
                height: 320,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                child: Center(
                  child: Image.network(widget.product.thumbnail, fit: BoxFit.contain),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      final active = i < rating;
                      return GestureDetector(
                        onTap: () => setState(() => rating = i + 1),
                        child: Icon(
                          Icons.star,
                          size: 24,
                          color: active ? AppColors.primary : Colors.grey.withOpacity(0.3), // ignore: deprecated_member_use
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Text("(${rating.toStringAsFixed(1)})"),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => qty = qty > 1 ? qty - 1 : 1),
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 12),
                        Text("$qty"),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => setState(() => qty++),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(widget.product.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),

              Text(
                "\$${widget.product.price * qty}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),
              const Divider(),

              const Text("Descriptions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(widget.product.description),

              const SizedBox(height: 20),
              const Divider(),

              const Text("Select Size", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              Row(
                children: List.generate(4, (i) {
                  final labels = ["S", "M", "L", "XL"];
                  final active = selectedSize == i;
                  return Padding(
                    padding: EdgeInsets.only(right: i == 3 ? 0 : 10),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedSize = i),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          labels[i],
                          style: TextStyle(
                            color: active ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                      onTap: () => setState(() => isFavorite = !isFavorite),
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.grey.shade300),
                          color: isFavorite ? AppColors.primary : Colors.transparent,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ChooseCartSheet.show(
                            parentContext: context,
                            product: widget.product.copyWith(qty: qty),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                        label: const Text("Add to Cart",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: AppColors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
