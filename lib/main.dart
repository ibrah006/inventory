import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/state/providers/groups_provider.dart';
import 'package:inventory/state/providers/stock_provider.dart';
import 'package:inventory/screens/add_inventory/add_inventory.dart';
import 'package:inventory/screens/home_screen.dart';
import 'package:inventory/screens/add_inventory/unit_measure_screen.dart';
import 'package:inventory/screens/invoice_screen.dart';
import 'package:inventory/state/providers/vendors_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GroupsProvider>(
            create: (context) => GroupsProvider()),
        ChangeNotifierProvider<StockProvider>(
            create: (context) => StockProvider()),
        ChangeNotifierProvider<VendorsProvider>(
            create: (context) => VendorsProvider())
      ],
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        theme: FluentThemeData(scaffoldBackgroundColor: Colors.white),
        initialRoute: "home",
        routes: {
          "home": (context) => HomeScreen(),
          "inventory/add": (context) => AddInventoryScreen(),
          "inventory/add/units": (context) => UnitMeasureScreen(),
          "inventory/invoice": (context) => InvoiceScreen()
        },
      ),
    );
  }
}
