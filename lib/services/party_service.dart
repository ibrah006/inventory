import 'package:dio/dio.dart';
import 'package:inventory/data/models/party.dart';

class PartyService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'http://your-backend-api.com/vendors'));

  Future<List<Party>> getVendors() async {
    try {
      final response = await _dio.get('/');
      return (response.data as List).map((e) => Party.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load vendors: $e');
    }
  }

  Future<Party> getVendorById(String id) async {
    try {
      final response = await _dio.get('/$id');
      return Party.fromJson(response.data);
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
