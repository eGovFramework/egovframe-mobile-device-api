import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';

/// 앱 전역 기기 UUID 조회 유틸.
/// [DeviceIdService]가 생성·저장한 UUID v4를 반환합니다.
class DeviceUuidUtil {
  static Future<String> getDeviceUuid() => DeviceIdService.getDeviceId();
}
