import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/size_config.dart';
import '../../../navigation/mainLayout.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final double totalAmount;

  const OrderConfirmationScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(getResponsiveSize(context, size: 24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Animation
              Container(
                height: getResponsiveSize(context, size: 120),
                width: getResponsiveSize(context, size: 120),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1), // ignore: deprecated_member_use
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: getResponsiveSize(context, size: 80),
                  color: Colors.green,
                ),
              ),

              SizedBox(height: getResponsiveSize(context, size: 24)),

              // Success Message
              Text(
                'Order Placed Successfully!',
                style: Styles.bold20(context).copyWith(
                  fontSize: getResponsiveText(context, fontSize: 24),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: getResponsiveSize(context, size: 12)),

              Text(
                'Your order has been sent successfully',
                style: Styles.body16(context).copyWith(
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: getResponsiveSize(context, size: 32)),

              // Order Details Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(getResponsiveSize(context, size: 20)),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(
                    getResponsiveRadius(context, radius: 16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Details',
                      style: Styles.bold20(context).copyWith(
                        fontSize: getResponsiveText(context, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: getResponsiveSize(context, size: 16)),
                    _detailRow(context, Icons.person, 'Name', name),
                    SizedBox(height: getResponsiveSize(context, size: 12)),
                    _detailRow(context, Icons.phone, 'Phone', phone),
                    SizedBox(height: getResponsiveSize(context, size: 12)),
                    _detailRow(context, Icons.location_on, 'Address', address),
                    SizedBox(height: getResponsiveSize(context, size: 16)),
                    const Divider(),
                    SizedBox(height: getResponsiveSize(context, size: 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: Styles.body16(context)),
                        Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
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
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: getResponsiveSize(context, size: 12),
                            vertical: getResponsiveSize(context, size: 6),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1), // ignore: deprecated_member_use
                            borderRadius: BorderRadius.circular(
                              getResponsiveRadius(context, radius: 20),
                            ),
                          ),
                          child: Text(
                            'Cash on Delivery',
                            style: Styles.body12(context).copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Back to Home Button
              SizedBox(
                width: double.infinity,
                height: getResponsiveSize(context, size: 60),
                child: ElevatedButton(
                  onPressed: () {
                    // Using popUntil is often more reliable when mixing Push/Pop with GoRouter
                    // This will pop all screens until we identify the first route (MainLayout)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        getResponsiveRadius(context, radius: 40),
                      ),
                    ),
                  ),
                  child: Text('Back to Home', style: Styles.button16(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: getResponsiveSize(context, size: 20),
          color: AppColors.primary,
        ),
        SizedBox(width: getResponsiveSize(context, size: 12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Styles.body12Grey(context),
              ),
              SizedBox(height: getResponsiveSize(context, size: 4)),
              Text(
                value,
                style: Styles.body14(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
