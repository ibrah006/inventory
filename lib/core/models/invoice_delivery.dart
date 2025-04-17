import 'package:fluent_ui/fluent_ui.dart';

// we accept empty delivery due date value for purchase invoice but not for sales invoice

class InvoiceDelivery {
  set dueDate(String newValue) => dueDateController.text = newValue;
  String get dueDate => dueDateController.text.trim();

  String status;

  InvoiceDelivery({required this.status});

  InvoiceDelivery.empty() : status = "";

  final TextEditingController dueDateController = TextEditingController();

  // Factory constructor to create an InvoiceDelivery from JSON
  factory InvoiceDelivery.fromJson(Map<String, dynamic> json) {
    return InvoiceDelivery(
      status: json['status'] as String? ??
          "", // Default to empty if no status is provided
    )..dueDate = json['dueDate'] as String? ?? ""; // Set dueDate if provided
  }

  Map<String, dynamic>? toJson() {
    return status.trim().isEmpty && dueDate.isEmpty
        ? null
        : {
            'status': status,
            'dueDate': dueDate,
          };
  }
}
