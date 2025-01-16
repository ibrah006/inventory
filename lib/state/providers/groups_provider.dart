import 'package:flutter/material.dart';
import 'package:inventory/database/group.dart';
import 'package:inventory/database/task.dart';
import 'package:inventory/extensions.dart';
import 'package:uuid/uuid.dart';

class GroupsProvider extends ChangeNotifier {
  GroupsProvider() {
    final String initialGroupID = Uuid().v1();

    _groups = [
      Group(id: initialGroupID, name: "TO-DO")
        ..tasks = [Task.create(name: "Sample", groupId: initialGroupID)]
    ];
  }

  late List<Group> _groups;

  List<Group> get groups => _groups;

  void add(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  // Group getGroup(Task task) {
  //   return _groups.firstWhere((group) => group.id == task.groupId);
  // }

  List<Task> getAllTasks() {
    final List<Task> allTasks = [];

    for (Group group in groups) {
      allTasks.addAll(group.tasks);
    }

    return allTasks;
  }

  void updateGroup(Group group) {
    _groups.replaceFirstWhere((group) => group.id == group.id, (group) {
      return group;
    });

    notifyListeners();
  }

  // void updateTask({required String groupId, required Task updatedTask}) {
  //   // final groupIndex = _groups.indexWhere((group) => group.id == groupId);
  //   // _groups[groupIndex].tasks.replace;

  //   _groups.replaceFirstWhere((group)=> group.id == groupId, (group) {
  //     group.tasks.replaceFirstWhere(test, replace)
  //   });
  // }

  /// Use for Read-only purposes. NO writing changes this way.
  Group firstWhere(bool Function(Group) test) {
    return groups.firstWhere(test);
  }

  set groups(List<Group> value) {
    _groups = value;
  }
}
