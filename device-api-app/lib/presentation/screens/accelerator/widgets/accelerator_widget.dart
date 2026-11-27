import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:flutter/material.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';

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

    if ((oldWidget.xAxis - widget.xAxis).abs() > 0.000001 ||
        (oldWidget.yAxis - widget.yAxis).abs() > 0.000001 ||
        (oldWidget.zAxis - widget.zAxis).abs() > 0.000001) {
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
        final dateTime = DateTime.fromMillisecondsSinceEpoch(
          milliseconds,
          isUtc: true,
        );
        return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
      }
    } catch (_) {
      // 변환 실패 시 원본 timestamp 문자열을 그대로 사용
    }
    return timestamp;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: EgovColor.black10,
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
            '${l10n.commonTimestampLabel}: ${_formatTimestamp(_currentTimestamp)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value.toStringAsFixed(6),
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
