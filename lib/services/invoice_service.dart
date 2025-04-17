import 'dart:convert';

import 'package:inventory/core/api/api_client.dart';
import 'package:inventory/core/api/enpoints.dart';
import 'package:inventory/core/models/invoice.dart';

class InvoiceService {
  static final LocalHttp _dio = ApiClient.http;

  static Future<List<Invoice>> getAllInvoices() async {
    try {
      final response = await _dio.get(ApiEndpoints.invoices);
      return (response.body as List).map((e) => Invoice.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load invoices: $e');
    }
  }

  static Future<Invoice> getInvoiceById(int id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.invoices}/$id');
      return Invoice.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Invoice not found');
    }
  }

  static Future<void> createInvoice(Map<String, dynamic> invoiceData) async {
    try {
      await _dio.post(ApiEndpoints.invoices, body: invoiceData);
    } catch (e) {
      throw Exception('Failed to create invoice: $e');
    }
  }

  static Future<void> updateInvoice(
      int id, Map<String, dynamic> invoiceData) async {
    try {
      await _dio.put('${ApiEndpoints.invoices}/$id', body: invoiceData);
    } catch (e) {
      throw Exception('Failed to update invoice');
    }
  }

  static Future<void> deleteInvoice(int id) async {
    try {
      await _dio.delete('${ApiEndpoints.invoices}/$id');
    } catch (e) {
      throw Exception('Failed to delete invoice');
    }
  }
}
