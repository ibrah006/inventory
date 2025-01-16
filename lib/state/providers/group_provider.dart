import 'package:flutter/material.dart';
import 'package:inventory/database/group.dart';
import 'package:inventory/database/item.dart';
import 'package:inventory/state/providers/groups_provider.dart';
import 'package:provider/provider.dart';

class GroupProvider extends ChangeNotifier {
  GroupProvider(this._group);

  Group _group;

  Group get group => _group;

  set group(Group value) {
    _group = value;
  }

  void updateItem(context, {required Item udpatedItem}) {
    // // update the due date
    // group.tasks.firstWhere((Task task) => task.id == taskId).dueDate = dueDate;

    Provider.of<GroupsProvider>(context, listen: false).updateGroup(group);
  }
}
