import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/utils/enums.dart';
import 'dart:math' as math;

class EmptyStatePainter extends CustomPainter {
  final EmptyWidgetType type;

  EmptyStatePainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.45;

    // Background circle
    final bgPaint = Paint()
      ..color = const Color(0xFFE8F2FB).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), radius, bgPaint);

    // Draw based on type
    switch (type) {
      case EmptyWidgetType.notes:
        _drawNotesEmpty(canvas, size, centerX, centerY);
        break;
      case EmptyWidgetType.activities:
        _drawActivitiesEmpty(canvas, size, centerX, centerY);
        break;
      case EmptyWidgetType.recordings:
        _drawRecordingsEmpty(canvas, size, centerX, centerY);
        break;
      case EmptyWidgetType.students:
        _drawStudentsEmpty(canvas, size, centerX, centerY);
        break;
    }
  }

  void _drawNotesEmpty(
      Canvas canvas, Size size, double centerX, double centerY) {
    final scale = size.width / 400;

    // Main document
    final docPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final docStrokePaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;

    final docRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 10 * scale),
        width: 140 * scale,
        height: 160 * scale,
      ),
      Radius.circular(8 * scale),
    );
    canvas.drawRRect(docRect, docPaint);
    canvas.drawRRect(docRect, docStrokePaint);

    // Document lines
    final linePaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;

    final lineOffsets = [-50.0, -30.0, -10.0];
    final lineWidths = [100.0, 100.0, 80.0];

    for (int i = 0; i < lineOffsets.length; i++) {
      canvas.drawLine(
        Offset(centerX - 50 * scale,
            centerY + lineOffsets[i] * scale - 10 * scale),
        Offset(centerX - 50 * scale + lineWidths[i] * scale,
            centerY + lineOffsets[i] * scale - 10 * scale),
        linePaint,
      );
    }

    // Magnifying glass
    final magX = centerX + 30 * scale;
    final magY = centerY + 30 * scale;
    final magRadius = 35 * scale;

    final magBgPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(magX, magY), 28 * scale, magBgPaint);

    final magStrokePaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale;
    canvas.drawCircle(Offset(magX, magY), magRadius, magStrokePaint);

    // Handle
    final handlePaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(magX + 25 * scale, magY + 25 * scale),
      Offset(magX + 50 * scale, magY + 50 * scale),
      handlePaint,
    );

    // X mark
    final xPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 3 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(magX - 12 * scale, magY - 12 * scale),
      Offset(magX + 12 * scale, magY + 12 * scale),
      xPaint,
    );
    canvas.drawLine(
      Offset(magX + 12 * scale, magY - 12 * scale),
      Offset(magX - 12 * scale, magY + 12 * scale),
      xPaint,
    );

    // Floating notes
    _drawFloatingRect(canvas, centerX - 130 * scale, centerY - 60 * scale,
        40 * scale, 50 * scale, -15, const Color(0xFFEC4899), scale);
    _drawFloatingRect(canvas, centerX + 100 * scale, centerY - 70 * scale,
        35 * scale, 45 * scale, 20, const Color(0xFFF59E0B), scale);
    _drawFloatingRect(canvas, centerX - 120 * scale, centerY + 60 * scale,
        38 * scale, 48 * scale, -20, const Color(0xFF10B981), scale);
  }

  void _drawActivitiesEmpty(
      Canvas canvas, Size size, double centerX, double centerY) {
    final scale = size.width / 400;

    // Bell icon
    final bellPaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final bellPath = Path();
    // Bell body
    bellPath.moveTo(centerX - 30 * scale, centerY);
    bellPath.quadraticBezierTo(centerX - 35 * scale, centerY - 50 * scale,
        centerX, centerY - 60 * scale);
    bellPath.quadraticBezierTo(centerX + 35 * scale, centerY - 50 * scale,
        centerX + 30 * scale, centerY);
    bellPath.lineTo(centerX - 30 * scale, centerY);
    canvas.drawPath(bellPath, bellPaint);

    // Bell bottom
    canvas.drawLine(
      Offset(centerX - 35 * scale, centerY),
      Offset(centerX + 35 * scale, centerY),
      bellPaint,
    );

    // Bell clapper
    canvas.drawCircle(Offset(centerX, centerY + 10 * scale), 5 * scale,
        Paint()..color = const Color(0xFF3B82F6));

    // Diagonal slash
    final slashPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 5 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(centerX - 50 * scale, centerY - 70 * scale),
      Offset(centerX + 50 * scale, centerY + 30 * scale),
      slashPaint,
    );
  }

  void _drawRecordingsEmpty(
      Canvas canvas, Size size, double centerX, double centerY) {
    final scale = size.width / 400;

    // Microphone
    final micPaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;

    // Mic capsule
    final micRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 20 * scale),
        width: 40 * scale,
        height: 60 * scale,
      ),
      Radius.circular(20 * scale),
    );
    canvas.drawRRect(micRect, micPaint);

    // Mic stand
    canvas.drawLine(
      Offset(centerX, centerY + 10 * scale),
      Offset(centerX, centerY + 40 * scale),
      micPaint,
    );

    // Mic base
    canvas.drawLine(
      Offset(centerX - 20 * scale, centerY + 40 * scale),
      Offset(centerX + 20 * scale, centerY + 40 * scale),
      micPaint,
    );

    // X mark
    final xPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(centerX - 15 * scale, centerY - 35 * scale),
      Offset(centerX + 15 * scale, centerY - 5 * scale),
      xPaint,
    );
    canvas.drawLine(
      Offset(centerX + 15 * scale, centerY - 35 * scale),
      Offset(centerX - 15 * scale, centerY - 5 * scale),
      xPaint,
    );
  }

  void _drawStudentsEmpty(
      Canvas canvas, Size size, double centerX, double centerY) {
    final scale = size.width / 400;

    // Person icon
    final personPaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;

    // Head
    canvas.drawCircle(
        Offset(centerX, centerY - 30 * scale), 25 * scale, personPaint);

    // Body
    final bodyPath = Path();
    bodyPath.moveTo(centerX, centerY - 5 * scale);
    bodyPath.lineTo(centerX, centerY + 20 * scale);
    canvas.drawPath(bodyPath, personPaint);

    // Arms
    canvas.drawLine(
      Offset(centerX - 30 * scale, centerY + 10 * scale),
      Offset(centerX + 30 * scale, centerY + 10 * scale),
      personPaint,
    );

    // Legs
    canvas.drawLine(
      Offset(centerX, centerY + 20 * scale),
      Offset(centerX - 20 * scale, centerY + 50 * scale),
      personPaint,
    );
    canvas.drawLine(
      Offset(centerX, centerY + 20 * scale),
      Offset(centerX + 20 * scale, centerY + 50 * scale),
      personPaint,
    );

    // X mark
    final xPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(centerX - 15 * scale, centerY - 45 * scale),
      Offset(centerX + 15 * scale, centerY - 15 * scale),
      xPaint,
    );
    canvas.drawLine(
      Offset(centerX + 15 * scale, centerY - 45 * scale),
      Offset(centerX - 15 * scale, centerY - 15 * scale),
      xPaint,
    );
  }

  void _drawFloatingRect(Canvas canvas, double x, double y, double width,
      double height, double angle, Color color, double scale) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle * math.pi / 180);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: width, height: height),
        Radius.circular(2 * scale),
      ),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}