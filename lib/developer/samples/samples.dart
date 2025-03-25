import 'dart:math';

import 'package:inventory/database/item.dart';
import 'package:inventory/database/person.dart';
import 'package:inventory/database/units.dart';
import 'package:inventory/database/parties/vendor.dart';

class Samples {
  static List<Item> generate() {
    List<Item> items = [];
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
      String groupId = "group_${random.nextInt(5) + 1}";
      String desc = itemDescriptions[random.nextInt(itemDescriptions.length)];
      List<Vendor> vendors = [
        sampleVendors[random.nextInt(sampleVendors.length)]
      ]; // Random vendor
      int inOrder = random.nextInt(100);
      int stockQuantity = random.nextInt(50);
      DateTime? lastCheckDate =
          DateTime.now().subtract(Duration(days: random.nextInt(30)));
      double unitPrice = (random.nextInt(500) + 1).toDouble();
      double inventoryValue = unitPrice * stockQuantity;
      String orderStatus = random.nextBool() ? "Pending" : "Completed";
      Person? lastUpdated = samplePerson;

      Item item = Item(
        id: id,
        groupId: groupId,
        desc: desc,
        vendors: vendors,
        inOrder: inOrder,
        stockQuantity: stockQuantity,
        lastCheckDate: lastCheckDate,
        unitPrice: unitPrice,
        inventoryValue: inventoryValue,
        orderStatus: orderStatus,
        lastUpdated: lastUpdated,
        buyingUnits: buyingUnit,
        sellingUnits: sellingUnit,
      );
      items.add(item);
    }

    return items;
  }
}
