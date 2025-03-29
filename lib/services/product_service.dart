import 'package:dio/dio.dart';
import 'package:inventory/core/api/api_client.dart';
import 'package:inventory/core/api/enpoints.dart';

import '../core/models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    try {
      Response response = await ApiClient.dio.get(ApiEndpoints.products);
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await ApiClient.dio.post(ApiEndpoints.products, data: product.toJson());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }
}
