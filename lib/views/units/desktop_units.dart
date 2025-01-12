import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
import 'package:note_viewer/widgets/units_widgets/desktop_semester_holder.dart';

class DesktopUnits extends StatelessWidget {
  const DesktopUnits({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: const SideNavigation(),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        FluentIcons.class_24_regular,
                        color: AppUtils.$mainBlue,
                      ),
                      Text(
                        "Units",
                        style: TextStyle(
                          fontSize: 30,
                          color: AppUtils.$mainBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                            backgroundColor:
                                WidgetStatePropertyAll(AppUtils.$mainBlue),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)))),
                        onPressed: () {
                          _showDialog(context);
                        },
                        child: Row(
                          children: [
                            Text("Add units",
                                style: TextStyle(
                                    fontSize: 16, color: AppUtils.$mainWhite)),
                            Gap(5),
                            Icon(FluentIcons.class_24_regular,
                                size: 16, color: AppUtils.$mainWhite),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Gap(10),
                  const Divider(
                    color: Color(0xFFCECECE),
                  ),
                  const Gap(20),
                  // Make the scrollable content expand dynamically
                  Expanded(
                    child: SingleChildScrollView(
                      // clipBehavior: Clip.none,
                      child: Column(
                        children: const [
                          DesktopSemesterHolder(),
                          Gap(20),
                          DesktopSemesterHolder(),
                          Gap(20),
                          DesktopSemesterHolder(),
                          Gap(20),
                          DesktopSemesterHolder(),
                          Gap(20),
                          DesktopSemesterHolder(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController nameController = TextEditingController();
          // TextEditingController imgController = TextEditingController();
          TextEditingController codeController = TextEditingController();
          TextEditingController course_idController = TextEditingController();
          TextEditingController studentsController = TextEditingController();
          TextEditingController assignmentsController = TextEditingController();
          TextEditingController semesterController = TextEditingController();

          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.height * 0.85,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: AppUtils.$mainWhite,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add Unit",
                            style: TextStyle(
                                fontSize: 18,
                                color: AppUtils.$mainBlue,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(FluentIcons.dismiss_24_regular))
                      ],
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5.5,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(FluentIcons.mail_24_regular),
                              labelText: 'Unit name',
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 212, 212, 212))),
                              focusColor: AppUtils.$mainBlue,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5.5,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(FluentIcons.mail_24_regular),
                              labelText: 'Unit name',
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 212, 212, 212))),
                              focusColor: AppUtils.$mainBlue,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5.5,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(FluentIcons.mail_24_regular),
                              labelText: 'Unit name',
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 212, 212, 212))),
                              focusColor: AppUtils.$mainBlue,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5.5,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(FluentIcons.mail_24_regular),
                              labelText: 'Unit name',
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 212, 212, 212))),
                              focusColor: AppUtils.$mainBlue,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5.5,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(FluentIcons.mail_24_regular),
                              labelText: 'Unit name',
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 212, 212, 212))),
                              focusColor: AppUtils.$mainBlue,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }
}
