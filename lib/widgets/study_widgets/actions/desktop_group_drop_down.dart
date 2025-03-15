import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class DesktopGroupDropDown extends StatelessWidget {
  const DesktopGroupDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppUtils.mainWhite(context),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 224, 224, 224),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(10, 5),
              )
            ]),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Group by"),
            Gap(5),
            SizedBox(
              width: 80,
              child: Divider(
                color: AppUtils.mainBlue(context),
                thickness: 1,
              ),
            ),
            Gap(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: context.read<TogglesProvider>().selectGroup,
                        onChanged: (value) {}),
                    Gap(10),
                    Text("Ungrouped")
                  ],
                ),
                Gap(20),
                Row(
                  children: [
                    Checkbox(
                        value: context.read<TogglesProvider>().selectGroup,
                        onChanged: (value) {}),
                    Gap(10),
                    Text("Group")
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
