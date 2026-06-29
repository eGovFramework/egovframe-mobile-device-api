import 'package:egovframe_mobile_deviceapi_app/domain/entities/accelerator_info.dart';

abstract class AcceleratorRepository {
  Future<List<AcceleratorInfo>> getAcceleratorInfoList(String uuid);
  Future<bool> saveAcceleratorInfo(AcceleratorInfo info);
  Future<bool> deleteAcceleratorInfo({required String uuid, required int sn});
}
