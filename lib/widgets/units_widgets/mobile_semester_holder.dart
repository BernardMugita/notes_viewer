import 'package:flutter/material.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/units_widgets/mobile_unit_holder.dart';

class MobileSemesterHolder extends StatefulWidget {
  final List units;

  const MobileSemesterHolder({super.key, required this.units});

  @override
  State<MobileSemesterHolder> createState() => _MobileSemesterHolderState();
}

class _MobileSemesterHolderState extends State<MobileSemesterHolder> {
  // Group units by their semester property
  Map<String, List<Map<String, dynamic>>> groupUnitsBySemester() {
    Map<String, List<Map<String, dynamic>>> groupedUnits = {};

    for (var unit in widget.units) {
      String semester = unit['semester'];
      if (groupedUnits.containsKey(semester)) {
        groupedUnits[semester]!.add(unit);
      } else {
        groupedUnits[semester] = [unit];
      }
    }

    return groupedUnits;
  }

  List<String> sortSemesters(
      Map<String, List<Map<String, dynamic>>> groupedUnits) {
    List<String> semesters = groupedUnits.keys.toList();

    semesters.sort((a, b) {
      List<int> aParts = a.split('.').map((e) => int.parse(e)).toList();
      List<int> bParts = b.split('.').map((e) => int.parse(e)).toList();

      // Compare the two semesters
      for (int i = 0; i < aParts.length; i++) {
        if (aParts[i] != bParts[i]) {
          return aParts[i] - bParts[i];
        }
      }
      return 0;
    });

    return semesters;
  }

  @override
  Widget build(BuildContext context) {
    final groupedUnits = groupUnitsBySemester();
    final sortedSemesters = sortSemesters(groupedUnits);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortedSemesters.map<Widget>((semester) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
              color: AppUtils.mainGrey(context),
            ))),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: groupedUnits[semester]!.map<Widget>((unit) {
                    return MobileUnitHolder(unit: unit);
                  }).toList(),
                ),
                Positioned(
                  top: -40,
                  left: 10,
                  child: Container(
                    padding: 
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    color: AppUtils.backgroundPanel(context),
                    child: Text(
                      "Semester $semester",
                      style: TextStyle(
                        color: AppUtils.mainGrey(context),
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
