import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/database/item.dart';
import 'package:inventory/database/units.dart';
import 'package:inventory/state/providers/add_inventory/unit_measure_provider.dart';
import 'package:inventory/state/providers/add_inventory/unit_provider.dart';
import 'package:inventory/state/providers/helper/buying_units.dart';
import 'package:inventory/state/providers/helper/selling_units.dart';
import 'package:inventory/state/providers/stock_provider.dart';
import 'package:inventory/screens/add_inventory/stats_screen.dart';
import 'package:inventory/screens/add_inventory/unit_measure_screen.dart';
import 'package:inventory/screens/add_inventory/vendor_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart' show InkWell, Material;

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  State<AddInventoryScreen> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventoryScreen> {
  int currentIndex = 0;

  List<Tab> tabs = [
    Tab(text: Text("Units"), body: UnitMeasureScreen()),
    Tab(text: Text("Statistics"), body: StatisticsScreen()),
    Tab(text: Text("Vendor"), body: VendorListScreen()),
  ];

  final TextEditingController _idController = TextEditingController(),
      _descController = TextEditingController();

  bool validateIdTextBox = false;
  bool validateDescTextBox = false;

  final buyingUnitsProvider = UnitProvider<BuyingUnits>();
  final sellingUnitsProvider = UnitProvider<SellingUnits>();

  final unitMeasureProvider = UnitMeasureProvider();

  Tab generateTab(int index) {
    late Tab tab;
    tab = Tab(
      text: Text('Document $index'),
      semanticLabel: 'Document #$index',
      icon: const FlutterLogo(),
      body: Container(
        color:
            Colors.accentColors[Random().nextInt(Colors.accentColors.length)],
      ),
      onClosed: () {
        setState(() {
          tabs!.remove(tab);

          if (currentIndex > 0) currentIndex--;
        });
      },
    );
    return tab;
  }

  IconData getSectionIcon() {
    switch (currentIndex) {
      case 0:
        return FluentIcons.tag_solid;
      case 1:
        return FluentIcons.bar_chart_vertical_fill;
      case 2:
        return FluentIcons.factory;
      default:
        return FluentIcons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UnitProvider<BuyingUnits>>(
            create: (context) => buyingUnitsProvider),
        ChangeNotifierProvider<UnitProvider<SellingUnits>>(
            create: (context) => sellingUnitsProvider),
        ChangeNotifierProvider<UnitMeasureProvider>(
            create: (context) => unitMeasureProvider),
      ],
      child: ScaffoldPage(
          header: PageHeader(
            leading: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Icon(
                FluentIcons.library_add_to,
                color: Colors.grey.withAlpha(240),
              ),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, right: .5),
                  // TODO: use Ink well
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "dashboard/",
                        style: TextStyle(fontSize: 12, color: Colors.grey[100]),
                      ),
                    ),
                  ),
                ),
                Text("Add Inventory"),
              ],
            ),
            commandBar: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavigationButton(
                    label: "Purchase",
                    icon: FluentIcons.shopping_cart,
                    onPressed: () {
                      Navigator.pushNamed(context, "inventory/invoice");
                    }),
                SizedBox(width: 10),
                _buildNavigationButton(
                    label: "Sale", icon: FluentIcons.money, onPressed: () {}),
              ],
            ),
          ),
          content: Column(
            children: [
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                      child: Column(
                          children: List.generate(2, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextBox(
                        controller: [_idController, _descController][index],
                        placeholder: ["Number", "Name"][index],
                      ),
                    );
                  }))),
                ],
              ),
              Expanded(
                child: TabView(
                  header: Icon(getSectionIcon(), color: Colors.blue),
                  tabs: tabs,
                  currentIndex: currentIndex,
                  onChanged: (index) => setState(() => currentIndex = index),
                  tabWidthBehavior: TabWidthBehavior.sizeToContent,
                  closeButtonVisibility: CloseButtonVisibilityMode.never,
                  showScrollButtons: false,
                  // wheelScroll: false,
                  // onNewPressed: () {
                  //   setState(() {
                  //     final index = tabs!.length + 1;
                  //     final tab = generateTab(index);
                  //     tabs.add(tab);
                  //   });
                  // },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = tabs!.removeAt(oldIndex);
                      tabs!.insert(newIndex, item);

                      if (currentIndex == newIndex) {
                        currentIndex = oldIndex;
                      } else if (currentIndex == oldIndex) {
                        currentIndex = newIndex;
                      }
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Button(
                  child: Text("Save Changes"),
                  onPressed: () {
                    // Example: Save logic here

                    print(
                        "isSameAsStockingUnit<Buying Units>: ${buyingUnitsProvider.isSameAsStockingUnit}");
                    print(
                        "isSameAsStockingUnit<Selling Units>: ${sellingUnitsProvider.isSameAsStockingUnit}");

                    String id = _idController.text.trim();
                    String desc = _descController.text.trim();

                    final stockingUnit =
                        unitMeasureProvider.stockingUnit.trim();

                    bool validateTextBoxes = false;
                    if (id.isEmpty) {
                      setState(() {
                        validateIdTextBox = true;
                        validateTextBoxes = true;
                      });
                    }
                    if (desc.isEmpty) {
                      setState(() {
                        validateDescTextBox = true;
                        validateTextBoxes = true;
                      });
                    }
                    unitMeasureProvider.validateStockingUnit();
                    print(
                        "validate stocking unit from provider: ${unitMeasureProvider.validateStockingUnitTextBox}");
                    // if (stockingUnit.isEmpty) {
                    //   unitMeasureProvider.validateStockingUnit();
                    //   validateTextBoxes = true;

                    //   setState(() {});

                    //   print(
                    //       "validate stocking unit from provider: ${unitMeasureProvider.validateStockingUnitTextBox}");
                    // }

                    if (validateTextBoxes) return;

                    final item = Item.create(
                        id: id,
                        desc: desc,
                        groupId: Uuid().v1(),
                        buyingUnits: Units.fromUnitsProvider(
                            buyingUnitsProvider,
                            isBuyingUnits: true),
                        sellingUnits: Units.fromUnitsProvider(
                            sellingUnitsProvider,
                            isBuyingUnits: false));

                    Provider.of<StockProvider>(context, listen: false)
                        .add(item);

                    for (final stockItem
                        in Provider.of<StockProvider>(context, listen: false)
                            .getStock()) {
                      print("stock item ${stockItem.id}: ${stockItem.toMap()}");
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildNavigationButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 115,
      child: FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
            padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 15, vertical: 10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: Colors.white), // Modern icon
            SizedBox(width: 6),
            Text(
              label,
              style: FluentTheme.of(context)
                  .typography
                  .caption
                  ?.copyWith(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
