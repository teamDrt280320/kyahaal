import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kyahaal/utils/constants.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    this.textInputAction,
    this.label,
    this.prefixText,
    this.keyboardType,
    this.autofillHints,
    this.maxLength,
    this.obscureText = false,
    this.validator,
    required this.controller,
    this.onSubmit,
  }) : super(key: key);

  final TextInputAction? textInputAction;
  final String? label;
  final String? prefixText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final int? maxLength;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Function(String)? onSubmit;

  OutlineInputBorder outlineInputBorder(
      {Color borderColor = brandBlack, double borderWidth = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmit,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      cursorColor: brandBlack,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength)
      ],
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelStyle: Get.textTheme.bodyText1?.copyWith(color: brandBlack),
        prefixText: prefixText,
        labelText: label,
        border: outlineInputBorder(),
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorder(borderWidth: 2),
        errorBorder: outlineInputBorder(borderColor: Colors.red),
        focusedErrorBorder:
            outlineInputBorder(borderWidth: 2, borderColor: Colors.red),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
