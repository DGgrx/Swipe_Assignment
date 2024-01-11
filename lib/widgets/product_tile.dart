import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile(
      {required this.imageUrl,
      required this.price,
      required this.productName,
      required this.productType,
      required this.tax,
      super.key});

  final String imageUrl;
  final double price;
  final String productName;
  final String productType;
  final double tax;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      shape: Theme.of(context).cardTheme.shape,
      elevation: 1,
      child: Row(
        children: [
          imageUrl.isEmpty
              ? Icon(
                  Icons.image,
                  size: 130,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.15),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 100,
                        minHeight: 100,
                        maxWidth: 100,
                        maxHeight: 100,
                      ),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text("Type: $productType")),
                      // Spacer(),
                      Flexible(
                        child: Text(
                          "Tax: ${tax.toStringAsFixed(2)}%",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
