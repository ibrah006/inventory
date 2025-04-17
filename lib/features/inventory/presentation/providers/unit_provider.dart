import 'package:fluent_ui/fluent_ui.dart';

class UnitProvider<T> extends ChangeNotifier {
  // bool isBuyingUnits

  @deprecated
  bool _isSameAsStockingUnit = false;

  @deprecated
  bool get isSameAsStockingUnit => _isSameAsStockingUnit;

  @deprecated
  set isSameAsStockingUnit(bool value) {
    _isSameAsStockingUnit = value;
  }

  final TextEditingController unitController = TextEditingController(),
      relationshipController = TextEditingController();

  set relationship(double newRelation) =>
      relationshipController.text = newRelation.toString();

  double get relationship {
    try {
      return double.parse(relationshipController.text);
    } catch (e) {
      return 0;
    }
  }

  String? _relationshipBy;

  String? get relationshipBy => _relationshipBy;

  set relationshipBy(String? value) {
    _relationshipBy = value;
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
