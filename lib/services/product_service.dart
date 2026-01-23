import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService {

  final base = "https://api.escuelajs.co/api/v1";

  Future<List<Product>> getProducts({int page = 0, int limit = 20}) async {

    //page = 0, offset = 0 * 20 = 0, (page * limit)
    //page = 1, offset = 1 * 20 = 20, (page * limit)
    //page = 2, offset = 2 * 20 = 40, (page * limit)

    int offset = page * limit;

    final url = "$base/products?offset=$offset&limit=$limit";
    http.Response response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        return compute(productFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }
}
