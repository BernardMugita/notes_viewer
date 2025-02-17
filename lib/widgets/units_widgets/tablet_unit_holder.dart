import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/units_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:provider/provider.dart';

class TabletUnitHolder extends StatefulWidget {
  final Map unit;

  const TabletUnitHolder({super.key, required this.unit});

  @override
  State<TabletUnitHolder> createState() => _TabletUnitHolderState();
}

class _TabletUnitHolderState extends State<TabletUnitHolder> {
  Map selectedUnit = {};

  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;
    final isSelectedUnit = widget.unit['id'] == selectedUnit['id'];

    return GestureDetector(
      onTap: () {
        final unitId = unit['id'];
        context.read<UnitsProvider>().setUnitId(unitId);
        String? token = context.read<AuthProvider>().token;
        if (token != null) {
          context.read<UserProvider>().fetchUserDetails(token);
        }
        context.go('/units/notes');
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppUtils.$mainWhite,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppUtils.$mainGrey)),
        child: Column(
          children: [
            Row(
              children: [
                Text("${unit['code']}: ${unit['name']}",
                    style: TextStyle(
                        fontSize: 16,
                        color: AppUtils.$mainBlue,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Consumer<TogglesProvider>(
                    builder: (BuildContext context, toggleProvider, _) {
                  return IconButton(
                      onPressed: () {
                        setState(() {
                          selectedUnit = {};
                          if (selectedUnit['id'] == widget.unit['id'] ||
                              toggleProvider.isUnitExpanded) {
                            selectedUnit = {};
                          } else {
                            selectedUnit = widget.unit;
                          }
                        });
                        toggleProvider.toggleIsUnitExpanded();
                      },
                      icon: isSelectedUnit && toggleProvider.isUnitExpanded
                          ? Icon(
                              FluentIcons.chevron_up_24_regular,
                              color: AppUtils.$mainBlack,
                            )
                          : Icon(
                              FluentIcons.chevron_down_24_regular,
                              color: AppUtils.$mainBlack,
                            ));
                })
              ],
            ),
            if (isSelectedUnit &&
                context.watch<TogglesProvider>().isUnitExpanded)
              Column(
                spacing: 5,
                children: [
                  Divider(
                    color: AppUtils.$mainBlueAccent,
                    indent: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: Column(children: [
                      _buildUnitHolderDetails(context, "Lessons",
                          unit['lessons'].length.toString()),
                      _buildUnitHolderDetails(
                          context, "Date Created", unit['created_at']),
                    ]),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitHolderDetails(
      BuildContext context, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Text(
          "$title:",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppUtils.$mainBlack),
        ),
        Text(
          title == "Date Created"
              ? AppUtils.formatDate(value.toString())
              : value.toString(),
          style: TextStyle(
            color: AppUtils.$mainBlack,
          ),
        ),
      ],
    );
  }
}
