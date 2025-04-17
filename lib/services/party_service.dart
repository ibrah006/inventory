import 'dart:convert';

import 'package:inventory/core/api/api_client.dart';
import 'package:inventory/core/api/enpoints.dart';
import 'package:inventory/core/models/party.dart';

class PartyService {
  static final LocalHttp _dio = ApiClient.http;

  static Future<List<Party>> getVendors() async {
    // try {
    final response = await _dio.get(ApiEndpoints.party);
    return (jsonDecode(response.body) as List)
        .map((e) => Party.fromJson(e))
        .toList();
    // } catch (e) {
    //   throw Exception('Failed to load vendors: $e');
    // }
  }

  static Future<Party> getVendorById(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.party}/$id');
      return Party.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Vendor not found');
    }
  }

  static Future<void> createVendor(Map<String, dynamic> vendorData) async {
    try {
      await _dio.post(ApiEndpoints.party, body: vendorData);
    } catch (e) {
      throw Exception('Failed to create vendor');
    }
  }

  static Future<void> updateVendor(
      String id, Map<String, dynamic> vendorData) async {
    try {
      await _dio.put('${ApiEndpoints.party}/$id', body: vendorData);
    } catch (e) {
      throw Exception('Failed to update vendor');
    }
  }
}
