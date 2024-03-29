import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe/common/constants.dart';
import 'package:swipe/common/loader.dart';
import 'package:swipe/screens/product/product_drawer.dart';
import 'package:swipe/screens/product/view_model/product_vm.dart';
import 'package:swipe/theme/view_model/theme_vm.dart';
import 'package:swipe/widgets/product_tile.dart';
import '../../models/product.dart';
import '../../network_service.dart';
import '../../widgets/expandable_fab.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProductVm, ConnectivityStatus, DarkThemeVm>(
      builder: (context, productVm, netStat, darkThemeVm, _) {
        List<Product> products = productVm.products;

        List<Product> list =
            productVm.isSearching ? productVm.searchResults : products;

        return Scaffold(
          body: GestureDetector(
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
                    Focus(
                      onFocusChange: (val){
                        productVm.isSearching = val;
                      },
                      child: SearchBar(
                        onSubmitted: (val){
                          productVm.searchTextController.clear();
                        },
                        controller: productVm.searchTextController,
                        hintText: "Search",
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.onSecondary),
                        elevation: MaterialStateProperty.all(2),
                        leading: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          productVm.onSearchTextChanged(value);
                        },
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
                                netStat == ConnectivityStatus.Offline
                                    ? productVm.showToast(
                                        "You are not Connected to the internet.")
                                    : productVm.getProducts();

                                /// This will update the cache
                                if (productVm.products.isNotEmpty) {
                                  productVm.refreshCacheMem();
                                }
                                await Future.delayed(Duration.zero);
                              },
                              child: products.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(50.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            "No products to show",
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                netStat ==
                                                        ConnectivityStatus
                                                            .Offline
                                                    ? productVm.showToast(
                                                        "You are not Connected to the internet.")
                                                    : productVm.getProducts();

                                                /// This will update the cache
                                                if (productVm
                                                    .products.isNotEmpty) {
                                                  productVm.refreshCacheMem();
                                                }
                                              },
                                              child: const Text("Refresh Data"))
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: list.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ProductTile(
                                          imageUrl: list[index].image!,
                                          price: list[index].price!,
                                          productName: list[index].productName!,
                                          productType: list[index].productType!,
                                          tax: list[index].tax!,
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
            padding: paddingGeneric,
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
                      return const Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Wrap(
                          children: [ProductForm()],
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
