import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductLogic extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  bool _loading = false;
  bool get loading => _loading;

  String _catId = "-1";
  String get catId => _catId;

  bool _hasMoreRecords = true;
  bool get hasMoreRecords => _hasMoreRecords;

  final _service = ProductService(); // Uses the new service!
  int _page = 0;
  final int _limit = 10;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  void setCatId(int id) {
    _catId = id.toString();
    notifyListeners();
  }

  void resetCatId() {
    _catId = "-1";
    notifyListeners();
  }

  Future readProductPagination({bool refresh = false}) async {
    if (refresh) {
      _page = 0;
      _products = [];
      _hasMoreRecords = true;
    }

    if (!_hasMoreRecords && !refresh) return;

    if (refresh) _loading = true;
    notifyListeners();

    // Call the Service
    List<Product> newlist = await _service.getProducts(
      page: _page, 
      limit: _limit, 
      categoryId: _catId
    );

    if (newlist.isEmpty) {
      _hasMoreRecords = false;
    } else {
      _products.addAll(newlist);
      _page++;
      if (newlist.length < _limit) _hasMoreRecords = false;
    }

    _loading = false;
    notifyListeners();
  }
}