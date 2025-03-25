import 'package:fluent_ui/fluent_ui.dart';

class UnitMeasureProvider extends ChangeNotifier {
  String stockingUnit = "";

  void notifyAboutStockingUnitChanges() {
    notifyListeners();
  }

  bool validateStockingUnitTextBox = false;

  void validateStockingUnit() {
    validateStockingUnitTextBox = stockingUnit.trim().isEmpty;
    notifyListeners();
  }
}
