import 'package:flutter/material.dart';
import 'package:inventory/core/models/product.dart';

class ProductProvider with ChangeNotifier {
  // List to hold products
  List<Product> _products = [];

  // Getter for the products list
  List<Product> get products => _products;

  // Initialize the Memory with products
  initializeProducts(List<Product> products) {
    _products = products;
  }

  /// Gets product with specified item description from the Memory
  /// Provide the full item description ' [productID] and [productName] '
  Product? getProductByItemDescription(String itemDescription) {
    try {
      return products.firstWhere(
          (product) => "${product.id} ${product.itemDesc}" == itemDescription);
    } catch (e) {
      return null;
    }
  }

  // Add a product
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners(); // Notify listeners that the product list has been updated
  }

  // Remove a product
  void removeProduct(String productId) {
    _products.removeWhere((product) => product.id == productId);
    notifyListeners(); // Notify listeners that the product list has been updated
  }

  // Update a product
  void updateProduct(String productId, Product updatedProduct) {
    int index = _products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners(); // Notify listeners that the product has been updated
    }
  }

  // Create a new product and add it
  void createProduct(Product product) {
    addProduct(product);
  }

  // Method to find a product by ID
  Product? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } on StateError {
      return null;
    }
  }

  // Fetch products (simulate fetching from API or database)
  Future<void> fetchProducts() async {
    // Simulate fetching data from an API or database
    await Future.delayed(Duration(seconds: 2));

    // Example data, replace with real fetching logic
    // _products =

    notifyListeners(); // Notify listeners that products have been fetched

    throw UnimplementedError();
  }
}
