import 'package:flutter/material.dart';

class DsTextField extends StatelessWidget {
  const DsTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.helperText,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    this.enabled = true,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final String? helperText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final bool obscureText;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    validator: validator,
    enabled: enabled,
    obscureText: obscureText,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    onFieldSubmitted: onFieldSubmitted,
    autofillHints: autofillHints,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(labelText: label, helperText: helperText),
  );
}
