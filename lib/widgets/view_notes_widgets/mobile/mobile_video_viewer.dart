import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class MobileVideoViewer extends StatefulWidget {
  final String fileName;
  final String uploadType;
  final Function onPressed;

  const MobileVideoViewer({
    super.key,
    required this.fileName,
    required this.uploadType,
    required this.onPressed,
  });

  @override
  State<MobileVideoViewer> createState() => _MobileVideoViewerState();
}

class _MobileVideoViewerState extends State<MobileVideoViewer> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  double _playbackSpeed = 1.0;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    final lesson = context.read<LessonsProvider>().lesson;
    final filePath =
        '${AppUtils.$serverDir}/${lesson['path']}/${widget.uploadType}/${widget.fileName}'
            .replaceAll(" ", "%20");

    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(filePath),
      httpHeaders: <String, String>{"ngrok-skip-browser-warning": "true"},
    );

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      widget.onPressed(formatDuration(videoPlayerController.value.duration));
      
      if (videoPlayerController.value.hasError) {
        print(
            "Video error description: ${videoPlayerController.value.errorDescription}");
      }

      setState(() {});
    });

    videoPlayerController.addListener(() {
      setState(() {});
    });

    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _onScreenTapped() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) _startHideTimer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 200,
              child: Text(
                widget.fileName,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: AppUtils.mainBlue(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FluentIcons.thumb_like_24_regular,
                    color: AppUtils.mainBlack(context),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FluentIcons.thumb_dislike_24_regular,
                    color: AppUtils.mainBlack(context),
                  ),
                ),
              ],
            ),
          ],
        ),
        const Gap(5),
        Divider(color: AppUtils.mainGrey(context)),
        const Gap(5),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: GestureDetector(
            onTap: _onScreenTapped,
            child: Stack(
              alignment: Alignment.center,
              children: [
                FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.newtonCradle(
                          color: AppUtils.mainBlue(context),
                          size: 100,
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Playback Error",
                          style: TextStyle(color: AppUtils.mainWhite(context)),
                        ),
                      );
                    }
                  },
                ),
                if (_showControls)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          videoPlayerController.value.isInitialized
                              ? Slider(
                                  value: videoPlayerController
                                      .value.position.inSeconds
                                      .toDouble(),
                                  max: videoPlayerController
                                      .value.duration.inSeconds
                                      .toDouble(),
                                  onChanged: (value) {
                                    videoPlayerController.seekTo(
                                        Duration(seconds: value.toInt()));
                                  },
                                  activeColor: AppUtils.mainBlue(context),
                                  inactiveColor: AppUtils.mainGrey(context),
                                )
                              : const SizedBox(),
                          const Gap(10),
                          Text(
                            "${formatDuration(videoPlayerController.value.position)}/${formatDuration(videoPlayerController.value.duration)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (videoPlayerController.value.isPlaying) {
                                      videoPlayerController.pause();
                                    } else {
                                      videoPlayerController.play();
                                    }
                                  });
                                },
                                child: Icon(
                                  videoPlayerController.value.isPlaying
                                      ? FluentIcons.pause_24_regular
                                      : FluentIcons.play_24_regular,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                  value: _playbackSpeed,
                                  dropdownColor: Colors.black,
                                  style: const TextStyle(color: Colors.white),
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                  items: [0.5, 1.0, 1.5, 2.0, 2.5].map((speed) {
                                    return DropdownMenuItem<double>(
                                      value: speed,
                                      child: Text("${speed}x"),
                                    );
                                  }).toList(),
                                  onChanged: (newSpeed) {
                                    if (newSpeed != null) {
                                      setState(() {
                                        _playbackSpeed = newSpeed;
                                        videoPlayerController
                                            .setPlaybackSpeed(newSpeed);
                                      });
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  final currentPosition =
                                      videoPlayerController.value.position;
                                  videoPlayerController.seekTo(
                                    currentPosition -
                                        const Duration(seconds: 10),
                                  );
                                },
                                icon: const Icon(
                                  FluentIcons.skip_back_10_24_regular,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  final currentPosition =
                                      videoPlayerController.value.position;
                                  videoPlayerController.seekTo(
                                    currentPosition +
                                        const Duration(seconds: 10),
                                  );
                                },
                                icon: const Icon(
                                  FluentIcons.skip_forward_10_24_regular,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenVideoViewer(
                                              controller:
                                                  videoPlayerController),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  FluentIcons.full_screen_maximize_24_regular,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

class FullScreenVideoViewer extends StatelessWidget {
  final VideoPlayerController controller;

  const FullScreenVideoViewer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
          child: Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      ),
    );
  }
}
