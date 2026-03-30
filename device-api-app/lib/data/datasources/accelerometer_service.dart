import 'dart:async';
import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/accelerator_info.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final StreamController<AccelerometerEvent> _accelerometerController = 
      StreamController<AccelerometerEvent>.broadcast();

  Stream<AccelerometerEvent> get accelerometerStream => _accelerometerController.stream;

  void startAccelerometer() {
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        _accelerometerController.add(event);
      },
      onError: (error) {
        // 에러 처리
      },
      onDone: () {
        // 스트림 완료 처리
      },
    );
  }

  void stopAccelerometer() {
    if (_accelerometerSubscription != null) {
      _accelerometerSubscription?.cancel();
      _accelerometerSubscription = null;
    }
  }

  void dispose() {
    stopAccelerometer();
    _accelerometerController.close();
  }

  // 가속도 정보 목록 조회
  static Future<List<AcceleratorInfo>> getAcceleratorInfoList(String uuid) async {
    final uri = Uri.parse(AppConfig.getAcceleratorUrl('/selectAcceleratorInfoList.do'))
        .replace(queryParameters: {'uuid': uuid});

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['resultState'] == 'OK') {
        final List<dynamic> acceleratorInfoList = jsonResponse['acceleratorInfoList'] ?? [];
        return acceleratorInfoList
            .map((item) => AcceleratorInfo.fromJson(item))
            .toList();
      }
    }
    throw Exception('Failed to load accelerator info list');
  }

  // 가속도 정보 저장
  static Future<bool> saveAcceleratorInfo(AcceleratorInfo info) async {
    final uri = Uri.parse(AppConfig.getAcceleratorUrl('/insertAcceleratorInfo.do'));
    
    final body = info.toJson().map((key, value) => MapEntry(key, value.toString()));

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['resultState'] == 'OK' || jsonResponse['useYn'] == 'OK';
    }
    return false;
  }

  // 가속도 정보 삭제
  static Future<bool> deleteAcceleratorInfo() async {
    final uri = Uri.parse(AppConfig.getAcceleratorUrl('/deleteAcceleratorInfo.do'));

    final response = await http.delete(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      try {
        if ((response.headers['content-type'] ?? '').contains('application/json')) {
          final Map<String, dynamic> body = json.decode(response.body) as Map<String, dynamic>;
          final successCode = (body['successCode'] ?? body['resultState'] ?? body['useYn'] ?? '').toString().toUpperCase();
          return successCode == 'OK' || successCode == 'Y';
        } else {
          final bodyText = response.body.trim().toLowerCase();
          return bodyText.isEmpty || bodyText == 'ok' || bodyText.contains('success');
        }
      } catch (_) {
        return true;
      }
    }
    return false;
  }
}
