import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/core/models/stock.dart';
import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';

class StockProvider extends ChangeNotifier {
  List<Stock> _stock = [];

  List<Stock> getStock() => _stock;

  void add(Stock item) {
    _stock.add(item);
    notifyListeners();
  }

  void saveInvoiceEntry(Invoice invoice) {
    print("about to save invoice entries");
    // TODO: (not urgent but) implement a better algorithm
    for (InvoiceItem invoiceItem in invoice.items) {
      _stock.firstWhere((stockItem) =>
          "${stockItem.product.id} ${stockItem.product.desc}" ==
          invoiceItem.itemDesc)
        ..stockQuantity += (invoice.isPurchaseInvoice
            ? invoiceItem.quantity
            : -invoiceItem.quantity)
        ..inventoryValue += (invoice.isPurchaseInvoice
            ? invoiceItem.amount
            : -invoiceItem.amount);
    }
    notifyListeners();
  }

  void intializeStock(List<Stock> items) {
    _stock = items;
  }
}
