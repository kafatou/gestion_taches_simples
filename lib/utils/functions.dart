import 'package:awesome_dialog/awesome_dialog.dart' as aw;
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

showBottomView(
  final BuildContext buildContext,
  final Widget view,
  bool isScrollControlled,
) {
  showModalBottomSheet(
    context: buildContext,
    backgroundColor: Colors.white,
    isScrollControlled: isScrollControlled,
    transitionAnimationController: AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: Navigator.of(buildContext).overlay!,
    ),
    builder: (BuildContext context) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Commence à droite
          end: Offset.zero, // Finit au centre
        ).animate(
          CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeOut,
          ),
        ),
        child: view,
      );
    },
  );
}

showDialogConfirmation(final context, String message, Function() onValidate) {
  aw.AwesomeDialog(
    context: context,
    dialogType: aw.DialogType.question,
    dismissOnTouchOutside: false,
    title: "Confirmation",
    desc: message,
    btnCancelText: 'Non',
    btnCancelOnPress: () {},
    btnOkText: 'Oui',
    btnOkOnPress: onValidate,
  ).show();
}

appShowDialog(final context, Widget child) {
  showDialog(context: context, builder: (_) => Dialog(child: child));
}

showToastErreur(String message) {
  toast(
    message,
    bgColor: redColor,
    textColor: white,
  );
}

showToastValide(String message) {
  toast(
    message,
    bgColor: greenColor,
    textColor: white,
  );
}

