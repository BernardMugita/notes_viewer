import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

// ... (your imports remain the same)

class DesktopVideoViewer extends StatefulWidget {
  final String fileName;
  final String uploadType;
  final Function(Duration duration) onPressed;

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
  late VoidCallback _listener;
  double _playbackSpeed = 1.0;

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
      widget.onPressed(videoPlayerController.value.duration);
      setState(() {});
    });

    _listener = () {
      if (mounted) setState(() {});
    };
    videoPlayerController.addListener(_listener);
  }

  @override
  void dispose() {
    videoPlayerController.removeListener(_listener);
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top title row
        Row(
          children: [
            Text(
              widget.fileName,
              style: TextStyle(
                color: AppUtils.mainBlue(context),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
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
        const Gap(10),

        // Video display
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        videoPlayerController.value.isPlaying
                            ? videoPlayerController.pause()
                            : videoPlayerController.play();
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController),
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.newtonCradle(
                    color: AppUtils.mainBlue(context),
                    size: 100,
                  ),
                );
              } else {
                return Center(
                  child: EmptyWidget(
                    errorHeading: "Playback Error",
                    errorDescription: "Video playback failed, please try again",
                    image: context.watch<ThemeProvider>().isDarkMode
                        ? 'assets/images/404-dark.png'
                        : 'assets/images/404.png',
                  ),
                );
              }
            },
          ),
        ),
        const Gap(10),

        // Slider
        videoPlayerController.value.isInitialized
            ? Slider(
                value: videoPlayerController.value.position.inSeconds
                    .toDouble()
                    .clamp(
                        0.0,
                        videoPlayerController.value.duration.inSeconds
                            .toDouble()),
                max: videoPlayerController.value.duration.inSeconds.toDouble(),
                onChanged: (value) {
                  videoPlayerController
                      .seekTo(Duration(seconds: value.toInt()));
                },
                activeColor: AppUtils.mainBlue(context),
                inactiveColor: AppUtils.mainGrey(context),
              )
            : const SizedBox(),

        const Gap(10),

        // Playback controls row
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  videoPlayerController.value.isPlaying
                      ? videoPlayerController.pause()
                      : videoPlayerController.play();
                });
              },
              icon: Icon(
                videoPlayerController.value.isPlaying
                    ? FluentIcons.pause_24_regular
                    : FluentIcons.play_24_regular,
                color: AppUtils.mainBlack(context),
              ),
            ),
            const Gap(10),
            Text(
              "${formatDuration(videoPlayerController.value.position)}/${formatDuration(videoPlayerController.value.duration)}",
              style: TextStyle(color: AppUtils.mainBlack(context)),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  "Playback Speed: ",
                  style: TextStyle(color: AppUtils.mainBlack(context)),
                ),
                DropdownButton<double>(
                  value: _playbackSpeed,
                  items: [0.5, 1.0, 1.5, 2.0]
                      .map((speed) => DropdownMenuItem<double>(
                            value: speed,
                            child: Text("${speed}x"),
                          ))
                      .toList(),
                  onChanged: (newSpeed) {
                    if (newSpeed != null) {
                      setState(() {
                        _playbackSpeed = newSpeed;
                        videoPlayerController.setPlaybackSpeed(newSpeed);
                      });
                    }
                  },
                ),
              ],
            ),
            const Gap(10),
            IconButton(
              onPressed: () {
                final currentPosition = videoPlayerController.value.position;
                final newPosition =
                    currentPosition - const Duration(seconds: 10);
                videoPlayerController.seekTo(
                  newPosition < Duration.zero ? Duration.zero : newPosition,
                );
              },
              icon: Icon(
                FluentIcons.skip_back_10_24_regular,
                color: AppUtils.mainBlack(context),
              ),
            ),
            IconButton(
              onPressed: () {
                final currentPosition = videoPlayerController.value.position;
                final duration = videoPlayerController.value.duration;
                final newPosition =
                    currentPosition + const Duration(seconds: 10);
                videoPlayerController.seekTo(
                  newPosition > duration ? duration : newPosition,
                );
              },
              icon: Icon(
                FluentIcons.skip_forward_10_24_regular,
                color: AppUtils.mainBlack(context),
              ),
            ),
            IconButton(
              onPressed: () async {
                final wasPlaying = videoPlayerController.value.isPlaying;
                if (wasPlaying) videoPlayerController.pause();

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenVideo(
                      videoPlayerController: videoPlayerController,
                    ),
                  ),
                );

                if (wasPlaying) videoPlayerController.play();
              },
              icon: Icon(
                FluentIcons.full_screen_maximize_24_regular,
                color: AppUtils.mainBlack(context),
              ),
            ),
          ],
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

class FullScreenVideo extends StatelessWidget {
  final VideoPlayerController videoPlayerController;

  const FullScreenVideo({super.key, required this.videoPlayerController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: VideoPlayer(videoPlayerController),
              ),
            ),

            // Back button (top-left corner)
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // Controls
            _FullScreenControls(controller: videoPlayerController),
          ],
        ),
      ),
    );
  }
}

class _FullScreenControls extends StatefulWidget {
  final VideoPlayerController controller;

  const _FullScreenControls({required this.controller});

  @override
  State<_FullScreenControls> createState() => _FullScreenControlsState();
}

class _FullScreenControlsState extends State<_FullScreenControls> {
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onVideoUpdate);
  }

  void _onVideoUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onVideoUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = widget.controller.value.isPlaying;
    final position = widget.controller.value.position;
    final duration = widget.controller.value.duration;

    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _showControls ? 1.0 : 0.0,
        child: Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VideoProgressIndicator(
                widget.controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.blue,
                  backgroundColor: Colors.grey,
                  bufferedColor: Colors.white,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying
                            ? widget.controller.pause()
                            : widget.controller.play();
                      });
                    },
                  ),
                  Text(
                    "${formatDuration(position)} / ${formatDuration(duration)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.fast_rewind, color: Colors.white),
                    onPressed: () {
                      final newPosition = position - const Duration(seconds: 10);
                      widget.controller.seekTo(
                        newPosition < Duration.zero ? Duration.zero : newPosition,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.fast_forward, color: Colors.white),
                    onPressed: () {
                      final newPosition = position + const Duration(seconds: 10);
                      widget.controller.seekTo(
                        newPosition > duration ? duration : newPosition,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration d) {
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

