import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  List<String> _items = [];
  bool _isLoading = false;

  List<String> get items => _items;
  bool get isLoading => _isLoading;

  int get totalPrice => _items.length * 42;

  void add(String item) async {
    _isLoading = true;
    _items.add(item);
    _isLoading = false;
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
