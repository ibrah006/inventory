import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/config/routes.dart';
import 'package:inventory/core/providers/product_provider.dart';
import 'package:inventory/core/providers/stock_provider.dart';
import 'package:inventory/features/inventory/data/samples.dart';
import 'package:inventory/presentation/providers/party_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Generate sample data
  // await Samples.generate();
  await Samples.initializeSamples();
  // await Samples.generateSampleInvoices();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StockProvider>(
            create: (context) => StockProvider()),
        ChangeNotifierProvider<ProductProvider>(
            create: (context) => ProductProvider()),
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

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
}
