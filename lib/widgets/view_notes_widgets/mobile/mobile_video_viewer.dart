import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/utils/enums.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class MobileVideoViewer extends StatefulWidget {
  final String fileName;
  final String uploadType;
  final Function onPressed;
  final Map<dynamic, dynamic> material;

  const MobileVideoViewer({
    super.key,
    required this.fileName,
    required this.uploadType,
    required this.onPressed,
    required this.material,
  });

  @override
  State<MobileVideoViewer> createState() => _MobileVideoViewerState();
}

class _MobileVideoViewerState extends State<MobileVideoViewer> {
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
    int timeInSeconds = 0;

    timeInSeconds = videoDuration.inSeconds - videoProgress.inSeconds;

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
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
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
                        child: Container(
                          color: Colors.transparent,
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
            !videoPlayerController.value.isPlaying
                ? Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppUtils.mainBlue(context).withOpacity(0.3),
                      ),
                      child: Column(
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${formatDuration(videoPlayerController.value.position)}/${formatDuration(videoPlayerController.value.duration)}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              if (videoPlayerController.value.isInitialized)
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
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
                                    inactiveColor: AppUtils.mainGrey(context),
                                  ),
                                )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Playback Speed: ",
                                style: TextStyle(color: Colors.white),
                              ),
                              DropdownButton<double>(
                                focusColor: Colors.white,
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
                                      videoPlayerController
                                          .setPlaybackSpeed(newSpeed);
                                    });
                                  }
                                },
                              ),
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
                                  final newPosition = currentPosition +
                                      const Duration(seconds: 10);
                                  videoPlayerController.seekTo(
                                    newPosition > duration
                                        ? duration
                                        : newPosition,
                                  );
                                },
                                icon: Icon(
                                  FluentIcons.skip_forward_10_24_regular,
                                  color: Colors.white,
                                ),
                              ),
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
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
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

class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const FullScreenVideo({super.key, required this.videoPlayerController});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
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
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    color: Colors.transparent,
                    width: widget.videoPlayerController.value.size.width,
                    height: widget.videoPlayerController.value.size.height,
                    child: VideoPlayer(widget.videoPlayerController),
                  ),
                ),
              ),
            ),
            // if (!widget.videoPlayerController.value.isPlaying)
            //   Positioned(
            //     top: 10,
            //     left: 10,
            //     right: 10,
            //     child: Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(5),
            //         color: AppUtils.mainBlue(context).withOpacity(0.3),
            //       ),
            //       child: Row(
            //         children: [
            //           IconButton(
            //             icon: const Icon(Icons.arrow_back, color: Colors.white),
            //             onPressed: () => Navigator.of(context).pop(),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            if (!widget.videoPlayerController.value.isPlaying)
              Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: _FullScreenControls(
                      controller: widget.videoPlayerController)),
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
  double _playbackSpeed = 1.0;

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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppUtils.mainBlue(context).withOpacity(0.3),
      ),
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.controller.value.isPlaying
                            ? widget.controller.pause()
                            : widget.controller.play();
                      });
                    },
                    icon: Icon(
                      widget.controller.value.isPlaying
                          ? FluentIcons.pause_24_regular
                          : FluentIcons.play_24_regular,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${formatDuration(widget.controller.value.position)}/${formatDuration(widget.controller.value.duration)}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              if (widget.controller.value.isInitialized)
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Slider(
                    value: widget.controller.value.position.inSeconds
                        .toDouble()
                        .clamp(
                            0.0,
                            widget.controller.value.duration.inSeconds
                                .toDouble()),
                    max: widget.controller.value.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      widget.controller
                          .seekTo(Duration(seconds: value.toInt()));
                    },
                    activeColor: AppUtils.mainBlue(context),
                    inactiveColor: AppUtils.mainGrey(context),
                  ),
                )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Playback Speed: ",
                style: TextStyle(color: Colors.white),
              ),
              DropdownButton<double>(
                focusColor: Colors.white,
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
                      widget.controller.setPlaybackSpeed(newSpeed);
                    });
                  }
                },
              ),
              IconButton(
                onPressed: () {
                  final currentPosition = widget.controller.value.position;
                  final newPosition =
                      currentPosition - const Duration(seconds: 10);
                  widget.controller.seekTo(
                    newPosition < Duration.zero ? Duration.zero : newPosition,
                  );
                },
                icon: Icon(
                  FluentIcons.skip_back_10_24_regular,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  final currentPosition = widget.controller.value.position;
                  final duration = widget.controller.value.duration;
                  final newPosition =
                      currentPosition + const Duration(seconds: 10);
                  widget.controller.seekTo(
                    newPosition > duration ? duration : newPosition,
                  );
                },
                icon: Icon(
                  FluentIcons.skip_forward_10_24_regular,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () async {
                  final wasPlaying = widget.controller.value.isPlaying;
                  if (wasPlaying) {
                    widget.controller.pause();
                  }

                  Navigator.of(context).pop();

                  if (wasPlaying) {
                    widget.controller.play();
                  }
                },
                icon: Icon(
                  FluentIcons.full_screen_maximize_24_regular,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
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
