import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DesktopVideoViewer extends StatefulWidget {
  final String fileName;
  final String uploadType;

  const DesktopVideoViewer({
    super.key,
    required this.fileName,
    required this.uploadType,
  });

  @override
  State<DesktopVideoViewer> createState() => _DesktopVideoViewerState();
}

class _DesktopVideoViewerState extends State<DesktopVideoViewer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final String url = AppUtils.$baseUrl;

  @override
  void initState() {
    super.initState();
    final Map lesson = context.read<LessonsProvider>().lesson;
    final String filePath =
        '$url/${lesson['path']}/${widget.uploadType}/${widget.fileName}';

    _controller = VideoPlayerController.networkUrl(
        Uri.parse(filePath.replaceAll(" ", "%20")));

    _initializeVideoPlayerFuture = _controller.initialize().catchError((e) {
      print("Error initializing video player: $e");
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppUtils.$mainBlack, borderRadius: BorderRadius.circular(5)),
      height: MediaQuery.of(context).size.height * 0.95,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.fileName,
                style: TextStyle(
                    color: AppUtils.$mainWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_like_24_regular,
                        color: AppUtils.$mainWhite,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_dislike_24_regular,
                        color: AppUtils.$mainWhite,
                      )),
                ],
              )
            ],
          ),
          Gap(5),
          Divider(
            color: AppUtils.$mainGrey,
          ),
          Gap(5),
          Expanded(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error loading video.",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      Positioned(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(
                          FluentIcons.play_24_regular,
                          size: 30,
                        ),
                      ))
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.newtonCradle(
                      color: AppUtils.$mainBlue,
                      size: 100,
                    ),
                  );
                } else {
                  return Center(
                    child: Text("Failed to load video"),
                  );
                }
              },
            ),
          ),
          Gap(5),
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                child: LinearProgressIndicator(
                  value: 0.1,
                  backgroundColor: AppUtils.$mainGrey,
                  borderRadius: BorderRadius.circular(30),
                  color: AppUtils.$mainBlue,
                ),
              ),
              Gap(10),
              Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? FluentIcons.pause_24_regular
                              : FluentIcons.play_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                      Gap(5),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FluentIcons.fast_forward_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                      Gap(5),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FluentIcons.rewind_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text("00:00/00:00",
                          style: TextStyle(color: AppUtils.$mainWhite)),
                      Gap(5),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FluentIcons.settings_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                      Gap(5),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FluentIcons.full_screen_maximize_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
