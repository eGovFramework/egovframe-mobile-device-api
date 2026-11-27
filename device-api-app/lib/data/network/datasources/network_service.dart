import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:network_info_plus/network_info_plus.dart' as network_info_plus;

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();
  
  final Connectivity _connectivity = Connectivity();
  final network_info_plus.NetworkInfo _networkInfoPlugin = network_info_plus.NetworkInfo();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// 현재 네트워크 연결 상태 확인
  Future<ConnectivityResult> getCurrentConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      appLog('현재 네트워크 상태: $result');
      return result;
    } catch (e) {
      appLog('네트워크 상태 확인 오류: $e');
      return ConnectivityResult.none;
    }
  }

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged.map((results) => 
          results.isNotEmpty ? results.first : ConnectivityResult.none);

  /// 현재 네트워크 정보 가져오기
  Future<NetworkInfo> getCurrentNetworkInfo() async {
    try {
      final connectivity = await getCurrentConnectivity();
      final deviceId = await getDeviceId();
      final deviceName = await _getDeviceName();
      
      String networkType = _mapConnectivityToType(connectivity);
      String networkTypeName = NetworkInfo.getNetworkTypeName(networkType);
      
      String? ipAddress;
      String? macAddress;
      String? ssid;

      if (connectivity == ConnectivityResult.wifi) {
        try {
          ipAddress = await _networkInfoPlugin.getWifiIP();
          ssid = await _networkInfoPlugin.getWifiName();
          // MAC 주소는 보안상 제한됨 (Android 6.0+, iOS)
        } catch (e) {
          appLog('WiFi 정보 가져오기 오류: $e');
        }
      }

      return NetworkInfo(
        networkType: networkType,
        networkTypeName: networkTypeName,
        deviceId: deviceId,
        deviceName: deviceName,
        useYn: 'Y',
        registDate: DateTime.now(),
        ipAddress: ipAddress,
        macAddress: macAddress,
        ssid: ssid,
      );
    } catch (e) {
      appLog('네트워크 정보 가져오기 오류: $e');
      rethrow;
    }
  }

  /// ConnectivityResult를 네트워크 타입 문자열로 변환
  String _mapConnectivityToType(ConnectivityResult connectivity) {
    switch (connectivity) {
      case ConnectivityResult.wifi:
        return 'WIFI';
      case ConnectivityResult.mobile:
        return 'CELL_4G'; // 기본적으로 4G로 설정, 실제로는 더 세분화 가능
      case ConnectivityResult.ethernet:
        return 'ETHERNET';
      case ConnectivityResult.none:
        return 'NONE';
      default:
        return 'UNKNOWN';
    }
  }

  /// 디바이스 ID 가져오기 (UUID v4)
  Future<String> getDeviceId() => DeviceIdService.getDeviceId();

  /// 디바이스 이름 가져오기
  Future<String> _getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return '${iosInfo.name} (${iosInfo.model})';
      }
      return 'Unknown Device';
    } catch (e) {
      appLog('디바이스 이름 가져오기 오류: $e');
      return 'Unknown Device';
    }
  }

  /// 디바이스 이름 (Repository Entity 매핑용)
  Future<String> getDeviceName() => _getDeviceName();

  /// 네트워크 정보 서버 전송 (HTTP만)
  Future<({int statusCode, String body})> insertNetworkInfo(
    Map<String, String> body,
  ) async {
    try {
      appLog('네트워크 정보 서버 전송 시작');

      final uri = Uri.parse(AppConfig.getNetworkUrl('/insertNetworkInfo.do'));
      final response = await DeviceApiClient.post(
            uri,
            body: body,
          );

      appLog('네트워크 정보 서버 전송 응답: status=${response.statusCode}');
      return (statusCode: response.statusCode, body: response.body);
    } catch (e) {
      appLog('네트워크 정보 서버 전송 오류: $e');
      return (statusCode: -1, body: '');
    }
  }

  /// 서버 네트워크 정보 목록 조회 (원시 JSON 항목)
  Future<List<Map<String, dynamic>>> fetchNetworkInfoList({
    required String uuid,
    String networkType = 'ALL',
  }) async {
    try {
      appLog('네트워크 정보 목록 서버 조회 시작');

      final uri = Uri.parse(AppConfig.getNetworkUrl('/selectNetworkInfoList.do'))
          .replace(
        queryParameters: {
          'uuid': uuid,
          'networktype': networkType,
        },
      );

      final response = await DeviceApiClient.get(uri);
      appLog('네트워크 정보 목록 서버 조회 응답: status=${response.statusCode}');

      if (response.statusCode != 200) {
        appLog('네트워크 정보 목록 조회 실패: HTTP ${response.statusCode}');
        return [];
      }

      final parsed = response.json;
      final raw = parsed?['networkInfoList'] ?? parsed?['list'] ?? [];
      if (raw is! List) {
        return [];
      }

      final result = raw
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      appLog('네트워크 정보 목록 서버 조회 완료: ${result.length}개');
      return result;
    } catch (e) {
      appLog('네트워크 정보 목록 서버 조회 오류: $e');
      return [];
    }
  }

  /// 네트워크 정보 삭제 (HTTP만)
  Future<({int statusCode, String body})> deleteNetworkInfoRequest(
    String sn,
    String uuid,
  ) async {
    try {
      appLog('네트워크 정보 서버 삭제 시작: $sn');

      final uri = Uri.parse(AppConfig.getNetworkUrl('/deleteNetworkInfo.do'))
          .replace(queryParameters: {'sn': sn, 'uuid': uuid});

      final response =
          await DeviceApiClient.delete(uri);
      appLog('네트워크 정보 서버 삭제 응답: status=${response.statusCode}');
      return (statusCode: response.statusCode, body: response.body);
    } catch (e) {
      appLog('네트워크 정보 서버 삭제 오류: $e');
      return (statusCode: -1, body: '');
    }
  }

  /// 네트워크 상태 체크하여 연결 가능 여부 확인
  Future<bool> isNetworkAvailable() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    } catch (e) {
      appLog('네트워크 연결 확인 오류: $e');
      return false;
    }
  }

  /// 서버 연결 상태 확인
  Future<bool> isServerConnected() async {
    try {
      appLog('서버 연결 상태 확인 시작...');
      
      // 먼저 네트워크 연결 상태 확인
      final isNetworkAvailable = await this.isNetworkAvailable();
      if (!isNetworkAvailable) {
        appLog('네트워크 연결이 없습니다.');
        return false;
      }

      appLog('네트워크 연결 확인됨, 서버 연결 테스트 시작...');

      try {
        final response = await DeviceApiClient.get(
          Uri.parse(AppConfig.getNetworkUrl('/selectNetworkInfoList.do')),
          timeout: const Duration(seconds: 5),
        );

        if (response.statusCode == 500) {
          appLog('서버 초기화 오류 감지 (상태코드: ${response.statusCode})');
          return false;
        }

        final isConnected = response.statusCode == 200;
        appLog('서버 연결 상태: ${isConnected ? "연결됨" : "연결 안됨"} (상태코드: ${response.statusCode})');
        return isConnected;
      } catch (e) {
        appLog('서버 연결 테스트 실패: $e');
        return false;
      }
    } catch (e) {
      appLog('서버 연결 확인 오류: $e');
      return false;
    }
  }

  /// 네트워크 품질 체크 (시뮬레이션)
  Future<String> getNetworkQuality() async {
    try {
      final connectivity = await getCurrentConnectivity();
      
      switch (connectivity) {
        case ConnectivityResult.wifi:
          return '우수';
        case ConnectivityResult.mobile:
          return '보통';
        case ConnectivityResult.ethernet:
          return '최우수';
        case ConnectivityResult.none:
          return '연결 없음';
        default:
          return '알 수 없음';
      }
    } catch (e) {
      appLog('네트워크 품질 확인 오류: $e');
      return '알 수 없음';
    }
  }


  /// 네트워크 상태에 따른 권장 동작 반환
  String getNetworkRecommendation(String networkType) {
    switch (networkType) {
      case 'WIFI':
        return '고품질 미디어 스트리밍 및 대용량 파일 다운로드 권장';
      case 'CELL_4G':
      case 'CELL_5G':
        return '일반적인 웹 브라우징 및 스트리밍 가능';
      case 'CELL_3G':
        return '텍스트 위주의 콘텐츠 이용 권장';
      case 'CELL_2G':
        return '기본적인 통신 기능만 이용 권장';
      case 'ETHERNET':
        return '최적의 네트워크 환경, 모든 기능 이용 가능';
      case 'NONE':
        return '네트워크 연결을 확인해주세요';
      default:
        return '네트워크 상태를 확인 중입니다';
    }
  }
}
