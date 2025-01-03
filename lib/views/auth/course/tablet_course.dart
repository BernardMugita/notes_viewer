import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:provider/provider.dart';

class TabletCourse extends StatelessWidget {
  const TabletCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    "Select a course to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text("Select a course from the drop down below to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppUtils.$mainWhite,
                      prefixIcon: const Icon(FluentIcons.book_24_regular),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          context
                              .read<TogglesProvider>()
                              .toggleCoursesDropDown();
                        },
                        child:
                            context.watch<TogglesProvider>().showCoursesDropDown
                                ? Icon(FluentIcons.chevron_up_24_regular)
                                : Icon(FluentIcons.chevron_down_24_regular),
                      ),
                      labelText: 'Course name',
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 212, 212, 212))),
                      focusColor: AppUtils.$mainBlue,
                    ),
                  ),
                ),
                if (context.watch<TogglesProvider>().showCoursesDropDown)
                  Positioned(
                    top: 60,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width / 2,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppUtils.$mainWhite,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 229, 229, 229),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Medicine",
                            style: TextStyle(fontSize: 16),
                          ),
                          Divider(
                            color: const Color.fromARGB(255, 209, 209, 209),
                          ),
                          Text(
                            "Dental Surgery",
                            style: TextStyle(fontSize: 16),
                          ),
                          Divider(
                            color: const Color.fromARGB(255, 209, 209, 209),
                          ),
                          Text(
                            "Pharmacy",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppUtils.$mainBlue),
                      padding: WidgetStatePropertyAll(EdgeInsets.only(
                          top: 20, bottom: 20, left: 10, right: 10)),
                    ),
                    child: const Text('Continue',
                        style: TextStyle(
                            fontSize: 16, color: AppUtils.$mainWhite)),
                  ),
                ),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value:
                            context.read<TogglesProvider>().rememberSelection,
                        onChanged: (bool? toggle) {
                          context
                              .read<TogglesProvider>()
                              .toggleRememberSelection();
                        }),
                    Gap(5),
                    Text("Remember my selection? ",
                        style: TextStyle(fontSize: 16)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
