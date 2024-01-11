import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe/common/loader.dart';
import 'package:swipe/screens/product/view_model/product_vm.dart';
import 'package:swipe/theme/view_model/theme_vm.dart';
import 'package:swipe/widgets/product_tile.dart';
import '../../models/product.dart';
import '../../widgets/expandable_fab.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(ProductListScreen._actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ProductVm>(context, listen: false).initCall();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductVm, DarkThemeVm>(
      builder: (context, productVm, darkThemeVm, _) {
        List<Product> products = productVm.products;

        return Scaffold(
          appBar: AppBar(
            // centerTitle: true,
            title: Text("Swipe"),
          ),
          body: productVm.isLoading
              ? const Loader()
              : ListView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ProductTile(
                      imageUrl: products[index].image!,
                      price: products[index].price!,
                      productName: products[index].productName!,
                      productType: products[index].productType!,
                      tax: products[index].tax!,
                    );
                  }),
          floatingActionButton: ExpandableFab(
            distance: 80,
            children: [
              ActionButton(
                onPressed: () => _showAction(context, 0),
                icon: const Icon(Icons.add),
              ),
              ActionButton(
                onPressed: () => darkThemeVm.toggleTheme(),
                icon: const Icon(Icons.brightness_5),
              ),
            ],
          ),
        );
      },
    );
  }
}
