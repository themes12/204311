import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:google_ml_kit/google_ml_kit.dart';

class FacePainter extends CustomPainter {
  final ui.Image image;
  final ui.Image filter_image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.filter_image, this.faces) {
    for(Face face in faces){
      rects.add(face.boundingBox);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
    ..color = Colors.red;
    canvas.drawImage(image, Offset.zero, paint);
    for(Rect rect in rects) {
      // canvas.drawImageRect(filter_image, rect, rect, paint);
      final double extensionFactor = 1.5; // Adjust this factor as needed
      final Rect destinationRect = Rect.fromPoints(
        Offset(rect.left - rect.width * (extensionFactor - 1) / 2, rect.top - rect.height * (extensionFactor - 1) / 2),
        Offset(rect.right + rect.width * (extensionFactor - 1) / 2, rect.bottom + rect.height * (extensionFactor - 1) / 2),
      );

      // Draw the filter image with the extended destination rectangle
      canvas.drawImageRect(
        filter_image,
        Rect.fromPoints(Offset(0, 0), Offset(filter_image.width.toDouble(), filter_image.height.toDouble())),
        destinationRect,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.image != image;
  }
}