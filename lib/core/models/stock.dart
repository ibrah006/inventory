import 'package:inventory/core/models/product.dart';

class Stock {
  Stock({
    required Product product,
    required int stockQuantity,
    required DateTime? lastCheckDate,
    required double inventoryValue,
  }) {
    _product = product;
    _stockQuantity = stockQuantity;
    _lastCheckDate = lastCheckDate;
    _inventoryValue = inventoryValue;
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      product: Product.fromJson(
          json['product']), // Assuming Product has fromJson constructor
      stockQuantity: json['stockQuantity'] as int,
      lastCheckDate: json['lastCheckDate'] != null
          ? DateTime.parse(json['lastCheckDate'])
          : null,
      inventoryValue: json['inventoryValue'] as double,
    );
  }

  late Product _product;
  Product get product => _product;

  late int _stockQuantity;
  int get stockQuantity => _stockQuantity;
  set stockQuantity(int newStockQuantity) {
    _stockQuantity = newStockQuantity;
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

  Map<String, dynamic> toMap() {
    return {
      'productId': _product.id,
      'stockQuantity': _stockQuantity,
      'lastCheckDate': _lastCheckDate?.toIso8601String(),
      'inventoryValue': _inventoryValue,
    };
  }
}
