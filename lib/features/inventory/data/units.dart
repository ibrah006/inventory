import 'dart:ffi';

import 'package:inventory/features/inventory/presentation/providers/unit_provider.dart';

class Units<T> extends UnitProvider<T> {
  bool isBuyingUnits;

  int? id;

  factory Units.fromUnitsProvider(UnitProvider unitProvider,
      {required bool isBuyingUnits, String unit = ""}) {
    return Units(isBuyingUnits: isBuyingUnits)
      ..unit = unit
      ..isSameAsStockingUnit = unitProvider.isSameAsStockingUnit
      ..unitController.text = unitProvider.unitController.text
      ..relationshipBy = unitProvider.relationshipBy;
  }

  String get unit => unitController.text.trim();
  set unit(String newValue) => unitController.text = newValue;

  Units({required this.isBuyingUnits});

  // Factory constructor to create a Units object from a JSON map
  factory Units.fromJson(Map<String, dynamic> json) {
    final units = Units<T>(isBuyingUnits: json['isBuyingUnits'] ?? false)
      ..unit = json['unit']
      // TODO : remove once the server handles this work
      ..relationship = (json["relationship"] as int).toDouble()
      ..relationshipBy = json['relationBy']
      ..id = json['id'] as int;

    return units;
  }

  Map<String, dynamic> toJson() {
    return {
      "isBuyingUnits": isBuyingUnits,
      // "isSameAsStockingUnit": isSameAsStockingUnit,
      "unit": unit,
      "relationship": relationship,
      "relationBy": relationshipBy
    };
  }
}
