import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/core/models/location.dart';
import 'package:inventory/core/models/product.dart';
import 'package:inventory/core/models/stock.dart';
import 'package:inventory/features/inventory/presentation/widgets/transfer_info_pane.dart';

class TransferInventoryScreen extends StatefulWidget {
  const TransferInventoryScreen({super.key});

  @override
  State<TransferInventoryScreen> createState() =>
      _TransferInventoryScreenState();
}

class _TransferInventoryScreenState extends State<TransferInventoryScreen> {
  Location? fromLocation;
  Location? toLocation;
  List<Location> locations = [];
  List<Stock> availableStock = [];
  Map<Product, int> transferQuantities = {};
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    // TODO
    // final locs = await LocationService.getAll();
    // setState(() {
    //   locations = locs;
    // });
  }

  Future<void> _loadStockForLocation(Location location) async {
    setState(() {
      isLoading = true;
      availableStock = [];
    });
    //TODO
    // final stock = await StockService.getStockByLocation(location.id);
    setState(() {
      //TODO
      // availableStock = stock;
      transferQuantities.clear();
      isLoading = false;
    });
  }

  void _showError(String message) {
    setState(() => errorMessage = message);
  }

  Future<void> _submitTransfer() async {
    if (fromLocation == null ||
        toLocation == null ||
        fromLocation == toLocation) {
      _showError("Select two different locations.");
      return;
    }

    final items = transferQuantities.entries
        .where((e) => e.value > 0)
        .map((e) => {
              'product': e.key.toJson(),
              'quantity': e.value,
            })
        .toList();

    if (items.isEmpty) {
      _showError("Specify at least one quantity to transfer.");
      return;
    }

    final payload = {
      'from': fromLocation!.toJson(),
      'to': toLocation!.toJson(),
      'items': items,
      'notes': notesController.text,
      'date': DateTime.now().toIso8601String(),
    };

    // TODO
    // await StockService.transferInventory(payload);
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => ContentDialog(
          title: Text("Success"),
          content: Text("Inventory transferred successfully."),
          actions: [
            FilledButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: ScaffoldPage.scrollable(
        header: PageHeader(
          leading: Padding(
            padding: EdgeInsets.only(left: 25, right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    padding: WidgetStatePropertyAll(EdgeInsets.all(10.0))),
                icon: Icon(FluentIcons.back)),
          ),
          title: Text("Transfer Inventory"),
        ),
        children: [
          InfoPane(
            title: "PRD-10000 Nylon Rope Roll 100m",
            info: {
              'Name': "Warehouse II",
              'Address': 'N/A',
              'Type': 'Unspecified',
            },
          ),
          if (errorMessage != null)
            InfoBar(
              title: const Text("Error"),
              content: Text(errorMessage!),
              severity: InfoBarSeverity.error,
              onClose: () => setState(() => errorMessage = null),
            ),
          const SizedBox(height: 16),
          ComboBox<Location>(
            placeholder: const Text("From Location"),
            value: fromLocation,
            items: locations
                .map((loc) => ComboBoxItem<Location>(
                      value: loc,
                      child: Text(loc.name),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() => fromLocation = val);
              if (val != null) _loadStockForLocation(val);
            },
          ),
          const SizedBox(height: 12),
          ComboBox<Location>(
            placeholder: const Text("To Location"),
            value: toLocation,
            items: locations
                .map((loc) => ComboBoxItem<Location>(
                      value: loc,
                      child: Text(loc.name),
                    ))
                .toList(),
            onChanged: (val) => setState(() => toLocation = val),
          ),
          const SizedBox(height: 24),
          if (isLoading)
            const Center(child: ProgressRing())
          else if (availableStock.isEmpty)
            const Text("No stock available at this location.")
          else
            ...availableStock.map((stock) {
              final controller = TextEditingController(
                text: transferQuantities[stock.product]?.toString() ?? '',
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InfoLabel(
                  label: stock.product.name,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("Available: ${stock.stockMeasure}"),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: TextBox(
                          controller: controller,
                          placeholder: "Qty",
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            final qty = int.tryParse(val) ?? 0;
                            setState(() {
                              transferQuantities[stock.product] = qty;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          const SizedBox(height: 16),
          TextBox(
            placeholder: "Transfer Notes (optional)",
            controller: notesController,
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          FilledButton(
            child: const Text("Transfer"),
            onPressed: _submitTransfer,
          ),
        ],
      ),
    );
  }
}
