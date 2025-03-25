import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/database/invoice/invoice_item.dart';
import 'package:inventory/database/invoice/purchase_invoice.dart';
import 'package:inventory/database/invoice/sales_invoice.dart';
import 'package:inventory/state/providers/stock_provider.dart';
import 'package:inventory/tables/row_info/stock_info.dart';
import 'package:provider/provider.dart';

/// TODO: implement selction table component
/// when a bunch of table rows are selected, we want to display the total below the corrsponding column
///

class StockTable extends StatefulWidget {
  const StockTable({super.key});

  @override
  State<StockTable> createState() => _StockTableState();
}

class _StockTableState extends State<StockTable> {
  StockInfoTotals stockInfoTotals = StockInfoTotals();
  StockInfoTotals selectedStockInfoTotals = StockInfoTotals();

  List<StockInfo> inventoryData = [];

  /// Calculate the total amount across all existing stock
  void calculateUpdateStockTotals() {
    // selectedStockInfoTotals.totals = 0;
    // selectedStockInfoTotals.quantity = 0;
    // selectedStockInfoTotals.totalSelected = 0;

    for (StockInfoTotals stockInfoTs in [
      stockInfoTotals,
      selectedStockInfoTotals
    ]) {
      stockInfoTs.totals = 0;
      stockInfoTs.quantity = 0;
      stockInfoTs.totalSelected = 0;
    }

    for (StockInfo stockItem in inventoryData) {
      stockInfoTotals.totals += stockItem.amount;
      stockInfoTotals.quantity += stockItem.quantity;
      stockInfoTotals.totalSelected += 1;
      if (stockItem.selected) {
        selectedStockInfoTotals.totals += stockItem.amount;
        selectedStockInfoTotals.quantity += stockItem.quantity;
        selectedStockInfoTotals.totalSelected += 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateUpdateStockTotals();

    inventoryData = Provider.of<StockProvider>(context)
        .getStock()
        .map<StockInfo>((stockItem) {
      return StockInfo(
          name: "${stockItem.id} ${stockItem.desc}",
          quantity: stockItem.stockQuantity,
          amount: stockItem.getTotalValue());
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Inventory Table
            Table(
              border: TableBorder(
                horizontalInside: BorderSide(width: 1, color: Colors.grey[30]),
              ),
              columnWidths: const {
                0: FlexColumnWidth(.75),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[10]),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Item Name',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Quantity',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Total',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),

            // Stock table rows
            Expanded(
              child: inventoryData.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("There's no stock data for now"),
                        SizedBox(height: 5.0),
                        Text('Click on "Add Inventory" to start'),
                        SizedBox(height: 10.0),
                        Icon(
                          FluentIcons.shopping_cart,
                          size: 27,
                        )
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Text("Items in stock will show up here"),
                        //     SizedBox(width: 7.0),

                        //   ],
                        // ),
                      ],
                    ))
                  : SingleChildScrollView(
                      child: Table(
                        border: TableBorder(
                          horizontalInside:
                              BorderSide(width: 1, color: Colors.grey[30]),
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(.75),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                        },
                        children: [
                          ..._buildInventoryTableRows(),
                        ],
                      ),
                    ),
            ),

            // Stock totals
            Table(
              columnWidths: const {
                0: FlexColumnWidth(.15),
                1: FlexColumnWidth(.6),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
              },
              border: TableBorder(
                top: BorderSide(width: 1, color: Colors.grey[30]),
              ),
              children: [
                TableRow(
                  // decoration: BoxDecoration(color: Colors.grey[10]),
                  children: [
                    Container(
                      height: 35,
                      color: Colors.blue.lightest,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(""),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        selectedStockInfoTotals.totalSelected == 0
                            ? "Shwoing all"
                            : '${selectedStockInfoTotals.totalSelected} selected',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text((selectedStockInfoTotals.totalSelected == 0
                                      ? stockInfoTotals
                                      : selectedStockInfoTotals)
                                  .quantity
                                  .toString()),
                              Text(
                                "sum",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[100]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "\$${(selectedStockInfoTotals.totalSelected == 0 ? stockInfoTotals : selectedStockInfoTotals).totals.toStringAsFixed(1)}"),
                              Text(
                                "sum",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[100]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  gotoInvoiceScreen({required bool isPurchase, required StockInfo data}) {
    final List<InvoiceItem> invoiceInitialItems = [
      InvoiceItem(
          itemDesc: data.name,
          quantity: 1,
          amount: data.amount,
          cost: data.amount)
    ];

    Navigator.pushNamed(
        context, "inventory/invoice/${isPurchase ? "purchase" : "sales"}",
        arguments: isPurchase
            ? PurchaseInvoice(
                invoiceInitialItems: invoiceInitialItems,
                initialItemDesc: data.name)
            : SalesInvoice(
                invoiceInitialItems: invoiceInitialItems,
                initialItemDesc: data.name));
  }

  List<TableRow> _buildInventoryTableRows() {
    // Example rows, replace with dynamic data

    return inventoryData.map((data) {
      return TableRow(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            height: 21,
            child: Checkbox(
                checked: data.selected,
                onChanged: (value) {
                  print("Toggled: $value");
                  setState(() {
                    data.selected = value ?? false;
                  });

                  print("set toggled value (selected): ${data.selected}");
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data.name),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data.quantity.toString()),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("\$${data.amount.toStringAsFixed(2)}")),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Button(
                    child: Icon(PURCHASE_ICON),
                    onPressed: () {
                      gotoInvoiceScreen(isPurchase: true, data: data);
                    }),
                SizedBox(width: 4),
                Button(
                    child: Icon(SALES_ICON),
                    onPressed: () {
                      gotoInvoiceScreen(isPurchase: false, data: data);
                    })
              ],
            ),
          )
        ],
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }
}
