import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const String _baseUrl = "https://api.escuelajs.co/api/v1";

  Future<List<Product>> getProducts({
    required int page, 
    int limit = 10, 
    String categoryId = "-1"
  }) async {
    try {
      String endpoint;
      int offset = page * limit;

      // Logic: If ID is -1, fetch ALL. Else, fetch specific Category.
      if (categoryId == "-1" || categoryId == "0") {
        endpoint = "$_baseUrl/products?offset=$offset&limit=$limit";
      } else {
        endpoint = "$_baseUrl/categories/$categoryId/products?offset=$offset&limit=$limit";
      }

      final uri = Uri.parse(endpoint);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}