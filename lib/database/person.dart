class Person {
  Person({required String name}) {
    _name = name;
  }

  late String _name;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": _name,
    };
  }
}
