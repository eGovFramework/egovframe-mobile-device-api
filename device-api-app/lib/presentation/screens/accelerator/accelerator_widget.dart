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
      if (milliseconds != null) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
        return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      print('Error formatting timestamp: $e');
    }
    return timestamp; // 변환 실패 시 원본 반환
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