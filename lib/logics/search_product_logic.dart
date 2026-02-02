import 'package:flutter/material.dart';
import '../models/product_model.dart';
// import '../services/product_service.dart'; // Uncomment if using service

class SearchProductLogic extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  bool _loading = false;
  bool get loading => _loading;

  void clear() {
    _products = [];
    notifyListeners();
  }
  
  // Add search functionality here later
  Future<void> search(String query) async {
    _loading = true;
    notifyListeners();
    // Simulate search or call API
    await Future.delayed(const Duration(seconds: 1));
    _loading = false;
    notifyListeners();
  }
}