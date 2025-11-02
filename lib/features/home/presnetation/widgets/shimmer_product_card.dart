import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            getResponsiveRadius(context, radius: 14),
          ),
        ),
        padding: EdgeInsets.all(getResponsiveSize(context, size: 10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE BLOCK
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(
                    getResponsiveRadius(context, radius: 12),
                  ),
                ),
              ),
            ),

            SizedBox(height: getResponsiveSize(context, size: 8)),

            // TITLE BLOCK
            Container(
              height: getResponsiveSize(context, size: 14),
              width: double.infinity,
              color: Colors.grey.shade300,
            ),

            SizedBox(height: getResponsiveSize(context, size: 6)),

            // PRICE BLOCK
            Container(
              height: getResponsiveSize(context, size: 12),
              width: getResponsiveSize(context, size: 60),
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
