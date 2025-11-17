import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/model/category_model.dart';
import '../../features/home/model/productResponse_model.dart';
import '../../features/home/model/product_model.dart';


class ApiService {
  final Dio dio = Dio();
  String? authToken;
  String? refreshToken;

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await dio.post(
        "https://dummyjson.com/auth/login",
        data: {"username": username, "password": password, "expiresInMins": 30},
      );

      authToken = response.data["accessToken"];
      refreshToken = response.data["refreshToken"];

      dio.options.headers['Authorization'] = 'Bearer $authToken';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", authToken!);
      await prefs.setString("refreshToken", refreshToken!);

      print("Token saved: ${response.data["accessToken"]}");
      return response.data;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("authToken");

      if (token == null) {
        print("No token found");
        return null;
      }

      final response = await dio.get(
        "https://dummyjson.com/auth/me",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("Auth header in getMe: ${dio.options.headers['Authorization']}");

      return response.data;
    } catch (e) {
      print("GetMe error: $e");
      return null;
    }
  }

  Future<void> refreshAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRefreshToken = prefs.getString("refreshToken");

      if (savedRefreshToken == null) {
        print("No refresh token found!");
        return;
      }

      final response = await dio.post(
        "https://dummyjson.com/auth/refresh",
        data: {
          "refreshToken": savedRefreshToken,
          "expiresInMins": 30,
        },
      );

      authToken = response.data["accessToken"];
      await prefs.setString("accessToken", authToken!);

      dio.options.headers['Authorization'] = 'Bearer $authToken';

      print("Token refreshed successfully!");
      print(authToken);
    } catch (e) {
      print("Refresh token error: $e");
    }
  }


  Future<ProductsResponse?> getAllProducts() async {
    try {
      final response = await dio.get("https://dummyjson.com/products");
      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      print("GetAllProducts error: $e");
      return null;
    }
  }


  Future<Product?> getSingleProduct(int id) async {
    try {
      final response = await dio.get("https://dummyjson.com/products/$id");
      return Product.fromJson(response.data);
    } catch (e) {
      print("GetSingleProduct error: $e");
      return null;
    }
  }


  Future<ProductsResponse?> searchProducts(String query) async {
    try {
      final response = await dio.get(
        "https://dummyjson.com/products/search",
        queryParameters: {"q": query},
      );
      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      print("SearchProducts error: $e");
      return null;
    }
  }
  Future<List<Category>> getCategories() async {
    try {
      final response = await dio.get("https://dummyjson.com/products/categories");
      final List data = response.data;
      return data.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      print("GetCategories error: $e");
      return [];
    }
  }

  Future<ProductsResponse?> getProductsByCategory(String slug) async {
    try {
      final response = await dio.get("https://dummyjson.com/products/category/$slug");
      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      print("GetProductsByCategory error: $e");
      return null;
    }
  }

}