import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/units_widgets/tablet_unit_holder.dart';

class TabletSemesterHolder extends StatelessWidget {
  const TabletSemesterHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Semester 1 (1.1)",
          style: TextStyle(color: AppUtils.$mainGrey, fontSize: 18),
        ),
        Gap(20),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          clipBehavior: Clip.none,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            TabletUnitHolder(),
            TabletUnitHolder(),
            TabletUnitHolder(),
            TabletUnitHolder(),
            TabletUnitHolder()
          ],
        )
      ],
    );
  }
}
