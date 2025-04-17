import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/core/models/stock.dart';

class DashboardStats {
  /// Total no. of products in database
  int productsCount;

  ///
  int itemsInStock;

  List<Stock> lowStockItems;

  List<Invoice> recentPurchases;

  List<Invoice> recentSales;

  DashboardStats(
      {required this.productsCount,
      required this.itemsInStock,
      required this.recentPurchases,
      required this.lowStockItems,
      required this.recentSales});

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
        productsCount: json["products_count"],
        itemsInStock: json["items_in_stock"],
        lowStockItems: (json["low_stock_items"] as List).map((lowStockItem) {
          return Stock.fromJson(lowStockItem);
        }).toList(),
        recentPurchases:
            (json["recent_purchases"] as List).map((purchaseInvoice) {
          return Invoice.fromJson(purchaseInvoice);
        }).toList(),
        recentSales: (json["recent_sales"] as List).map((salesInvoice) {
          return Invoice.fromJson(salesInvoice);
        }).toList());
  }
}
