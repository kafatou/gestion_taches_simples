import 'package:flutter/material.dart';
import 'package:gestion_taches/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.fieldName,
    this.inputType,
    this.prefixIcon,
    this.suffixIcon, this.readOnly, this.onTap,
  });

  final TextEditingController controller;
  final String fieldName;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final bool? readOnly;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColor),
    );
    return TextFormField(
      readOnly: readOnly ?? false,
      onTap: onTap,
      cursorColor: primaryColor,
      controller: controller,
      keyboardType: inputType ?? TextInputType.text,
      decoration: InputDecoration(
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        labelText: fieldName,
        labelStyle: secondaryTextStyle(
          color: black,
          size: 14,
          weight: FontWeight.w400,
          height: 20,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
