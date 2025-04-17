import 'dart:math';

import 'package:inventory/core/models/pricing_list.dart';
import 'package:inventory/core/models/stock.dart';
import 'package:inventory/core/models/party.dart';
import 'package:inventory/core/models/product.dart';
import 'package:inventory/features/inventory/data/units.dart';
import 'package:inventory/features/inventory/presentation/providers/helper/buying_units.dart';
import 'package:inventory/features/inventory/presentation/providers/helper/selling_units.dart';

import 'package:inventory/services/product_service.dart';
import 'package:inventory/services/stock_service.dart';

class Samples {
  static List<Product> sampleProducts = [];
  static List<Stock> sampleStock = [];

  static Future<void> initializeSamples() async {
    sampleProducts = await ProductService.fetchProducts();
    sampleStock = await StockService.getStock();
  }

  static Future<void> generate() async {
    Random random = Random();

    List<Party> sampleVendors = [
      Party.vendor(name: "TechWorld Inc.", id: "TW-001", location: "USA"),
      Party.vendor(name: "Gizmo Solutions", id: "GS-002", location: "Canada"),
      Party.vendor(name: "ElectroHub", id: "EH-003", location: "UK"),
      Party.vendor(
          name: "SmartTech Traders", id: "ST-004", location: "Germany"),
    ];

    for (Party vendor in sampleVendors) {
      await vendor.insert();
    }

    for (int i = 0; i < 30; i++) {
      String productId = "PRD-${(10000 + i).toString()}";

      String desc = _getSampleDescription();
      String stockingUnit = _getStockingUnitFor(desc);
      int stockMeasure = _getRealisticStockMeasure(desc, stockingUnit);
      double unitPrice = _getRealisticPrice(desc, stockingUnit);
      double inventoryValue = unitPrice * stockMeasure;

      // Buying: Multiples of 5
      int buyingRelationship = _getMultipleOfFiveOrTen(5, 100);

      // Selling: +/- 0–5 from buying
      int sellingRelationship = buyingRelationship + _getSellingAdjustment();

      List<Party> vendors = [
        sampleVendors[random.nextInt(sampleVendors.length)],
        if (random.nextBool())
          sampleVendors[random.nextInt(sampleVendors.length)]
      ];

      DateTime? lastCheckDate =
          DateTime.now().subtract(Duration(days: random.nextInt(60)));

      final buyingUnit = Units<BuyingUnits>(isBuyingUnits: true)
        ..unit = stockingUnit == 'roll' ? "meter" : "item"
        ..relationshipBy = stockingUnit == 'roll'
            ? 'meter per roll'
            : stockingUnit == 'box'
                ? 'item per box'
                : 'item'
        ..relationship = buyingRelationship.toDouble();

      final sellingUnit = Units<SellingUnits>(isBuyingUnits: false)
        ..unit = stockingUnit == 'roll' ? "meter" : "item"
        ..relationshipBy = stockingUnit == 'roll'
            ? 'meter per roll'
            : stockingUnit == 'box'
                ? 'item per box'
                : 'item'
        ..relationship = sellingRelationship.toDouble();

      String category = _getCategory(desc, stockingUnit);

      final Product sampleProduct = Product.create(
        id: productId,
        desc: desc,
        category: category,
        unitPrice: unitPrice,
        buyingUnits: buyingUnit,
        sellingUnits: sellingUnit,
        pricingList: PricingList(),
        stockingUnit: stockingUnit,
      );

      await ProductService.addProduct(sampleProduct);
      sampleProducts.add(sampleProduct);

      final Stock stockItem = Stock(
        product: sampleProduct,
        stockMeasure: stockMeasure,
        inventoryValue: inventoryValue,
        lastCheckDate: lastCheckDate,
        id: null,
      );

      sampleStock.add(stockItem);
      await stockItem.update();
    }
  }

  static final List<String> rollProducts = [
    "Fiber Optic Cable Roll",
    "Carpet Roll - Grey 10m",
    "Vinyl Flooring Roll",
    "Electric Wire Roll 50m",
    "Plastic Wrap Roll",
    "Wallpaper Roll - Floral Design",
    "Rubber Seal Strip Roll",
    "Nylon Rope Roll 100m",
    "Irrigation Hose Roll",
    "Soundproof Foam Roll"
  ];

  static final List<String> quantityProducts = [
    "USB Cable Pack - 10pcs",
    "LED Bulb Box - 20pcs",
    "Screwdriver Set - 12 Tools",
    "Notebook Bundle - 5 Units",
    "Gaming Mouse - RGB",
    "Smartwatch Fitness Tracker",
    "Bluetooth Speaker Portable",
    "Office Chair - Ergonomic",
    "Wireless Keyboard",
    "Stapler Set - Office Use",
    "Ink Cartridge Multipack",
    "Wall Clock",
    "Desk Lamp",
    "Portable Hard Drive",
    "External SSD",
    "Phone Charger - 3 Pack"
  ];

  static String _getCategory(String desc, String stockingUnit) {
    if (stockingUnit == 'roll') {
      if (desc.contains("Cable") ||
          desc.contains("Wire") ||
          desc.contains("Rope")) {
        return "Cables & Wiring";
      } else if (desc.contains("Carpet") ||
          desc.contains("Vinyl") ||
          desc.contains("Wallpaper")) {
        return "Flooring & Coverings";
      } else if (desc.contains("Wrap") ||
          desc.contains("Foam") ||
          desc.contains("Seal")) {
        return "Packaging & Insulation";
      } else {
        return "Roll Goods";
      }
    } else {
      if (desc.contains("Cable") || desc.contains("Charger")) {
        return "Electronics Accessories";
      } else if (desc.contains("Bulb") ||
          desc.contains("Lamp") ||
          desc.contains("Clock")) {
        return "Lighting & Decor";
      } else if (desc.contains("Mouse") ||
          desc.contains("Keyboard") ||
          desc.contains("Speaker")) {
        return "Computer Peripherals";
      } else if (desc.contains("Chair") ||
          desc.contains("Stapler") ||
          desc.contains("Notebook")) {
        return "Office Supplies";
      } else if (desc.contains("Hard Drive") || desc.contains("SSD")) {
        return "Storage Devices";
      } else {
        return "General Goods";
      }
    }
  }

  static int _getMultipleOfFiveOrTen(int min, int max) {
    final random = Random();
    int step = 5;
    int range = ((max - min) ~/ step);
    return min + (random.nextInt(range + 1) * step);
  }

  static int _getSellingAdjustment() {
    final random = Random();
    return random.nextInt(11) - 5; // -5 to +5
  }

  static String _getSampleDescription() {
    final all = [...rollProducts, ...quantityProducts];
    return all[Random().nextInt(all.length)];
  }

  static String _getStockingUnitFor(String desc) {
    final isRoll = desc.toLowerCase().contains("roll");
    if (isRoll) return "roll";

    return Random().nextDouble() < 0.85 ? "box" : "item";
  }

  static int _getRealisticStockMeasure(String desc, String stockingUnit) {
    final random = Random();
    switch (stockingUnit) {
      case 'roll':
        return random.nextInt(91) + 10; // 10–100 meters
      case 'item':
        return random.nextInt(30) + 1; // 1–30 items
      case 'box':
      default:
        return random.nextInt(91) + 10; // 10–100 boxes
    }
  }

  static double _getRealisticPrice(String desc, String stockingUnit) {
    final random = Random();
    switch (stockingUnit) {
      case 'roll':
        return random.nextDouble() * 10 + 5; // $5–$15 per meter
      case 'item':
        return random.nextDouble() * 200 + 20; // $20–$220 per item
      case 'box':
      default:
        return random.nextDouble() * 100 + 30; // $30–$130 per box
    }
  }
}
