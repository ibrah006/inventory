import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/presentation/providers/party_provider.dart';
import 'package:inventory/services/party_service.dart';
import 'package:provider/provider.dart';

// party is either vendor or customer

enum PartyValidationFeedback {
  /// Error indicating that the user tried to create a party but the inputted id/name already corresponds to another party
  vendorExistsError,
  emptyInputError,
  valid,
}

enum PartyType { vendor, customer }

final Map<PartyValidationFeedback, String> _errorMessages = {
  PartyValidationFeedback.emptyInputError: "Cannot leave this field empty",
  PartyValidationFeedback.vendorExistsError:
      "Please enter a different ID/Name. Inputted ID/Name already corresponds to a different Vendor."
};

class Party {
  // Constructors

  Party(
      {required this.name,
      required this.id,
      required this.type,
      this.location});

  Party.fromId({required this.id, required this.type}) {
    // TODO: Get name from database. Either from Vendor table or Customer table depending on th runtimeType
  }

  Party.vendor(
      {required String? name, required this.id, required this.location})
      : type = PartyType.vendor,
        name = name ?? getPartyName(id);

  Party.customer(
      {required String? name, required this.id, required this.location})
      : type = PartyType.customer,
        name = name ?? getPartyName(id);

  Party.copy(Party other) {
    // Vendor(context, id: id);
    name = other.name;
    id = other.id;
    type = other.type;
  }

  // Factory constructor from JSON
  factory Party.fromJson(Map<String, dynamic> json) {
    // Parse the 'type' field and map it to the correct PartyType enum
    final partyType =
        PartyType.values.firstWhere((e) => e.name == json['type']);

    return Party(
      name: json['name'] as String,
      id: json['id'] as String,
      type: partyType,
      location: json['location'],
    );
  }

  // Attributes

  late String id;

  late String name;

  late PartyType type;

  String? location;

  // Methods

  bool get _isVendor => type == PartyType.vendor;

  PartyProvider _getPartyProvider(BuildContext context) =>
      context.read<PartyProvider>();

  // Party.fromJson(Map json) {
  //   // return Vendor(context, id: id);
  // }

  Party._future({required this.type}) {
    name = "";
    id = "";
  }

  // Convert the Party instance to JSON format
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "type": type.name, "location": location};
  }

  // Static Methods

  static String getPartyName(String id) {
    // TODO: get party name from database
    throw UnimplementedError();
  }

  // DATABASE INTEGRATION

  Future<void> insert() async {
    try {
      await PartyService.createVendor(toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class FutureParty extends Party {
  // FutureParty.empty({this.showIdTextBox = false}) : super._future();

  FutureParty.vendor({this.showIdTextBox = false})
      : super._future(type: PartyType.vendor);

  FutureParty.customer({this.showIdTextBox = false, party})
      : super._future(type: PartyType.customer);

  FutureParty.fromParty(Party party, {this.showIdTextBox = false})
      : super.copy(party);

  factory FutureParty.fromJson(Map<String, dynamic> json) {
    return FutureParty.fromParty(Party.fromJson(json),
        showIdTextBox: json["showIdTextBox"] ?? false);
  }

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
        .add(_isVendor ? Party.copy(this) : Party.copy(this));
  }

  /// Be sure to set State after the calling of this function
  /// Sets the variable [errorMessage] to something if there's an error in validating the ID textfield. othereise it will remain null
  /// remove the context inoput input after implementing database. so instead of checking the vendors from providers, chek from database tables directly
  Future<void> validateIdTextField(BuildContext context,
      {bool isNewVendor = true}) async {
    print("validateIdTextField function called: $id, $name");

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

        // Update the database table party
        await super.insert();

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
