import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/tables/custom_table/column_item.dart';
import 'package:inventory/tables/row_info/row_info_regular.dart';
import 'package:inventory/tables/row_info/stock_info.dart';

class CustomTable extends StatefulWidget {
  const CustomTable(
      {super.key,
      required this.columnItems,
      // required this.dataCellItems,
      required this.data});

  final List<ColumnItem> columnItems;

  // final Map<Column, DataCellItem> dataCellItems;

  final List<RowInfo> data;

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  FlexColumnWidth flexColumnWidth(int index) =>
      FlexColumnWidth(widget.columnItems[index].flex);

  StockInfoTotals selectedStockInfoTotals = StockInfoTotals();

  @override
  Widget build(BuildContext context) {
    final columnWidths = List.generate(
        widget.columnItems.length, (index) => flexColumnWidth(index)).asMap();

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          children: [
            Table(
              border: TableBorder(
                horizontalInside: BorderSide(width: 1, color: Colors.grey[30]),
              ),
              columnWidths: columnWidths,
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[10]),
                  children: [
                    ...List.generate(widget.columnItems.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.columnItems[index].title,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      );
                    }),
                  ],
                ),
              ],
            ),
            SingleChildScrollView(
              child: Table(
                border: TableBorder(
                  horizontalInside:
                      BorderSide(width: 1, color: Colors.grey[30]),
                ),
                columnWidths: columnWidths,
                children: [
                  ..._buildInventoryTableRows(),
                ],
              ),
            ),
          ],
        ),
        if (selectedStockInfoTotals.totalSelected > 0)
          Padding(
            padding: const EdgeInsets.only(top: 3.0, right: 3.0),
            child: IconButton(
                icon: Icon(
                  FluentIcons.delete,
                  color: Colors.red,
                ),
                onPressed: deleteSelected),
          )
      ],
    );
  }

  List<TableRow> _buildInventoryTableRows() {
    // Example rows, replace with dynamic data

    return widget.data.map((data) {
      return TableRow(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            height: 20,
            width: 20,
            child: Checkbox(
                checked: data.selected,
                onChanged: (value) {
                  setState(() {
                    data.selected = value!;
                  });

                  selectedStockInfoTotals.totalSelected +=
                      (data.selected ? 1 : -1);
                }),
          ),
          ...List.generate(data.rowCells.length, (index) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(data.rowCells[index])
                // TextBox(
                //   controller: data.rowCells[index],
                //   smartDashesType: SmartDashesType.disabled,
                //   decoration: WidgetStatePropertyAll(
                //     BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                //   ),
                // ),
                );
          }),
        ],
      );
    }).toList();
  }

  void deleteSelected() {
    widget.data.removeWhere((datum) => datum.selected);
    selectedStockInfoTotals.totalSelected = 0;
    setState(() {});
  }
}
