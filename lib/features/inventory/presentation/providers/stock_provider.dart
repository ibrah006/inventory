import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/features/inventory/data/item.dart';
import 'package:inventory/features/invoice/data/invoice.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';

class StockProvider extends ChangeNotifier {
  List<Item> _stock = [];

  List<Item> getStock() => _stock;

  void add(Item item) {
    _stock.add(item);
    notifyListeners();
  }

  void saveInvoiceEntry(Invoice invoice) {
    print("about to save invoice entries");
    // TODO: (not urgent but) implement a better algorithm
    for (InvoiceItem invoiceItem in invoice.items) {
      _stock.firstWhere((stockItem) =>
          "${stockItem.id} ${stockItem.desc}" == invoiceItem.itemDesc)
        ..stockQuantity += (invoice.isPurchaseInvoice
            ? invoiceItem.quantity
            : -invoiceItem.quantity)
        ..inventoryValue += (invoice.isPurchaseInvoice
            ? invoiceItem.amount
            : -invoiceItem.amount);
    }
    notifyListeners();
  }

  void intializeStock(List<Item> items) {
    _stock = items;
  }
}
