class StockInfo {
  StockInfo(
      {required String name,
      required int quantity,
      required double amount,
      bool? selected}) {
    this.name = name;
    this.quantity = quantity;
    this.amount = amount;
    this.selected = selected ?? false;
  }

  late String _name;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  late int _quantity;

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }

  late double _amount;

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  late bool _selected;

  bool get selected => _selected;

  set selected(bool value) {
    _selected = value;
  }
}

class StockInfoTotals {
  int totalSelected = 0;

  int _quantity = 0;

  int get quantity => _quantity;

  set quantity(int quantity) {
    _quantity = quantity;
  }

  double _totals = 0.0;

  double get totals => _totals;

  set totals(double totals) {
    _totals = totals;
  }
}
