import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key,
      required this.hintText,
      required this.label,
      required this.validator,
      required this.inputType,
      this.leadingIcon,
      this.trailingIcon,
      required this.maxLength,
      this.inputFormatters});

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
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: leadingIcon,
          suffixIcon: trailingIcon,
          counterText: "",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
