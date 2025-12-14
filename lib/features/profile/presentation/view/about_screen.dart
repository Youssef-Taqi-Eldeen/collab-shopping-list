import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("About ShopSync", style: Styles.bold20(context)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 24),

            _sectionCard(
              context,
              icon: Icons.shopping_cart_outlined,
              title: "What is ShopSync?",
              content:
              "ShopSync is a collaborative shopping list application that helps people plan, manage, and share shopping lists in real time with family and friends.",
            ),

            _sectionCard(
              context,
              icon: Icons.groups_outlined,
              title: "Why ShopSync?",
              content:
              "No more duplicated items, forgotten groceries, or messy notes. Everyone stays in sync, and updates happen instantly.",
            ),

            _featuresSection(context),

            _sectionCard(
              context,
              icon: Icons.lightbulb_outline,
              title: "Our Vision",
              content:
              "We aim to simplify everyday shopping and turn it into a smooth, shared experience that saves time and effort.",
            ),

            const SizedBox(height: 20),

            _versionInfo(context),
          ],
        ),
      ),
    );
  }

  // ---------------- Header ----------------

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            "ShopSync",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Collaborative Shopping Made Simple",
            style: Styles.body14(context).copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ---------------- Section Card ----------------

  Widget _sectionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String content,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(title, style: Styles.bold20(context)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: Styles.body14(context),
          ),
        ],
      ),
    );
  }

  // ---------------- Features ----------------

  Widget _featuresSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_outline, color: AppColors.primary),
              const SizedBox(width: 10),
              Text("Key Features", style: Styles.bold20(context)),
            ],
          ),
          const SizedBox(height: 12),

          _featureItem("Shared shopping lists"),
          _featureItem("Real-time updates"),
          _featureItem("Simple and clean interface"),
          _featureItem("Designed for families & teams"),
        ],
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  // ---------------- Version Info ----------------

  Widget _versionInfo(BuildContext context) {
    return Center(
      child: Text(
        "Version 1.0.0",
        style: Styles.body12Grey(context),
      ),
    );
  }
}
