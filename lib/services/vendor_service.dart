import 'package:dio/dio.dart';
import 'package:inventory/core/models/vendor.dart';

class VendorService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'http://your-backend-api.com/vendors'));

  Future<List<Vendor>> getVendors() async {
    try {
      final response = await _dio.get('/');
      return (response.data as List).map((e) => Vendor.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load vendors: $e');
    }
  }

  Future<Vendor> getVendorById(String id) async {
    try {
      final response = await _dio.get('/$id');
      return Vendor.fromJson(response.data);
    } catch (e) {
      throw Exception('Vendor not found');
    }
  }

  Future<void> createVendor(Map<String, dynamic> vendorData) async {
    try {
      await _dio.post('/', data: vendorData);
    } catch (e) {
      throw Exception('Failed to create vendor');
    }
  }

  Future<void> updateVendor(String id, Map<String, dynamic> vendorData) async {
    try {
      await _dio.put('/$id', data: vendorData);
    } catch (e) {
      throw Exception('Failed to update vendor');
    }
  }
}
