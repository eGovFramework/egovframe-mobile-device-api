import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_scan.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

/// 바코드 스캐너 및 서버 HTTP 통신 (device-api-web /bar REST)
class BarcodeService {
  /// 스캔 대상 코드 포맷 (1D 선형 + 2D 매트릭스 전체)
  static const int scanCodeFormat = Format.any;

  /// 카메라 프레임 중앙에서 디코딩할 정사각 영역 비율 (0~1)
  static const double scanCropPercent = 0.7;

  /// 코드 미검출 시 다음 프레임 디코딩까지 대기 시간
  static const Duration scanDelay = Duration(milliseconds: 200);

  /// 코드 검출 성공 후 대기 시간
  static const Duration scanDelaySuccess = Duration(milliseconds: 500);

  /// ZXing 포맷 비트값을 코드 유형 문자열로 변환 (예: 13번째 비트 -> 'QR Code')
  static String formatCodeType(int? format) => (format ?? Format.none).name;

  /// ZXing 디코딩 결과(Code)를 도메인 엔티티로 변환. 유효하지 않으면 null.
  static BarcodeScan? scanFromCode(Code code) {
    if (!code.isValid) {
      return null;
    }

    final text = code.text?.trim();
    if (text == null || text.isEmpty) {
      return null;
    }

    return BarcodeScan(
      codeType: formatCodeType(code.format),
      codeText: text,
      isActive: true,
    );
  }

  /// 서버: 바코드 정보 등록
  static Future<Map<String, dynamic>?> postBarcodeInfo(
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse(AppConfig.getBarcodeUrl('/insertBarcodeInfo.do'));

    try {
      final resp = await DeviceApiClient.post(uri, body: fields);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('BarcodeService.postBarcodeInfo failed: $e');
      return null;
    }
  }

  /// 서버: 바코드 정보 목록 조회 (uuid 필터)
  static Future<List<Map<String, dynamic>>> fetchBarcodeInfoList({
    required String uuid,
  }) async {
    final uri = Uri.parse(AppConfig.getBarcodeUrl('/selectBarcodeInfoList.do'))
        .replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return [];
      }

      return resp.list('barcodeInfoList');
    } catch (e) {
      appLog('BarcodeService.fetchBarcodeInfoList failed: $e');
      return [];
    }
  }

  /// 서버: 바코드 정보 삭제 (sn + uuid)
  static Future<Map<String, dynamic>?> deleteBarcodeInfo({
    required int sn,
    required String uuid,
  }) async {
    final uri = Uri.parse(AppConfig.getBarcodeUrl('/deleteBarcodeInfo.do'))
        .replace(queryParameters: {'sn': sn.toString(), 'uuid': uuid});

    try {
      final resp = await DeviceApiClient.delete(uri);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('BarcodeService.deleteBarcodeInfo failed: $e');
      return null;
    }
  }
}
