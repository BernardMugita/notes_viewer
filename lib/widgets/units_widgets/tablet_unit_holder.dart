import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class TabletUnitHolder extends StatefulWidget {
  final Map<String, dynamic> unit;
  const TabletUnitHolder({super.key, required this.unit});

  @override
  State<TabletUnitHolder> createState() => _TabletUnitHolderState();
}

class _TabletUnitHolderState extends State<TabletUnitHolder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<UnitsProvider>().setUnitId(widget.unit['id']);
        context.go('/notes');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppUtils.mainWhite(context),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.unit['name'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      widget.unit['code'],
                      style: TextStyle(color: AppUtils.mainGrey(context)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          FluentIcons.book_open_24_regular,
                          color: AppUtils.mainGrey(context),
                        ),
                        const Gap(10),
                        Text(
                          '${widget.unit['lessons'].length} Lessons',
                          style: TextStyle(
                              color: AppUtils.mainGrey(context), fontSize: 16),
                        )
                      ],
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Icon(
                          FluentIcons.people_24_regular,
                          color: AppUtils.mainGrey(context),
                        ),
                        const Gap(10),
                        Text(
                          '${widget.unit['students'].length} Students',
                          style: TextStyle(
                              color: AppUtils.mainGrey(context), fontSize: 16),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            const Gap(20),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppUtils.mainBlue(context),
                  image: DecorationImage(
                      image: NetworkImage(widget.unit['img']),
                      fit: BoxFit.cover)),
            ),
          ],
        ),
      ),
    );
  }
}
