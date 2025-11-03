import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/uploads_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class TabletFile extends StatefulWidget {
  final String fileName;
  final String lesson;
  final Map material;
  final IconData? icon;
  final List notes;
  final List slides;

  const TabletFile({
    super.key,
    required this.fileName,
    required this.lesson,
    required this.material,
    required this.icon,
    required this.notes,
    required this.slides,
  });

  @override
  State<TabletFile> createState() => _TabletFileState();
}

class _TabletFileState extends State<TabletFile> {
  bool _isHovered = false;
  Map selectedRecording = {};
  bool isRightClicked = false;
  bool actionMode = false;
  bool isSelectedRecording = false;
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
      }
    });
  }

  Future<void> onRightClick(PointerDownEvent event) async {
    if (event.kind == PointerDeviceKind.mouse &&
        (event.buttons & kSecondaryMouseButton) != 0) {
      setState(() {
        isRightClicked = !isRightClicked;
        actionMode = !actionMode;

        if (selectedRecording.isNotEmpty) {
          selectedRecording.clear();
        } else {
          selectedRecording['id'] = widget.material;
          isSelectedRecording =
              selectedRecording['id']['id'] == widget.material['id'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.material['file'].split('.')[1];
    final String url = AppUtils.$serverDir;
    final user = context.read<UserProvider>().user;

    int? index = (widget.key is ValueKey<int>)
        ? (widget.key as ValueKey<int>).value
        : null;

    Color getFileColor(String extension) {
      switch (extension) {
        case 'pdf':
          return AppUtils.mainRed(context);
        case 'docx':
          return AppUtils.mainBlue(context);
        case 'xlsx':
          return const Color.fromARGB(255, 100, 187, 0);
        case 'ppt':
          return Colors.orange;
        default:
          return AppUtils.mainBlue(context);
      }
    }

    final fileColor = getFileColor(fileExtension);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          context
              .go('/units/notes/${widget.lesson}/${widget.fileName}', extra: {
            "path": "$url/${widget.material['file']}",
            "material": widget.material,
            "featured_material":
                widget.notes.isEmpty ? widget.slides : widget.notes,
          });
        },
        child: Listener(
          onPointerDown: onRightClick,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isHovered ? fileColor : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelectedRecording && actionMode
                        ? fileColor
                        : _isHovered
                            ? fileColor
                            : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Index Number
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? Colors.white.withOpacity(0.2)
                            : fileColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          "${index ?? 0}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: _isHovered ? Colors.white : fileColor,
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),

                    // File Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? Colors.white.withOpacity(0.2)
                            : fileColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 20,
                        color: _isHovered ? Colors.white : fileColor,
                      ),
                    ),
                    const Gap(12),

                    // File Name
                    Expanded(
                      child: Text(
                        widget.material['name'] ?? 'material',
                        style: TextStyle(
                          fontSize: 15,
                          color: _isHovered
                              ? Colors.white
                              : isSelectedRecording && actionMode
                                  ? fileColor
                                  : AppUtils.mainBlack(context),
                          fontWeight:
                              _isHovered || (isSelectedRecording && actionMode)
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Admin Actions
                    if (user.isNotEmpty &&
                        user['role'] == 'admin' &&
                        _isHovered)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            FluentIcons.more_vertical_24_regular,
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              // Edit functionality
                            } else if (value == 'delete') {
                              setState(() {
                                selectedRecording['id'] = widget.material;
                                isSelectedRecording = true;
                              });
                              _showDeleteDialog(context);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(FluentIcons.edit_24_regular,
                                      size: 18,
                                      color: AppUtils.mainBlue(context)),
                                  const Gap(12),
                                  const Text('Edit File'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(FluentIcons.delete_24_regular,
                                      size: 18,
                                      color: AppUtils.mainRed(context)),
                                  const Gap(12),
                                  const Text('Delete File'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext content) {
    showDialog(
      context: content,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Container(
            padding: const EdgeInsets.all(28),
            constraints: BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppUtils.mainRed(context).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FluentIcons.delete_24_regular,
                    color: AppUtils.mainRed(context),
                    size: 48,
                  ),
                ),
                const Gap(20),
                Text(
                  "Delete File",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppUtils.mainBlack(context),
                  ),
                ),
                const Gap(12),
                Text(
                  "Are you sure you want to delete this file? This action cannot be undone.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppUtils.mainGrey(context),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedRecording = {};
                            isSelectedRecording = false;
                          });
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 16),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: AppUtils.mainGrey(context)),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppUtils.mainBlack(context),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Consumer<UploadsProvider>(
                        builder: (context, uploadsProvider, _) {
                          return ElevatedButton(
                            onPressed: uploadsProvider.isLoading
                                ? null
                                : () {
                                    uploadsProvider.deleteUploadedMaterial(
                                        tokenRef,
                                        selectedRecording['id']['id']);
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      Navigator.pop(context);
                                    });
                                  },
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 16),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                AppUtils.mainRed(context),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: uploadsProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

