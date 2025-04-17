import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/core/models/stock.dart';
import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';
import 'package:inventory/services/stock_service.dart';

class StockProvider extends ChangeNotifier {
  List<Stock> _stock = [];

  List<Stock> getStock() => _stock;

  /// Any one of the inputs is necessary
  Future<Stock> getStockItem(
      {required int? stockId, required String? productId}) async {
    if (stockId == null && productId == null) {
      throw "One of the inputs is necessary. Either [stockId] or [productId] must not be null";
    }

    try {
      final Stock stockItem = _stock.firstWhere((stockItem) =>
          stockItem.product.id == productId || stockItem.id == stockId);

      return stockItem;
    } catch (e) {
      // Stock item not found in memory, check database
      if (stockId != null) {
        return await StockService.getStockById(stockId);
      } else {
        // Else case means the productId is not null
        productId!;
        return await StockService.getStockByProductId(productId);
      }
    }
  }

  void add(Stock item) {
    _stock.add(item);
    notifyListeners();
  }

  void saveInvoiceEntry(Invoice invoice) async {
    print("about to save invoice entries");

    // TODO: (not urgent but) implement a better algorithm
    for (InvoiceItem invoiceItem in invoice.items) {
      // TODO: Update stock Entity
      await Stock.updateWithStockItem(invoiceItem);

      // TODO (ISSUE): CAN'T GET THE PRODUCT ID BECUASE IT'S MIXED WITH NAME AS 'DESC'

      invoiceItem.invoiceNumber = int.parse(invoice.invoiceNumber);

      print("invoice item amount: ${invoiceItem.amount}");

      print(
          "stock item (before update): ${_stock.firstWhere((stockItem) => "${stockItem.product.id} ${stockItem.product.name}" == invoiceItem.itemDesc).toJson()}");

      _stock.firstWhere((stockItem) =>
          "${stockItem.product.id} ${stockItem.product.name}" ==
          invoiceItem.itemDesc)
        ..stockMeasure += (invoice.isPurchaseInvoice
            ? invoiceItem.measure
            : -invoiceItem.measure)
        ..inventoryValue += (invoice.isPurchaseInvoice
            ? invoiceItem.amount
            : -invoiceItem.amount);

      print(
          "stock item (after update): ${_stock.firstWhere((stockItem) => "${stockItem.product.id} ${stockItem.product.name}" == invoiceItem.itemDesc).toJson()}");
    }
    notifyListeners();
  }

  void intializeStock(List<Stock> items) {
    _stock = items;
  }
}
