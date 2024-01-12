import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe/db/dao/product_dao.dart';
import 'package:swipe/db/entity/product.dart' as E;
import 'package:swipe/screens/product/repo/product_repo.dart';
import '../../../common/navigator.dart';
import '../../../common/routing.dart';
import '../../../db/database/app_database.dart';
import '../../../models/product.dart';
import '../../../widgets/dialog_box.dart';

class ProductVm extends ChangeNotifier {
  /// These are to access the local Database that is created for Caching.
  late final AppDatabase database;
  late final ProductDao productDao;

  ProductsRepo prodRepo = ProductsRepo();

  List<Product> products = [];
  List<E.Product> cachedProds = [];

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

  /// This is a [GET] Request to the repo which makes the API call and returns a
  /// List<Product> parsed from the JSON.
  void getProducts() async {
    isLoading = true;
    try {
      products = await prodRepo.getProducts();
    } catch (e) {
      showDialogBox(e.toString().substring(11));
    }
    isLoading = false;
  }

  /// This call is a data initialisation call when the app is first loaded.
  void initCall() async {
    try {
      products = await prodRepo.getProducts();
    } catch (e) {
      showToast("Data was unable to Load. Showing cached results.");
    }

    database =
        await $FloorAppDatabase.databaseBuilder('productDatabase.db').build();
    productDao = database.productDao;

    /// This will access the database for Cached values in the DB. If the API call
    /// fails and the product list is empty we check the Cached Database. If is also
    /// populated then we will populate our products List.
    if (products.isEmpty) {
      int? val = await productDao.countEntries();

      if (val != null || val != 0) {
        cachedProds = await productDao.findAllProducts();

        for (var prod in cachedProds) {
          products.add(Product.fromEntity(prod));
        }
      }
    }

    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(NavigationService.navigatorKey.currentContext!,
            rootNavigator: true)
        .pushReplacement(Routes.landingScreen());

    isLoading = false;
  }

  /// This will refresh the Cache Memory by first clearing it from all the old
  /// entries and then re-filling them with new ones.
  ///
  /// For the innate purpose of our application at this scale, an assumption is
  /// made that since only [50 entries] are in the entire database this action
  /// would not be at all expensive and would not affect the performance of our
  /// app.
  void refreshCacheMem() async {
    if (products.isNotEmpty) {
      int? num = await productDao.deleteAll();
      if (kDebugMode) {
        print("$num entries deleted from Database.");
      }
      List<E.Product> list = [];
      for (var prod in products) {
        list.add(E.Product(
          price: prod.price!,
          image: prod.image,
          productName: prod.productName!,
          productType: prod.productType!,
          tax: prod.tax!,
        ));
      }
      await productDao.insertAllProducts(list);
    }
  }

  List<Product> searchResults = [];
  TextEditingController searchTextController = TextEditingController();

  bool _isSearching = false;

  bool get isSearching => _isSearching;

  set isSearching(bool val) {
    _isSearching = val;
    notifyListeners();
  }

  void onSearchTextChanged(String text) {
    print("Function CALLLEDD !!! ");
    print("search String: $text");
    searchResults.clear();
    if (text.isEmpty) {
      notifyListeners();
      return;
    }

    for (var product in products) {
      if (product.productName!.toLowerCase().contains(text.toLowerCase())) {
        searchResults.add(product);
      }
    }

    print(searchResults);

    notifyListeners();
  }

  /// This function makes a call to the Repo to open the Image picker and return
  /// the selected Images.
  List<File?> images = [];

  void pickImage(BuildContext context) async {
    images = await prodRepo.imagePicker(ImageSource.gallery);
    notifyListeners();
  }

  /// To show a Loader on the Modal Screen after the uploading has started
  bool _isModalLoading = false;

  bool get isModalLoading => _isModalLoading;

  set isModalLoading(bool val) {
    _isModalLoading = val;
    notifyListeners();
  }

  void clearData() {
    images = [];
    prodNameController.text = "";
    taxController.text = "";
    priceController.text = "";
  }

  /// This makes a [POST] API call form the repo and uploads the Product details
  /// to the server.
  void uploadData() async {
    isModalLoading = true;
    try {
      await prodRepo.uploadProductData(
        images,
        productName: prodNameController.text,
        productType: prodTypeVal,
        price: priceController.text,
        tax: taxController.text,
      );
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
      clearData();
      // This is just for smoother animation.
      await Future.delayed(const Duration(seconds: 1));
      await showDialogBox("The Data was uploaded Successfully");
      getProducts();
    } catch (e) {
      showDialogBox(e.toString().substring(11));
    }
    isModalLoading = false;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0);
  }
}
