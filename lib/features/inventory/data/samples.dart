import 'dart:math';

import 'package:inventory/core/models/stock.dart';
import 'package:inventory/data/models/person.dart';
import 'package:inventory/core/models/product.dart';
import 'package:inventory/features/inventory/data/units.dart';
import 'package:inventory/core/models/vendor.dart';

class Samples {
  static List<Stock> generate() {
    List<Stock> items = [];
    Random random = Random();
    List<String> itemDescriptions = [
      "Laptop",
      "Smartphone",
      "Tablet",
      "Headphones",
      "Monitor",
      "Keyboard",
      "Mouse",
      "Charger",
      "Speaker",
      "Webcam",
      "Smartwatch",
      "Printer",
      "Camera",
      "Microphone",
      "External Hard Drive",
      "USB Cable",
      "Power Bank",
      "Router",
      "Projector",
      "Drone"
    ];

    List<Vendor> sampleVendors = [
      Vendor.create(name: "Vendor A", id: "VENDOR-001"),
      Vendor.create(name: "Vendor B", id: "VENDOR-002"),
      Vendor.create(name: "Vendor C", id: "VENDOR-003"),
    ];

    Person samplePerson = Person(name: "John Doe");
    Units buyingUnit = Units(isBuyingUnits: true)..unit = "Piece";
    Units sellingUnit = Units(isBuyingUnits: false)..unit = "Piece";

    for (int i = 0; i < 20; i++) {
      String id = "item_${i + 1}";
      String desc = itemDescriptions[random.nextInt(itemDescriptions.length)];
      List<Vendor> vendors = [
        sampleVendors[random.nextInt(sampleVendors.length)]
      ]; // Random vendor
      // int inOrder = random.nextInt(100);
      int stockQuantity = random.nextInt(50);
      DateTime? lastCheckDate =
          DateTime.now().subtract(Duration(days: random.nextInt(30)));
      double unitPrice = (random.nextInt(500) + 1).toDouble();
      double inventoryValue = unitPrice * stockQuantity;
      String orderStatus = random.nextBool() ? "Pending" : "Completed";
      Person? lastUpdated = samplePerson;

      final Stock stockItem = Stock(
          product: Product(
            stockingUnit: "Box",
            id: id,
            desc: desc,
            vendors: vendors,
            unitPrice: unitPrice,
            orderStatus: orderStatus,
            lastUpdated: lastUpdated,
            buyingUnits: buyingUnit,
            sellingUnits: sellingUnit,
          ),
          stockQuantity: stockQuantity,
          inventoryValue: inventoryValue,
          lastCheckDate: lastCheckDate);
      items.add(stockItem);
    }

    return items;
  }
}
