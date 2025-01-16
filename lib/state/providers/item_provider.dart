import 'package:flutter/material.dart';
import 'package:inventory/database/item.dart';

import 'package:inventory/state/providers/group_provider.dart';
import 'package:provider/provider.dart';

class ItemProvider extends ChangeNotifier {
  Item _item;

  Item get item => _item;

  set task(Item value) {
    _item = value;
  }

  ItemProvider(this._item);

  void updateLastCheckDate(context, {required DateTime dueDate}) {
    // set new due date
    _item.lastCheckDate = dueDate;

    // pass in the the updated _task to the Group Provider which change
    Provider.of<GroupProvider>(context, listen: false)
        .updateItem(context, udpatedItem: _item);

    // group.tasks.firstWhere((Task task) => task.id == taskId).dueDate = dueDate;
    // update the group
    // Provider.of<GroupsProvider>(context, listen: false)
    //     .updateGroup(updatedGroup);
  }
}
