import 'package:flutter/material.dart';
import 'package:gestion_taches/commons_widgets/custom_card_view.dart';
import 'package:gestion_taches/features/tasks/providers/task_provider.dart';
import 'package:gestion_taches/features/tasks/views/addtask_view.dart';
import 'package:gestion_taches/utils/functions.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../models/task_model.dart';

class ListtasksView extends StatelessWidget {
  const ListtasksView({super.key});

  @override
  Widget build(BuildContext context) {
    List tasks = context.watch<TaskProvider>().alltasks;
    bool fromData = context.watch<TaskProvider>().getTasksFromData;
    var provider = context.read<TaskProvider>();
    return fromData
        ? Center(child: Text('Veuillez patienter...'))
        : tasks.isEmpty
        ? Center(child: Text('vide'))
        : ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            Task task = tasks[index];
            return Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              task.status == provider.listStatus.first
                                  ? greenColor
                                  : redColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          task.status == provider.listStatus.first
                              ? Icons.check
                              : Icons.cancel,
                          color: white,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.name ?? '---',
                              style: primaryTextStyle(color: black, size: 15),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Text(
                                  "Début : ${task.dateBegin}",
                                  style: secondaryTextStyle(
                                    color: black,
                                    size: 11,
                                  ),
                                ),
                                Text(
                                  "Fin : ${task.dateEnd}",
                                  style: secondaryTextStyle(
                                    color: black,
                                    size: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).expand(),
                  Icon(Icons.more_vert, color: primaryColor),
                ],
              ),
            ).onTap(() {
              showBottomView(
                context,
                Column(
                  spacing: 15,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Actions', style: boldTextStyle(size: 25)).center(),
                    CustomCardView(
                      title: 'Modifier',
                      onTap: () {
                        Navigator.pop(context);
                        provider.editTask(index);
                        appShowDialog(context, AddtaskView());
                      },
                      color: primaryColor,
                      img: 'modifier',
                    ),
                    CustomCardView(
                      title: 'Supprimer',
                      onTap: () {
                        showDialogConfirmation(
                          context,
                          'Voulez-vous vraiment supprimer ?',
                          () {
                            Navigator.pop(context);
                            provider.deleteTask(index);
                          },
                        );
                      },
                      color: redColor,
                      img: 'supprimer',
                    ),
                  ],
                ).paddingAll(20),
                false,
              );
            });
          },
        );
  }
}
