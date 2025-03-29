import 'package:fluent_ui/fluent_ui.dart';

// we accept empty delivery due date value for purchase invoice but not for sales invoice

class InvoiceDelivery {
  set dueDate(String newValue) => dueDateController.text = newValue;
  String get dueDate => dueDateController.text.trim();

  String status;

  InvoiceDelivery({required this.status});

  InvoiceDelivery.empty() : status = "";

  final TextEditingController dueDateController = TextEditingController();
}
