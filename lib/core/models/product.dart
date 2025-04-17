import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/core/models/party.dart';
import 'package:inventory/core/models/pricing_list.dart';
import 'package:inventory/core/providers/product_provider.dart';
import 'package:inventory/data/models/person.dart';
import 'package:inventory/features/inventory/data/units.dart';
import 'package:inventory/features/inventory/presentation/providers/helper/buying_units.dart';
import 'package:inventory/features/inventory/presentation/providers/helper/selling_units.dart';
import 'package:inventory/services/product_service.dart';
import 'package:provider/provider.dart';

class Product {
  Product(
      {required String id,
      required String name,
      required int barcode,
      required String? category,
      required List<Party>? vendors,
      // required String orderStatus,
      required Units<BuyingUnits> buyingUnits,
      required Units<SellingUnits> sellingUnits,
      required double? unitPrice,
      required String stockingUnit,
      required PricingList? pricingList}) {
    _id = id;
    _name = name;
    _barcode = barcode;
    _category = category;
    _vendors = vendors;
    _buyingUnits = buyingUnits;
    _sellingUnits = sellingUnits;
    _unitPrice = unitPrice;
    _stockingUnit = stockingUnit;
    if (pricingList != null) this.pricingList = pricingList;
  }

  Product.empty();

  Product.preview(Map previewJson) {
    _id = previewJson["id"];
    _name = previewJson["name"];
    _barcode = previewJson["barcode"];
    _category = previewJson["category"];
    _unitPrice = previewJson["unitPrice"].toDouble();
    _stockingUnit = previewJson["stockingUnit"];
  }

  Product.create(
      {required String id,
      required String desc,
      required String? category,
      required double? unitPrice,
      required Units<BuyingUnits> buyingUnits,
      required Units<SellingUnits> sellingUnits,
      required String stockingUnit,
      required PricingList? pricingList}) {
    _id = id;
    _name = desc;
    _category = category;
    _unitPrice = unitPrice;
    _buyingUnits = buyingUnits;
    _sellingUnits = sellingUnits;
    _stockingUnit = stockingUnit;
    this.pricingList = pricingList ?? PricingList();
  }

  // fromJson factory constructor
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] as String,
        name: json['name'] as String,
        barcode: json["barcode"],
        category: json["category"],
        vendors: null,
        // vendors: (json['vendors'] as List<dynamic>?)
        //     ?.map((vendorJson) => Party.fromJson(vendorJson))
        //     .toList(),
        buyingUnits: Units.fromJson(json['buyingUnits']),
        sellingUnits: Units.fromJson(json['sellingUnits']),
        // TODO : remove once the server handles this work
        unitPrice: json['unitPrice'],
        stockingUnit: json['stockingUnit'] as String,
        pricingList: PricingList.fromJson(json['pricingList']));
  }

  /// 1. Pass in [context] and [id to get the product from ProductProvider
  /// 2. Pass in only [id] to get the product from database
  /// if any of the conditions (1) or (2) fail, the function will throw an error
  static Future<Product> fromId(
      {required BuildContext? context, required String id}) async {
    // if (context == null ) {
    //   throw "The parameters context and id cannot be null at the same time. At least one of the parameters must be non-null.";
    // }

    if (context != null) {
      // Get the product from the provider

      final Product? product =
          context.read<ProductProvider>().getProductById(id);
      if (product != null) return product;

      // if product equals null, we will continue with the function to check if the product can be found in the database
    }

    // Get product from database
    return await ProductService.fetchById(id);
  }

  late String _id;
  String get id => _id;

  late String _name;
  String get name => _name;

  // Get item description
  String get itemDesc => "$id $name";

  // Barcode
  late int _barcode;
  int get barcode => _barcode;
  set barcode(int newValue) => _barcode = newValue;

  String barcodeDisplay() {
    final barcodeStr = barcode.toString();

    if (barcodeStr.length > 11) {
      throw ArgumentError('Barcode length exceeds 11 digits.');
    }

    return barcodeStr.padLeft(11, '0');
  }

  List<Party>? _vendors = [];
  List<Party>? get vendors => _vendors;

  @deprecated
  late String _orderStatus;
  @deprecated
  String get orderStatus => _orderStatus;

  @deprecated
  late Person? _lastUpdated;
  @deprecated
  Person? get lastUpdated => _lastUpdated;

  late Units<BuyingUnits> _buyingUnits;
  Units<BuyingUnits> get buyingUnits => _buyingUnits;

  late Units<SellingUnits> _sellingUnits;
  Units<SellingUnits> get sellingUnits => _sellingUnits;

  @deprecated
  late double? _unitPrice;
  @deprecated
  double? get unitPrice => _unitPrice;

  late PricingList pricingList = PricingList();

  late String _stockingUnit;
  String get stockingUnit => _stockingUnit;

  late String? __category;
  set _category(String? newCategory) {
    __category = (newCategory?.isNotEmpty ?? false) ? newCategory : null;
  }

  String? get category => __category;

  // toJson method to serialize the Product object into a Map
  Map<String, dynamic> toJson() {
    late final bool hasBarcode;
    try {
      barcode;
      hasBarcode = true;
    } catch (e) {
      hasBarcode = false;
    }
    return {
      'id': _id,
      'name': _name,
      ...hasBarcode ? {'barcode': barcode} : {},
      'category': category,
      // Temporary
      // 'vendors': _vendors?.map((vendor) => vendor.toJson()).toList(),
      // Deprecated
      // 'orderStatus': _orderStatus,
      // 'lastUpdated': _lastUpdated?.toJson(),
      'buyingUnits': _buyingUnits.toJson(),
      'sellingUnits': _sellingUnits.toJson(),
      'pricingList': pricingList.toJson(),
      'unitPrice': _unitPrice,
      'stockingUnit': _stockingUnit,
    };
  }

  // Method to set the values for each attribute in Product
  void setSelf(Product product) {
    _id = product.id;
    _name = product.name;
    _barcode = product.barcode;
    _category = product.category;
    _vendors = product.vendors;
    // _orderStatus = product.orderStatus;
    // _lastUpdated = product.lastUpdated;
    _stockingUnit = product.stockingUnit;
    _unitPrice = product.unitPrice;
    try {
      pricingList = product.pricingList;
      _buyingUnits = product.buyingUnits;
      _sellingUnits = product.sellingUnits;
    } catch (e) {
      // this try-catch has been established for allowing the setSelf (current) function to be used even in preview mode (Product.preview constructor)
    }
  }
}
