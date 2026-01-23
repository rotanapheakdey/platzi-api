import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductLogic extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

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
}
