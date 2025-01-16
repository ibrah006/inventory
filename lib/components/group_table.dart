import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/components/invoice_row.dart';
import 'package:inventory/components/popup/contents/search_user.dart';
import 'package:inventory/components/popup/contents/status_menu.dart';
import 'package:inventory/components/popup/popup_helper.dart';
import 'package:inventory/database/group.dart';
import 'package:inventory/database/item.dart';
import 'package:inventory/state/providers/item_provider.dart';
import 'package:inventory/tables/cell/data_cell_wrapper.dart';
import 'package:provider/provider.dart';

class GroupTable extends StatefulWidget {
  const GroupTable({super.key, required this.group});

  final Group group;

  @override
  State<GroupTable> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupTable> {
  late final List<Item> items;
  // final borderStyle = OutlineInputBorder(
  //     borderSide: BorderSide(width: 1.5, color: Colors.blueAccent.shade700),
  //     borderRadius: BorderRadius.circular(5));

  // late final InputDecoration textFieldDecoration;

  final TextStyle titleStyle = TextStyle(
      color: Colors.black.withOpacity(.79),
      fontWeight: FontWeight.w500,
      fontSize: 27);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
                left:
                    BorderSide(width: 1, color: DataCellWrapper.BORDER_COLOR)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: List.generate(7, (index) {
                  return DataCellWrapper(
                      isHeader: true,
                      flex: index == 3 ? 2 : 1,
                      child: Text([
                        "Number",
                        "Quantity",
                        "Unit",
                        "Item Description",
                        "Price",
                        "Tax Amount",
                        "Amount"
                      ][index]));
                }),
              ),
              ...List.generate(items.length, (index) {
                final Item item = items[index];

                return ChangeNotifierProvider<ItemProvider>(
                  create: (context) => ItemProvider(item),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(children: [
                        DataCellWrapper(child: Text(item.desc)),
                        DataCellWrapper(
                            popup: PopupHelper(
                                content: SearchUserPopup(),
                                popupTooltip: "Add Users"),
                            child: Text("NA")),
                        DataCellWrapper(
                          child: Text(""),
                        ),
                        // stock quantity
                        DataCellWrapper(
                          child: Text(item.stockQuantity.toString()),
                        ),
                        // unit quantity
                        DataCellWrapper(
                          child: Text(""),
                        ),
                        // value in inventory
                        DataCellWrapper(
                          child: Text(""),
                        ),
                        DataCellWrapper(
                            popup: PopupHelper(
                                content: StatusMenu(),
                                popupTooltip: "Change Order Status"),
                            child: Text(item.orderStatus)),
                      ]),
                    ],
                  ),
                );
              }),
              InvoiceRow()
            ],
          ),
        ),
        // TextBox(
        //   controller: _taskController,
        //   cursorColor: Colors.black,
        //   style: TextStyle(fontSize: 13),
        //   onSubmitted: (value) {
        //     print("right here");

        //     final task = value.trim();
        //     if (task.isNotEmpty) {
        //       // items.add(Item.create(
        //       //     id: Uuid().v1(), desc: task, groupId: widget.group.id));

        //       _taskController.clear();
        //     }
        //     setState(() {});
        //   },
        //   // decoration: textFieldDecoration
        // ),
        SizedBox(height: 30)
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    items = widget.group.itmes;

    // textFieldDecoration = InputDecoratiion(
    //     isDense: true,
    //     hintText: " + Add task",
    //     border: borderStyle.copyWith(borderSide: BorderSide.none),
    //     focusedBorder: borderStyle);
  }
}
