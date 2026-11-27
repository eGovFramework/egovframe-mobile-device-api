import 'dart:convert';

/// ?깆쓽 怨듯넻 ?ㅼ젙??愿由ы븯???대옒??
///
/// 二쇱냼? 怨꾩젙? 鍮뚮뱶 ?몄옄濡??섍릿??
/// local ?? `--dart-define=APP_ENV=local --dart-define=API_HOST=127.0.0.1`
/// dev ?? `--dart-define=APP_ENV=dev --dart-define=API_BASE_URL=https://example.com:9700 --dart-define=API_USERNAME=deviceapi --dart-define=API_PASSWORD=...`
/// MQTT ?묒냽 媛믪? ?쒕쾭 ?꾨줈?뚯씪?먯꽌 ?쎄퀬, IoT ?붾㈃?먯꽌 ?곌껐???뚮쭔 ?ъ슜?쒕떎.
class AppConfig {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'local',
  );

  /// ?ㅽ궡怨??몄뒪?몃? ??踰덉뿉 吏?뺥븷 ???ъ슜?쒕떎. 鍮꾩뼱 ?덉쑝硫?APP_ENV濡?議고빀?쒕떎.
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  // static const String apiHost = String.fromEnvironment('API_HOST', defaultValue: '127.0.0.1');
  static const String apiHost = String.fromEnvironment(
    'API_HOST',
    defaultValue: '127.0.0.1',
  );
  static const String apiPort = String.fromEnvironment(
    'API_PORT',
    defaultValue: '9700',
  );

  static const String apiUsername = String.fromEnvironment('API_USERNAME');
  static const String apiPassword = String.fromEnvironment('API_PASSWORD');

  // API ?붾뱶?ъ씤?몃뱾
  static const String acceleratorEndpoint = '/acl';
  static const String fileReadWriteEndpoint = '/frw';
  static const String gpsEndpoint = '/gps';
  static const String deviceEndpoint = '/dvc';
  static const String mediaEndpoint = '/mda';
  static const String networkEndpoint = '/nwk';
  static const String interfaceEndpoint = '/itf';
  static const String fileOpenerEndpoint = '/fop';
  static const String barcodeEndpoint = '/bar';
  static const String compassEndpoint = '/cps';
  static const String contactsEndpoint = '/ctt';
  static const String pushEndpoint = '/pus';
  static const String socketEndpoint = '/ws';
  static const String streamingEndpoint = '/stm';
  static const String faceMeshEndpoint = '/fms';
  static const String iotEndpoint = '/iot';
  static const String aiChatEndpoint = '/aic';
  static const String websocketPath = '/websocket/chat.ws';

  /// DEV ?쒕쾭媛 Basic ?몄쬆???붽뎄?????붿껌 ?ㅻ뜑. local? 鍮꾩뼱 ?덈떎.
  static Map<String, String> get authorizationHeaders {
    if (apiUsername.isEmpty && apiPassword.isEmpty) {
      return const {};
    }
    final token = base64Encode(utf8.encode('$apiUsername:$apiPassword'));
    return {'Authorization': 'Basic $token'};
  }

  static const String mqttTelemetryTopicSuffix = 'telemetry';
  static const String mqttCommandTopicSuffix = 'command';
  static const Duration mqttConnectTimeout = Duration(seconds: 10);

  static const String dbFileExtension = '.db';
  // ?쒕쾭 MySQL DDL(deviceapi_all_create_mysql.sql) ?뚯씠釉붾챸怨??숈씪
  static const String barcodeTableName = 'BARCODE_INFO';
  static const String compassTableName = 'COMPASS';
  static const String contactsTableName = 'CONTACT_INFO';
  static const String pushTableName = 'PUSH_DEVICE';
  static const String socketTableName = 'SOCKET_MESSAGE';
  static const String streamingTableName = 'MEDIA';
  static const String deviceTableName = 'DEVICE';
  static const String acceleratorTableName = 'ACCELERATOR';
  static const String gpsTableName = 'GPS';
  static const String networkTableName = 'NETWORK';

  /// Media ??硫뷀? ?뚯씠釉?(MySQL MEDIA + FILE_DETAIL_INFO 議곗씤 ?뺥깭, Streaming??MEDIA? 援щ텇)
  static const String mediaInfoTableName = 'MEDIA_INFO';
  static const String fileReadWriteTableName = 'FILE_READER_WRITE';
  static const String fileOpenerTableName = 'FILE_OPENER_LIST';
  static const String interfaceTableName = 'INTERFACE_EGOV';
  static const String faceMeshTableName = 'FACE_MESH_INFO';
  static const String iotTableName = 'IOT_MESSAGE';
  static const String aiChatTableName = 'AI_CHAT_INFO';

  // ??꾩븘???ㅼ젙
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const Duration fileUploadTimeout = Duration(seconds: 20);
  static const Duration fileDownloadTimeout = Duration(seconds: 30);

  // ?몄뀡 留뚮즺 ?쒓컙 ?ㅼ젙
  static const Duration sessionTimeout = Duration(minutes: 10);

  /// Google Maps API ??(AndroidManifest `com.google.android.geo.API_KEY`? ?숈씪 媛?
  /// 鍮뚮뱶 ?? --dart-define=GOOGLE_MAPS_API_KEY=your_key
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'GOOGLE_MAP_API_KEY',
  );

  static const Set<String> _invalidGoogleMapsApiKeys = {
    '',
    'GOOGLE_MAP_API_KEY',
    'YOUR_API_KEY_HERE',
  };

  /// ????Google Maps ?ъ슜 媛???щ?
  static bool get isGoogleMapsConfigured =>
      !_invalidGoogleMapsApiKeys.contains(googleMapsApiKey);

  static String get currentBaseUrl {
    if (apiBaseUrl.isNotEmpty) {
      return apiBaseUrl.endsWith('/')
          ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
          : apiBaseUrl;
    }
    final scheme = appEnv == 'local' ? 'http' : 'https';
    return '$scheme://$apiHost:$apiPort';
  }

  // ?꾩껜 URL ?앹꽦 ?ы띁 硫붿꽌?쒕뱾
  static String getAcceleratorUrl(String path) =>
      '$currentBaseUrl$acceleratorEndpoint$path';
  static String getFileReadWriteUrl(String path) =>
      '$currentBaseUrl$fileReadWriteEndpoint$path';
  static String getGpsUrl(String path) => '$currentBaseUrl$gpsEndpoint$path';
  static String getDeviceUrl(String path) =>
      '$currentBaseUrl$deviceEndpoint$path';
  static String getMediaUrl(String path) =>
      '$currentBaseUrl$mediaEndpoint$path';
  static String getNetworkUrl(String path) =>
      '$currentBaseUrl$networkEndpoint$path';
  static String getInterfaceUrl(String path) =>
      '$currentBaseUrl$interfaceEndpoint$path';
  static String getFileOpenerUrl(String path) =>
      '$currentBaseUrl$fileOpenerEndpoint$path';
  static String getBarcodeUrl(String path) =>
      '$currentBaseUrl$barcodeEndpoint$path';
  static String getCompassUrl(String path) =>
      '$currentBaseUrl$compassEndpoint$path';
  static String getContactsUrl(String path) =>
      '$currentBaseUrl$contactsEndpoint$path';
  static String getPushUrl(String path) => '$currentBaseUrl$pushEndpoint$path';
  static String getSocketUrl(String path) =>
      '$currentBaseUrl$socketEndpoint$path';
  static String getStreamingUrl(String path) =>
      '$currentBaseUrl$streamingEndpoint$path';
  static String getFaceMeshUrl(String path) =>
      '$currentBaseUrl$faceMeshEndpoint$path';
  static String getIotUrl(String path) => '$currentBaseUrl$iotEndpoint$path';
  static String getAiChatUrl(String path) =>
      '$currentBaseUrl$aiChatEndpoint$path';

  static String get barcodeServerBaseUrl => '$currentBaseUrl$barcodeEndpoint';
  static String get compassServerBaseUrl => '$currentBaseUrl$compassEndpoint';
  static String get contactsServerBaseUrl => '$currentBaseUrl$contactsEndpoint';
  static String get pushServerBaseUrl => '$currentBaseUrl$pushEndpoint';
  static String get socketServerBaseUrl => '$currentBaseUrl$socketEndpoint';
  static String get streamingServerBaseUrl =>
      '$currentBaseUrl$streamingEndpoint';
  static String get acceleratorServerBaseUrl =>
      '$currentBaseUrl$acceleratorEndpoint';
  static String get gpsServerBaseUrl => '$currentBaseUrl$gpsEndpoint';
  static String get networkServerBaseUrl => '$currentBaseUrl$networkEndpoint';
  static String get deviceServerBaseUrl => '$currentBaseUrl$deviceEndpoint';
  static String get mediaServerBaseUrl => '$currentBaseUrl$mediaEndpoint';
  static String get fileReadWriteServerBaseUrl =>
      '$currentBaseUrl$fileReadWriteEndpoint';
  static String get fileOpenerServerBaseUrl =>
      '$currentBaseUrl$fileOpenerEndpoint';
  static String get interfaceServerBaseUrl =>
      '$currentBaseUrl$interfaceEndpoint';
  static String get faceMeshServerBaseUrl => '$currentBaseUrl$faceMeshEndpoint';
  static String get iotServerBaseUrl => '$currentBaseUrl$iotEndpoint';
  static String get aiChatServerBaseUrl => '$currentBaseUrl$aiChatEndpoint';
  static String get featureServerBaseUrl => barcodeServerBaseUrl;

  static String get websocketUrl {
    final uri = Uri.parse(currentBaseUrl);
    final host = uri.host;
    final port = uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    return '$scheme://$host:$port$websocketPath';
  }

  /// MQTT telemetry topic: `iot/{deviceId}/telemetry`
  static String mqttTelemetryTopic(String deviceId) =>
      'iot/$deviceId/$mqttTelemetryTopicSuffix';

  /// MQTT command topic: `iot/{deviceId}/command`
  static String mqttCommandTopic(String deviceId) =>
      'iot/$deviceId/$mqttCommandTopicSuffix';
}
