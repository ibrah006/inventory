import 'package:inventory/database/invoice/invoice.dart';
import 'package:inventory/database/invoice/invoice_item.dart';

class PurchaseInvoice extends Invoice {
  @deprecated
  List<InvoiceItem>? invoiceInitialItems;

  PurchaseInvoice({this.invoiceInitialItems, String? initialItemDesc}) {
    this.initialItemDesc = initialItemDesc;

    print('itemname from stock table: ${initialItemDesc}');
  }

  @override
  List<InvoiceItem> get items => invoiceInitialItems ?? super.items;

  @override
  String? initialItemDesc;
}
