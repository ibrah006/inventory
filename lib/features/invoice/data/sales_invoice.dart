import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';

class SalesInvoice extends Invoice {
  @deprecated
  List<InvoiceItem>? invoiceInitialItems;

  SalesInvoice({this.invoiceInitialItems, this.initialItemDesc}) {
    if (initialItemDesc != null) {}
  }

  @override
  List<InvoiceItem> get items => invoiceInitialItems ?? super.items;

  @override
  String? initialItemDesc;
}
