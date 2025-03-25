import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/config/routes.dart';
import 'package:inventory/features/customer/presentation/providers/customer_provider.dart';
import 'package:inventory/features/inventory/presentation/providers/stock_provider.dart';
import 'package:inventory/features/vendor/presentation/providers/vendors_provider.dart';
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
        ChangeNotifierProvider<VendorsProvider>(
            create: (context) => VendorsProvider()),
        ChangeNotifierProvider<CustomerProvider>(
            create: (context) => CustomerProvider())
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
