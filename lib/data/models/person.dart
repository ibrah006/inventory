class Person {
  Person({required String name}) {
    _name = name;
  }

  factory Person.fromJson(Map json) {
    return Person(name: json["name"]);
  }

  late String _name;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": _name,
    };
  }
}
