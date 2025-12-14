import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/cart_cubit.dart';
import 'order_confirmation_screen.dart';

class AddressScreen extends StatefulWidget {
  final String cartId;
  final double totalAmount;

  const AddressScreen({
    super.key,
    required this.cartId,
    required this.totalAmount,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _confirmOrder() {
    if (!_formKey.currentState!.validate()) return;

    // Delete the cart
    // We don't await this to keep UI snappy, but we catch potential errors
    context.read<CartsCubit>().deleteCart(widget.cartId).catchError((e) {
      debugPrint("Error deleting cart: $e");
    });

    // Navigate to confirmation screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          totalAmount: widget.totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Delivery Address', style: Styles.bold20(context)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(getResponsiveSize(context, size: 20)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(getResponsiveSize(context, size: 16)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1), // ignore: deprecated_member_use
                  borderRadius: BorderRadius.circular(
                    getResponsiveRadius(context, radius: 12),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: getResponsiveSize(context, size: 48),
                      color: AppColors.primary,
                    ),
                    SizedBox(height: getResponsiveSize(context, size: 8)),
                    Text(
                      'Enter your delivery details',
                      style: Styles.body16(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: getResponsiveSize(context, size: 24)),

              // Name Field
              Text('Full Name', style: Styles.body14(context)),
              SizedBox(height: getResponsiveSize(context, size: 8)),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      getResponsiveRadius(context, radius: 12),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      getResponsiveRadius(context, radius: 12),
                    ),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              SizedBox(height: getResponsiveSize(context, size: 16)),

              // Phone Field
              Text('Phone Number', style: Styles.body14(context)),
              SizedBox(height: getResponsiveSize(context, size: 8)),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      getResponsiveRadius(context, radius: 12),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      getResponsiveRadius(context, radius: 12),
                    ),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.trim().length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              SizedBox(height: getResponsiveSize(context, size: 16)),

              // Address Field
              Text('Delivery Address', style: Styles.body14(context)),
              SizedBox(height: getResponsiveSize(context, size: 8)),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Enter your full address',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      getResponsiveRadius(context, radius: 12),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      getResponsiveRadius(context, radius: 12),
                    ),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  if (value.trim().length < 10) {
                    return 'Please enter a complete address';
                  }
                  return null;
                },
              ),

              SizedBox(height: getResponsiveSize(context, size: 24)),

              // Order Summary
              Container(
                padding: EdgeInsets.all(getResponsiveSize(context, size: 16)),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(
                    getResponsiveRadius(context, radius: 12),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: Styles.body16(context)),
                        Text(
                          '\$${widget.totalAmount.toStringAsFixed(2)}',
                          style: Styles.bold20(context).copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getResponsiveSize(context, size: 8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Method', style: Styles.body14(context)),
                        Text(
                          'Cash on Delivery',
                          style: Styles.body14(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: getResponsiveSize(context, size: 32)),

              // Confirm Button
              SizedBox(
                height: getResponsiveSize(context, size: 60),
                child: ElevatedButton(
                  onPressed: _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        getResponsiveRadius(context, radius: 40),
                      ),
                    ),
                  ),
                  child: Text('Confirm Order', style: Styles.button16(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
