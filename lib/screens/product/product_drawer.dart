import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe/common/loader.dart';
import 'package:swipe/network_service.dart';
import 'package:swipe/screens/product/view_model/product_vm.dart';
import 'package:swipe/widgets/selected_image.dart';

import '../../common/constants.dart';
import '../../widgets/form_field.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductVm, ConnectivityStatus>(
      builder: (context, prodVm, netStat, _) {
        return prodVm.isModalLoading
            ? const SizedBox(height: 200, child: Center(child: Loader()))
            : Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: s
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 8.0),
                      child: Text(
                        "Please enter the details of the product that you want to add",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),

                    /// This FormField if for taking in the Name of the Product
                    CustomFormField(
                      contr: prodVm.prodNameController,
                      label: "Product Name",
                      hintText: "iPhone 15",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name.';
                        } else if (value.length > 100) {
                          return 'Name too long.';
                        }
                        return null;
                      },
                      inputType: TextInputType.text,
                      leadingIcon: const Icon(Icons.abc_rounded),
                      maxLength: 100,
                    ),

                    /// The subsequent DropDown menu offers the user to select from a list
                    /// of ProductType. This can be updated in the future. Or can be fetched
                    /// from the server.
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 8, 8, 0),
                      child: Text(
                        "Product Type:",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: paddingGeneric,
                      child: DropdownButtonFormField(
                        icon: const Icon(Icons.list),
                        elevation: 1,
                        value: prodVm.prodTypeVal,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: border10)),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            prodVm.prodTypeVal = value!;
                          });
                        },
                        items: prodVm.prodType
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                      ),
                    ),

                    /// These 2 FormFields take in the [Selling Price] as well as the [Tax Rate]
                    /// of the products.
                    ///
                    /// - I have set the [tax Rate] check to ensure that it is below 100. The price
                    /// can be anything. Just that the input length is restricted to 15 digits.
                    Row(
                      children: [
                        Flexible(
                          child: CustomFormField(
                            contr: prodVm.priceController,
                            label: "Price",
                            hintText: "100.00",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter name.';
                              }
                              return null;
                            },
                            inputType: TextInputType.number,
                            leadingIcon:
                                const Icon(Icons.currency_rupee_rounded),
                            maxLength: 15,
                            inputFormatters: [decimalCheck],
                          ),
                        ),
                        Flexible(
                          child: CustomFormField(
                            contr: prodVm.taxController,
                            label: "Tax",
                            hintText: "100.00",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value.';
                              } else if (double.parse(value) > 100) {
                                return "Enter value less than 100%";
                              }
                              return null;
                            },
                            inputType: TextInputType.number,
                            trailingIcon: const Icon(Icons.percent),
                            maxLength: 5,
                            inputFormatters: [decimalCheck],
                          ),
                        ),
                      ],
                    ),

                    ///This container is an [ImagePicker] and also previews the images that are picked
                    ///by the image picker.
                    Container(
                      margin: paddingGeneric,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: border10,
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: InkWell(
                        /// If the images are already picked and our List<File?> is not empty
                        /// Then I don't want the user to accidentally click on the background
                        /// container and go to the [ImagePicker] screen again. So this is to
                        /// prevent that.
                        onTap: prodVm.images.isEmpty
                            ? () {
                                prodVm.pickImage(context);
                              }
                            : () {},
                        child: Center(
                          child: prodVm.images.isEmpty
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "Add Image (Optional)",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(8),
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        1, // number of items in each row
                                    mainAxisSpacing:
                                        8.0, // spacing between rows
                                    crossAxisSpacing:
                                        8.0, // spacing between columns
                                  ),
                                  itemCount: prodVm.images.length,
                                  itemBuilder: (context, index) {
                                    return SelectedImage(
                                      image: prodVm.images[index]!,
                                      index: index,
                                      callback: () {
                                        prodVm.images.removeAt(index);
                                        setState(() {});
                                      },
                                    );
                                  }),
                        ),
                      ),
                    ),

                    /// This button validates the [FormData] from it's current State and also
                    /// calls the method to [POST] the data to the API. The API call is made by
                    /// the [ViewModel].
                    netStat == ConnectivityStatus.Offline
                        ? const Text(
                            "Please connect to the internet.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          )
                        : Container(),
                    Padding(
                      padding: paddingGeneric,
                      child: ElevatedButton(
                        onPressed: netStat == ConnectivityStatus.Offline
                            ? null
                            : () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  prodVm.uploadData();
                                }
                              },
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(3),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.onSecondary)),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            "Add Entry".toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}
