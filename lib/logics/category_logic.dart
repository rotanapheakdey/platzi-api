import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryLogic extends ChangeNotifier {
  List<Cat> _cats = [];
  List<Cat> get cats => _cats;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> read() async {
    _loading = true;
    notifyListeners();

    try {
      var url = Uri.parse("https://api.escuelajs.co/api/v1/categories");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        _cats = data.map((e) => Cat.fromJson(e)).toList();
        // Add "All" button manually at the start
        _cats.insert(0, Cat(id: -1, name: "All", image: ""));
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }

    _loading = false;
    notifyListeners();
  }
}