import 'package:flutter/material.dart';
import 'package:gestion_taches/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomWrapStepView extends StatelessWidget {
  const CustomWrapStepView(
      {super.key,
      required this.title,
      required this.list,
      required this.onTap,
      required this.index, this.width});

  final String title;
  final List list;
  final Function(int i) onTap;
  final int index;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Text(
          title,
          style: boldTextStyle(color: black),
        ),
        Wrap(
          spacing: 2,
          runSpacing: 5,
          children: list.map((item) {
            int position = list.indexOf(item);
            return StepItemView(
              width: width ?? 0.3,
              index: position,
              onTap: () {
                onTap(position);
              },
              check: index == position,
              title: item,
            );
          }).toList(),
        ),
      ],
    );
  }
}



class StepItemView extends StatelessWidget {
  const StepItemView({
    super.key,
    required this.index,
    required this.onTap,
    required this.check,
    required this.title,
    required this.width,
  });

  final int index;
  final Function() onTap;
  final bool check;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * width,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: check ? primaryColor.withValues(alpha: 0.1) : white,
          border: Border.all(
              color: check
                  ? primaryColor
                  : Colors.white),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: check ? white : Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          spacing: 2,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.check_circle,
                      color: check
                          ? primaryColor : white,
                      size: 8,
                    )),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: secondaryTextStyle(
                  color: check
                      ? primaryColor
                      : black),
            ),
          ],
        ).paddingBottom(8),
      ),
    );
  }
}
