import 'dart:convert';

import 'package:inventory/core/api/api_client.dart';
import 'package:inventory/core/api/enpoints.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';

class InvoiceItemService {
  static final LocalHttp _http = ApiClient.http;

  // List<List<InvoiceItem>>
  static Future<List<List<InvoiceItem>>> getSalesOverview() async {
    final response = await _http.get(ApiEndpoints.salesOverview);

    final responseBody = jsonDecode(response.body) as List;

    return (responseBody).map((categories) {
      return (categories as List).map((invoiceItemRaw) {
        final invoiceItem =
            InvoiceItem.fromJson(invoiceItemRaw as Map<String, dynamic>);

        return invoiceItem;
      }).toList();
    }).toList();
  }
}
