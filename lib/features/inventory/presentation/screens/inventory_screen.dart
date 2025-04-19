import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:inventory/config/routes.dart';
import 'package:inventory/core/constants/in_out_icons.dart';
import 'package:inventory/core/providers/product_provider.dart';
import 'package:inventory/features/inventory/data/samples.dart';
import 'package:inventory/core/providers/stock_provider.dart';
import 'package:inventory/features/inventory/presentation/widgets/products_lookup_search_bar.dart';
import 'package:inventory/features/inventory/presentation/widgets/dashboard_stats_section.dart';
import 'package:inventory/features/inventory/presentation/widgets/sales_overview_chart.dart';
import 'package:inventory/presentation/providers/party_provider.dart';
import 'package:inventory/presentation/widgets/tables/stock_table.dart';
import 'package:provider/provider.dart';

class InventoryDashboardScreen extends StatefulWidget {
  @override
  State<InventoryDashboardScreen> createState() =>
      _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState extends State<InventoryDashboardScreen> {
  void gotoAddScreen() {
    Navigator.pushNamed(context, AppRoutes.add);
    // Navigator.pushNamed(context, "inventory/add/units");
  }

  // Divider get _divider => Divider(
  //       style: DividerThemeData(
  //           decoration: BoxDecoration(
  //         color: Colors.grey[150],
  //       )),
  //     );

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text('Inventory Dashboard',
            style: FluentTheme.of(context).typography.title),
        commandBar: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FluentIcons.receipt_processing, color: Colors.blue),
            SizedBox(width: 10),
            FilledButton(
                child: Row(
                  children: [
                    Icon(PURCHASE_ICON),
                    SizedBox(width: 5),
                    Text("Purchase", style: TextStyle(fontSize: 12)),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.purchaseInvoice);
                }),
            SizedBox(width: 10),
            FilledButton(
                child: Row(
                  children: [
                    Icon(SALES_ICON),
                    SizedBox(width: 5),
                    Text("Sales", style: TextStyle(fontSize: 12)),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.salesInvoice);
                }),
          ],
        ),
      ),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Button(
                      onPressed: gotoAddScreen,
                      style: ButtonStyle(
                        padding: ButtonState.all(const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16)),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Icon(
                                FluentIcons.cube_shape_solid,
                                size: 18.5,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                child: Icon(
                                  Icons.add_circle,
                                  size: 13,
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 10),
                          Text('Add Inventory'),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Button(
                      onPressed: () {
                        // Action to transfer inventory
                        Navigator.pushNamed(
                            context, AppRoutes.transferInventory);
                      },
                      style: ButtonStyle(
                        padding: ButtonState.all(const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black, // Filled background
                            ),
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              FluentIcons.database_swap,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Transfer Inventory Item'),
                        ],
                      ),
                    ),
                  ],
                ),
                LookupSearchBar(),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                // Container(
                //   width: 280,
                //   margin: EdgeInsets.only(right: 15, top: 15),
                //   height: MediaQuery.of(context).size.height,
                //   color: Colors.white,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const SizedBox(height: 16),
                //       // Home Item
                //       _buildNavItem(
                //         icon: FluentIcons.home_solid,
                //         label: 'Home',
                //         index: 0,
                //       ),
                //       _buildNavItem(
                //         icon: FluentIcons.check_list,
                //         label: 'My work',
                //         index: 1,
                //       ),
                //       _divider,
                //       _buildNavItem(
                //           icon: FluentIcons.starburst,
                //           label: 'Favorites',
                //           index: 2,
                //           isExpandable: true),
                //       _divider,
                //       // _buildSectionHeader('Favorites'),
                //       Expander(
                //           // trailing: Icon(FluentIcons.chevron_down),
                //           // shape: RoundedRectangleBorder(side: BorderSide.none),
                //           header: const Text(
                //             'Workspaces',
                //             style:
                //                 TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                //           ),
                //           leading: Icon(FluentIcons.view_dashboard,
                //               color: Colors.grey[170], size: 18),
                //           content: Column(
                //             children: [
                //               _buildNavItem(
                //                 icon: FluentIcons.home,
                //                 label: 'Main workspace',
                //                 index: 2,
                //                 hasIndicator: true,
                //               ),
                //               _buildNavItem(
                //                 icon: FluentIcons.folder_fill,
                //                 label: 'First Project',
                //                 index: 3,
                //               ),
                //               _buildNavItem(
                //                 icon: FluentIcons.bar_chart_vertical,
                //                 label: 'Dashboard and reporting',
                //                 index: 4,
                //               ),
                //             ],
                //           )),
                //       _divider,
                //       // Add Workspace Button
                //       Row(
                //         children: [
                //           Flexible(
                //             child: Button(
                //               onPressed: () {},
                //               style: ButtonStyle(
                //                   shape: WidgetStatePropertyAll(
                //                       RoundedRectangleBorder(side: BorderSide.none))),
                //               child: Row(
                //                 mainAxisSize: MainAxisSize.min,
                //                 children: [
                //                   const Icon(FluentIcons.add),
                //                   SizedBox(width: 5.0),
                //                   const Text('Add workspace'),
                //                 ],
                //               ),
                //             ),
                //           ),
                //           Button(
                //             onPressed: () {},
                //             style: ButtonStyle(
                //                 shape: WidgetStatePropertyAll(
                //                     RoundedRectangleBorder(side: BorderSide.none))),
                //             child: Row(
                //               mainAxisSize: MainAxisSize.min,
                //               children: [
                //                 const Icon(FluentIcons.go_to_dashboard),
                //                 SizedBox(width: 5.0),
                //                 const Text('Browse all'),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Panel: Add Inventory and Transfer
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Statistics Tiles
                                  DashboardStatsSection(),
                                  SizedBox(height: 25),
                                  SalesOverviewChart(),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            // Right Panel: Inventory Table
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Inventory Overview',
                                    style: FluentTheme.of(context)
                                        .typography
                                        .subtitle,
                                  ),
                                  SizedBox(height: 15),
                                  // Stock table
                                  SizedBox(height: 315, child: StockTable())
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildNavItem(
  //     {required IconData icon,
  //     required String label,
  //     required int index,
  //     bool hasIndicator = false,
  //     isExpandable = false
  //     }) {
  //   final bool isSelected = 1 == index;

  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         // selectedIndex = index;
  //       });
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
  //       padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
  //       decoration: BoxDecoration(
  //         color: isSelected ? Colors.blue.withOpacity(.2) : Colors.transparent,
  //         borderRadius: BorderRadius.circular(4),
  //       ),
  //       child: Row(
  //         children: [
  //           if (hasIndicator)
  //             Icon(FluentIcons.home,
  //                 color: Colors.magenta.withAlpha(180), size: 18)
  //           else
  //             Icon(icon, color: Colors.grey[160], size: 18),
  //           const SizedBox(width: 12),
  //           Text(
  //             label,
  //             style: TextStyle(
  //                 color: Colors.grey[210], fontWeight: FontWeight.w500
  //                 // fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
  //                 ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();

    if (mounted) {
      Provider.of<StockProvider>(context, listen: false)
          .intializeStock(Samples.sampleStock);
      Provider.of<ProductProvider>(context, listen: false)
          .initializeProducts(Samples.sampleProducts);

      // Load Parties (Vendors/Customers)
      Provider.of<PartyProvider>(context, listen: false)
          .initialize()
          .then((value) {
        print("loaded parties successfully");
      });
    }
  }

  Widget _buildStatTile(BuildContext context, String title, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[10],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FluentTheme.of(context).typography.body),
          SizedBox(height: 8),
          Text(value, style: FluentTheme.of(context).typography.title),
        ],
      ),
    );
  }
}
