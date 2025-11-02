import '../../../core/services/api_services.dart';
import '../model/category_model.dart';
import '../model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiService api;
  String? selectedCategory;

  HomeCubit(this.api) : super(HomeInitial());

  List<Category> categories = [];
  List<Product> products = [];

  Future<void> loadHome() async {
    selectedCategory = null;

    emit(HomeLoading());

    final categoriesResult = await api.getCategories();
    final productsResult = await api.getAllProducts();

    if (productsResult == null) {
      emit(HomeError("Failed to load products"));
      return;
    }

    categories = categoriesResult;
    products = productsResult.products;

    emit(HomeLoaded(categories, products));
  }

  Future<void> filterByCategory(String slug) async {
    selectedCategory = slug;
    emit(HomeProductsLoading());

    final result = await api.getProductsByCategory(slug);

    if (result != null) {
      emit(HomeLoaded(categories, result.products));
    } else {
      emit(HomeError("Category load failed"));
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(HomeLoaded(categories, products));
      return;
    }

    emit(HomeProductsLoading());
    final result = await api.searchProducts(query);

    if (result != null) {
      emit(HomeLoaded(categories, result.products));
    }
  }


}
