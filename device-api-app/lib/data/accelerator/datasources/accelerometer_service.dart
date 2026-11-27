import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'dart:async';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// 가속도 센서 스트림·서버 HTTP 통신 (Domain Entity 미사용)
class AccelerometerService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final StreamController<AccelerometerEvent> _accelerometerController =
      StreamController<AccelerometerEvent>.broadcast();

  Stream<AccelerometerEvent> get accelerometerStream =>
      _accelerometerController.stream;

  void startAccelerometer() {
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        _accelerometerController.add(event);
      },
      onError: (_) {},
      onDone: () {},
    );
  }

  void stopAccelerometer() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  void dispose() {
    stopAccelerometer();
    _accelerometerController.close();
  }

  /// 가속도 정보 목록 서버 조회 (원시 JSON 항목)
  static Future<List<Map<String, dynamic>>> fetchAcceleratorInfoList(
    String uuid,
  ) async {
    final uri = Uri.parse(AppConfig.getAcceleratorUrl('/selectAcceleratorInfoList.do'))
        .replace(queryParameters: {'uuid': uuid});

    final response = await DeviceApiClient.get(uri);

    if (response.statusCode != 200 || response.resultState != 'OK') {
      throw Exception('Failed to load accelerator info list');
    }

    return response.list('acceleratorInfoList');
  }

  /// 가속도 정보 서버 저장 (응답 본문 반환)
  static Future<Map<String, dynamic>?> postAcceleratorInfo(
    Map<String, String> body,
  ) async {
    final uri = Uri.parse(AppConfig.getAcceleratorUrl('/insertAcceleratorInfo.do'));

    try {
      final response = await DeviceApiClient.post(uri, body: body);

      if (response.statusCode != 200) {
        return null;
      }

      return response.json;
    } catch (e) {
      return null;
    }
  }

  /// 가속도 정보 서버 삭제 (sn + uuid)
  static Future<Map<String, dynamic>?> deleteAcceleratorInfoRequest(
    int sn,
    String uuid,
  ) async {
    final uri = Uri.parse(
      AppConfig.getAcceleratorUrl('/deleteAcceleratorInfo.do'),
    ).replace(queryParameters: {
      'sn': sn.toString(),
      'uuid': uuid,
    });

    final response = await DeviceApiClient.delete(uri);
    if (response.statusCode != 200) {
      return null;
    }

    return response.json;
  }
}
