import 'package:inventory/database/invoice_item.dart';
import 'package:inventory/database/project.dart';
import 'package:inventory/database/vendor.dart';
import 'package:inventory/extensions.dart';

class Invoice {
  final String invoiceNumber;
  final Vendor vendor;

  bool isPurchaseInvoice;

  late final double price;
  final double taxAmount;

  /// P.O/S.O Number
  String? poSoNumber;

  Project? project;

  /// (Optinal) Notes or Terms
  String? notes;

  /// Optional payment mathod field
  String? paymentMethod;

  /// issue and due date fields
  String issueDue;

  /// [dueDate] will not take in empty string. If inputted with empty string it will set itself to null.
  String? dueDate;

  /// for now, this total is going to be excluding the tax
  double subTotal;

  ///
  Iterable<InvoiceItem> items;

  Invoice(
      {required this.invoiceNumber,
      required this.vendor,
      required this.isPurchaseInvoice,
      required this.taxAmount,
      // new
      required this.poSoNumber,
      required this.project,
      required this.notes,
      required this.paymentMethod,
      required this.issueDue,
      required this.dueDate,
      required this.subTotal,
      // follpwing won't be part of the  database (ofc its a list)
      required this.items
      // required this.unit,
      // required this.price,
      // required this.taxAmount,
      }) {
    // final units = isPurchaseInvoice ? item.buyingUnits : item.sellingUnits;

    // price = units.price

    dueDate = dueDate != null && dueDate!.trim().isEmpty ? null : dueDate;
  }

  // Method to calculate the total cost including tax
  double get totalCost => subTotal + taxAmount;

  // Method to represent the object as a string for easier debugging/logging
  @Deprecated("This method is outdated")
  @override
  String toString() {
    return 'Invoice(vendor: $vendor, invoiceId: $invoiceNumber, date: $issueDue, '
        'price: $price, taxAmount: $taxAmount)';
  }

  // Method to convert the object to a JSON format (for API communication or persistence)
  Map<String, dynamic> toJson() {
    return {
      'vendor': vendor,
      'invoiceNumber': invoiceNumber,
      'issueDate': issueDue,
      'dueDate': dueDate,
      'price': price,
      'taxAmount': taxAmount,
      "isPurchaseInvoice": isPurchaseInvoice,
      // new
      "poSoNumber": poSoNumber,
      "project": project?.toMap(),
      "notes": notes,
      "paymentMethod": paymentMethod,
      "subTotal": subTotal,
    };
  }

  // Method to create an Invoice from JSON (used for deserialization)
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        vendor: json['vendor'],
        invoiceNumber: json['invoiceNumber'],
        isPurchaseInvoice: json["isPurchaseInvoice"],
        issueDue: json['date'],
        dueDate: json["dueDate"],
        taxAmount: json["taxAmount"],
        // new
        poSoNumber: json['poSoNumber'],
        project:
            json["project"] != null ? Project.fromJson(json["project"]) : null,
        notes: json['notes'],
        paymentMethod: json["paymentMethod"],
        subTotal: double.parse(json["subTotal"]),
        // TODO: change this from just passing int empty list to getting the items fo this invoice from database
        items: []
        // quantity: json['quantity'],
        // unit: json['unit'],
        // price: json['price'],
        // taxAmount: json['taxAmount'],
        );
  }

  Iterable<InvoiceValidationFeedback> validateFields() {
    final List<InvoiceValidationFeedback> validations = [];

    // Helper function to validate non-empty and trimmed strings
    bool isValidString(String value) {
      return value.trim().isNotEmpty;
    }

    // Validate invoiceNumber (non-optional)
    if (!isValidString(invoiceNumber)) {
      validations.add(InvoiceValidationFeedback.invalidInvoiceNumber);
    }

    // Validate vendor. Do not need to check if the vendor actually exists becuase the vendor field will not take in a vendor that doesn't exist
    if (vendor.name.trim().isEmpty) {
      validations.add(InvoiceValidationFeedback.invalidVendor);
    }

    // Validate issueDue (non-optional) - date format validation
    if (!issueDue.isValidDate()) {
      validations.add(InvoiceValidationFeedback.invalidIssueDate);
    }

    // Validate dueDate (optional but if provided, must be in date format)
    if (dueDate != null && !dueDate!.isValidDate()) {
      validations.add(InvoiceValidationFeedback.invalidDueDate);
    }

    // Validate subTotal (non-optional) - must be greater than 0
    if (subTotal == 0) {
      validations.add(InvoiceValidationFeedback.zeroTotalWarning);
    }

    // If all validations pass
    if (validations.isEmpty) validations.add(InvoiceValidationFeedback.valid);

    return validations;
  }
}

enum InvoiceValidationFeedback {
  invalidInvoiceNumber,
  invalidVendor,
  invalidIssueDate,
  invalidDueDate,
  zeroTotalWarning,
  valid,
}
