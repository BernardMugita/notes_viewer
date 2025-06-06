import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/notes/desktop_notes.dart';
import 'package:maktaba/views/notes/mobile_notes.dart';
import 'package:maktaba/views/notes/tablet_notes.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:provider/provider.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String tokenRef = '';
  String unitId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final unitsProvider = context.read<UnitsProvider>();
      final lessonsProvider = context.read<LessonsProvider>();

      final String token = authProvider.token ?? '';
      final String id = unitsProvider.unitId;

      if (id.isNotEmpty) {
        unitId = id;
        lessonsProvider.getAllLesson(token, unitId);
      }

      if (token.isNotEmpty) {
        tokenRef = token;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileNotes(
          tokenRef: tokenRef,
          unitId: unitId,
        ),
        tabletLayout: TabletNotes(
          tokenRef: tokenRef,
          unitId: unitId,
        ),
        desktopLayout: DesktopNotes(
          tokenRef: tokenRef,
          unitId: unitId,
        ));
  }
}
