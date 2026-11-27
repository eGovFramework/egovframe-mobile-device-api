import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:http/http.dart' as http;

/// device-api-web 공통 HTTP 클라이언트.
///
/// Cordova 가이드의 `EgovInterface.get` / `post` / `geturl`에 해당한다.
/// Interface 기능 앱(`/itf`, 가입·로그인·탈퇴 화면)과는 별개의 클래스다.
///
/// 서버 주소, Accept, 폼 인코딩, 제한 시간, JSON/`resultState` 해석을 여기서 처리한다.
/// 각 기능 앱은 경로와 파라미터, 응답에서 꺼낼 목록 키만 넘긴다.
class DeviceApiClient {
  DeviceApiClient._();

  static const Duration probeTimeout = Duration(seconds: 5);

  /// 가이드 `geturl`. 환경설정에 등록된 device-api-web 기본 주소.
  static String getUrl() => AppConfig.currentBaseUrl;

  /// [path]가 `/gps/insertGPSInfo.do` 형태이면 기본 주소를 붙인다.
  static Uri resolve(String path, {Map<String, String>? params}) {
    final base = path.startsWith('http') ? path : '$getUrl$path';
    final uri = Uri.parse(base);
    if (params == null || params.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: params);
  }

  static http.Client openClient() => http.Client();

  static Future<DeviceApiResult> get(
    Uri url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) {
    return _execute('GET', url, headers: headers, timeout: timeout);
  }

  static Future<DeviceApiResult> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) {
    return _execute('POST', url, headers: headers, body: body, timeout: timeout);
  }

  static Future<DeviceApiResult> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) {
    return _execute(
      'DELETE',
      url,
      headers: headers,
      body: body,
      timeout: timeout,
    );
  }

  /// 스트림·multipart 요청. [client]는 [openClient]로 만들고, 스트림을 읽은 뒤 close 한다.
  static Future<http.StreamedResponse> send(
    http.Client client,
    http.BaseRequest request, {
    Duration? timeout,
  }) {
    request.headers.addAll(AppConfig.authorizationHeaders);
    final future = client.send(request);
    if (timeout == null) {
      return future;
    }
    return future.timeout(timeout);
  }

  static Future<DeviceApiResult> _execute(
    String method,
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    final response = await _raw(method, url, headers: headers, body: body)
        .timeout(timeout ?? AppConfig.defaultTimeout);
    return DeviceApiResult.fromResponse(response);
  }

  static Future<http.Response> _raw(
    String method,
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    final merged = _headers(headers, body: body);
    switch (method) {
      case 'POST':
        return http.post(url, headers: merged, body: body);
      case 'DELETE':
        return http.delete(url, headers: merged, body: body);
      default:
        return http.get(url, headers: merged);
    }
  }

  static Map<String, String> _headers(
    Map<String, String>? headers, {
    Object? body,
  }) {
    final merged = <String, String>{
      'Accept': 'application/json',
      ...AppConfig.authorizationHeaders,
      ...?headers,
    };
    if (body is Map && !merged.containsKey('Content-Type')) {
      merged['Content-Type'] = 'application/x-www-form-urlencoded';
    }
    return merged;
  }

  static Future<bool> isNetworkAvailable() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    } catch (e) {
      appLog('Network availability check failed: $e');
      return false;
    }
  }

  /// 기능별 목록·조회 URL로 device-api-web 연결을 확인한다.
  static Future<ServerConnectionResult> probe({
    required Uri url,
    required String featureName,
    bool checkNetwork = true,
    String method = 'GET',
    Map<String, String>? headers,
    Object? body,
    Duration timeout = probeTimeout,
  }) async {
    try {
      appLog('Checking $featureName server connection...');

      if (checkNetwork && !await isNetworkAvailable()) {
        appLog('No network connection.');
        return ServerConnectionResult.networkUnavailable;
      }

      final DeviceApiResult response;
      try {
        response = method.toUpperCase() == 'POST'
            ? await post(url, headers: headers, body: body, timeout: timeout)
            : await get(url, headers: headers, timeout: timeout);
      } catch (e) {
        appLog('$featureName server connection test failed: $e');
        return ServerConnectionResult.serverUnreachable;
      }

      if (response.statusCode == 200) {
        appLog('$featureName server connection: ok');
        return ServerConnectionResult.connected;
      }

      if (response.statusCode == 500) {
        appLog(
          '$featureName server DB error (status: 500). '
          'Check MySQL on 127.0.0.1:3306 and hyb schema.',
        );
        return ServerConnectionResult.serverDbError;
      }

      appLog(
        '$featureName server connection failed (status: ${response.statusCode})',
      );
      return ServerConnectionResult.serverUnreachable;
    } catch (e) {
      appLog('$featureName server connection check failed: $e');
      return ServerConnectionResult.serverUnreachable;
    }
  }
}

/// device-api-web REST 응답. HTTP 상태, 원문, JSON, `resultState`를 함께 담는다.
class DeviceApiResult {
  DeviceApiResult({
    required this.statusCode,
    required this.bodyBytes,
    required this.jsonValue,
  });

  final int statusCode;
  final Uint8List bodyBytes;
  final Object? jsonValue;

  factory DeviceApiResult.fromResponse(http.Response response) {
    Object? jsonValue;
    if (response.bodyBytes.isNotEmpty) {
      try {
        jsonValue = jsonDecode(utf8.decode(response.bodyBytes));
      } catch (_) {
        jsonValue = null;
      }
    }
    return DeviceApiResult(
      statusCode: response.statusCode,
      bodyBytes: response.bodyBytes,
      jsonValue: jsonValue,
    );
  }

  bool get httpOk => statusCode == 200;

  String get body => utf8.decode(bodyBytes, allowMalformed: true);

  Map<String, dynamic>? get json {
    final value = jsonValue;
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  String? get resultState => json?['resultState']?.toString();

  String? get resultMessage => json?['resultMessage']?.toString();

  /// HTTP 200이고, 본문에 `resultState`가 있으면 OK 또는 PARTIAL일 때 성공이다.
  bool get isSuccess {
    if (!httpOk) {
      return false;
    }
    final state = resultState;
    return state == null || state == 'OK' || state == 'PARTIAL';
  }

  List<Map<String, dynamic>> list(String key) {
    final value = json?[key];
    if (value is! List) {
      return [];
    }
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
