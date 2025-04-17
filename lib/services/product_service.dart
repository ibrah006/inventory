import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventory/core/api/api_client.dart';
import 'package:inventory/core/api/enpoints.dart';

import '../core/models/product.dart';

class ProductService {
  String mapToQueryParams(Map<String, String> params) {
    return Uri(queryParameters: params).query;
  }

  static Future<List<Product>> fetchProducts(
      {bool? includeStockEntries, bool? includeInvoices}) async {
    // try {
    // Query parameters
    final String queryParams = Uri(queryParameters: {
      if (includeStockEntries != null) ...{"stockEntries": true},
      if (includeInvoices != null) ...{"invoices": true}
    }).query;

    http.Response response =
        await ApiClient.http.get("${ApiEndpoints.products}?$queryParams");

    return (jsonDecode(response.body) as List)
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
    // } catch (e) {
    //   throw Exception('Failed to load products: $e');
    // }
  }

  static Future<Product> fetchById(String id) async {
    try {
      http.Response response =
          await ApiClient.http.get(ApiEndpoints.productById(id));
      return Product.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get product $id\nerror: $e');
    }
  }

  /// assigns barcode to the product passed-in upon creation of the product in server
  static Future<void> addProduct(Product product) async {
    // try {
    print("this is the product creation body: ${product.toJson()}");
    final response = await ApiClient.http
        .post(ApiEndpoints.products, body: product.toJson());

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    product.barcode = body["barcode"];
    // } catch (e) {
    //   throw Exception('Failed to add product: $e');
    // }
  }

  static Future<List<Product>> productsLookup(
      {String? id, String? name, String? barcode}) async {
    late final Map<String, dynamic> requestBody;
    if (id != null) {
      requestBody = {
        "identifier": name != null ? "description" : "id",
        "query": {
          "id": id,
          ...name != null ? {"name": name} : {}
        }
      };
    } else if (name != null) {
      requestBody = {
        "identifier": "name",
        "query": {"name": name}
      };
    } else if (barcode != null) {
      requestBody = {
        "identifier": "barcode",
        "query": {"barcode": barcode}
      };
    }

    print(
        "loookup response body: ${(await ApiClient.http.post("/lookup", body: requestBody)).body}");

    final response = await ApiClient.http
        .post(ApiEndpoints.lookupProducts, body: requestBody);

    late final List productsRaw;
    try {
      productsRaw = jsonDecode(response.body) as List;
    } catch (e) {
      // TODO: temporary, handle the error instead of throwing abother error
      throw "Products raw received: ${response.body}\nerror caught: $e";
    }

    // The productsRaw received as response body will have products that hold only minimal (non-relational) attributes, which can only be used for preview purposes
    return productsRaw
        .map((productRaw) => Product.preview(productRaw as Map))
        .toList();
  }
}
