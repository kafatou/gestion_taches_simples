import 'package:flutter/material.dart';
import 'package:gestion_taches/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    //this.color,
    //this.textColor,
  });

  final String title;
  final VoidCallback onPressed;
  //final Color? color, textColor;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      width: context.width(),
      //padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shapeBorder: RoundedRectangleBorder(borderRadius: radius(12)),
      color: primaryColor,
      elevation: 10,
      onTap: onPressed,
      child: Text(title, style: boldTextStyle(color: white)),
    );
  }
}

