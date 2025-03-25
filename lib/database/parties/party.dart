import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/database/parties/vendor.dart';
import 'package:inventory/state/providers/parties/customer_provider.dart';
import 'package:inventory/state/providers/parties/party_provider.dart';
import 'package:inventory/state/providers/parties/vendors_provider.dart';
import 'package:provider/provider.dart';

// party is either vendor or customer

enum PartyValidationFeedback {
  /// Error indicating that the user tried to create a party but the inputted id/name already corresponds to another party
  vendorExistsError,
  emptyInputError,
  valid,
}

final Map<PartyValidationFeedback, String> _errorMessages = {
  PartyValidationFeedback.emptyInputError: "Cannot leave this field empty",
  PartyValidationFeedback.vendorExistsError:
      "Please enter a different ID/Name. Inputted ID/Name already corresponds to a different Vendor."
};

abstract class Party {
  Party(BuildContext context, {required this.id}) {
    name = context
        .read<VendorsProvider>()
        .parties
        .firstWhere((party) => party.id == id)
        .name;
  }

  bool get _isVendor {
    return this.runtimeType.toString() == "Vendor" ||
        this.runtimeType.toString() == "FutureVendor";
  }

  PartyProvider _getPartyProvider(BuildContext context) {
    return _isVendor
        ? context.read<VendorsProvider>()
        : context.read<CustomerProvider>();
  }

  Party.copy(Party other) {
    // Vendor(context, id: id);
    name = other.name;
    id = other.id;
  }

  // Party.fromJson(Map json) {
  //   // return Vendor(context, id: id);
  // }

  Party._future() {
    name = "";
    id = "";
  }

  Party.create({required this.id, required this.name});

  late String id;
  late String name;

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }
}

abstract class FutureParty extends Party {
  FutureParty({this.showIdTextBox = false}) : super._future();

  // factory FutureParty.fromParty(Vendor party) {
  //   id = party.id;
  //   name = party.name;
  // }

  @override
  set id(String newValue) => idController.text = newValue;
  @override
  String get id => idController.text.trim();

  @override
  set name(String newValue) => nameController.text = newValue;
  @override
  String get name => nameController.text.trim();

  final TextEditingController nameController = TextEditingController(),
      idController = TextEditingController();

  /// This function just gets the fields ready for user to input party id before confirm adding the new party.
  /// This will not reset the party name text field.
  void resetFieldsNewVendor() {
    showIdTextBox = true;
    idController.clear();
    showSuccessfullyAdded = false;
    errorMessage = null;
  }

  /// Sets to an error message (to variable [errorMessage]) if validationFeedback != (valid || null). Otherwise returns null indicating there are no errors to display.
  void _setErrorMessage(PartyValidationFeedback? validationFeedback) {
    try {
      errorMessage = _errorMessages[validationFeedback]!;
    } on TypeError {
      if (validationFeedback == null) {
        // TODO: do the below validation check by calling the funciton _validateIdTextField when it no longer will take in the input 'context' which should be removed once databases are implmented
        // if (validateIdTextField(context))
        // we could still use provider and get the job done temporarily but i'm gonna implement this after databases are setup
        throw UnimplementedError(
            "not implemented yet. this part of function yet to be implmented");
      }
      // no error to display
      errorMessage = null;
    }
  }

  _updatePartyProvider(BuildContext context) {
    _getPartyProvider(context)
        .add(_isVendor ? Vendor.copy(this) : Vendor.copy(this));
  }

  /// Be sure to set State after the calling of this function
  /// Sets the variable [errorMessage] to something if there's an error in validating the ID textfield. othereise it will remain null
  /// remove the context inoput input after implementing database. so instead of checking the vendors from providers, chek from database tables directly
  void validateIdTextField(BuildContext context, {bool isNewVendor = true}) {
    print("validateIdTextField function called");

    id = id.trim();

    late final PartyValidationFeedback feedback;

    if (id.isEmpty) {
      feedback = PartyValidationFeedback.emptyInputError;
    } else if (isNewVendor) {
      bool isVendorExists = _getPartyProvider(context).partyExists(id: id);

      if (isVendorExists) {
        feedback = PartyValidationFeedback.vendorExistsError;
        idController.text = "";
      } else {
        feedback = PartyValidationFeedback.valid;

        // update and notify party provider about the added party
        _updatePartyProvider(context);
        // TODO: update the database table party

        // Set showIdTextBox = false to because the entered input by user is valid
        showIdTextBox = false;
        // Set error message back to null
        errorMessage = null;
      }
    } else {
      // isNewVendor = false case

      throw UnimplementedError("isNewVendor = false is not implmented yet.");
    }

    showSuccessfullyAdded = feedback == PartyValidationFeedback.valid;

    _setErrorMessage(feedback);
  }

  /// turning this to [false] won't (automatically) hide the text box that is associated with the text controller [idController]
  bool showIdTextBox;

  FocusNode idFocusNode = FocusNode();

  String? errorMessage;

  bool showSuccessfullyAdded = false;
}
