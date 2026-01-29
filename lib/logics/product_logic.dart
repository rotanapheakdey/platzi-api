import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductLogic extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _loading = false;
  bool get loading => _loading;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  final _service = ProductService();

  // Future readProduct() async {
  //   _products = await _service.getProducts();
  //   _loading = false;
  //   notifyListeners();
  // }

  int _page = 0;

  Future readProductPagination({bool refresh = false}) async {
    if (refresh) {
      _page = 0;
      _products = [];
    }

    List<Product> newlist = await _service.getProducts(page: _page);
    if (newlist.isNotEmpty) {
      _products += newlist;
      _page++;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> readCategories() async {
    try {
      var url = Uri.parse("https://api.escuelajs.co/api/v1/categories");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        _categories = data.map((e) => Category.fromJson(e)).toList();
        notifyListeners(); // Update UI when data arrives
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }
}
