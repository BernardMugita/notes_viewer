import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/utils/enums.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DesktopVideoViewer extends StatefulWidget {
  final String fileName;
  final String uploadType;
  final Map<dynamic, dynamic> material;
  final Function(Duration duration) onPressed;

  const DesktopVideoViewer({
    super.key,
    required this.fileName,
    required this.uploadType,
    required this.material,
    required this.onPressed,
  });

  @override
  State<DesktopVideoViewer> createState() => _DesktopVideoViewerState();
}

class _DesktopVideoViewerState extends State<DesktopVideoViewer> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  late VoidCallback _listener;
  late DashboardProvider dashboardProvider;
  bool showVideoControls = false;
  Map lesson = {};
  double _playbackSpeed = 1.0;
  Map currentlyViewing = {};
  Map<String, dynamic> user = {};
  Duration remainingTime = const Duration(milliseconds: 0);

  Duration fetchDuration(Duration videoDuration, Duration videoProgress) {
    int timeInSeconds = videoDuration.inSeconds - videoProgress.inSeconds;
    remainingTime = Duration(seconds: timeInSeconds);
    return remainingTime;
  }

  void saveCurrentlyViewing(
      Map user,
      Map lesson,
      String materialId,
      String materialName,
      String createdAt,
      String type,
      String description,
      Duration duration) async {
    currentlyViewing = {
      "user_id": user['id'],
      "lesson_name": lesson['name'],
      "lesson_materials": lesson['materials'],
      "material_id": materialId,
      "name": materialName,
      "created_at": createdAt,
      "type": type,
      "description": description,
      "duration": duration.inSeconds,
    };

    dashboardProvider.saveUsersRecentlyViewedMaterial(currentlyViewing);
  }

  @override
  void initState() {
    super.initState();

    lesson = context.read<LessonsProvider>().lesson;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserProvider>(context, listen: false).user;
    dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
  }

  @override
  void dispose() {
    fetchDuration(videoPlayerController.value.duration,
        videoPlayerController.value.position);

    saveCurrentlyViewing(
        user,
        lesson,
        widget.material['id'],
        widget.material['name'],
        widget.material['created_at'],
        widget.material['type'],
        widget.material['description'],
        remainingTime);

    videoPlayerController.removeListener(_listener);
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppUtils.mainBlue(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  FluentIcons.video_24_filled,
                  size: 20,
                  color: AppUtils.mainBlue(context),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  widget.fileName,
                  style: TextStyle(
                    color: AppUtils.mainBlack(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Gap(16),
          Divider(color: Colors.grey.shade200, height: 1),
          const Gap(16),

          // Video Player
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: Colors.black,
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Listener(
                          onPointerDown: (PointerEvent event) {
                            setState(() {
                              videoPlayerController.value.isPlaying
                                  ? videoPlayerController.pause()
                                  : videoPlayerController.play();
                            });
                          },
                          child: FittedBox(
                            fit: BoxFit.contain,
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              width: videoPlayerController.value.size.width,
                              height: videoPlayerController.value.size.height,
                              child: VideoPlayer(videoPlayerController),
                            ),
                          ),
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
                          child: EmptyWidget(
                            errorHeading: "Playback Error",
                            errorDescription:
                                "Video playback failed, please try again",
                            type: EmptyWidgetType.recordings,
                          ),
                        );
                      }
                    },
                  ),
                ),

                // Video Controls
                if (!videoPlayerController.value.isPlaying)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Play/Pause Button
                              Container(
                                decoration: BoxDecoration(
                                  color: AppUtils.mainBlue(context),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      videoPlayerController.value.isPlaying
                                          ? videoPlayerController.pause()
                                          : videoPlayerController.play();
                                    });
                                  },
                                  icon: Icon(
                                    videoPlayerController.value.isPlaying
                                        ? FluentIcons.pause_24_filled
                                        : FluentIcons.play_24_filled,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Gap(16),

                              // Time Display
                              Text(
                                "${formatDuration(videoPlayerController.value.position)} / ${formatDuration(videoPlayerController.value.duration)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Gap(16),

                              // Progress Slider
                              if (videoPlayerController.value.isInitialized)
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 4,
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 6),
                                      overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 12),
                                    ),
                                    child: Slider(
                                      value: videoPlayerController
                                          .value.position.inSeconds
                                          .toDouble()
                                          .clamp(
                                              0.0,
                                              videoPlayerController
                                                  .value.duration.inSeconds
                                                  .toDouble()),
                                      max: videoPlayerController
                                          .value.duration.inSeconds
                                          .toDouble(),
                                      onChanged: (value) {
                                        videoPlayerController.seekTo(
                                            Duration(seconds: value.toInt()));
                                      },
                                      activeColor: AppUtils.mainBlue(context),
                                      inactiveColor:
                                          Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                )
                              else
                                Spacer(),
                              const Gap(16),

                              // Playback Speed
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButton<double>(
                                  value: _playbackSpeed,
                                  underline: SizedBox(),
                                  dropdownColor: Colors.grey.shade900,
                                  style: TextStyle(color: Colors.white),
                                  icon: Icon(
                                    FluentIcons.chevron_down_24_regular,
                                    color: Colors.white,
                                    size: 16,
                                  ),
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
                                        videoPlayerController
                                            .setPlaybackSpeed(newSpeed);
                                      });
                                    }
                                  },
                                ),
                              ),
                              const Gap(8),

                              // Skip Backward
                              IconButton(
                                onPressed: () {
                                  final currentPosition =
                                      videoPlayerController.value.position;
                                  final newPosition = currentPosition -
                                      const Duration(seconds: 10);
                                  videoPlayerController.seekTo(
                                    newPosition < Duration.zero
                                        ? Duration.zero
                                        : newPosition,
                                  );
                                },
                                icon: Icon(
                                  FluentIcons.rewind_24_regular,
                                  color: Colors.white,
                                ),
                              ),

                              // Skip Forward
                              IconButton(
                                onPressed: () {
                                  final currentPosition =
                                      videoPlayerController.value.position;
                                  final duration =
                                      videoPlayerController.value.duration;
                                  final newPosition = currentPosition +
                                      const Duration(seconds: 10);
                                  videoPlayerController.seekTo(
                                    newPosition > duration
                                        ? duration
                                        : newPosition,
                                  );
                                },
                                icon: Icon(
                                  FluentIcons.fast_forward_24_regular,
                                  color: Colors.white,
                                ),
                              ),

                              // Fullscreen
                              IconButton(
                                onPressed: () async {
                                  final wasPlaying =
                                      videoPlayerController.value.isPlaying;
                                  if (wasPlaying) {
                                    videoPlayerController.pause();
                                  }

                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenVideo(
                                        videoPlayerController:
                                            videoPlayerController,
                                      ),
                                    ),
                                  );

                                  if (wasPlaying) {
                                    videoPlayerController.play();
                                  }
                                },
                                icon: Icon(
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

// Fullscreen Video Widget (simplified for brevity)
class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const FullScreenVideo({super.key, required this.videoPlayerController});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Listener(
                onPointerDown: (PointerEvent event) {
                  setState(() {
                    widget.videoPlayerController.value.isPlaying
                        ? widget.videoPlayerController.pause()
                        : widget.videoPlayerController.play();
                  });
                },
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: widget.videoPlayerController.value.size.width,
                    height: widget.videoPlayerController.value.size.height,
                    child: VideoPlayer(widget.videoPlayerController),
                  ),
                ),
              ),
            ),
            if (!widget.videoPlayerController.value.isPlaying)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: _buildFullScreenControls(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenControls() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppUtils.mainBlue(context),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                widget.videoPlayerController.value.isPlaying
                    ? widget.videoPlayerController.pause()
                    : widget.videoPlayerController.play();
              });
            },
            icon: Icon(
              widget.videoPlayerController.value.isPlaying
                  ? FluentIcons.pause_24_filled
                  : FluentIcons.play_24_filled,
              color: Colors.white,
            ),
          ),
        ),
        const Gap(16),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: widget.videoPlayerController.value.position.inSeconds
                  .toDouble()
                  .clamp(
                      0.0,
                      widget.videoPlayerController.value.duration.inSeconds
                          .toDouble()),
              max: widget.videoPlayerController.value.duration.inSeconds
                  .toDouble(),
              onChanged: (value) {
                widget.videoPlayerController
                    .seekTo(Duration(seconds: value.toInt()));
              },
              activeColor: AppUtils.mainBlue(context),
              inactiveColor: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
        const Gap(16),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FluentIcons.full_screen_minimize_24_regular,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
