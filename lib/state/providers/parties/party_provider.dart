import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/database/parties/party.dart';

abstract class PartyProvider extends ChangeNotifier {
  final List<Party> _parties = [];

  List<Party> get parties => _parties;

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
      final party = parties.firstWhere((v) {
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
