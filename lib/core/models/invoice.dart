import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/core/extensions/date_format_check.dart';
import 'package:inventory/data/models/party.dart';
import 'package:inventory/core/models/invoice_delivery.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';
import 'package:inventory/core/models/project.dart';

enum InvoiceType { purchase, sales }

class Invoice {
  String? initialItemDesc;

  String get invoiceNumber => invoiceNumberController.text.trim();
  set invoiceNumber(String newInvoiceNumber) =>
      invoiceNumberController.text = newInvoiceNumber;

  late FutureParty party;

  late InvoiceType type;

  // late final double price;
  double get taxAmount {
    try {
      return double.parse(taxController.text.trim());
    } on FormatException {
      return 0;
    }
  }

  set taxAmount(double newTaxAmount) =>
      taxController.text = newTaxAmount.toString();

  /// P.O/S.O Number
  String get poSoNumber => poSoNumberController.text.trim();
  set poSoNumber(String newPoSoNumber) =>
      poSoNumberController.text = newPoSoNumber;

  Project? project;

  /// (Optional) Notes or Terms
  String get notes => notesController.text.trim();
  set notes(String newNote) => notesController.text = newNote;

  /// Optional payment method field
  String? paymentMethod;

  /// issue and due date fields
  String get issueDate => issueDateController.text.trim();
  set issueDate(String newValue) => issueDateController.text = newValue;

  /// [dueDate] will not take in empty string. If inputted with empty string it will set itself to null.
  String? dueDate;

  /// (excluding tax)
  double subTotal;

  late InvoiceDelivery delivery;

  ///
  List<InvoiceItem> items = [];

  factory Invoice.purchase() {
    return Invoice(type: InvoiceType.purchase);
  }

  factory Invoice.sales() {
    return Invoice(type: InvoiceType.sales);
  }

  Invoice(
      {String? invoiceNumber,
      Party? party,
      double? taxAmount,
      // new
      String? poSoNumber,
      this.project,
      String? notes,
      this.paymentMethod,
      String? issueDate,
      this.dueDate,
      this.subTotal = 0.0,
      InvoiceDelivery? delivery,
      required this.type

      // follpwing won't be part of the  database (ofc its a list)
      // Iterable<InvoiceItem>? items
      // String? unit,
      // String? price,
      // String? taxAmount,
      }) {
    if (invoiceNumber != null &&
        taxAmount != null &&
        poSoNumber != null &&
        notes != null &&
        issueDate != null &&
        party != null) {
      this.invoiceNumber = invoiceNumber;
      this.taxAmount = taxAmount;
      this.poSoNumber = poSoNumber;
      this.notes = notes;
      this.issueDate = issueDate;
    }

    this.delivery = delivery ?? InvoiceDelivery.empty();

    this.party = party != null
        ? FutureParty.fromParty(party)
        : (isPurchaseInvoice ? FutureParty.vendor() : FutureParty.customer());

    // this.items = ;

    // final units = isPurchaseInvoice ? item.buyingUnits : item.sellingUnits;

    // price = units.price

    dueDate = dueDate != null && dueDate!.trim().isEmpty ? null : dueDate;
  }

  // Factory constructor to create an Invoice from JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    // Parsing the invoice type
    final typeString = json['type'] as String;
    final type = InvoiceType.values.firstWhere(
      (e) => e.toString().split('.').last == typeString,
      orElse: () => InvoiceType.sales, // Default to sales if not found
    );

    // Parse nested fields
    return Invoice(
      invoiceNumber: json['invoiceNumber'] as String?,
      party: json['party'] != null ? FutureParty.fromJson(json['party']) : null,
      taxAmount: json['taxAmount'] != null
          ? double.tryParse(json['taxAmount'].toString()) ?? 0.0
          : 0.0,
      poSoNumber: json['poSoNumber'] as String?,
      project:
          json['project'] != null ? Project.fromJson(json['project']) : null,
      notes: json['notes'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      issueDate: json['issueDate'] as String?,
      dueDate: json['dueDate'] as String?,
      subTotal: json['subTotal'] != null
          ? double.tryParse(json['subTotal'].toString()) ?? 0.0
          : 0.0,
      delivery: json['delivery'] != null
          ? InvoiceDelivery.fromJson(json['delivery'])
          : InvoiceDelivery.empty(),
      type: type,
    );
  }

  bool get isPurchaseInvoice => type == InvoiceType.purchase;

  // Method to calculate the total cost including tax
  double get totalAmount => subTotal + taxAmount;

  // Method to represent the object as a string for easier debugging/logging
  @Deprecated("This method is outdated")
  @override
  String toString() {
    return 'Invoice(party: $party, invoiceId: $invoiceNumber, date: $issueDate, '
        'taxAmount: $taxAmount)';
  }

  // Method to convert the object to a JSON format (for API communication or persistence)
  Map<String, dynamic> toJson() {
    return {
      'party': party.toJson(),
      'invoiceNumber': invoiceNumber,
      'issueDate': issueDate,
      'dueDate': dueDate,
      'taxAmount': taxAmount,
      "poSoNumber": poSoNumber,
      "project": project?.toMap(),
      "notes": notes,
      "paymentMethod": paymentMethod,
      "subTotal": subTotal,
    };
  }

  // Method to create an Invoice from JSON (used for deserialization)
  // factory Invoice.fromJson(Map<String, dynamic> json) {
  //   return Invoice(
  //     vendor: json["vendor"],
  //     invoiceNumber: json['invoiceNumber'],
  //     issueDate: json['date'],
  //     dueDate: json["dueDate"],
  //     taxAmount: json["taxAmount"],
  //     // new
  //     poSoNumber: json['poSoNumber'],
  //     project:
  //         json["project"] != null ? Project.fromJson(json["project"]) : null,
  //     notes: json['notes'],
  //     paymentMethod: json["paymentMethod"],
  //     subTotal: double.parse(json["subTotal"]),
  //     // TODO: change this from just passing int empty list to getting the items fo this invoice from database
  //     // items: []
  //     // quantity: json['quantity'],
  //     // unit: json['unit'],
  //     // price: json['price'],
  //     // taxAmount: json['taxAmount'],
  //   );
  // }

  void add(InvoiceItem invoiceItem) {
    items.add(invoiceItem);

    subTotal += invoiceItem.amount;
  }

  // TODO: create this mody funciton to modify already-added invoiceItem in items
  // void modify()

  // List<InvoiceValidationFeedback>
  dynamic validateFields({required bool isPurchaseInvoice}) {
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
    if (party.name.trim().isEmpty || party.id.trim().isEmpty) {
      validations.add(InvoiceValidationFeedback.invalidVendor);
    }

    // Validate issueDate (non-optional) - date format validation
    if (!issueDate.isValidDate()) {
      validations.add(InvoiceValidationFeedback.invalidIssueDate);
    }

    // Validate dueDate (optional but if provided, must be in date format)
    if (dueDate != null && !dueDate!.isValidDate()) {
      validations.add(InvoiceValidationFeedback.invalidDueDate);
    }

    if (!isPurchaseInvoice &&
        !delivery.dueDate.isValidDate(showDebugPrint: true)) {
      validations.add(InvoiceValidationFeedback.invalidDeliveryDueDate);
    }

    if (delivery.status.trim().isEmpty) {
      validations.add(InvoiceValidationFeedback.invalidDeliveryStatus);
    }

    // Validate subTotal (non-optional) - must be greater than 0
    if (subTotal == 0) {
      validations.add(InvoiceValidationFeedback.zeroTotalWarning);
    }

    // If all validations pass
    if (validations.isEmpty) validations.add(InvoiceValidationFeedback.valid);

    return validations;
  }

  // INPUT FIELDS //

  final TextEditingController itemNameController = TextEditingController();

  final TextEditingController invoiceNumberController = TextEditingController(),
      poSoNumberController = TextEditingController(),
      notesController = TextEditingController(),
      issueDateController = TextEditingController(),
      dueDateController = TextEditingController(),
      taxController = TextEditingController();
}

enum InvoiceValidationFeedback {
  invalidInvoiceNumber,
  invalidVendor,
  invalidIssueDate,
  invalidDueDate,
  // invalid delivery fields feedbacks
  invalidDeliveryDueDate,
  invalidDeliveryStatus,
  //
  zeroTotalWarning,
  valid,
}
