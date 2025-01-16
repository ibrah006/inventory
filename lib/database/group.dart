import 'package:inventory/database/item.dart';
import 'package:inventory/database/task.dart';
import 'package:uuid/uuid.dart';

class Group {
  Group({required String id, required String name}) {
    this.id = id;
    this.name = name;
  }

  factory Group.create() {
    return Group(id: Uuid().v1(), name: "");
  }

  late String _id;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  late String _name;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  @Deprecated("This is a deprecated attribute. use items")
  List<Task> tasks = [];

  List<Item> itmes = [];
}
