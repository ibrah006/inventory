import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/config/routes.dart';
import 'package:inventory/core/constants/in_out_icons.dart';
import 'package:inventory/features/inventory/data/samples.dart';
import 'package:inventory/core/providers/stock_provider.dart';
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
    debugPrint("vendors: ${context.read<PartyProvider>().parties}");

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
            SizedBox(width: 7),
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
      content: Row(
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
              padding: const EdgeInsets.all(16.0),
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
                            Button(
                              child: Text('Add Inventory'),
                              onPressed: gotoAddScreen,
                              style: ButtonStyle(
                                padding: ButtonState.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20)),
                              ),
                            ),
                            SizedBox(height: 16),
                            Button(
                              child: Text('Transfer Inventory Item'),
                              onPressed: () {
                                // Action to transfer inventory
                              },
                              style: ButtonStyle(
                                padding: ButtonState.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20)),
                              ),
                            ),
                            SizedBox(height: 32),
                            Text(
                              'Dashboard Statistics',
                              style:
                                  FluentTheme.of(context).typography.subtitle,
                            ),
                            SizedBox(height: 8),
                            // Statistics Tiles
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                _buildStatTile(context, 'Total Items', '150'),
                                _buildStatTile(
                                    context, 'Items Out Today', '10'),
                                _buildStatTile(
                                    context, 'Items Added Today', '20'),
                              ],
                            ),
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
                              style:
                                  FluentTheme.of(context).typography.subtitle,
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
          .intializeStock(Samples.generate());
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
