import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/empty_widget.dart';
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
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    final lesson = context.read<LessonsProvider>().lesson;
    final filePath =
        '${AppUtils.$baseUrl}/${lesson['path']}/${widget.uploadType}/${widget.fileName}'
            .replaceAll(" ", "%20");

    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(filePath),
      httpHeaders: <String, String>{"ngrok-skip-browser-warning": "true"},
    );

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      widget.onPressed(formatDuration(videoPlayerController.value.duration));
      setState(() {}); // Refresh after initialization.
    });

    // Update UI on video progress changes.
    videoPlayerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row.
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
        // Video Display with Play/Pause on Tap.
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
                        if (videoPlayerController.value.isPlaying) {
                          videoPlayerController.pause();
                        } else {
                          videoPlayerController.play();
                        }
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
                      errorDescription:
                          "Video playback failed, please try again",
                      image: 'assets/images/404.png'),
                );
              }
            },
          ),
        ),
        const Gap(10),
        // Draggable progress bar using Slider.
        videoPlayerController.value.isInitialized
            ? Slider(
                value:
                    videoPlayerController.value.position.inSeconds.toDouble(),
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
        // Control Row with Play/Pause, Time, Playback Speed, Rewind, Fast Forward, and Full Screen.
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
              child: Center(
                child: Icon(
                  videoPlayerController.value.isPlaying
                      ? FluentIcons.pause_24_regular
                      : FluentIcons.play_24_regular,
                  color: AppUtils.mainBlack(context),
                ),
              ),
            ),
            const Gap(10),
            Text(
              "${formatDuration(videoPlayerController.value.position)}/${formatDuration(videoPlayerController.value.duration)}",
              style: TextStyle(color: AppUtils.mainBlack(context)),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Playback Speed: ",
                  style: TextStyle(color: AppUtils.mainBlack(context)),
                ),
                DropdownButton<double>(
                  value: _playbackSpeed,
                  items: [0.5, 1.0, 1.5, 2.0].map((speed) {
                    return DropdownMenuItem<double>(
                      value: speed,
                      child: Text("${speed}x"),
                    );
                  }).toList(),
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
                Duration newPosition =
                    currentPosition - const Duration(seconds: 10);
                if (newPosition < Duration.zero) {
                  newPosition = Duration.zero;
                }
                videoPlayerController.seekTo(newPosition);
              },
              icon: Icon(
                FluentIcons.skip_back_10_24_regular,
                color: AppUtils.mainBlack(context),
              ),
            ),
            // Fast Forward +10 sec.
            IconButton(
              onPressed: () {
                final currentPosition = videoPlayerController.value.position;
                final duration = videoPlayerController.value.duration;
                Duration newPosition =
                    currentPosition + const Duration(seconds: 10);
                if (newPosition > duration) {
                  newPosition = duration;
                }
                videoPlayerController.seekTo(newPosition);
              },
              icon: Icon(
                FluentIcons.skip_forward_10_24_regular,
                color: AppUtils.mainBlack(context),
              ),
            ),
            // Full Screen button.
            IconButton(
              onPressed: () async {
                final wasPlaying = videoPlayerController.value.isPlaying;
                if (wasPlaying) {
                  videoPlayerController.pause();
                }
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenVideo(
                      videoPlayerController: videoPlayerController,
                    ),
                  ),
                );
                if (wasPlaying) {
                  videoPlayerController.play();
                }
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

// Refined Full screen video widget with controls on hover and an exit option.
class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const FullScreenVideo({super.key, required this.videoPlayerController});

  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  bool _showControls = true;
  Timer? _hideTimer;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _playbackSpeed = 1.0;
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

  void _onMouseMove(PointerEvent details) {
    if (!_showControls) {
      setState(() {
        _showControls = true;
      });
    }
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayerController = widget.videoPlayerController;
    return Scaffold(
      backgroundColor: Colors.black,
      body: MouseRegion(
        onHover: _onMouseMove,
        onEnter: (_) {
          setState(() {
            _showControls = true;
          });
          _startHideTimer();
        },
        onExit: (_) {
          setState(() {
            _showControls = false;
          });
        },
        child: Stack(
          children: [
            Center(
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
                child: AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                ),
              ),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress Slider.
                      videoPlayerController.value.isInitialized
                          ? Slider(
                              value: videoPlayerController
                                  .value.position.inSeconds
                                  .toDouble(),
                              max: videoPlayerController
                                  .value.duration.inSeconds
                                  .toDouble(),
                              onChanged: (value) {
                                videoPlayerController
                                    .seekTo(Duration(seconds: value.toInt()));
                              },
                              activeColor: AppUtils.mainBlue(context),
                              inactiveColor: AppUtils.mainGrey(context),
                            )
                          : const SizedBox(),
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
                          const SizedBox(width: 10),
                          Text(
                            "${formatDuration(videoPlayerController.value.position)}/${formatDuration(videoPlayerController.value.duration)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Text(
                                "Speed: ",
                                style: TextStyle(color: Colors.white),
                              ),
                              DropdownButton<double>(
                                value: _playbackSpeed,
                                dropdownColor: Colors.black,
                                items: [0.5, 1.0, 1.5, 2.0, 2.5].map((speed) {
                                  return DropdownMenuItem<double>(
                                    value: speed,
                                    child: Text(
                                      "${speed}x",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
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
                            ],
                          ),
                          const Gap(20),
                          IconButton(
                            onPressed: () {
                              final currentPosition =
                                  videoPlayerController.value.position;
                              Duration newPosition =
                                  currentPosition - const Duration(seconds: 10);
                              if (newPosition < Duration.zero) {
                                newPosition = Duration.zero;
                              }
                              videoPlayerController.seekTo(newPosition);
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
                              final duration =
                                  videoPlayerController.value.duration;
                              Duration newPosition =
                                  currentPosition + const Duration(seconds: 10);
                              if (newPosition > duration) {
                                newPosition = duration;
                              }
                              videoPlayerController.seekTo(newPosition);
                            },
                            icon: const Icon(
                              FluentIcons.skip_forward_10_24_regular,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              FluentIcons.dismiss_24_regular,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (_showControls)
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    FluentIcons.dismiss_24_regular,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
