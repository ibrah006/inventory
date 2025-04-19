class Location {
  final String id;
  final String name;
  final String? address;
  final String? type;

  Location({
    required this.id,
    required this.name,
    this.address,
    this.type,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (address != null) 'address': address,
      if (type != null) 'type': type,
    };
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Location && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
