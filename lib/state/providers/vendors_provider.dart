import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/database/vendor.dart';

class VendorsProvider extends ChangeNotifier {
  List<Vendor> _vendors = [];

  List<Vendor> get vendors => _vendors;

  void add(String vendorName) {
    try {
      _vendors.firstWhere((vendor) => vendor.name == vendorName);
    } on StateError {
      _vendors.add(Vendor(name: vendorName));
      notifyListeners();
    }
  }

  bool vendorExists(String name) {
    try {
      vendors.firstWhere((v) => v.name == name);
      return true;
    } on StateError {
      return false;
    }
  }
}
