import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe/common/loader.dart';
import 'package:swipe/screens/product/product_drawer.dart';
import 'package:swipe/screens/product/view_model/product_vm.dart';
import 'package:swipe/theme/view_model/theme_vm.dart';
import 'package:swipe/widgets/product_tile.dart';
import '../../models/product.dart';
import '../../widgets/expandable_fab.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  void _showAction(BuildContext context, int index) {
    // showDialog<void>(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: Text(ProductListScreen._actionTitles[index]),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(),
    //           child: const Text('CLOSE'),
    //         ),
    //       ],
    //     );
    //   },
    // );

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              children: [ProductForm()],
            ),
          );
        });
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
            title: const Text("Swipe Assignment"),
            actions: [
              IconButton(
                  onPressed: () {
                    productVm.isSearching = true;
                  },
                  icon: Icon(Icons.search,
                      color: Theme.of(context).colorScheme.onTertiary)),
            ],
          ),
          body: productVm.isLoading
              ? const Loader()
              : products.isEmpty
                  ? const Center(child: Text("No Products to show"))
                  : GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            !productVm.isSearching
                                ? Container()
                                : SearchBar(
                                    elevation: MaterialStateProperty.all(1),
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.search),
                                    ),
                                    trailing: [
                                      IconButton(
                                          onPressed: () {
                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                            productVm.isSearching = false;
                                          },
                                          icon: Icon(Icons.close))
                                    ],
                                  ),
                            SizedBox(
                              height: !productVm.isSearching ? 0 : 10,
                            ),
                            Expanded(
                              child: ListView.builder(
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
                            ),
                          ],
                        ),
                      ),
                    ),
          floatingActionButton: ExpandableFab(
            distance: 80,
            children: [
              Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).colorScheme.secondary,
                elevation: 4,
                child: IconButton(
                  tooltip: 'Change brightness mode',
                  isSelected: darkThemeVm.darkTheme,
                  onPressed: darkThemeVm.toggleTheme,
                  color: Theme.of(context).colorScheme.onSecondary,
                  icon: const Icon(Icons.wb_sunny_outlined),
                  selectedIcon: const Icon(Icons.brightness_2_outlined),
                ),
              ),
              ActionButton(
                onPressed: () => _showAction(context, 0),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }
}
