import 'package:inventory/database/vendor.dart';
import 'package:inventory/database/person.dart';
import 'package:inventory/database/units.dart';

class Item {
  Item(
      {required String id,
      required String groupId,
      required String desc,
      required List<Vendor>? vendors,
      required int inOrder,
      required int stockQuantity,
      required DateTime? lastCheckDate,
      required double unitPrice,
      required double inventoryValue,
      required String orderStatus,
      required Person? lastUpdated,
      required Units buyingUnits,
      required Units sellingUnits}) {
    _id = id;
    _groupId = groupId;
    _desc = desc;
    _vendors = vendors;
    _inOrder = inOrder;
    _stockQuantity = stockQuantity;
    _lastCheckDate = lastCheckDate;
    _unitPrice = unitPrice;
    _inventoryValue = inventoryValue;
    _orderStatus = orderStatus;
    _lastUpdated = lastUpdated;
    _buyingUnits = buyingUnits;
    _sellingUnits = sellingUnits;
  }

  factory Item.create(
      {required String id,
      required String desc,
      required String groupId,
      required Units buyingUnits,
      required Units sellingUnits}) {
    return Item(
      id: id,
      groupId: groupId,
      desc: desc,
      vendors: null,
      inOrder: 0,
      stockQuantity: 0,
      lastCheckDate: null,
      unitPrice: 0,
      inventoryValue: 0,
      orderStatus: "",
      lastUpdated: null,
      buyingUnits: buyingUnits..isBuyingUnits = true,
      sellingUnits: sellingUnits,
    );
    // Item(;
    // id: Uuid().v1(),
    // groupId: groupId,
    // name: name,
    // vendors: null,
    // status: "",
    // dueDate: null,
    // stockQuantity: 0);
  }

  late Units _buyingUnits;

  Units get buyingUnits => _buyingUnits;

  set buyingUnits(Units value) {
    _buyingUnits = value;
  }

  late Units _sellingUnits;

  Units get sellingUnits => _sellingUnits;

  set sellingUnits(Units value) {
    _sellingUnits = value;
  }

  late String _id;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  // get the item's inventory value
  double getTotalValue() {
    return _stockQuantity * _unitPrice;
  }

  @deprecated
  late String _groupId;

  @deprecated
  String get groupId => _groupId;

  @deprecated
  set groupId(String value) {
    _groupId = value;
  }

  late String _desc;

  String get desc => _desc;

  set name(String value) {
    _desc = value;
  }

  late List<Vendor>? _vendors;

  List<Vendor>? get vendors => _vendors;

  set vendors(List<Vendor>? value) {
    vendors = value;
  }

  late int _inOrder;

  int get inOrder => _inOrder;

  set inOrder(int value) {
    _inOrder = value;
  }

  late int _stockQuantity;

  int get stockQuantity => _stockQuantity;

  set stockQuantity(int value) {
    _stockQuantity = value;
  }

  late DateTime? _lastCheckDate;

  DateTime? get lastCheckDate => _lastCheckDate;

  set lastCheckDate(DateTime? value) {
    _lastCheckDate = value;
  }

  late double _unitPrice;

  double get unitPrice => _unitPrice;

  set unitPrice(double value) {
    _unitPrice = value;
  }

  late double _inventoryValue;

  double get inventoryValue => _inventoryValue;

  set inventoryValue(double value) {
    _inventoryValue = value;
  }

  late String _orderStatus;

  String get orderStatus => _orderStatus;

  set orderStatus(String value) {
    _orderStatus = value;
  }

  late Person? _lastUpdated;

  Person? get lastUpdated => _lastUpdated;

  set lastUpdated(Person? value) {
    _lastUpdated = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'groupId': _groupId,
      'desc': _desc,
      'vendors': _vendors?.map((vendor) => vendor.toMap()).toList(),
      'inOrder': _inOrder,
      'stockQuantity': _stockQuantity,
      'lastCheckDate':
          _lastCheckDate?.toIso8601String(), // Convert DateTime to String
      'unitPrice': _unitPrice,
      'inventoryValue': _inventoryValue,
      'orderStatus': _orderStatus,
      'lastUpdated': _lastUpdated?.toMap(),
      'buyingUnits': _buyingUnits.toMap(),
      'sellingUnits': _sellingUnits.toMap(),
    };
  }
}
