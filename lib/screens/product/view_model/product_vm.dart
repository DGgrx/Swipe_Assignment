import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe/db/entity/product.dart' as A;
import 'package:swipe/screens/product/repo/product_repo.dart';
import '../../../common/navigator.dart';
import '../../../db/database/app_database.dart';
import '../../../models/product.dart' as B;

class ProductVm extends ChangeNotifier {
  late final database;
  late final productDao;

  ProductsRepo prodRepo = ProductsRepo();

  List<B.Product> products = [];

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

  List<String> prodType = ["Product", "Cargo", "Food"];

  TextEditingController prodNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  String prodTypeVal = "Product";

  /// This is a call to the repo which makes the API call and returns a
  /// List<Product> parsed from the JSON.
  void getProducts() async {
    isLoading = true;
    try {
      products = await prodRepo.getProducts();
    } catch (e) {
      showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            content: Center(child: Text(e.toString())),
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
    isLoading = false;
  }

  /// This call is a data initialisation call when the app is first loaded.
  void initCall() async {
    products = await prodRepo.getProducts();

    //TODO- This code will be implemented in the Splash Screen as this logic belongs there
    database =
        await $FloorAppDatabase.databaseBuilder('productDatabase.db').build();
    productDao = database.productDao;
    // int? num = await productDao.deleteAll();
    // print(num);
    // List<A.Product> list = [];
    // for (var prod in products) {
    //   list.add(A.Product(
    //     price: prod.price!,
    //     image: prod.image,
    //     productName: prod.productName!,
    //     productType: prod.productType!,
    //     tax: prod.tax!,
    //   ));
    // }
    // await productDao.insertAllProducts(list);
    // print(await productDao.isEmpty());
    // print(await productDao.countEntries());

    // TODO - This can be used for searching
    // dynamic list = await productDao.getProductByName("ice%");
    // print(list.length);

    isLoading = false;
  }

  /// This function makes a call to the Repo to open the Image picker and return
  /// the selected Images.
  List<File?> images = [];

  void pickImage(BuildContext context) async {
    images = await prodRepo.imagePicker(ImageSource.gallery);
    notifyListeners();
  }

  bool _isModalLoading = false;

  bool get isModalLoading => _isModalLoading;

  set isModalLoading(bool val) {
    _isModalLoading = val;
    notifyListeners();
  }

  void uploadData() async {
    // print(prodNameController.text);
    // print(prodTypeVal);
    // print(priceController.text);
    // print(taxController.text);
    // print(images[0]!.path);
    isModalLoading = true;
    // dynamic response = await prodRepo.uploadProductData(
    //   images,
    //   productName: prodNameController.text,
    //   productType: prodTypeVal,
    //   price: priceController.text,
    //   tax: taxController.text,
    // );
    try {
      await Future.delayed(Duration(seconds: 5));
      throw Exception("hello");
    } catch (e) {
      showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            content: Center(child: Text(e.toString())),
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
    isModalLoading = false;
    // print(response);
  }
}
