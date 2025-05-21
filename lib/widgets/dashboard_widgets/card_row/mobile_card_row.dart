import 'package:flutter/material.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/dashboard_widgets/card_row/mobile_card.dart';

class MobileCardRow extends StatefulWidget {
  final Map user;
  final int users;
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

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppUtils.mainGrey(context)),
          color: AppUtils.mainWhite(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text("Summary",
                style:
                    TextStyle(fontSize: 16, color: AppUtils.mainGrey(context))),
          ),
          Divider(
            color: AppUtils.mainGrey(context),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                spacing: 10,
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
          ),
        ],
      ),
    );
  }
}
