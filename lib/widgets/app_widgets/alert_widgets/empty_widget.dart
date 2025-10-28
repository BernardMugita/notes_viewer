import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/utils/app_utils.dart';

import 'package:maktaba/utils/enums.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_state_painter.dart';

class EmptyWidget extends StatefulWidget {
  final String errorHeading;
  final String errorDescription;
  final EmptyWidgetType type;

  const EmptyWidget({
    super.key,
    required this.errorHeading,
    required this.errorDescription,
    this.type = EmptyWidgetType.notes,
  });

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: _buildEmptyWidget(0.4, 150),
      tabletLayout: _buildEmptyWidget(0.4, 200),
      desktopLayout: _buildEmptyWidget(0.4, 200),
    );
  }

  Widget _buildEmptyWidget(double heightDenomenator, double size) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * heightDenomenator,
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.errorHeading,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: EmptyStatePainter(type: widget.type),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.errorDescription,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
