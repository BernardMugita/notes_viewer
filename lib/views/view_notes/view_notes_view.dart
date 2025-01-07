import 'package:flutter/material.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/view_notes/desktop_view_notes.dart';
import 'package:note_viewer/views/view_notes/mobile_view_notes.dart';
import 'package:note_viewer/views/view_notes/tablet_view_notes.dart';

class ViewNotesView extends StatelessWidget {
  const ViewNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileViewNotes(),
        tabletLayout: TabletViewNotes(),
        desktopLayout: DesktopViewNotes());
  }
}
