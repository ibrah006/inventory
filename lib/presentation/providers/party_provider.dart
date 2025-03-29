import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/core/providers/invoice_provider.dart';
import 'package:inventory/data/models/party.dart';
import 'package:provider/provider.dart';

class PartyProvider extends ChangeNotifier {
  final List<Party> _parties = [];

  /// Getter method for [_parties]
  /// Pass in [context] to get vendors or customers depending on the type of Invoice screen (Purchase / Sales) user is in.
  List<Party> parties(BuildContext? context) {
    try {
      context!;
      final isPurchaseInvoice =
          context.read<InvoiceProvider>().invoiceType == InvoiceType.purchase;

      if (isPurchaseInvoice) {
        // return vendors
        return _parties
            .where((party) => party.type == PartyType.vendor)
            .toList();
      } else {
        // return customers
        return _parties
            .where((party) => party.type == PartyType.customer)
            .toList();
      }
    } catch (e) {
      return _parties;
    }
  }

  // List<Party> parties()=> _parties;

  void add(Party newParty) {
    try {
      _parties.firstWhere((party) => party.id == newParty.id);
    } on StateError {
      _parties.add(newParty);
      notifyListeners();
    }
  }

  bool partyExists({String? name, String? id}) {
    if (name == null && id == null) {
      throw "name and id inputs for the funciton partyExists(...) can't be null at the same time";
    }

    try {
      final party = parties(null).firstWhere((v) {
        if ((name != null && id != null)) {
          if (v.name == name && v.id == id) return true;
          // else case for the above if condition would mean that the party with the given id/name already corressponds to another party
        } else if (v.name == name || v.id == id) {
          return true;
        }
        return false;

        // return (v.name == name && id != null) || v.id == id;
      });

      print(
          "looking: name: ${name}, id: ${id} party found: ${party}, name: ${party.name}, id: ${party.id}");

      return true;
    } on StateError {
      return false;
    }
  }
}
