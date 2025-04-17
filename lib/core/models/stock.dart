import 'package:inventory/core/models/product.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';
import 'package:inventory/services/stock_service.dart';

class Stock {
  Stock({
    final int? id,
    required Product product,
    // Length in meters (for roll) or Unit quantity (for box)
    required int stockMeasure,
    required DateTime? lastCheckDate,
    required double inventoryValue,
  }) {
    if (id != null) _id = id;
    _product = product;
    _stockMeasure = stockMeasure;
    _lastCheckDate = lastCheckDate;
    _inventoryValue = inventoryValue;
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    late final double inventoryValue;

    try {
      inventoryValue = json["value"] as double;
    } catch (e) {
      inventoryValue = (json["value"] as int).toDouble();
    }

    return Stock(
      id: json["id"],
      product: Product.fromJson(json['product']),
      stockMeasure: json['measure'] as int,
      lastCheckDate: json['lastCheckDate'] != null
          ? DateTime.parse(json['lastCheckDate'])
          : null,
      inventoryValue: inventoryValue,
    );
  }

  late int _id;

  int get id {
    throw UnimplementedError("didn't decide how the stock id works yet");
  }

  late Product _product;
  Product get product => _product;

  late int _stockMeasure;
  int get stockMeasure => _stockMeasure;
  set stockMeasure(int newStockMeasure) {
    _stockMeasure = newStockMeasure;
    // TODO: Update the stock quantity on the database table
  }

  late DateTime? _lastCheckDate;
  DateTime? get lastCheckDate => _lastCheckDate;

  late double _inventoryValue;
  double get inventoryValue => _inventoryValue;
  set inventoryValue(double newInventoryValue) {
    _inventoryValue = newInventoryValue;
    // TODO: Update the product's inventory value on the database table
  }

  // TODO: update this with respect to how the backend database functions
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      // Stock Quantity
      'measure': _stockMeasure,
      // Inventory Value $
      'value': _inventoryValue,
    };
  }

  // DATABASE INTEGRATION

  Future<void> update() async {
    await StockService.updateStock(_product.id, toJson());
  }

  static Future<void> updateWithStockItem(InvoiceItem item) async {
    await StockService.updateStock(item.id, item.toJson());
  }
}
