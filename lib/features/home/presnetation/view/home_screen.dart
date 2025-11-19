import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/size_config.dart';

import '../../cubit/home_cubit.dart';
import '../../model/category_model.dart';
import '../../model/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Explore Top Products\n   With Exclusive Deals",
          style: Styles.bold20(context),
          maxLines: 2,
        ),
      ),


      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(child: Text(state.message));
          }

          return Padding(
            padding: EdgeInsets.all(getResponsiveSize(context, size: 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          context.read<HomeCubit>().search(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Search products...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: AppColors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                getResponsiveRadius(context, radius: 12)),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                getResponsiveRadius(context, radius: 12)),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Container(
                      padding: EdgeInsets.all(getResponsiveSize(context, size: 12)),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                            getResponsiveRadius(context, radius: 12)),
                      ),
                      child: const Icon(Icons.filter_alt, color: Colors.white),
                    ),
                  ],
                ),

                SizedBox(height: getResponsiveSize(context, size: 16)),

                _categoriesSection(context, state),

                SizedBox(height: getResponsiveSize(context, size: 16)),

                _productsSection(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _categoriesSection(BuildContext context, HomeState state) {
    if (state is! HomeLoaded && state is! HomeProductsLoading) {
      return const SizedBox.shrink();
    }

    final categories =
    state is HomeLoaded ? state.categories : context.read<HomeCubit>().categories;

    return SizedBox(
      height: getResponsiveSize(context, size: 40),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length+1,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) {
            // FIRST ITEM = ALL
            if (i == 0) {
              final bool isSelected =
                  context.read<HomeCubit>().selectedCategory == "all";

              return GestureDetector(
                onTap: () {
                  context.read<HomeCubit>().selectedCategory = "all";
                  context.read<HomeCubit>().loadHome();
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getResponsiveSize(context, size: 16),
                    vertical: getResponsiveSize(context, size: 10),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius:
                    BorderRadius.circular(getResponsiveRadius(context, radius: 12)),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "All",
                      style: Styles.body14(context).copyWith(
                        color: isSelected ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              );
            }

            // REAL CATEGORIES
            final Category cat = categories[i - 1];
            final bool isSelected =
                context.read<HomeCubit>().selectedCategory == cat.slug;

            return GestureDetector(
              onTap: () => context.read<HomeCubit>().filterByCategory(cat.slug),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveSize(context, size: 16),
                  vertical: getResponsiveSize(context, size: 10),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius:
                  BorderRadius.circular(getResponsiveRadius(context, radius: 12)),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    cat.name,
                    style: Styles.body14(context).copyWith(
                      color: isSelected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
              ),
            );
          }

      ),
    );
  }

  // ---------- PRODUCT SECTION WITH SHIMMER ----------
  Widget _productsSection(BuildContext context, HomeState state) {
    // shimmer loading when filtering/searching
    if (state is HomeProductsLoading) {
      return Expanded(
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 8,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: getResponsiveSize(context, size: 12),
            crossAxisSpacing: getResponsiveSize(context, size: 12),
            childAspectRatio: 0.67,
          ),
          itemBuilder: (_, i) => _shimmerCard(context),
        ),
      );
    }

    // loaded products
    if (state is HomeLoaded) {
      return Expanded(
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: state.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: getResponsiveSize(context, size: 12),
            crossAxisSpacing: getResponsiveSize(context, size: 12),
            childAspectRatio: 0.67,
          ),
          itemBuilder: (context, i) =>
              _productCard(context, state.products[i]),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // ---------- SHIMMER PRODUCT CARD ----------
  Widget _shimmerCard(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
          BorderRadius.circular(getResponsiveRadius(context, radius: 14)),
        ),
        padding: EdgeInsets.all(getResponsiveSize(context, size: 10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Container(
              height: getResponsiveSize(context, size: 14),
              color: Colors.grey.shade300,
            ),
            SizedBox(height: getResponsiveSize(context, size: 6)),
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

  // ---------- REAL PRODUCT CARD ----------
  Widget _productCard(BuildContext context, Product product) {
    return Container(
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
          )
        ],
      ),
      padding: EdgeInsets.all(getResponsiveSize(context, size: 10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          Expanded(
            child: Center(
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(height: getResponsiveSize(context, size: 8)),

          // TITLE
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Styles.body14(context),
          ),

          SizedBox(height: getResponsiveSize(context, size: 4)),

          // PRICE
          Text(
            "\$${product.price}",
            style: Styles.bold20(context).copyWith(
              fontSize: getResponsiveText(context, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
