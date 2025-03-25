import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/database/item.dart';
import 'package:inventory/state/providers/stock_provider.dart';
import 'package:inventory/tables/row_info/row_info_regular.dart';
import 'package:provider/provider.dart';

class InvoiceItem {
  InvoiceItem({String? itemDesc, int? quantity, double? cost, double? amount}) {
    this.itemDesc = itemDesc ?? this.itemDesc;
    this.quantity = quantity ?? this.quantity;
    this.cost = cost ?? this.cost;
    this.amount = amount ?? this.amount;
  }

  /// [itemDesc] contains id and desc in the form [item_id item_desc]
  String get itemDesc => itemDescController.text.trim();
  set itemDesc(String newValue) => itemDescController.text = newValue;

  int get quantity {
    try {
      return int.parse(quantityController.text.trim());
    } on FormatException {
      return 0;
    }
  }

  set quantity(int newValue) =>
      quantityController.text = newValue.toString().trim();

  double get cost {
    try {
      return double.parse(costController.text.trim());
    } on FormatException {
      return 0;
    }
  }

  set cost(double newValue) => costController.text = newValue.toString().trim();

  double get amount {
    try {
      return double.parse(amountController.text.trim());
    } on FormatException {
      return 0;
    }
  }

  set amount(double newValue) =>
      amountController.text = newValue.toString().trim();

  factory InvoiceItem.fromRowInfo(RowInfo rowInfo) {
    return InvoiceItem(
        itemDesc: rowInfo.rowCells[0],
        quantity: int.parse(rowInfo.rowCells[1]),
        cost: double.parse(rowInfo.rowCells[2]),
        amount: double.parse(rowInfo.rowCells[3]));
  }

  RowInfo toRowInfo() {
    return RowInfo(rowCells: [
      itemDesc,
      quantity.toString(),
      cost.toStringAsFixed(2),
      amount.toStringAsFixed(2)
    ]);
  }

  /// Functionality when a new id has been chosen from the Auto Suggest Box
  void onNewIdSelected(Item stockItem) {
    itemDesc = stockItem.id;

    // TODO: if this is a sales invoice, then check if there is at least one unit item in stock otherwise throw error

    quantity = 1;
    cost = stockItem.unitPrice;
    amount = (stockItem.unitPrice * quantity);
  }

  final TextEditingController itemDescController = TextEditingController(),
      quantityController = TextEditingController(),
      costController = TextEditingController(),
      amountController = TextEditingController();

  void clearTextFields() {
    itemDescController.clear();
    costController.clear();
    costController.clear();
    amountController.clear();
  }

  AddInvoiceItemFeedback canValidateFields(BuildContext context) {
    if (itemDesc.isNotEmpty) {
      try {
        print("item id from canValidateFields: ${itemDesc}");
        Provider.of<StockProvider>(context, listen: false)
            .getStock()
            .firstWhere(
                (stockItem) => "${stockItem.id} ${stockItem.desc}" == itemDesc);
      } on StateError {
        return AddInvoiceItemFeedback.itemError;
      }

      if (quantity == 0) {
        return AddInvoiceItemFeedback.quantityError;
      }

      if (cost.isNaN || cost <= 0) {
        return AddInvoiceItemFeedback.warning;
      }
      return AddInvoiceItemFeedback.valid;
    } else {
      print("empty id");
      return AddInvoiceItemFeedback.itemError;
    }
  }
}

enum AddInvoiceItemFeedback {
  /// [valid] is when user typed in id, quantity and cost. all of them > 0
  /// [warning] is when the cost field is left empty or 0
  valid,
  itemError,
  quantityError,
  warning
}
