import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera_demo/face_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

class FaceMeshWidget extends StatefulWidget {
  const FaceMeshWidget({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<FaceMeshWidget> createState() => _FaceMeshWidgetState();
}

class _FaceMeshWidgetState extends State<FaceMeshWidget> {
  final faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableLandmarks: true,
      )
  );

  List<Face> _faces = [];
  ui.Image? _image;
  ui.Image? filterImage;
  Future<void> detectFaces() async {
    final inputImage = InputImage.fromFilePath(widget.imagePath);
    _faces = await faceDetector.processImage(inputImage);
    _image = await loadImage();
    filterImage = await loadImageFilter();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: detectFaces(), builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done) {
        return CustomPaint(painter: FacePainter(_image!, filterImage!, _faces),);
      } else {
        return const Center(child: CircularProgressIndicator(),);
      }
    });
  }

  Future<ui.Image> loadImage() async {
    final data = await File(widget.imagePath).readAsBytes();
    return await decodeImageFromList(data);
  }

  Future<ui.Image> loadImageFilter() async {
    final data = await rootBundle.load('asset/filter.png');
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    return completer.future;
  }
}