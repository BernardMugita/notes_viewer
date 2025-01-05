import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/dashboard_widgets/card_row/desktop_card.dart';

class DesktopCardRow extends StatelessWidget {
  const DesktopCardRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Summary",
              style: TextStyle(fontSize: 16, color: AppUtils.$mainGrey)),
          Gap(10),
          Row(
            children: [
              DesktopCard(),
              Gap(20),
              DesktopCard(),
              Gap(20),
              DesktopCard(),
              Gap(20),
              DesktopCard(),
              Gap(20),
              DesktopCard(),
            ],
          ),
        ],
      ),
    );
  }
}
