import 'package:fluent_ui/fluent_ui.dart';

class UnitProvider<T> extends ChangeNotifier {
  // bool isBuyingUnits

  bool _isSameAsStockingUnit = false;

  bool get isSameAsStockingUnit => _isSameAsStockingUnit;

  set isSameAsStockingUnit(bool value) {
    _isSameAsStockingUnit = value;
  }

  final TextEditingController unitController = TextEditingController(),
      relationshipController = TextEditingController();

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
