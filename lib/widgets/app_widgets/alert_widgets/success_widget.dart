import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/utils/app_utils.dart';

class SuccessWidget extends StatefulWidget {
  final String message;

  const SuccessWidget({super.key, required this.message});

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: _buildSuccessWidget(0.8, 14, 5, 5),
      tabletLayout: _buildSuccessWidget(0.25, 16, 20, 10),
      desktopLayout: _buildSuccessWidget(0.25, 16, 10, 30),
    );
  }

  Widget _buildSuccessWidget(double widthDenomenator, double successFontSize,
      double verticalPadding, double horizontalPadding) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * widthDenomenator,
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: AppUtils.mainGreen(context),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppUtils.mainWhite(context),
                child: Icon(
                  FluentIcons.checkmark_circle_24_filled,
                  color: AppUtils.mainGreen(context),
                ),
              ),
              const SizedBox(width: 10), // Add spacing between elements
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: AppUtils.mainWhite(context),
                    fontWeight: FontWeight.bold,
                    fontSize: successFontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -2,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * widthDenomenator,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _progressAnimation.value, // Animate progress
                  backgroundColor: Colors.transparent,
                  color: AppUtils.mainGreen(context),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
