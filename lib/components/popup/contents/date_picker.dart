import 'package:flutter/material.dart';
import 'package:managy/providers/groups_provider.dart';
import 'package:managy/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatefulWidget {
  final Function() onDateSelected;

  DatePicker(this.onDateSelected, {super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // TODO: implement provider
  void selectDate(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    // showDatePicker(
    //   context: context,
    //   initialDate: task.dueDate ?? DateTime.now(),
    //   firstDate: DateTime(2024),
    //   lastDate: DateTime(2101),
    // );

    final DateTime date = dateRangePickerSelectionChangedArgs.value;

    final taskProvider = Provider.of<TaskProvider>(context, listen: false)
      ..updateDueDate(context, dueDate: date);

    widget.onDateSelected();

    // taskProvider.task.menuControllers.dateHelper.content.controller.close();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "group one name from provider: ${Provider.of<GroupsProvider>(context, listen: false).groups[0].name}");

    return SizedBox(
        height: 230,
        width: 400,
        child: SfDateRangePicker(
          initialDisplayDate: Provider.of<TaskProvider>(context).task.dueDate,
          onSelectionChanged: (dateRangePickerSelectionChangedArgs) =>
              selectDate(dateRangePickerSelectionChangedArgs),
        ));
  }
}
