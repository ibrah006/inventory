import 'package:inventory/data/models/party.dart';

class Vendor extends Party {
  Vendor.fromId({
    required super.id,
  }) : super.fromId(Vendor);

  Vendor.create({required super.id, required super.name});
  // Vendor(super.context, {required super.id});

//   Vendor(BuildContext context, {required this.id}) {
//     name = context
//         .read<VendorsProvider>()
//         .vendors
//         .firstWhere((vendor) => vendor.id == id)
//         .name;
//   }

  Vendor.copy(Party other) : super.copy(other);

  // Vendor fromJson (takes a Map and Context for provider)
  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor.fromId(id: json['id']);
  }

  @override
  Map<String, dynamic> toJson() {
    final vendorMap = super.toJson();
    vendorMap['type'] = 'vendor'; // Adding type for identifying Vendor
    return vendorMap;
  }

//   // Vendor.fromJson(Map json) {
//   //   // return Vendor(context, id: id);
//   // }

//   Vendor._future() {
//     name = "";
//     id = "";
//   }

//   Vendor.create({required this.id, required this.name});

//   late String id;
//   late String name;

//   Map<String, dynamic> toMap() {
//     return {"id": id, "name": name};
//   }
// }

// final Map<VendorValidationFeedback, String> _errorMessages = {
//   VendorValidationFeedback.emptyInputError: "Cannot leave this field empty",
//   VendorValidationFeedback.vendorExistsError:
//       "Please enter a different ID/Name. Inputted ID/Name already corresponds to a different Vendor."
// };
}

class FutureVendor extends FutureParty implements Vendor {
  FutureVendor({required String id, required String name}) {
    super.id = id;
    super.name = name;
  }

  factory FutureVendor.fromVendor(Vendor vendor) {
    return FutureVendor(id: vendor.id, name: vendor.name);
  }

  factory FutureVendor.empty() {
    return FutureVendor(id: "", name: "");
  }
}

// class FutureVendor extends Vendor {
//   FutureVendor({this.showIdTextBox = false}) : super._future();

//   factory FutureVendor.fromVendor(Vendor vendor) {
//     return FutureVendor()
//       ..id = vendor.id
//       ..name = vendor.name;
//   }

//   @override
//   set id(String newValue) => idController.text = newValue;
//   @override
//   String get id => idController.text.trim();

//   @override
//   set name(String newValue) => nameController.text = newValue;
//   @override
//   String get name => nameController.text.trim();

//   final TextEditingController nameController = TextEditingController(),
//       idController = TextEditingController();

//   /// This function just gets the fields ready for user to input vendor id before confirm adding the new vendor.
//   /// This will not reset the vendor name text field.
//   void resetFieldsNewVendor() {
//     showIdTextBox = true;
//     idController.clear();
//     showSuccessfullyAdded = false;
//     errorMessage = null;
//   }

//   /// Sets to an error message (to variable [errorMessage]) if validationFeedback != (valid || null). Otherwise returns null indicating there are no errors to display.
//   void _setErrorMessage(VendorValidationFeedback? validationFeedback) {
//     try {
//       errorMessage = _errorMessages[validationFeedback]!;
//     } on TypeError {
//       if (validationFeedback == null) {
//         // TODO: do the below validation check by calling the funciton _validateIdTextField when it no longer will take in the input 'context' which should be removed once databases are implmented
//         // if (validateIdTextField(context))
//         // we could still use provider and get the job done temporarily but i'm gonna implement this after databases are setup
//         throw UnimplementedError(
//             "not implemented yet. this part of function yet to be implmented");
//       }
//       // no error to display
//       errorMessage = null;
//     }
//   }

//   /// Be sure to set State after the calling of this function
//   /// Sets the variable [errorMessage] to something if there's an error in validating the ID textfield. othereise it will remain null
//   /// remove the context inoput input after implementing database. so instead of checking the vendors from providers, chek from database tables directly
//   void validateIdTextField(BuildContext context, {bool isNewVendor = true}) {
//     print("validateIdTextField function called");

//     id = id.trim();

//     late final VendorValidationFeedback feedback;

//     if (id.isEmpty) {
//       feedback = VendorValidationFeedback.emptyInputError;
//     } else if (isNewVendor) {
//       bool isVendorExists =
//           context.read<VendorsProvider>().vendorExists(id: id);

//       if (isVendorExists) {
//         feedback = VendorValidationFeedback.vendorExistsError;
//         idController.text = "";
//       } else {
//         feedback = VendorValidationFeedback.valid;

//         // update and notify vendor provider about the added vendor
//         context.read<VendorsProvider>().add(Vendor.copy(this));
//         // TODO: update the database table vendor

//         // Set showIdTextBox = false to because the entered input by user is valid
//         showIdTextBox = false;
//         // Set error message back to null
//         errorMessage = null;
//       }
//     } else {
//       // isNewVendor = false case

//       throw UnimplementedError("isNewVendor = false is not implmented yet.");
//     }

//     showSuccessfullyAdded = feedback == VendorValidationFeedback.valid;

//     _setErrorMessage(feedback);
// }

/// turning this to [false] won't (automatically) hide the text box that is associated with the text controller [idController]
// bool showIdTextBox;

// FocusNode idFocusNode = FocusNode();

// String? errorMessage;

// bool showSuccessfullyAdded = false;
// }

enum VendorValidationFeedback {
  /// Error indicating that the user tried to create a vendor but the inputted id/name already corresponds to another vendor
  vendorExistsError,
  emptyInputError,
  valid,
}
