import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/dashboard_widgets/card_row/desktop_card.dart';
import 'package:provider/provider.dart';

class DesktopCardRow extends StatefulWidget {
  final double users;
  final Map materialCount;
  const DesktopCardRow(
      {super.key, required this.users, required this.materialCount});

  @override
  State<DesktopCardRow> createState() => _DesktopCardRowState();
}

class _DesktopCardRowState extends State<DesktopCardRow> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;

    return Container(
      height: MediaQuery.of(context).size.height/2,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppUtils.mainWhite(context),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppUtils.mainGrey(context)),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              Icon(FluentIcons.list_24_regular,
                  color: AppUtils.mainBlue(context)),
              Text("Summary",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppUtils.mainBlue(context),
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(
            color: AppUtils.mainGrey(context),
          ),
          Column(
            spacing: 10,
            children: [
              if (user.isNotEmpty && user['role'] == 'admin')
                DesktopCard(
                  users: widget.users,
                  material: "",
                  count: 0,
                ),
              for (var material in widget.materialCount.entries)
                DesktopCard(
                  users: 0,
                  material: material.key,
                  count: widget.materialCount[material.key],
                )
            ],
          ),
        ],
      ),
    );
  }
}
