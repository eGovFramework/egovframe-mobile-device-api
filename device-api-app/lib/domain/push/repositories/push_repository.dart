import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_message_info.dart';

abstract class PushRepository {
  Future<bool> initializeNotifications();

  Future<PushDeviceInfo> collectPushDeviceInfo();

  Future<bool> registerPushDevice(PushDeviceInfo info);

  Future<bool> isDeviceRegistered(String uuid);

  Future<List<PushMessageInfo>> getPushMessageList(String uuid);

  Future<bool> deleteAllPushDevices();
}
