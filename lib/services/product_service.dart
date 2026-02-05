import 'dart:convert';
import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const String _baseUrl = "https://api.escuelajs.co/api/v1";

  // ... imports

  Future<List<Product>> getProducts({
    required int page, 
    int limit = 10, 
    String categoryId = "-1",
    int? minPrice, 
    int? maxPrice
  }) async {
    try {
      int offset = page * limit;
      String endpoint = "$_baseUrl/products?offset=$offset&limit=$limit";

      if (categoryId != "-1" && categoryId != "0") {
        endpoint = "$_baseUrl/categories/$categoryId/products?offset=$offset&limit=$limit";
      }

      // ... price logic ...

      debugPrint("API CALL: $endpoint"); // <--- LOOK FOR THIS IN CONSOLE

      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        debugPrint("API ERROR: ${response.statusCode} - ${response.body}"); // <--- OR THIS
        return [];
      }
    } catch (e) {
      debugPrint("NETWORK CRASH: $e"); // <--- OR THIS
      return [];
    }
  }
}