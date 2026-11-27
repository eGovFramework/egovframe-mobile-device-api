import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';

abstract class AcceleratorRepository {
  Future<List<AcceleratorInfo>> getAcceleratorInfoList(String uuid);
  Future<bool> saveAcceleratorInfo(AcceleratorInfo info);
  Future<bool> deleteAcceleratorInfo(AcceleratorInfo info, String deviceUuid);
}
