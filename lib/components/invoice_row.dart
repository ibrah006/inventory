import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:inventory/tables/cell/data_cell_wrapper.dart';

class InvoiceRow extends StatefulWidget {
  const InvoiceRow({super.key});

  @override
  State<InvoiceRow> createState() => _InvoiceRowState();
}

class _InvoiceRowState extends State<InvoiceRow> {
  // enabled text editing fields
  final TextEditingController idController = TextEditingController(),
      quantityController = TextEditingController(),
      priceController = TextEditingController(),
      taxAmountController = TextEditingController();

  // disabled (read-only) text editing fields
  final TextEditingController descController = TextEditingController(),
      totalAmountController = TextEditingController();

  String unit = "";

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      // DataCellWrapper(
      //     padding: EdgeInsets.zero, child: TextBox(controller: idController)),
      // DataCellWrapper(
      //     padding: EdgeInsets.zero,
      //     child: TextBox(controller: quantityController)),
      // DataCellWrapper(child: Text(unit)),
      // DataCellWrapper(child: Text(desc)),
      // DataCellWrapper(
      //     padding: EdgeInsets.zero,
      //     child: TextBox(controller: priceController)),
      // DataCellWrapper(
      //     padding: EdgeInsets.zero,
      //     child: TextBox(controller: taxAmountController)),
      // // Show total
      // DataCellWrapper(child: Text("")),
      DataCellWrapper(
          padding: EdgeInsets.zero, child: TextBox(controller: idController)),
      DataCellWrapper(
          padding: EdgeInsets.zero,
          child: TextBox(controller: quantityController)),
      // change to combo box
      DataCellWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: ComboBox(
            items: [],
          ),
        ),
      ),
      DataCellWrapper(
          padding: EdgeInsets.zero,
          flex: 2,
          fillColor: Colors.grey.withAlpha(20),
          child: TextBox(controller: descController, enabled: false)),
      DataCellWrapper(
          padding: EdgeInsets.zero,
          child: TextBox(controller: priceController)),
      DataCellWrapper(
          padding: EdgeInsets.zero,
          child: TextBox(controller: taxAmountController)),
      DataCellWrapper(
          padding: EdgeInsets.zero,
          fillColor: Colors.grey.withAlpha(20),
          child: TextBox(
            controller: totalAmountController,
            enabled: false,
          )),
    ]);
  }
}
