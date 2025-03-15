import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/dashboard_widgets/card_row/tablet_card.dart';

class TabletCardRow extends StatefulWidget {
  final Map user;
  final double users;
  final Map materialCount;

  const TabletCardRow(
      {super.key,
      required this.user,
      required this.users,
      required this.materialCount});

  @override
  State<TabletCardRow> createState() => _TabletCardRowState();
}

class _TabletCardRowState extends State<TabletCardRow> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Summary",
              style: TextStyle(fontSize: 16, color: AppUtils.mainGrey(context))),
          Gap(10),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (user.isNotEmpty && user['role'] == 'admin')
                  TabletCard(
                    users: widget.users,
                    material: "",
                    count: 0,
                  ),
                for (var material in widget.materialCount.entries)
                  TabletCard(
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
