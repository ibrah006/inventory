import 'package:inventory/features/inventory/presentation/providers/unit_provider.dart';

class Units<T> extends UnitProvider<T> {
  bool isBuyingUnits;

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
      ..isSameAsStockingUnit = json['isSameAsStockingUnit'] ?? false
      ..unitController.text = json['unit'] ?? ""
      ..relationshipController.text = json['relationship'] ?? ""
      ..relationshipBy = json['relationBy'];

    return units;
  }

  Map<String, dynamic> toJson() {
    return {
      "isBuyingUnits": isBuyingUnits,
      "isSameAsStockingUnit": isSameAsStockingUnit,
      "unit": unitController.text,
      "relationship": relationshipController.text,
      "relationBy": relationshipBy
    };
  }
}
