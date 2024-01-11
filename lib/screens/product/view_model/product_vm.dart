import 'package:flutter/material.dart';
import 'package:swipe/screens/product/repo/product_repo.dart';

import '../../../models/product.dart';

class ProductVm extends ChangeNotifier {

  ProductsRepo prodRepo = ProductsRepo();

  List<Product> products = [];

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void getProducts() async {
    isLoading = true;
    products = await prodRepo.getProducts();
    isLoading = false;
    print(products);
    print(products.length);
  }

  void initCall()async{
    products = await prodRepo.getProducts();
    isLoading = false;
    // notifyListeners();
  }

}