import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swipe/models/product.dart';

class ProductsRepo {
  Future<List<Product>> getProducts() async {
    final response =
        await http.get(Uri.parse('https://app.getswipe.in/api/public/get'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      List<Product> prods = [];
      for (var p in jsonDecode(response.body)) {
        prods.add(Product.fromJson(p));
      }
      return prods;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load products');
    }
  }
}
