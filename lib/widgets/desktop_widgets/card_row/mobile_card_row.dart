import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/desktop_widgets/card_row/mobile_card.dart';

class MobileCardRow extends StatelessWidget {
  const MobileCardRow({super.key});

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                MobileCard(),
                Gap(20),
                MobileCard(),
                Gap(20),
                MobileCard(),
                Gap(20),
                MobileCard(),
                Gap(20),
                MobileCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
