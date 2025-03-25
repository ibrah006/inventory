import 'package:inventory/database/invoice/invoice.dart';
import 'package:inventory/database/invoice/invoice_item.dart';

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
