import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';

abstract class BarcodeRepository {
  Future<bool> uploadBarcodeInfo(BarcodeInfo info);

  Future<List<BarcodeInfo>> getBarcodeList(String deviceUuid);

  Future<bool> deleteBarcodeInfo(BarcodeInfo info, String deviceUuid);
}
