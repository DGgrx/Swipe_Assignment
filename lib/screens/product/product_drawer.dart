import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/form_field.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  List<String> colors = ["Product", "Cargo", "Food"];
  String dropdownVal = "Food";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // mainAxisAlignment: s
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Please enter the details of the product that you want to add"),
          ),
          CustomFormField(
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
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 8, 0),
            child: Text(
              "Product Type:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              hint: const Text("Product Type"),
              icon: const Icon(Icons.list),
              elevation: 1,
              value: dropdownVal,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownVal = value!;
                });
              },
              items: colors
                  .map((e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ))
                  .toList(),
            ),
          ),
          Row(
            children: [
              Flexible(
                child: CustomFormField(
                    label: "Price",
                    hintText: "100.00",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name.';
                      }
                      return null;
                    },
                    inputType: TextInputType.number,
                    leadingIcon: const Icon(Icons.currency_rupee_rounded),
                    maxLength: 15,
                    inputFormatters: [
                      // FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ]),
              ),
              Flexible(
                child: CustomFormField(
                    label: "Tax",
                    hintText: "100.00",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value.';
                      } else if (int.parse(value) > 100) {
                        return "Enter value less than 100%";
                      }
                      return null;
                    },
                    inputType: TextInputType.number,
                    trailingIcon: const Icon(Icons.percent),
                    maxLength: 5,
                    inputFormatters: [
                      // FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ]),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {

                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Add Entry".toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
