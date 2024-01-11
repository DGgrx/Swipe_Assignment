import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe/screens/product/repo/product_repo.dart';
import 'package:swipe/theme/view_model/theme_vm.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  ProductsRepo prodRepo = ProductsRepo();

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeVm>(
      builder: (context,darkThemeVm,_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Swipers"),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: (){
                prodRepo.getProducts();
              }, child: Text("Get Data"),
            ),
          ),
          floatingActionButton: IconButton(
            onPressed: () {
              darkThemeVm.darkTheme = !darkThemeVm.darkTheme;
            }, icon: Icon(Icons.brightness_5),
            
          ),
        );
      }
    );
  }
}
