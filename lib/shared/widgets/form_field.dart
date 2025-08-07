import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final String label;
  final Function(String) onChanged;
  final String? initialValue;
  final TextInputType? keyboardType;
  final int? maxLines;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
