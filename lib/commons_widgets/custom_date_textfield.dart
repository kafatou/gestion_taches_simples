import 'package:flutter/material.dart';
import 'package:gestion_taches/utils/colors.dart';
import 'package:gestion_taches/utils/date_time_utils.dart';
import 'custom_text_form_field.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class CustomDateTextfield extends StatelessWidget {
  const CustomDateTextfield({
    super.key,
    required this.controller,
    required this.fieldName,
    this.dateMax,
    this.dateMin,
  });

  final TextEditingController controller;
  final String fieldName;
  final DateTime? dateMax;
  final DateTime? dateMin;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      onTap: () {
        picker.DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: dateMin ?? DateTime(1920),
          maxTime: dateMax ?? DateTime(2099),
          theme: picker.DatePickerTheme(
            headerColor: primaryColor,
            backgroundColor: Colors.white,
            itemStyle: TextStyle(color: Colors.black),
            doneStyle: TextStyle(color: Colors.white),
            cancelStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (date) {
            controller.text = date.format();
          },
          currentTime: DateTime.now(),
          locale: picker.LocaleType.fr,
          onConfirm: (date) {
            controller.text = date.format();
          },
        );
      },
      suffixIcon: Icon(Icons.calendar_month, color: primaryColor),
      readOnly: true,
      controller: controller,
      fieldName: fieldName,
      inputType: TextInputType.datetime,
    );
  }
}
