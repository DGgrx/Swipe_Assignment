import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe/screens/product/repo/product_repo.dart';
import '../../../models/product.dart';

class ProductVm extends ChangeNotifier {

  ProductsRepo prodRepo = ProductsRepo();

  List<Product> products = [];

  /// This part is responsible for showing the loader screen while the data is
  /// loading. Just set the [_isLoading] to true use the [_isLoading] from the
  /// Provider as a boolean to load either the required content on the screen or
  /// to show the loader while the data is fetched.
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }


  /// This is a call to the repo which makes the API call and returns a
  /// List<Product> parsed from the JSON.
  void getProducts() async {
    isLoading = true;
    products = await prodRepo.getProducts();
    isLoading = false;
  }

  /// This call is a data initialisation call when the app is first loaded.
  void initCall()async{
    products = await prodRepo.getProducts();
    isLoading = false;
  }

  /// This function makes a call to the Repo to open the Image picker and return
  /// the selected Images.
  List<File?> images = [];
  void pickImage(BuildContext context)async{
    images = await prodRepo.imagePicker(ImageSource.gallery);
    notifyListeners();
  }

}