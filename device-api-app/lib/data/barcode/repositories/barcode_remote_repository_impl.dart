import 'package:egovframe_mobile_deviceapi_app/data/barcode/datasources/barcode_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/repositories/barcode_repository.dart';

class BarcodeRemoteRepositoryImpl implements BarcodeRepository {
  @override
  Future<bool> uploadBarcodeInfo(BarcodeInfo info) async {
    final response = await BarcodeService.postBarcodeInfo(info.toUploadFields());
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    if (resultState == 'OK') {
      return true;
    }

    final useYn = (response['useYn'] ?? '').toString();
    return useYn == 'OK';
  }

  @override
  Future<List<BarcodeInfo>> getBarcodeList(String deviceUuid) async {
    final rawList = await BarcodeService.fetchBarcodeInfoList(uuid: deviceUuid);
    return rawList.map(BarcodeInfo.fromJson).toList();
  }

  @override
  Future<bool> deleteBarcodeInfo(
    BarcodeInfo info,
    String deviceUuid,
  ) async {
    if (!barcodeBelongsToDevice(info, deviceUuid)) {
      return false;
    }

    final response = await BarcodeService.deleteBarcodeInfo(
      sn: info.sn,
      uuid: deviceUuid,
    );
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }
}
