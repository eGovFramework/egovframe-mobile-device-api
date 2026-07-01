import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../utils/error_handler.dart';

class ThreeDCube extends StatefulWidget {
  final double xAxis;
  final double yAxis;
  final double zAxis;

  const ThreeDCube({
    super.key,
    required this.xAxis,
    required this.yAxis,
    required this.zAxis,
  });

  @override
  State<ThreeDCube> createState() => _ThreeDCubeState();
}

class _ThreeDCubeState extends State<ThreeDCube> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(8, 8),
            spreadRadius: 2,
          ),
        ],
        gradient: RadialGradient(
          colors: [
            Colors.grey[100]!,
            Colors.grey[200]!,
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CustomPaint(
                     painter: Simple3DCubePainter(
             xRotation: widget.xAxis * 0.1,
             yRotation: widget.yAxis * 0.1,
             zRotation: widget.zAxis * 0.1,
           ),
          size: const Size(400, 400),
        ),
      ),
    );
  }


}

// 간단하고 안전한 3D 큐브를 그리는 CustomPainter
class Simple3DCubePainter extends CustomPainter {
  final double xRotation;
  final double yRotation;
  final double zRotation;

  Simple3DCubePainter({
    required this.xRotation,
    required this.yRotation,
    required this.zRotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    try {
      final center = Offset(size.width / 2, size.height / 2);
      final cubeSize = 100.0; // 고정 크기
      
      // 배경 그리기
      _drawBackground(canvas, size);
      
      // 큐브의 8개 정점 (3D 좌표)
      final vertices3D = [
        {'pos': Offset(-cubeSize/2, -cubeSize/2), 'z': -cubeSize/2}, // 0: 왼쪽 위 앞
        {'pos': Offset(cubeSize/2, -cubeSize/2), 'z': -cubeSize/2},  // 1: 오른쪽 위 앞
        {'pos': Offset(cubeSize/2, cubeSize/2), 'z': -cubeSize/2},   // 2: 오른쪽 아래 앞
        {'pos': Offset(-cubeSize/2, cubeSize/2), 'z': -cubeSize/2},  // 3: 왼쪽 아래 앞
        {'pos': Offset(-cubeSize/2, -cubeSize/2), 'z': cubeSize/2},  // 4: 왼쪽 위 뒤
        {'pos': Offset(cubeSize/2, -cubeSize/2), 'z': cubeSize/2},   // 5: 오른쪽 위 뒤
        {'pos': Offset(cubeSize/2, cubeSize/2), 'z': cubeSize/2},    // 6: 오른쪽 아래 뒤
        {'pos': Offset(-cubeSize/2, cubeSize/2), 'z': cubeSize/2},   // 7: 왼쪽 아래 뒤
      ];
      
                    // 변환된 정점들
       final transformedVertices = vertices3D.map((vertex) {
         final pos = vertex['pos'] as Offset;
         final z = vertex['z'] as double;
         
         // 간단한 3D 변환
         final transformedX = pos.dx * math.cos(yRotation) - z * math.sin(yRotation);
         final transformedY = pos.dy * math.cos(xRotation) - z * math.sin(xRotation);
         
         return Offset(
           transformedX + center.dx,
           transformedY + center.dy,
         );
       }).toList();
      
                    // 큐브의 면들 정의
       final faces = [
         {'indices': [0, 1, 2, 3], 'color': Colors.blue},     // 앞면
         {'indices': [1, 5, 6, 2], 'color': Colors.red},      // 오른쪽면
         {'indices': [5, 4, 7, 6], 'color': Colors.green},    // 뒷면
         {'indices': [4, 0, 3, 7], 'color': Colors.orange},   // 왼쪽면
         {'indices': [3, 2, 6, 7], 'color': Colors.purple},   // 아래면
         {'indices': [4, 5, 1, 0], 'color': Colors.cyan},     // 위면
       ];
      
      // 각 면의 중심점 Z좌표 계산 및 정렬
      final sortedFaces = faces.map((face) {
        final indices = face['indices'] as List<int>;
        final centerZ = indices.map((i) => vertices3D[i]['z'] as double).reduce((a, b) => a + b) / 4;
        return {...face, 'centerZ': centerZ};
      }).toList();
      
      // Z축 기준으로 정렬 (뒤에서 앞으로)
      sortedFaces.sort((a, b) => (a['centerZ'] as double).compareTo(b['centerZ'] as double));
      
                    // 각 면을 그리기
       for (final faceData in sortedFaces) {
         final indices = faceData['indices'] as List<int>;
         final baseColor = faceData['color'] as Color;
         final centerZ = faceData['centerZ'] as double;
         
         // 깊이에 따른 조명 효과 (투명도 없이)
         final lightIntensity = (centerZ + cubeSize/2) / cubeSize;
         final adjustedColor = Color.lerp(
           baseColor,
           Colors.grey[300]!,
           (1.0 - lightIntensity).clamp(0.0, 0.3),
         )!;
         
         _drawFace(canvas, transformedVertices, indices, adjustedColor);
       }
      
      // 큐브의 모서리 그리기
      _drawEdges(canvas, transformedVertices);
      
    } catch (e, stackTrace) {
      ErrorHandler.logError(e, stackTrace, context: 'CubePainter.paint');
    }
  }
  
  void _drawBackground(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.grey[100]!
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
  }
  
  void _drawFace(Canvas canvas, List<Offset> vertices, List<int> indices, Color color) {
    try {
      final path = Path();
      path.moveTo(vertices[indices[0]].dx, vertices[indices[0]].dy);
      for (int i = 1; i < indices.length; i++) {
        path.lineTo(vertices[indices[i]].dx, vertices[indices[i]].dy);
      }
      path.close();
      
      // 면 그리기
      final facePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(path, facePaint);
      
      // 면 테두리
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawPath(path, borderPaint);
    } catch (e, stackTrace) {
      ErrorHandler.logError(e, stackTrace, context: 'CubePainter._drawFace');
    }
  }

  void _drawEdges(Canvas canvas, List<Offset> vertices) {
    try {
      final edgePaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      
      // 큐브의 모서리들
      final edges = [
        [0, 1], [1, 2], [2, 3], [3, 0], // 앞면 모서리
        [4, 5], [5, 6], [6, 7], [7, 4], // 뒷면 모서리
        [0, 4], [1, 5], [2, 6], [3, 7], // 연결 모서리
      ];
      
      for (final edge in edges) {
        if (edge[0] < vertices.length && edge[1] < vertices.length) {
          canvas.drawLine(vertices[edge[0]], vertices[edge[1]], edgePaint);
        }
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e, stackTrace, context: 'CubePainter._drawEdges');
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is Simple3DCubePainter) {
      return oldDelegate.xRotation != xRotation ||
             oldDelegate.yRotation != yRotation ||
             oldDelegate.zRotation != zRotation;
    }
    return true;
  }
}
