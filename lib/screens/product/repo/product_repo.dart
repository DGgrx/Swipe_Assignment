import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe/models/product.dart';

class ProductsRepo {
  /// This is a [GET] request to the API
  Future<List<Product>> getProducts() async {
    final response =
        await http.get(Uri.parse('https://app.getswipe.in/api/public/get'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      List<Product> prods = [];
      for (var p in jsonDecode(response.body)) {
        prods.add(Product.fromJson(p));
      }
      return prods;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load products');
    }
  }

  /// This is a call to the System to [pick an Image] from the external Storage of the
  /// device.
  Future<List<File?>> imagePicker(ImageSource source) async {
    try {
      final List<XFile?> images = await ImagePicker().pickMultiImage();
      if (images.isEmpty) return [];
      List<File> files = [];
      for (var file in images) {
        files.add(await cropImage(File(file!.path)));
      }
      return files;
    } on PlatformException catch (e) {
      print(e);
    }
    return [];
  }

  /// Function to crop the images one by one, since the call is made inside
  /// a for loop that iterated through every image. Other approaches are
  /// also possible.
  Future<File> cropImage(File pickedImage) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image [1:1]',
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            hideBottomControls: true),
        IOSUiSettings(
          title: 'Crop Image [1:1]',
          rotateClockwiseButtonHidden: true,
          aspectRatioPickerButtonHidden: true,
          aspectRatioLockEnabled: true,
          rotateButtonsHidden: true,
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return File(pickedImage.path);
    }
  }

//TODO - Make an API call to [POST] the form data
}
