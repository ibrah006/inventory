import 'package:dio/dio.dart';
import 'package:inventory/core/models/stock.dart';

class StockService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'http://your-backend-api.com/stock'));

  Future<List<Stock>> getStock() async {
    try {
      final response = await _dio.get('/');
      return (response.data as List).map((e) => Stock.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load stock: $e');
    }
  }

  Future<Stock> getStockById(int id) async {
    try {
      final response = await _dio.get('/$id');
      return Stock.fromJson(response.data);
    } catch (e) {
      throw Exception('Stock item not found');
    }
  }

  Future<void> updateStock(
      String productId, Map<String, dynamic> stockData) async {
    try {
      await _dio.put('/update/$productId', data: stockData);
    } catch (e) {
      throw Exception('Failed to update stock');
    }
  }
}
