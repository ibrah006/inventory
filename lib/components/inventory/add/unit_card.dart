import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/state/providers/add_inventory/unit_measure_provider.dart';
import 'package:inventory/state/providers/add_inventory/unit_provider.dart';
import 'package:provider/provider.dart';

// T must be passed in
class UnitCard<T> extends StatefulWidget {
  final String title;

  UnitCard({required this.title}) {
    // final typeCompare = SellingUnits().runtimeType;
    // print(
    //     "this is T.runtimeType: ${T.runtimeType == typeCompare}, SellingUnits.runtimeType: ${SellingUnits().runtimeType}");
    // if (T.runtimeType == SellingUnits().runtimeType) {
    //   print("we're good");
    // }
    // if (T is SellingUnits || T is BuyingUnits) {
    // } else {
    //   throw "Make sure you pass in T for UnitCard. it could be UnitCard<BuyingUnits> or UnitCard<SellingUnits>";
    // }
  }

  @override
  State<UnitCard> createState() => _UnitCardState<T>();
}

class _UnitCardState<T> extends State<UnitCard> {
  @override
  Widget build(BuildContext context) {
    final details = Provider.of<UnitProvider<T>>(context, listen: false);

    final stockingUnit = Provider.of<UnitMeasureProvider>(context).stockingUnit;

    print("stocking unit: $stockingUnit");

    final bool isSameAsStockingUnit = details.isSameAsStockingUnit;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withAlpha(75)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: FluentTheme.of(context).typography.subtitle,
          ),
          SizedBox(height: 8),
          Checkbox(
            checked: isSameAsStockingUnit,
            content: Text("Same as stocking unit"),
            onChanged: (value) {
              if ((value ?? false) &&
                  details.unitController.text.trim().isEmpty) {
                details.unitController.text = "item";
                details.relationshipController.text = "1";
                details.relationshipBy =
                    "${details.unitController.text.trim()} per $stockingUnit";
              }
              setState(() {
                details.isSameAsStockingUnit = value ?? false;
              });
            },
          ),
          SizedBox(height: 8),
          TextBox(
            controller: details.unitController,
            enabled: !isSameAsStockingUnit,
            onTapOutside: (event) {
              setState(() {});

              FocusScope.of(context).unfocus();
            },
            onEditingComplete: () {
              setState(() {});
            },
            onSubmitted: (value) {
              setState(() {});

              FocusScope.of(context).unfocus();
            },
            placeholder: "Enter selling unit (e.g., Each)",
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextBox(
                  enabled: !isSameAsStockingUnit,
                  controller: details.relationshipController,
                  placeholder: "Enter relationship (e.g., 5)",
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: InfoLabel(
                  label: "Relationship by",
                  child: ComboBox<String>(
                    onChanged: isSameAsStockingUnit
                        ? null
                        : (value) {
                            setState(() {
                              details.relationshipBy = value;
                            });
                          },
                    value: details.relationshipBy,
                    placeholder: Text("Select relationship"),
                    items: [
                      ComboBoxItem(
                        value:
                            "$stockingUnit per ${details.unitController.text}",
                        child: Text(
                            "$stockingUnit per ${details.unitController.text}"),
                      ),
                      ComboBoxItem(
                        value:
                            "${details.unitController.text} per $stockingUnit",
                        child: Text(
                            "${details.unitController.text} per $stockingUnit"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
