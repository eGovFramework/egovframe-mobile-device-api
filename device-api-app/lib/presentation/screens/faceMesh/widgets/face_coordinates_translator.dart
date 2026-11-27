import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Face Mesh 좌표 [FaceMeshOverlayPainter]
double translateFaceX(
  double x,
  Size canvasSize,
  Size imageSize,
  CameraLensDirection cameraLensDirection, {
  int rotationDegrees = 0,
}) {
  final normalized = ((rotationDegrees % 360) + 360) % 360;
  switch (normalized) {
    case 90:
      return x *
          canvasSize.width /
          (Platform.isIOS ? imageSize.width : imageSize.height);
    case 270:
      return canvasSize.width -
          x *
              canvasSize.width /
              (Platform.isIOS ? imageSize.width : imageSize.height);
    default:
      switch (cameraLensDirection) {
        case CameraLensDirection.back:
          return x * canvasSize.width / imageSize.width;
        default:
          return canvasSize.width - x * canvasSize.width / imageSize.width;
      }
  }
}

double translateFaceY(
  double y,
  Size canvasSize,
  Size imageSize,
  CameraLensDirection cameraLensDirection, {
  int rotationDegrees = 0,
}) {
  final normalized = ((rotationDegrees % 360) + 360) % 360;
  switch (normalized) {
    case 90:
    case 270:
      return y *
          canvasSize.height /
          (Platform.isIOS ? imageSize.height : imageSize.width);
    default:
      return y * canvasSize.height / imageSize.height;
  }
}

Rect translateFaceRect(
  Rect boundingBox,
  Size canvasSize,
  Size imageSize,
  CameraLensDirection cameraLensDirection, {
  int rotationDegrees = 0,
}) {
  final left = translateFaceX(
    boundingBox.left,
    canvasSize,
    imageSize,
    cameraLensDirection,
    rotationDegrees: rotationDegrees,
  );
  final top = translateFaceY(
    boundingBox.top,
    canvasSize,
    imageSize,
    cameraLensDirection,
    rotationDegrees: rotationDegrees,
  );
  final right = translateFaceX(
    boundingBox.right,
    canvasSize,
    imageSize,
    cameraLensDirection,
    rotationDegrees: rotationDegrees,
  );
  final bottom = translateFaceY(
    boundingBox.bottom,
    canvasSize,
    imageSize,
    cameraLensDirection,
    rotationDegrees: rotationDegrees,
  );
  return Rect.fromLTRB(left, top, right, bottom);
}
