import 'package:floor/floor.dart';

@entity
class Product {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? image;
  final double price;
  final String productName;
  final String productType;
  final double tax;

  Product(
      {this.id,
      this.image,
      required this.price,
      required this.productName,
      required this.productType,
      required this.tax});
}
