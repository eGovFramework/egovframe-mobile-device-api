/// 앱의 공통 설정을 관리하는 클래스
class AppConfig {
  // 서버 설정
  // 개발/운영 환경별 설정 (필요시 확장 가능)
  static const String baseUrl = 'http://10.0.2.2:9700';
  
  // API 엔드포인트들
  static const String acceleratorEndpoint = '/acl';
  static const String fileReadWriteEndpoint = '/frw';
  static const String gpsEndpoint = '/gps';
  static const String deviceEndpoint = '/dvc';
  static const String mediaEndpoint = '/mda';
  static const String networkEndpoint = '/nwk';
  static const String interfaceEndpoint = '/itf';
  static const String fileOpenerEndpoint = '/fop';
  
  // 타임아웃 설정
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const Duration fileUploadTimeout = Duration(seconds: 20);
  static const Duration fileDownloadTimeout = Duration(seconds: 30);
  
  // 세션 만료 시간 설정
  static const Duration sessionTimeout = Duration(minutes: 10);
  
  static String get currentBaseUrl {
    return baseUrl;
  }
  
  // 전체 URL 생성 헬퍼 메서드들
  static String getAcceleratorUrl(String path) => '$currentBaseUrl$acceleratorEndpoint$path';
  static String getFileReadWriteUrl(String path) => '$currentBaseUrl$fileReadWriteEndpoint$path';
  static String getGpsUrl(String path) => '$currentBaseUrl$gpsEndpoint$path';
  static String getDeviceUrl(String path) => '$currentBaseUrl$deviceEndpoint$path';
  static String getMediaUrl(String path) => '$currentBaseUrl$mediaEndpoint$path';
  static String getNetworkUrl(String path) => '$currentBaseUrl$networkEndpoint$path';
  static String getInterfaceUrl(String path) => '$currentBaseUrl$interfaceEndpoint$path';
  static String getFileOpenerUrl(String path) => '$currentBaseUrl$fileOpenerEndpoint$path';
}
