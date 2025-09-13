import 'package:flutter/material.dart';
import 'package:gestion_taches/features/tasks/providers/task_provider.dart';
import 'package:gestion_taches/features/tasks/views/addtask_view.dart';
import 'package:gestion_taches/features/tasks/views/listtasks_view.dart';
import 'package:gestion_taches/utils/colors.dart';
import 'package:gestion_taches/utils/constants.dart';
import 'package:gestion_taches/utils/functions.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<TaskProvider>().getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appScaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderComponent(),
            Container(
              color: primaryColor,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: appScaffoldBg,
                  borderRadius: radiusOnly(topRight: 40),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Constants.listTitle,
                      style: boldTextStyle(size: 20, color: Colors.black),
                    ).paddingTop(15),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListtasksView(),
                    ),
                  ],
                ).cornerRadiusWithClipRRectOnly(topRight: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderComponent extends StatelessWidget {
  const HeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<TaskProvider>();
    return Container(
      color: appScaffoldBg,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: radiusOnly(bottomLeft: 40),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Constants.welcomeMsg,
                  style: boldTextStyle(size: 20, color: Colors.white),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.add, color: primaryColor, size: 20),
                ).onTap(() {
                  provider.resetVariables();
                  provider.setFromEdit(false);
                  appShowDialog(context, AddtaskView());
                }),
              ],
            ).paddingTop(40),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: radius(24),
              ),
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: provider.researchTaskController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon:
                      context.watch<TaskProvider>().researchOn
                          ? Icon(Icons.cancel, color: redColor).onTap(() {
                            provider.resetResearch();
                          })
                          : Icon(Icons.search_sharp, color: primaryColor).onTap(
                            () {
                              if (provider
                                  .researchTaskController
                                  .text
                                  .isNotEmpty) {
                                provider.researchTask();
                              }
                            },
                          ),
                  hintText: Constants.research,
                  hintStyle: boldTextStyle(color: primaryColor),
                ),
                keyboardType: TextInputType.text,
                cursorColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
