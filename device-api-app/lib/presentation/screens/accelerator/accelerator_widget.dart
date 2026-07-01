import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';

class AccelerationDisplay extends StatefulWidget {
  final double xAxis;
  final double yAxis;
  final double zAxis;
  final String timestamp;

  const AccelerationDisplay({
    super.key,
    required this.xAxis,
    required this.yAxis,
    required this.zAxis,
    required this.timestamp,
  });

  @override
  State<AccelerationDisplay> createState() => _AccelerationDisplayState();
}

class _AccelerationDisplayState extends State<AccelerationDisplay> {
  double _currentX = 0.0;
  double _currentY = 0.0;
  double _currentZ = 0.0;
  String _currentTimestamp = '';

  @override
  void initState() {
    super.initState();
    _currentX = widget.xAxis;
    _currentY = widget.yAxis;
    _currentZ = widget.zAxis;
    _currentTimestamp = widget.timestamp;
  }

  @override
  void didUpdateWidget(AccelerationDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool hasChanged = false;

    if ((oldWidget.xAxis - widget.xAxis).abs() > 0.001 ||
        (oldWidget.yAxis - widget.yAxis).abs() > 0.001 ||
        (oldWidget.zAxis - widget.zAxis).abs() > 0.001) {
      hasChanged = true;
    }

    if (hasChanged) {
      setState(() {
        _currentX = widget.xAxis;
        _currentY = widget.yAxis;
        _currentZ = widget.zAxis;
        _currentTimestamp = widget.timestamp;
      });
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final milliseconds = int.tryParse(timestamp);
      if (milliseconds == null) {
        ErrorHandler.logError(
          FormatException('타임스탬프를 숫자로 변환할 수 없습니다: $timestamp'),
          StackTrace.current,
          context: 'AccelerationDisplay._formatTimestamp',
        );
        return timestamp;
      }
      final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        e,
        stackTrace,
        context: 'AccelerationDisplay._formatTimestamp',
      );
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAxisRow('X', _currentX, Colors.red),
          const SizedBox(height: 8),
          _buildAxisRow('Y', _currentY, Colors.green),
          const SizedBox(height: 8),
          _buildAxisRow('Z', _currentZ, Colors.blue),
          const SizedBox(height: 16),
          Text(
            'Timestamp: ${_formatTimestamp(_currentTimestamp)}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAxisRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}