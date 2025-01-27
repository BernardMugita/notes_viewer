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
  final Function onPressed;

  const DesktopVideoViewer({
    super.key,
    required this.fileName,
    required this.uploadType,
    required this.onPressed,
  });

  @override
  State<DesktopVideoViewer> createState() => _DesktopVideoViewerState();
}

class _DesktopVideoViewerState extends State<DesktopVideoViewer> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    final lesson = context.read<LessonsProvider>().lesson;
    final filePath =
        '${AppUtils.$baseUrl}/${lesson['path']}/${widget.uploadType}/${widget.fileName}'
            .replaceAll(" ", "%20");

    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(filePath),
        httpHeaders: <String, String>{"ngrok-skip-browser-warning": "true"});

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      widget.onPressed(formatDuration(videoPlayerController.value.duration));
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: AppUtils.$mainBlack,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              Text(
                widget.fileName,
                style: TextStyle(
                  color: AppUtils.$mainWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FluentIcons.thumb_like_24_regular,
                  color: AppUtils.$mainWhite,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FluentIcons.thumb_dislike_24_regular,
                  color: AppUtils.$mainWhite,
                ),
              ),
            ],
          ),
          Gap(10),
          Expanded(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (videoPlayerController.value.isPlaying) {
                                videoPlayerController.pause();
                              } else {
                                videoPlayerController.play();
                              }
                            });
                          },
                          child: Center(
                            child: Icon(
                              videoPlayerController.value.isPlaying
                                  ? FluentIcons.pause_24_regular
                                  : FluentIcons.play_24_regular,
                              size: 50,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
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
                    child: Text(
                      "Failed to load video",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
              },
            ),
          ),
          Gap(10),
          LinearProgressIndicator(
            value: videoPlayerController.value.isInitialized
                ? videoPlayerController.value.position.inSeconds /
                    videoPlayerController.value.duration.inSeconds
                : 0.0,
            backgroundColor: AppUtils.$mainGrey,
            color: AppUtils.$mainBlue,
          ),
          Gap(10),
          Row(
            children: [
              Text(
                "${formatDuration(videoPlayerController.value.position)}/${formatDuration(videoPlayerController.value.duration)}",
                style: TextStyle(color: AppUtils.$mainWhite),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    videoPlayerController.seekTo(Duration.zero);
                  });
                },
                icon: Icon(
                  FluentIcons.rewind_24_regular,
                  color: AppUtils.$mainWhite,
                ),
              ),
              IconButton(
                onPressed: () {
                  videoPlayerController.setPlaybackSpeed(1.5);
                },
                icon: Icon(
                  FluentIcons.fast_forward_24_regular,
                  color: AppUtils.$mainWhite,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FluentIcons.full_screen_maximize_24_regular,
                  color: AppUtils.$mainWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
