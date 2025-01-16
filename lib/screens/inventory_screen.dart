import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/components/group_table.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/database/group.dart';
import 'package:inventory/developer/samples/samples.dart';
import 'package:inventory/state/providers/group_provider.dart';
import 'package:inventory/state/providers/groups_provider.dart';
import 'package:inventory/state/providers/stock_provider.dart';
import 'package:inventory/tables/stock_table.dart';
import 'package:provider/provider.dart';

class InventoryDashboard extends StatefulWidget {
  @override
  State<InventoryDashboard> createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard> {
  void gotoAddScreen() {
    Navigator.pushNamed(context, "inventory/add");
    setState(() {});
    // Navigator.pushNamed(context, "inventory/add/units");
  }

  @override
  Widget build(BuildContext context) {
    List<Group> groups = Provider.of<GroupsProvider>(context).groups;

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
                  Navigator.pushNamed(context, "inventory/invoice");
                  setState(() {});
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
                onPressed: () {}),
          ],
        ),
      ),
      content: SingleChildScrollView(
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
                          padding: ButtonState.all(const EdgeInsets.symmetric(
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
                          padding: ButtonState.all(const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20)),
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Dashboard Statistics',
                        style: FluentTheme.of(context).typography.subtitle,
                      ),
                      SizedBox(height: 8),
                      // Statistics Tiles
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildStatTile(context, 'Total Items', '150'),
                          _buildStatTile(context, 'Items Out Today', '10'),
                          _buildStatTile(context, 'Items Added Today', '20'),
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
                        style: FluentTheme.of(context).typography.subtitle,
                      ),
                      SizedBox(height: 15),
                      SizedBox(height: 315, child: StockTable())
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Group Tables
            Column(
              children: List.generate(groups.length, (index) {
                final group = groups[index];

                return ChangeNotifierProvider<GroupProvider>(
                    create: (context) => GroupProvider(group),
                    child: GroupTable(group: group));
              }),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Provider.of<StockProvider>(context, listen: false)
        .intializeStock(Samples.generate());
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
