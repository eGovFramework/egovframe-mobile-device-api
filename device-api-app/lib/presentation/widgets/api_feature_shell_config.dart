import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/view/accelerator_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/view/device_info_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/view/file_readwrite_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/view/fileopener_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/view/gps_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/view/interface_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/view/media_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/view/network_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/view/barcode_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/view/compass_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/view/contacts_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/view/push_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view/socket_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/view/streaming_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view/face_mesh_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view/iot_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view/ai_chat_description.dart';
import 'package:flutter/material.dart';

enum ApiFeature {
  network,
  accelerator,
  deviceInfo,
  fileOpener,
  fileReadWrite,
  gps,
  media,
  interface,
  barcode,
  compass,
  contacts,
  push,
  socket,
  streaming,
  faceMesh,
  iot,
  aiChat,
}

class ApiFeatureShellConfig {
  final String targetPage;
  final Widget guidePage;

  const ApiFeatureShellConfig({
    required this.targetPage,
    required this.guidePage,
  });

  static const Map<ApiFeature, ApiFeatureShellConfig> _configs = {
    ApiFeature.network: ApiFeatureShellConfig(
      targetPage: 'network',
      guidePage: NetworkFunctionPage(),
    ),
    ApiFeature.accelerator: ApiFeatureShellConfig(
      targetPage: 'accelerator_info_page',
      guidePage: AcceleratorFunctionPage(),
    ),
    ApiFeature.deviceInfo: ApiFeatureShellConfig(
      targetPage: 'device_info_page',
      guidePage: DeviceFunctionPage(),
    ),
    ApiFeature.fileOpener: ApiFeatureShellConfig(
      targetPage: 'file_opener',
      guidePage: FileOpenerFunctionPage(),
    ),
    ApiFeature.fileReadWrite: ApiFeatureShellConfig(
      targetPage: 'file_readWrite',
      guidePage: FileReadWriteFunctionPage(),
    ),
    ApiFeature.gps: ApiFeatureShellConfig(
      targetPage: 'gps',
      guidePage: GpsFunctionPage(),
    ),
    ApiFeature.media: ApiFeatureShellConfig(
      targetPage: 'media',
      guidePage: MediaFunctionPage(),
    ),
    ApiFeature.interface: ApiFeatureShellConfig(
      targetPage: 'interface',
      guidePage: InterfaceFunctionPage(),
    ),
    ApiFeature.barcode: ApiFeatureShellConfig(
      targetPage: 'barcode',
      guidePage: BarcodeFunctionPage(),
    ),
    ApiFeature.compass: ApiFeatureShellConfig(
      targetPage: 'compass',
      guidePage: CompassFunctionPage(),
    ),
    ApiFeature.contacts: ApiFeatureShellConfig(
      targetPage: 'contacts',
      guidePage: ContactsFunctionPage(),
    ),
    ApiFeature.push: ApiFeatureShellConfig(
      targetPage: 'push',
      guidePage: PushFunctionPage(),
    ),
    ApiFeature.socket: ApiFeatureShellConfig(
      targetPage: 'socket',
      guidePage: SocketFunctionPage(),
    ),
    ApiFeature.streaming: ApiFeatureShellConfig(
      targetPage: 'streaming',
      guidePage: StreamingFunctionPage(),
    ),
    ApiFeature.faceMesh: ApiFeatureShellConfig(
      targetPage: 'faceMesh',
      guidePage: FaceMeshFunctionPage(),
    ),
    ApiFeature.iot: ApiFeatureShellConfig(
      targetPage: 'iot',
      guidePage: IotFunctionPage(),
    ),
    ApiFeature.aiChat: ApiFeatureShellConfig(
      targetPage: 'aiChat',
      guidePage: AiChatFunctionPage(),
    ),
  };

  static ApiFeatureShellConfig of(ApiFeature feature) => _configs[feature]!;
}
