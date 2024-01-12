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

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['image'] = this.image;
//   data['price'] = this.price;
//   data['product_name'] = this.productName;
//   data['product_type'] = this.productType;
//   data['tax'] = this.tax;
//   return data;
// }
}
