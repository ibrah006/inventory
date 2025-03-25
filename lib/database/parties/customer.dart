import 'package:inventory/database/parties/party.dart';

class Customer extends Party {
  Customer(super.context, {required super.id});

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
