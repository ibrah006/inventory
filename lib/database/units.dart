import 'package:inventory/state/providers/add_inventory/unit_provider.dart';

class Units<T> extends UnitProvider<T> {
  bool isBuyingUnits;

  factory Units.fromUnitsProvider(UnitProvider unitProvider,
      {required bool isBuyingUnits}) {
    return Units(isBuyingUnits: isBuyingUnits)
      ..isSameAsStockingUnit = unitProvider.isSameAsStockingUnit
      ..unitController.text = unitProvider.unitController.text
      ..relationshipBy = unitProvider.relationshipBy;
  }

  String get unit => unitController.text.trim();
  set unit(String newValue) => unitController.text = newValue;

  Units({required this.isBuyingUnits});

  Map<String, dynamic> toMap() {
    return {
      "isBuyingUnits": isBuyingUnits,
      "isSameAsStockingUnit": isSameAsStockingUnit,
      "unit": unitController.text,
      "relationship": relationshipController.text,
      "relationBy": relationshipBy
    };
  }
}
