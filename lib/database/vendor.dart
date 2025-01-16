import 'package:uuid/uuid.dart';

class Vendor {
  Vendor({required this.name}) {
    id = "VENDOR-${Uuid().v1()}";
  }

  late String id;
  String name;

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }
}
