import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomCardView extends StatelessWidget {
  const CustomCardView({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    required this.img,
  });

  final String title;
  final String img;

  final Color? color;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      child: Row(
            spacing: 30,
            children: [
              Image.asset(
                'assets/$img.png',
                height: 20,
                width: 20,
                color: color ?? black,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: boldTextStyle(color: color ?? black),
              ),
            ],
          )
          .paddingSymmetric(vertical: 10, horizontal: 40)
          .withWidth(double.infinity)
          .onTap(onTap),
    );
  }
}
