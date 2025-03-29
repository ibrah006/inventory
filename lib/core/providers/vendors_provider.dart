// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:inventory/database/parties/vendor.dart';

import 'package:inventory/presentation/providers/party_provider.dart';

class VendorsProvider extends PartyProvider {}

// class VendorsProvider extends ChangeNotifier {
//   List<Vendor> _vendors = [];

//   List<Vendor> get vendors => _vendors;

//   void add(Vendor newVendor) {
//     try {
//       _vendors.firstWhere((vendor) => vendor.id == newVendor.id);
//     } on StateError {
//       _vendors.add(newVendor);
//       notifyListeners();
//     }
//   }

//   bool vendorExists({String? name, String? id}) {
//     if (name == null && id == null) {
//       throw "name and id inputs for the funciton vendorExists(...) can't be null at the same time";
//     }

//     try {
//       final vendor = vendors.firstWhere((v) {
//         if ((name != null && id != null)) {
//           if (v.name == name && v.id == id) return true;
//           // else case for the above if condition would mean that the vendor with the given id/name already corressponds to another vendor
//         } else if (v.name == name || v.id == id) {
//           return true;
//         }
//         return false;

//         // return (v.name == name && id != null) || v.id == id;
//       });

//       print(
//           "looking: name: ${name}, id: ${id} vendor found: ${vendor}, name: ${vendor.name}, id: ${vendor.id}");

//       return true;
//     } on StateError {
//       return false;
//     }
//   }
// }
