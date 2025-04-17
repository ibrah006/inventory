import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/core/models/product.dart';
import 'package:inventory/core/providers/product_provider.dart';
import 'package:inventory/core/providers/stock_provider.dart';
import 'package:inventory/presentation/widgets/tables/row_info/row_info_regular.dart';
import 'package:provider/provider.dart';

class InvoiceItem extends Product {
  // not part of the InvoiceItem table schema (only local usage)
  @Deprecated(
      "invoiceType is deprecated and will be replaced with invoice [invoice.type]")
  InvoiceType invoiceType;

  late final Invoice invoice;

  InvoiceItem(
      {required this.invoiceType,
      String? name,
      int? measure,
      double? cost,
      double? amount})
      : super.empty() {
    // this.itemDesc = itemDesc ?? this.itemDesc;

    this.measure = measure ?? this.measure;
    this.cost = cost ?? this.cost;
    this.amount = amount ?? this.amount;
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    final type = InvoiceType.values.firstWhere(
      (e) => e.name == json["type"],
      orElse: () => InvoiceType.purchase, // Default to purchase if not found
    );

    late final Invoice? invoice;
    try {
      invoice = Invoice.fromJson(json["invoice"] as Map<String, dynamic>);
    } catch (e) {
      invoice = null;
    }

    late final Product? product;
    try {
      product = Product.preview(json["product"]);
    } catch (e) {
      product = null;
    }

    final invoiceItem = InvoiceItem(
        invoiceType: type,
        measure: json["measure"],
        cost: json["cost"],
        amount: json["amount"]);

    if (product != null) {
      print("product is not null and this is category: ${product.category}");
      invoiceItem.setSelf(product);
    }

    if (invoice != null) {
      invoiceItem.invoice = invoice;
      invoiceItem.invoiceNumber = int.parse(invoice.invoiceNumber);
    }

    // Here, _isMeasureInStockingUnit needs to be directly modified
    invoiceItem._isMeasureInStockingUnit = false;

    return invoiceItem;
  }

  // Copy constructor
  factory InvoiceItem.copy(InvoiceItem original) {
    // Copy Product fields
    final copiedProduct = Product.create(
        id: original.id,
        desc: original.name,
        category: original.category,
        unitPrice: original.unitPrice,
        buyingUnits: original.buyingUnits,
        sellingUnits: original.sellingUnits,
        stockingUnit: original.stockingUnit,
        pricingList: original.pricingList);

    try {
      original.barcode;
      copiedProduct.barcode = original.barcode;
    } catch (e) {}

    // Create a new InvoiceItem based on the copied Product and copy the other fields
    return InvoiceItem(
      invoiceType: original.invoiceType,
      name: original.name,
      measure: original.measure,
      cost: original.cost,
      amount: original.amount,
    )
      ..setSelf(
          copiedProduct) // Set the copied Product fields to the new InvoiceItem
      .._itemDescController.text = original._itemDescController.text
      ..measureController.text = original.measureController.text
      ..costController.text = original.costController.text
      ..amountController.text = original.amountController.text;
  }

  /// [itemDesc] contains id and desc in the form [item_id item_desc]
  @override
  String get itemDesc {
    try {
      return super.itemDesc;
    } catch (e) {
      return "";
    }
  }

  set _itemDesc(String newItemDesc) {
    _itemDescController.text = newItemDesc;
  }

  /// This function will set the [_itemDescController]'s [text] value to the product item description
  /// Pass in context to get the product details from Product Provider (recommended)
  Future<void> setId(BuildContext? context, String productId) async {
    final Product product = await Product.fromId(context: context, id: id);

    // Set the item desc TextEditController's text value [_itemDescController]
    _itemDesc = product.itemDesc;

    super.setSelf(product);
  }

  // set itemDesc(String newValue) => ;

  // Invoice ID
  late int invoiceNumber;

  int get measure {
    try {
      return int.parse(measureController.text.trim());
    } on FormatException {
      return 0;
    }
  }

  set measure(int newValue) =>
      measureController.text = newValue.toString().trim();

  double get cost {
    try {
      return double.parse(costController.text.trim());
    } on FormatException {
      return 0;
    }
  }

  set cost(double newValue) {
    costController.text = newValue.toString().trim();
  }

  double get amount {
    try {
      var amount = cost * measure;

      if (isMeasureInStockingUnit) {
        final isPurchaseInvoice = invoiceType.name == "purchase";
        final units = isPurchaseInvoice ? buyingUnits : sellingUnits;

        print(
            "from amount: measure: $measure, relation: ${units.relationship}, relationBy: ${units.relationshipBy}");

        if (units.relationshipBy?.trim() ==
            "${stockingUnit.toLowerCase()} per ${units.unit}") {
          // stocking unit per measuring unit (eg. box per item)
          amount = (measure / units.relationship) * cost;
        } else {
          // measuring unit per stocking unit (eg. item per box)
          amount = (cost * measure) * units.relationship;
        }
      }

      return amount;
    } catch (e) {
      // Happens when no product is selected
      // (i.e., some of the attribs of super class Product has no value assigned to it yet (late),
      // such as buyingUnits which is used above, resulting in this LateInitializationError)
      // As a result of this we return 0 as amount;
      return 0;
    }
  }

  double get amountNonTransformed {
    try {
      return double.parse(amountController.text.trim());
    } on FormatException {
      print(
          "for some reason we're getting format exception, amount controller text: ${amountController.text}");
      return 0;
    }
  }

  set amount(double newValue) {
    // amount = newValue * measure * ;
    amountController.text = newValue.toString();
  }

  double measuringUnits = 0;

  // @Deprecated("Useless")
  // factory InvoiceItem.fromRowInfo(RowInfo rowInfo) {
  //   return InvoiceItem(
  //       itemDesc: rowInfo.rowCells[0],
  //       quantity: int.parse(rowInfo.rowCells[1]),
  //       cost: double.parse(rowInfo.rowCells[2]),
  //       amount: double.parse(rowInfo.rowCells[3]));
  // }

  bool _isMeasureInStockingUnit = true;
  bool get isMeasureInStockingUnit => _isMeasureInStockingUnit;
  set isMeasureInStockingUnit(bool newValue) {
    _isMeasureInStockingUnit = newValue;

    try {
      buyingUnits;
    } catch (e) {
      debugPrint("""
        \nTwo Possibilities of Error:
        1. Relational attributes of product cannot be accessed in preview mode.
        isMeasureInStockingUnit attrib of InvoiceItem uses relational attributes of super class Product.
        If you're getting this error then you've most likely initiated product for this instance using Product.
        Preview constructor which is only meant to provide minimal view of product.
        Relational attributes of Product not initialized (late) -> actual error

        2. (CAN IGNORE) Units modifier changed either from measuring unit -> stocking unit or other way around when no product selected -> newInvoiceItem -> Invoice Screen
        Just move on ignoring this error if that's the case
        """);
      return;
    }

    final isPurchaseInvoice = invoiceType == InvoiceType.purchase;

    final units = isPurchaseInvoice ? buyingUnits : sellingUnits;

    late final double mUnits;
    if (!isMeasureInStockingUnit) {
      mUnits = measure.toDouble();
    } else if (units.relationshipBy == "${units.unit} per $stockingUnit") {
      mUnits = measure * units.relationship;
    } else if (units.relationshipBy == "$stockingUnit per ${units.unit}") {
      mUnits = measure / units.relationship;
    } else {
      throw "Relationship BY for product $itemDesc by has an unexpected form. It can either be 'measuring_unit per stocking_unit' or 'stocking_unit per measuring_unit', received: '${units.relationshipBy}'";
    }

    measuringUnits = mUnits;
  }

  RowInfo toRowInfo() {
    try {
      super.id;
    } catch (e) {
      throw "Failed to convert InvoiceItem to RowInfo while product id has not been initialized or is empty";
    }

    return RowInfo(rowCells: [
      itemDesc,
      measure.toString(),
      cost.toStringAsFixed(2),
      amount.toStringAsFixed(2)
    ]);
  }

  // Method to convert an InvoiceItem to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'product': super.toJson(),
      'measure': measuringUnits,
      'cost': cost,
      'amount': amount,
      'invoice': invoiceNumber
    };
  }

  /// Functionality when a new id has been chosen from the Auto Suggest Box
  void onNewIdSelected(Product productItem) {
    // itemDesc = stockItem.id;

    // Reinitialize each of the super class (product entity) attributes
    // product = productItem;
    setSelf(productItem);

    // TODO: if this is a sales invoice, then check if there is at least one unit item in stock otherwise throw error
    // TODO: create bool funciton that checks to see if there are [n] number of quantity left in stock

    measure = 1;

    measuringUnits = 1;
    cost = productItem.unitPrice ?? 0;
    amount = amount;
  }

  // @deprecated
  final TextEditingController _itemDescController = TextEditingController();

  TextEditingController get itemDescController => _itemDescController;

  final TextEditingController measureController = TextEditingController(),
      costController = TextEditingController(),
      amountController = TextEditingController();

  void clearTextFields() {
    _itemDescController.clear();
    costController.clear();
    costController.clear();
    amountController.clear();
    measureController.clear();
  }

  AddInvoiceItemFeedback canValidateFields(BuildContext context) {
    if (itemDesc.isNotEmpty) {
      try {
        print("item id from canValidateFields: ${itemDesc}");
        Provider.of<StockProvider>(context, listen: false)
            .getStock()
            .firstWhere((stockItem) =>
                "${stockItem.product.id} ${stockItem.product.name}" ==
                itemDesc);
      } on StateError {
        return AddInvoiceItemFeedback.itemError;
      }

      if (measure == 0) {
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

  void onItemDescriptionFieldChanged(BuildContext context, String newValue,
      TextChangedReason textChangedReason) {
    final Product? product =
        Provider.of<ProductProvider>(context, listen: false)
            .getProductByItemDescription(newValue);

    if (product != null) {
      onNewIdSelected(product);
    } else {
      print("item not found: ${newValue}");
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
