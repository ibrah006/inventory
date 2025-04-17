import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';

class UnitsSplitButton extends StatefulWidget {
  const UnitsSplitButton(
      {super.key,
      required this.updateParentState,
      required this.selectedItem,
      required this.controller,
      required this.onChanged});

  final Function() updateParentState;
  final InvoiceItem selectedItem;
  final TextEditingController controller;
  final Function(String value)? onChanged;

  @override
  State<UnitsSplitButton> createState() => _UnitsSplitButtonState();
}

class _UnitsSplitButtonState extends State<UnitsSplitButton> {
  final itemsController = FlyoutController();

  var radioIndex = 0;

  late bool isRoll;

  @override
  Widget build(BuildContext context) {
    try {
      isRoll = widget.selectedItem.stockingUnit.toLowerCase() == "roll";
    } catch (e) {
      // This error occurs when there is no product selected.
      isRoll = false;
    }

    return Row(
      children: [
        Expanded(
            child: TextBox(
                onChanged: widget.onChanged, controller: widget.controller)),
        FlyoutTarget(
            controller: itemsController,
            child: Button(
              onPressed: showUnitOptions,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.75),
                  child: Row(
                    children: [
                      Text(isRoll
                          ? radioIndex == 0
                              ? "Roll"
                              : "Length"
                          : radioIndex == 0
                              ? "Box"
                              : "Item"),
                      SizedBox(width: 10),
                      const Icon(
                        FluentIcons.chevron_down,
                        size: 7.5,
                      ),
                    ],
                  )),
            ))
      ],
    );
  }

  void showUnitOptions() async {
    await itemsController.showFlyout(
      autoModeConfiguration: FlyoutAutoConfiguration(
        preferredMode: FlyoutPlacementMode.topCenter,
      ),
      barrierDismissible: true,
      dismissOnPointerMoveAway: false,
      dismissWithEsc: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return MenuFlyout(
            items: List.generate(2, (index) {
              return ToggleMenuFlyoutItem(
                text: Text(
                    (isRoll ? ['Roll', 'Length'] : ['Box', 'Item'])[index]),
                value: radioIndex == index,
                onChanged: (v) {
                  widget.selectedItem.isMeasureInStockingUnit = index == 0;

                  setState(() => radioIndex = index);
                  Navigator.pop(context);
                },
              );
            }),
          );
        });
      },
    );

    // setState(() {});
    widget.updateParentState();
  }
}
