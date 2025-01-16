import 'package:flutter/material.dart';
import 'package:inventory/screens/inventory_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryDashboard();
  }
}
