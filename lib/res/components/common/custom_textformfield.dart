import 'package:flutter/material.dart';

class CustomTextFormfield extends StatelessWidget {
  const CustomTextFormfield({
    super.key,
    this.controller,
    required this.fieldTitle,
    this.validator,  this.keyboardType,
  });
  final TextEditingController? controller;
  final String fieldTitle;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: fieldTitle,
      ),
    );
  }
}