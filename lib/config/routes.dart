import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/features/inventory/presentation/screens/add_inventory_screen.dart';
import 'package:inventory/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:inventory/features/invoice/presentation/screens/invoice_screen.dart';

class AppRoutes {
  // inventory dashboard
  static const String dashboard = "/dashboard";
  static const String add = "/dashboard/add";
  static const String purchaseInvoice = "/invoice/purchase";
  static const String salesInvoice = "/invoice/sales";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      switch (settings.name) {
        case dashboard:
          return InventoryDashboardScreen();
        case add:
          return AddInventoryScreen();
        case salesInvoice:
          return InvoiceScreen(Invoice.sales());
        case purchaseInvoice:
          return InvoiceScreen(Invoice.purchase());
        default:
          return Placeholder();
      }
    });
  }
}
