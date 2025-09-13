import 'package:flutter/material.dart';
import 'package:gestion_taches/commons_widgets/custom_date_textfield.dart';
import 'package:gestion_taches/commons_widgets/custom_text_form_field.dart';
import 'package:gestion_taches/commons_widgets/custom_wrap_step_view.dart';
import 'package:gestion_taches/features/tasks/providers/task_provider.dart';
import 'package:gestion_taches/utils/constants.dart';
import 'package:gestion_taches/utils/functions.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../commons_widgets/custom_button.dart';

class AddtaskView extends StatelessWidget {
  const AddtaskView({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<TaskProvider>();
    int index = context.watch<TaskProvider>().index;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 30,
            children: [
              Column(
                spacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.fromEdit ? 'Modification' : "Ajout de tache",
                        style: boldTextStyle(color: black, size: 20),
                      ),
                      Icon(Icons.cancel, color: redColor, size: 20).onTap(() {
                        context.read<TaskProvider>().resetVariables();
                        Navigator.pop(context);
                      }),
                    ],
                  ).paddingTop(10),
                  Divider(),
                ],
              ),
              CustomTextFormField(
                controller: provider.nameTaskController,
                fieldName: "Nom",
              ),
              CustomDateTextfield(
                controller: provider.dateBeginTaskController,
                fieldName: "Date debut",
              ),
              CustomDateTextfield(
                controller: provider.dateEndTaskController,
                fieldName: "Date fin",
              ),
              CustomWrapStepView(
                title: "Statut",
                list: provider.listStatus,
                onTap: (p) => provider.editIndexStatus(p),
                index: index,
              ),
            ],
          ),
          CustomButton(
            title: provider.fromEdit ? 'Modifier' : 'Ajouter',
            onPressed: () async {
              if (provider.nameTaskController.text.isNotEmpty) {
                await provider.addTask();
                if (provider.fromEdit) {
                  showToastValide(Constants.editMsg);
                  provider.setFromEdit(false);
                } else {
                  showToastValide(Constants.addMsg);
                }
              } else {
                showToastErreur("Le nom est obligatoire");
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ).paddingAll(20),
    );
  }
}
