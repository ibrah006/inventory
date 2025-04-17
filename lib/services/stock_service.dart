import 'dart:convert';

import 'package:inventory/config/routes.dart';
import 'package:inventory/core/api/api_client.dart';
import 'package:inventory/core/models/stock.dart';

class StockService {
  static final LocalHttp _dio = ApiClient.http;

  static Future<List<Stock>> getStock() async {
    // try {
    final response = await _dio.get('${AppRoutes.stock}/');

    final responseData = jsonDecode(response.body);

    print("stock response data: ${responseData}");

    return (responseData as List).map((e) => Stock.fromJson(e)).toList();

    // try {

    // } on Exception {
    //   // when the returned result is map type then we assume that the stock is empty.
    //   // check to make sure the assumption is true, if not, we throw an error
    //   if ((responseData as Map).isEmpty) {

    //   }
    // }
    // } catch (e) {
    //   throw Exception('Failed to load stock: $e');
    // }
  }

  static Future<Stock> getStockById(int id) async {
    try {
      final response = await _dio.get('${AppRoutes.stock}/$id');
      return Stock.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Stock item not found, e: $e');
    }
  }

  static Future<Stock> getStockByProductId(String productId) async {
    try {
      final response = await _dio.get('${AppRoutes.stock}/product/$productId');
      return Stock.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Stock item not found, e: $e');
    }
  }

  static Future<void> updateStock(
      String productId, Map<String, dynamic> stockBody) async {
    try {
      final response = await _dio.put(AppRoutes.stock, body: stockBody);
      print(
          "stock response status: ${response.statusCode}, body: ${response.body}");
    } catch (e) {
      throw Exception('Failed to update stock, e: $e');
    }
  }
}
