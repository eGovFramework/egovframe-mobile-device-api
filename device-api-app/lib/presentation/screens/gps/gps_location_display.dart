import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsLocationDisplay extends StatefulWidget {
  final Position? position;
  final String? timestamp;

  const GpsLocationDisplay({
    super.key,
    this.position,
    this.timestamp,
  });

  @override
  State<GpsLocationDisplay> createState() => _GpsLocationDisplayState();
}

class _GpsLocationDisplayState extends State<GpsLocationDisplay> {
  Position? _currentPosition;
  String _currentTimestamp = '';

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.position;
    _currentTimestamp = widget.timestamp ?? '';
  }

  @override
  void didUpdateWidget(GpsLocationDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool hasChanged = false;

    if (oldWidget.position != widget.position) {
      hasChanged = true;
    }

    if (hasChanged) {
      setState(() {
        _currentPosition = widget.position;
        _currentTimestamp = widget.timestamp ?? '';
      });
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final milliseconds = int.tryParse(timestamp);
      if (milliseconds != null) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
        final localTime = dateTime.toLocal(); // UTC를 로컬 시간으로 변환
        return '${localTime.year}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')} ${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}:${localTime.second.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      print('Error formatting timestamp: $e');
    }
    return timestamp; // 변환 실패 시 원본 반환
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: EgovColor.white100,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: EgovColor.gray30,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '위치 정보가 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: EgovColor.gray40,
            ),
          ),
        ),
      );
    }

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
          _buildLocationRow('위도', _currentPosition!.latitude, EgovColor.primary50),
          const SizedBox(height: 8),
          _buildLocationRow('경도', _currentPosition!.longitude, EgovColor.success50),
          const SizedBox(height: 8),
          _buildLocationRow('정확도', _currentPosition!.accuracy, EgovColor.danger50, unit: 'm'),
          if (_currentTimestamp.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Timestamp: ${_formatTimestamp(_currentTimestamp)}',
              style: const TextStyle(
                fontSize: 12,
                color: EgovColor.gray40,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationRow(String label, double value, Color color, {String unit = ''}) {
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
          '${value.toStringAsFixed(6)}$unit',
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
