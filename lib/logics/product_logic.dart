import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductLogic extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  bool _loading = false;
  bool get loading => _loading;

  String _catId = "-1"; // Filter: Category
  String get catId => _catId;
  
  // NEW: Store Price Filters so they don't disappear when scrolling
  int? _minPrice; 
  int? _maxPrice;

  bool _hasMoreRecords = true;
  bool get hasMoreRecords => _hasMoreRecords;
  String? _error; 
  String? get error => _error;

  final _service = ProductService();
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
    _minPrice = null; // Clear price on category reset too
    _maxPrice = null;
    notifyListeners();
  }

  Future readProductPagination({
    bool refresh = false, 
    int? minPrice, 
    int? maxPrice
  }) async {
    // 1. If new filters are passed, SAVE THEM. If not, keep old ones.
    if (minPrice != null) _minPrice = minPrice;
    if (maxPrice != null) _maxPrice = maxPrice;

    if (refresh) {
      _page = 0;
      _products = [];
      _hasMoreRecords = true;
      _error = null;
    }

    if (!_hasMoreRecords && !refresh) return;

    if (refresh || _page == 0) {
      _loading = true;
      notifyListeners();
    }

    try {
      // 2. Use the SAVED filters (_minPrice, _maxPrice)
      List<Product> newlist = await _service.getProducts(
        page: _page, 
        limit: _limit, 
        categoryId: _catId,
        minPrice: _minPrice, 
        maxPrice: _maxPrice
      );

      if (newlist.isEmpty) {
        if (_products.isEmpty) {
          debugPrint("Logic: No data returned.");
        }
        _hasMoreRecords = false;
      } else {
        _products.addAll(newlist);
        _page++;
        if (newlist.length < _limit) _hasMoreRecords = false;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint("Logic Error: $_error");
    }

    _loading = false;
    notifyListeners();
  }
}