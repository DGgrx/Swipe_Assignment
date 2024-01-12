import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe/common/loader.dart';
import 'package:swipe/screens/product/product_drawer.dart';
import 'package:swipe/screens/product/view_model/product_vm.dart';
import 'package:swipe/theme/view_model/theme_vm.dart';
import 'package:swipe/widgets/product_tile.dart';
import '../../models/product.dart';
import '../../widgets/expandable_fab.dart';
import '../../db/entity/product.dart' as A;

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // void _showAction(BuildContext context) {
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
  // }

  // TODO: Move this to Splash Screen.
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
          body: products.isEmpty
              ? const Center(child: Text("No Products to show"))
              : GestureDetector(
                  onTap: () {
                    /// This is to pop the focus of the search bar and close all the
                    /// keyboards open.
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SearchBar(
                            hintText: "Search",
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.onSecondary),
                            elevation: MaterialStateProperty.all(2),
                            leading: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.search),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          productVm.isLoading
                              ? const Column(
                                  children: [
                                    SizedBox(
                                      height: 300,
                                    ),
                                    Loader(),
                                  ],
                                )
                              : Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      /// Since our call is fire and forget. We have to include a delayed future
                                      /// of [0 seconds] to make our function return a Future for the
                                      /// [refreshIndicator] to work.
                                      productVm.getProducts();
                                      await Future.delayed(Duration.zero);
                                    },
                                    child: ListView.builder(
                                        itemCount: products.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return ProductTile(
                                            imageUrl: products[index].image!,
                                            price: products[index].price!,
                                            productName:
                                                products[index].productName!,
                                            productType:
                                                products[index].productType!,
                                            tax: products[index].tax!,
                                          );
                                        }),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpandableFab(
              distance: 80,
              children: [
                /// This actionButton will open the BottomModalSheet to add a new
                /// entry to the products.
                ActionButton(
                  onPressed: () => showModalBottomSheet(
                    showDragHandle: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Wrap(
                          children: [
                            ProductForm()
                          ],
                        ),
                      );
                    },
                  ),
                  icon: const Icon(Icons.add),
                ),

                /// This ActionButton Changes the current theme of the app from
                /// [Dark/Light] Mode.
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
              ],
            ),
          ),
        );
      },
    );
  }
}
