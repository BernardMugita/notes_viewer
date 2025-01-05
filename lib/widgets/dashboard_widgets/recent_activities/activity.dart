import 'package:flutter/material.dart';
import 'package:note_viewer/utils/app_utils.dart';

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: AppUtils.$mainWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text("Bio-Chemistry notes uploaded"), Text("13:13")],
      ),
    );
  }
}
