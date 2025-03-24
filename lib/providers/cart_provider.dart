import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Total count of items in the cart
  int get cartItemCount {
    return _cartItems.fold<int>(
      0, // Initial value as an int
          (sum, item) => sum + (item['quantity'] as int? ?? 0), // Safely handle nulls
    );
  }

  // Get count of a specific item in the cart
  int getItemCount(int itemId) {
    final item = _cartItems.firstWhere(
          (item) => item['id'] == itemId,
      orElse: () => <String, dynamic>{},
    );
    return item != null ? (item['quantity'] as int? ?? 0) : 0; // Handle null case
  }


  // Add item to cart with optional quantity
  void addItem(Map<String, dynamic> item, {int quantity = 1}) {
    final index = _cartItems.indexWhere((cartItem) => cartItem['id'] == item['id']);
    if (index != -1) {
      _cartItems[index]['quantity'] += quantity;
    } else {
      _cartItems.add({...item, 'quantity': quantity});
    }
    notifyListeners();
  }

  // Remove an item by its ID
  void removeItem(int itemId) {
    _cartItems.removeWhere((item) => item['id'] == itemId);
    notifyListeners();
  }

  // Get total amount for all items in the cart
  double getTotalAmount() {
    return _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  // Clear all items from the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
