import 'package:inventory/data/models/person.dart';
import 'package:inventory/features/inventory/data/units.dart';
import 'package:inventory/features/inventory/presentation/providers/helper/buying_units.dart';
import 'package:inventory/features/inventory/presentation/providers/helper/selling_units.dart';
import 'package:inventory/core/models/vendor.dart';

class Product {
  Product(
      {required String id,
      required String desc,
      required List<Vendor>? vendors,
      required String orderStatus,
      required Person? lastUpdated,
      required Units buyingUnits,
      required Units sellingUnits,
      required double? unitPrice,
      required String stockingUnit}) {
    _id = id;
    _desc = desc;
    _vendors = vendors;
    _orderStatus = orderStatus;
    _lastUpdated = lastUpdated;
    _buyingUnits = buyingUnits;
    _sellingUnits = sellingUnits;
    _unitPrice = unitPrice;
    _stockingUnit = stockingUnit;
  }

  factory Product.create(
      {required String id,
      required String desc,
      required double? unitPrice,
      required Units<BuyingUnits> buyingUnits,
      required Units<SellingUnits> sellingUnits,
      required String stockingUnit}) {
    return Product(
        id: id,
        desc: desc,
        vendors: [],
        orderStatus: "",
        stockingUnit: stockingUnit,
        lastUpdated: null,
        buyingUnits: buyingUnits,
        sellingUnits: sellingUnits,
        unitPrice: unitPrice);
  }

  late String _id;
  String get id => _id;

  late String _desc;
  String get desc => _desc;

  late List<Vendor>? _vendors;
  List<Vendor>? get vendors => _vendors;

  late String _orderStatus;
  String get orderStatus => _orderStatus;

  late Person? _lastUpdated;
  Person? get lastUpdated => _lastUpdated;

  late Units _buyingUnits;
  Units get buyingUnits => _buyingUnits;

  late Units _sellingUnits;
  Units get sellingUnits => _sellingUnits;

  late double? _unitPrice;
  double? get unitPrice => _unitPrice;

  late String _stockingUnit;
  String get stockingUnit => _stockingUnit;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'desc': _desc,
      'vendors': _vendors?.map((vendor) => vendor.toJson()).toList(),
      'orderStatus': _orderStatus,
      'lastUpdated': _lastUpdated?.toJson(),
      'buyingUnits': _buyingUnits.toJson(),
      'sellingUnits': _sellingUnits.toJson(),
    };
  }

  // fromJson factory constructor
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      desc: json['desc'] as String,
      vendors: (json['vendors'] as List<dynamic>?)
          ?.map((vendorJson) => Vendor.fromJson(vendorJson))
          .toList(),
      orderStatus: json['orderStatus'] as String,
      lastUpdated: json['lastUpdated'] != null
          ? Person.fromJson(json['lastUpdated'])
          : null,
      buyingUnits: Units.fromJson(json['buyingUnits']),
      sellingUnits: Units.fromJson(json['sellingUnits']),
      unitPrice: json['unitPrice'] as double?,
      stockingUnit: json['stockingUnit'] as String,
    );
  }

  // toJson method to serialize the Product object into a Map
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'desc': _desc,
      'vendors': _vendors?.map((vendor) => vendor.toJson()).toList(),
      'orderStatus': _orderStatus,
      'lastUpdated': _lastUpdated?.toJson(),
      'buyingUnits': _buyingUnits.toJson(),
      'sellingUnits': _sellingUnits.toJson(),
      'unitPrice': _unitPrice,
      'stockingUnit': _stockingUnit,
    };
  }
}
