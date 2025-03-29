import 'package:dio/dio.dart';
import 'package:inventory/core/models/invoice.dart';

class InvoiceService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'http://your-backend-api.com/invoices'));

  Future<List<Invoice>> getAllInvoices() async {
    try {
      final response = await _dio.get('/');
      return (response.data as List).map((e) => Invoice.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load invoices: $e');
    }
  }

  Future<Invoice> getInvoiceById(int id) async {
    try {
      final response = await _dio.get('/$id');
      return Invoice.fromJson(response.data);
    } catch (e) {
      throw Exception('Invoice not found');
    }
  }

  Future<void> createInvoice(Map<String, dynamic> invoiceData) async {
    try {
      await _dio.post('/', data: invoiceData);
    } catch (e) {
      throw Exception('Failed to create invoice');
    }
  }

  Future<void> updateInvoice(int id, Map<String, dynamic> invoiceData) async {
    try {
      await _dio.put('/$id', data: invoiceData);
    } catch (e) {
      throw Exception('Failed to update invoice');
    }
  }

  Future<void> deleteInvoice(int id) async {
    try {
      await _dio.delete('/$id');
    } catch (e) {
      throw Exception('Failed to delete invoice');
    }
  }
}
