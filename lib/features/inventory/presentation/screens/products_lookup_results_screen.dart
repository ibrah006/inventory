import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/core/models/product.dart';

class ProductsLookupResultsScreen extends StatelessWidget {
  const ProductsLookupResultsScreen({super.key, required this.results});

  final List<Product> results;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: IconButton(
              iconButtonMode: IconButtonMode.large,
              icon: Icon(FluentIcons.back, size: 19),
              onPressed: () => Navigator.pop(context)),
        ),
        title: Text("Search Results"),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Table(
              border: TableBorder(
                horizontalInside: BorderSide(width: 1, color: Colors.grey[30]),
              ),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[10]),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Description',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Unit Price',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Stocking unit',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Brarcode',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
            Table(
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                },
                children: List.generate(results.length, (index) {
                  final product = results[index];

                  return TableRow(children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCell(
                            child: Text("${product.id} ${product.name}"))),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCell(
                            child: Text(product.unitPrice.toString()))),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCell(child: Text(product.stockingUnit))),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCell(child: Text(product.barcodeDisplay())))
                  ]);
                })),
          ],
        ),
      ),
    );
  }
}
