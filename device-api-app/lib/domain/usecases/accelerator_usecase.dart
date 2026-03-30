import 'package:egovframe_mobile_deviceapi_app/domain/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/accelerator_repository.dart';

class AcceleratorUseCase {
  final AcceleratorRepository repository;

  AcceleratorUseCase(this.repository);

  /// 가속도계 정보 조회
  Future<List<AcceleratorInfo>> getAcceleratorInfo(String uuid) async {
    return await repository.getAcceleratorInfoList(uuid);
  }

  /// 가속도계 정보 저장
  Future<bool> saveAcceleratorInfo(AcceleratorInfo info) async {
    return await repository.saveAcceleratorInfo(info);
  }
}
