import 'package:swipe/db/entity/product.dart' as E;

class Product {
  final int? id;
  String? image;
  double? price;
  String? productName;
  String? productType;
  double? tax;

  Product(
      {this.id,
      this.image,
      required this.price,
      required this.productName,
      required this.productType,
      required this.tax});

  Product.fromJson(Map<String, dynamic> json, {this.id}) {
    image = json['image'];
    price = json['price'];
    productName = json['product_name'];
    productType = json['product_type'];
    tax = json['tax'];
  }

  Product.fromEntity(E.Product product, {this.id}) {
    image = product.image;
    productName = product.productName;
    productType = product.productType;
    price = product.price;
    tax = product.tax;
  }
}
