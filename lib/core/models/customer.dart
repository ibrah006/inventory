import 'package:inventory/data/models/party.dart';

class Customer extends Party {
  Customer.create({required super.name, required super.id});

  Customer.fromId({required super.id}) : super.fromId(Customer);

  Customer.copy(Party other) : super.copy(other);
}

class FutureCustomer extends FutureParty implements Customer {
  FutureCustomer({required String id, required String name}) {
    super.id = id;
    super.name = name;
  }

  factory FutureCustomer.fromCustomer(Customer vendor) {
    return FutureCustomer(id: vendor.id, name: vendor.name);
  }

  factory FutureCustomer.empty() {
    return FutureCustomer(id: "", name: "");
  }
}
