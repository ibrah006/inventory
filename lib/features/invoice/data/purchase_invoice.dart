import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';

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
