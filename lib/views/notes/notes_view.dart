import 'package:flutter/material.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/notes/desktop_notes.dart';
import 'package:note_viewer/views/notes/mobile_notes.dart';
import 'package:note_viewer/views/notes/tablet_notes.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileNotes(),
        tabletLayout: TabletNotes(),
        desktopLayout: DesktopNotes());
  }
}
