import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/features/inventory/presentation/providers/helper/buying_units.dart';
import 'package:inventory/features/inventory/presentation/providers/helper/selling_units.dart';
import 'package:inventory/features/inventory/presentation/providers/unit_measure_provider.dart';
import 'package:inventory/features/inventory/presentation/widgets/unit_card.dart';
import 'package:provider/provider.dart';

class UnitMeasureScreen extends StatefulWidget {
  static const String STOCKINGUNIT_VALIDATION_ERROR_MESSAGE =
      "This field cannot be empty";

  @override
  State<UnitMeasureScreen> createState() => _UnitMeasureScreenState();
}

class _UnitMeasureScreenState extends State<UnitMeasureScreen> {
  @override
  Widget build(BuildContext context) {
    final unitMeasureProvider = Provider.of<UnitMeasureProvider>(context);

    return ScaffoldPage(
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stocking Unit Section
            Text(
              "Stocking Unit of Measure",
              style: FluentTheme.of(context).typography.subtitle,
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBox(
                  onChanged: (value) {
                    Provider.of<UnitMeasureProvider>(context, listen: false)
                        .stockingUnit = value;
                  },
                  onTapOutside: (event) {
                    unitMeasureProvider.notifyAboutStockingUnitChanges();

                    FocusScope.of(context).unfocus();
                  },
                  onEditingComplete:
                      unitMeasureProvider.notifyAboutStockingUnitChanges,
                  onSubmitted: (value) {
                    unitMeasureProvider.notifyAboutStockingUnitChanges();

                    FocusScope.of(context).unfocus();
                  },
                  placeholder: "Enter stocking unit (e.g., Box)",
                ),
                if (unitMeasureProvider.validateStockingUnitTextBox) ...[
                  SizedBox(height: 5),
                  Text(
                    UnitMeasureScreen.STOCKINGUNIT_VALIDATION_ERROR_MESSAGE,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  )
                ]
              ],
            ),
            SizedBox(height: 24),

            UnitCard<BuyingUnits>(title: "Buying Units"),
            SizedBox(height: 24),
            UnitCard<SellingUnits>(title: "Selling Units"),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
