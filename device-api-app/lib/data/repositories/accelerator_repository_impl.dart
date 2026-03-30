import 'package:egovframe_mobile_deviceapi_app/data/datasources/accelerometer_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/accelerator_repository.dart';

class AcceleratorRepositoryImpl implements AcceleratorRepository {
  AcceleratorRepositoryImpl();

  @override
  Future<List<AcceleratorInfo>> getAcceleratorInfoList(String uuid) async {
    return await AccelerometerService.getAcceleratorInfoList(uuid);
  }

  @override
  Future<bool> saveAcceleratorInfo(AcceleratorInfo info) async {
    return await AccelerometerService.saveAcceleratorInfo(info);
  }

  @override
  Future<bool> deleteAcceleratorInfo() async {
    return await AccelerometerService.deleteAcceleratorInfo();
  }
}
