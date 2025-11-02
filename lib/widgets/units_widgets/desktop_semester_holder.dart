import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/units_widgets/desktop_unit_holder.dart';

class DesktopSemesterHolder extends StatefulWidget {
  final List units;

  const DesktopSemesterHolder({super.key, required this.units});

  @override
  State<DesktopSemesterHolder> createState() => _DesktopSemesterHolderState();
}

class _DesktopSemesterHolderState extends State<DesktopSemesterHolder> {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedSemesters.map<Widget>((semester) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppUtils.mainGrey(context).withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Semester Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppUtils.mainBlue(context).withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppUtils.mainBlue(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(12),
                    Text(
                      "Semester $semester",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppUtils.mainBlack(context),
                      ),
                    ),
                    const Gap(12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppUtils.mainBlue(context).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${groupedUnits[semester]!.length} ${groupedUnits[semester]!.length == 1 ? 'Unit' : 'Units'}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppUtils.mainBlue(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Units List
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: groupedUnits[semester]!
                      .asMap()
                      .entries
                      .map<Widget>((entry) {
                    final index = entry.key;
                    final unit = entry.value;
                    final isLast = index == groupedUnits[semester]!.length - 1;

                    return Column(
                      children: [
                        DesktopUnitHolder(unit: unit),
                        if (!isLast) const Gap(12),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
