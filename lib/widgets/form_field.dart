import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swipe/common/constants.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key,
      required this.contr,
      required this.hintText,
      required this.label,
      required this.validator,
      required this.inputType,
      this.leadingIcon,
      this.trailingIcon,
      required this.maxLength,
      this.inputFormatters});

  final TextEditingController contr;
  final String hintText;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final Icon? leadingIcon;
  final Icon? trailingIcon;
  final int maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingGeneric,
      child: TextFormField(
        controller: contr,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: leadingIcon,
          suffixIcon: trailingIcon,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: border10,
          ),
          label: Text(label),
          hintText: hintText,
        ),
        maxLength: maxLength,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
