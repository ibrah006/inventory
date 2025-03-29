import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/core/models/invoice.dart';

class Dialogs {
  static final Map<InvoiceValidationFeedback, String>
      _invoicevalidationErrorMessages = {
    InvoiceValidationFeedback.invalidInvoiceNumber:
        "Invalid Invoice Number: Invoice Number cannot be empty.",
    InvoiceValidationFeedback.invalidDueDate:
        "Invlaid Due date: Please provide date in valid DD/MM/YYYY format.",
    InvoiceValidationFeedback.invalidIssueDate:
        "Invlaid Issue date: Please provide date in valid DD/MM/YYYY format.",
    InvoiceValidationFeedback.invalidVendor:
        "Invalid Vendor: Please provide a valid vendor with name and id.",
    //TODO: URGENT add delivery invalid feedbacks
    InvoiceValidationFeedback.invalidDeliveryDueDate:
        "Invalid Delivery Due date: Please provide date in valid DD/MM/YYYY format.",
    InvoiceValidationFeedback.invalidDeliveryStatus:
        "Invalid Status: Status field cannot be empty.",
  };

  static Future<String?> showZeroTotalInvoiceWarning(BuildContext context) {
    return _showDialog(context,
        title: "Zero Total",
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "This invoice has sub-total amount \$0.00. Are you sure you want to save this entry anyway?"),
          ],
        ),
        negativeButton: "Cancel",
        positiveButton: "Yes");
  }

  static Future<String?> showSuccessfullyAddInvoice(BuildContext context) {
    return _showDialog(context,
        title: "Invoice Entry Added",
        body: Text(
            "The Invoice entry has been successfully added.\n\n\nGo back or add another invoice entry?"),
        negativeButton: "Go back",
        positiveButton: "Add another");
  }

  static Future<String?> showInvoiceErrors(BuildContext context,
      {required Iterable<InvoiceValidationFeedback> validationFeedbacks}) {
    String feedbackMessage = "";
    for (int i = 0; i < validationFeedbacks.length; i++) {
      final addNewLine = i < validationFeedbacks.length - 1;
      feedbackMessage +=
          "${_invoicevalidationErrorMessages[validationFeedbacks.elementAt(i)]!}${addNewLine ? "\n" : ""}";
    }

    return _showDialog(context,
        title: "Field Error${validationFeedbacks.length > 1 ? "s" : ""}",
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fix the field errors before saving the invoice.\n"),
            Text(
              feedbackMessage,
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
        negativeButton: "Cancel",
        positiveButton: "Okay");
  }

  static Future<String?> itemNotFoundDialog(BuildContext context,
      {required String itemName}) {
    return _showDialog(context,
        title: "Item not found",
        positiveButton: "Yes",
        negativeButton: "Cancel",
        body: Text(
            "$itemName is not found in the inventory. Do you want to add this item to inventory?"));
  }

  static Future<String?> quantityErrorDialog(BuildContext context,
      {required String body}) {
    return _showDialog(context,
        title: "Insufficient Quantity",
        positiveButton: "Okay",
        negativeButton: "Cancel",
        body: Text(body));
  }

  static Future<String?> costWarning(BuildContext context) {
    return _showDialog(context,
        title: "Zero Cost",
        positiveButton: "Yes",
        negativeButton: "Cancel",
        body: Text(
            "You have entered price as zero for this item. Are you sure you want to proceed?"));
  }

  /// pass in [true] for vendor and [false] for customer in [isVendor]
  static Future<String?> vendorNotFoundDialog(BuildContext context,
      {required String vendor, required bool isVendor}) async {
    final partyName = isVendor ? "Vendor" : "Customer";

    final result = await _showDialog(
      context,
      title: "$partyName not found",
      positiveButton: "Proceed",
      negativeButton: "Cancel",
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
              text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Do you want to add ${partyName.toLowerCase()} ',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              TextSpan(
                text: '$vendor',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              TextSpan(
                text: ' into the database?',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          )),
          SizedBox(height: 35),
          Text(
              "By proceeding, you will be promted with a text input to give an ID for the ${partyName.toLowerCase()}.",
              style: FluentTheme.of(context).typography.caption!.copyWith(
                  color: Colors.grey[130], fontWeight: FontWeight.w500))
        ],
      ),
    );

    return result;
  }

  static Future<String?> _showDialog(BuildContext context,
      {required String title,
      required Widget body,
      required String negativeButton,
      required String positiveButton}) {
    return showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(title),
        content: body,
        actions: [
          Button(
            child: Text(negativeButton),
            onPressed: () {
              Navigator.pop(context, negativeButton.toLowerCase());
              // Delete file here
            },
          ),
          FilledButton(
            child: Text(positiveButton),
            onPressed: () =>
                Navigator.pop(context, positiveButton.toLowerCase()),
          ),
        ],
      ),
    );
  }
}
