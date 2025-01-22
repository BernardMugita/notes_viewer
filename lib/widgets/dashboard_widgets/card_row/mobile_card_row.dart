import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/dashboard_widgets/card_row/mobile_card.dart';

class MobileCardRow extends StatefulWidget {
  final Map user;
  final double users;
  final Map materialCount;

  const MobileCardRow(
      {super.key,
      required this.users,
      required this.materialCount,
      required this.user});

  @override
  State<MobileCardRow> createState() => _MobileCardRowState();
}

class _MobileCardRowState extends State<MobileCardRow> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Summary",
              style: TextStyle(fontSize: 16, color: AppUtils.$mainGrey)),
          Gap(20),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 5,
              runSpacing: 20,
              children: [
                if (user.isNotEmpty && user['role'] == 'admin')
                  MobileCard(
                    users: widget.users,
                    material: "",
                    count: 0,
                  ),
                for (var material in widget.materialCount.entries)
                  MobileCard(
                    users: 0,
                    material: material.key,
                    count: widget.materialCount[material.key],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
