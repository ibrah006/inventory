import 'package:inventory/components/popup/popup_menu_controllers.dart';
import 'package:inventory/database/person.dart';
import 'package:uuid/uuid.dart';

class Task {
  Task(
      {required String id,
      required String name,
      required String groupId,
      required Person? owner,
      required String status,
      required DateTime? dueDate,
      required int stockQuantity}) {
    _id = id;
    _name = name;
    _owner = owner;
    _status = status;
    _dueDate = dueDate;
    _stockQuantity = stockQuantity;
  }

  factory Task.create({required String name, required String groupId}) {
    return Task(
        id: Uuid().v1(),
        groupId: groupId,
        name: name,
        owner: null,
        status: "",
        dueDate: null,
        stockQuantity: 0);
  }

  late int _stockQuantity;

  int get stockQuantity => _stockQuantity;

  set stockQuantity(int value) {
    _stockQuantity = value;
  }

  late String _id;
  late String _groupId;

  String get groupId => _groupId;

  set groupId(String value) {
    _groupId = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  late String _name;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  late Person? _owner;

  Person? get owner => _owner;

  set owner(Person? value) {
    _owner = value;
  }

  late String _status;

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  late DateTime? _dueDate;

  DateTime? get dueDate => _dueDate;

  set dueDate(DateTime? value) {
    _dueDate = value;
  }

  late final PopupMenuControllers menuControllers =
      PopupMenuControllers(onDateSelected: () {});

  // Group group;
}
