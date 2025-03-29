import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/config/routes.dart';
import 'package:inventory/core/providers/stock_provider.dart';
import 'package:inventory/presentation/providers/party_provider.dart';
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
        ChangeNotifierProvider<StockProvider>(
            create: (context) => StockProvider()),
        ChangeNotifierProvider<PartyProvider>(
            create: (context) => PartyProvider()),
      ],
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        theme: FluentThemeData(scaffoldBackgroundColor: Colors.white),
        initialRoute: AppRoutes.dashboard,
        onGenerateRoute: AppRoutes.generateRoute,
        // routes: {
        //   "home": (context) => HomeScreen(),
        //   "inventory/add": (context) => AddInventoryScreen(),
        //   "inventory/add/units": (context) => UnitMeasureScreen(),
        //   "inventory/invoice/purchase": (context) =>
        //       InvoiceScreen(PurchaseInvoice()),
        //   "inventory/invoice/sales": (context) => InvoiceScreen(SalesInvoice()),
        // },
      ),
    );
  }
}
