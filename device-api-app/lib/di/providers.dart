import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/data/accelerator/datasources/accelerometer_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileMgmt/datasources/file_management_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileMgmt/repositories/file_mgmt_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/network/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/accelerator/repositories/accelerator_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/accelerator/repositories/accelerator_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/accelerator/repositories/accelerator_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/repositories/device_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/repositories/device_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/repositories/device_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/repositories/file_readwrite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/repositories/file_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/repositories/file_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileopener/repositories/file_opener_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileopener/repositories/file_opener_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileopener/repositories/file_opener_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/gps/repositories/gps_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/gps/repositories/gps_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/gps/repositories/gps_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/interface/repositories/interface_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/interface/repositories/interface_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/interface/repositories/interface_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/media/repositories/media_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/media/repositories/media_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/media/repositories/media_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/network/repositories/network_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/network/repositories/network_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/network/repositories/network_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/barcode/repositories/barcode_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/barcode/repositories/barcode_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/barcode/repositories/barcode_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/compass/repositories/compass_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/compass/repositories/compass_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/compass/repositories/compass_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/contacts/repositories/contacts_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/contacts/repositories/contacts_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/contacts/repositories/contacts_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/push/repositories/push_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/push/repositories/push_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/push/repositories/push_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/socket/repositories/socket_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/socket/repositories/socket_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/socket/repositories/socket_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/streaming/repositories/streaming_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/streaming/repositories/streaming_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/streaming/repositories/streaming_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/di/accelerator_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/barcode_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/compass_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/contacts_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/device_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/face_mesh_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/file_readwrite_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/fileopener_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/gps_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/interface_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/media_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/network_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/push_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/socket_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/streaming_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/repositories/barcode_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/repositories/compass_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/repositories/contacts_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/repositories/push_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/repositories/socket_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/repositories/streaming_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/usecases/barcode_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/usecases/compass_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/usecases/contacts_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/usecases/push_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/usecases/socket_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/usecases/streaming_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/repositories/accelerator_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/repositories/device_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/repositories/face_mesh_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/repositories/file_mgmt_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/usecases/file_mgmt_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/repositories/file_readwrite_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/repositories/fileopener_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/repositories/gps_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/repositories/interface_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/repositories/media_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/repositories/network_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/usecases/accelerator_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/usecases/device_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/usecases/face_mesh_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/usecases/file_readwrite_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/usecases/fileopener_server_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/usecases/gps_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/usecases/interface_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/usecases/media_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/usecases/network_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/datasources/face_mesh_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/repositories/face_mesh_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/repositories/face_mesh_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/repositories/face_mesh_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/iot/datasources/iot_mqtt_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/iot/repositories/iot_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/iot/repositories/iot_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/iot/repositories/iot_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/di/iot_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/repositories/iot_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/usecases/iot_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/data/aiChat/repositories/ai_chat_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/aiChat/repositories/ai_chat_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/aiChat/repositories/ai_chat_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/di/ai_chat_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/repositories/ai_chat_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/usecases/ai_chat_usecase.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) => DeviceApiClient.openClient();

@Riverpod(keepAlive: true)
DeviceInfoPlugin deviceInfoPlugin(Ref ref) => DeviceInfoPlugin();

@Riverpod(keepAlive: true)
NetworkService networkService(Ref ref) => NetworkService();

@Riverpod(keepAlive: true)
AccelerometerService accelerometerService(Ref ref) => AccelerometerService();

@Riverpod(keepAlive: true)
FileManagementService fileManagementService(Ref ref) => FileManagementService();

@Riverpod(keepAlive: true)
FileMgmtRepository fileMgmtRepository(Ref ref) =>
    FileMgmtRepositoryImpl(ref.watch(fileManagementServiceProvider));

@Riverpod(keepAlive: true)
FileMgmtUseCase fileMgmtUseCase(Ref ref) =>
    FileMgmtUseCase(ref.watch(fileMgmtRepositoryProvider));

@Riverpod(keepAlive: true)
DeviceRepository deviceRepository(Ref ref) {
  DeviceConnectionState readConnection() => ref.read(deviceConnectionProvider);
  return DeviceRepositoryImpl(
    remote: DeviceRemoteRepositoryImpl(),
    sqlite: DeviceSqliteRepositoryImpl(
      ref.watch(deviceSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
AcceleratorRepository acceleratorRepository(Ref ref) {
  AcceleratorConnectionState readConnection() =>
      ref.read(acceleratorConnectionProvider);
  return AcceleratorRepositoryImpl(
    remote: AcceleratorRemoteRepositoryImpl(),
    sqlite: AcceleratorSqliteRepositoryImpl(
      ref.watch(acceleratorSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
GpsRepository gpsRepository(Ref ref) {
  GpsConnectionState readConnection() => ref.read(gpsConnectionProvider);
  return GpsRepositoryImpl(
    remote: GpsRemoteRepositoryImpl(),
    sqlite: GpsSqliteRepositoryImpl(
      ref.watch(gpsSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
FileRepository fileRepository(Ref ref) {
  FileReadWriteConnectionState readConnection() =>
      ref.read(fileReadWriteConnectionProvider);
  return FileRepositoryImpl(
    remote: FileRemoteRepositoryImpl(),
    sqlite: FileSqliteRepositoryImpl(
      ref.watch(fileReadWriteSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
ServerFileRepository serverFileRepository(Ref ref) {
  FileOpenerConnectionState readConnection() =>
      ref.read(fileOpenerConnectionProvider);
  return ServerFileRepositoryImpl(
    remote: FileOpenerRemoteRepositoryImpl(),
    sqlite: FileOpenerSqliteRepositoryImpl(
      ref.watch(fileOpenerSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
MediaRepository mediaRepository(Ref ref) {
  MediaConnectionState readConnection() => ref.read(mediaConnectionProvider);
  return MediaRepositoryImpl(
    remote: MediaRemoteRepositoryImpl(),
    sqlite: MediaSqliteRepositoryImpl(
      ref.watch(mediaSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
InterfaceRepository interfaceRepository(Ref ref) {
  InterfaceConnectionState readConnection() =>
      ref.read(interfaceConnectionProvider);
  return InterfaceRepositoryImpl(
    remote: InterfaceRemoteRepositoryImpl(),
    sqlite: InterfaceSqliteRepositoryImpl(
      ref.watch(interfaceSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}
@Riverpod(keepAlive: true)
NetworkRepository networkRepository(Ref ref) {
  NetworkConnectionState readConnection() =>
      ref.read(networkConnectionProvider);
  return NetworkRepositoryImpl(
    remote: NetworkRemoteRepositoryImpl(
      networkService: ref.watch(networkServiceProvider),
    ),
    sqlite: NetworkSqliteRepositoryImpl(
      ref.watch(networkSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
DeviceUseCase deviceUseCase(Ref ref) =>
    DeviceUseCase(ref.watch(deviceRepositoryProvider));

@Riverpod(keepAlive: true)
AcceleratorUseCase acceleratorUseCase(Ref ref) =>
    AcceleratorUseCase(ref.watch(acceleratorRepositoryProvider));

@Riverpod(keepAlive: true)
GpsUseCase gpsUseCase(Ref ref) =>
    GpsUseCase(ref.watch(gpsRepositoryProvider));

@Riverpod(keepAlive: true)
FileReadwriteUseCase fileReadwriteUseCase(Ref ref) =>
    FileReadwriteUseCase(ref.watch(fileRepositoryProvider));

@Riverpod(keepAlive: true)
FileopenerServerUseCase fileopenerServerUseCase(Ref ref) =>
    FileopenerServerUseCase(ref.watch(serverFileRepositoryProvider));

@Riverpod(keepAlive: true)
MediaUseCase mediaUseCase(Ref ref) =>
    MediaUseCase(ref.watch(mediaRepositoryProvider));

@Riverpod(keepAlive: true)
InterfaceUseCase interfaceUseCase(Ref ref) =>
    InterfaceUseCase(ref.watch(interfaceRepositoryProvider));

@Riverpod(keepAlive: true)
NetworkUseCase networkUseCase(Ref ref) =>
    NetworkUseCase(ref.watch(networkRepositoryProvider));

@Riverpod(keepAlive: true)
BarcodeRepository barcodeRepository(Ref ref) {
  BarcodeConnectionState readConnection() => ref.read(barcodeConnectionProvider);
  return BarcodeRepositoryImpl(
    remote: BarcodeRemoteRepositoryImpl(),
    sqlite: BarcodeSqliteRepositoryImpl(
      ref.watch(barcodeSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
BarcodeUseCase barcodeUseCase(Ref ref) =>
    BarcodeUseCase(ref.watch(barcodeRepositoryProvider));

@Riverpod(keepAlive: true)
CompassRepository compassRepository(Ref ref) {
  CompassConnectionState readConnection() => ref.read(compassConnectionProvider);
  return CompassRepositoryImpl(
    remote: CompassRemoteRepositoryImpl(),
    sqlite: CompassSqliteRepositoryImpl(
      ref.watch(compassSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
CompassUseCase compassUseCase(Ref ref) =>
    CompassUseCase(ref.watch(compassRepositoryProvider));

@Riverpod(keepAlive: true)
ContactsRepository contactsRepository(Ref ref) {
  ContactsConnectionState readConnection() =>
      ref.read(contactsConnectionProvider);
  return ContactsRepositoryImpl(
    remote: ContactsRemoteRepositoryImpl(),
    sqlite: ContactsSqliteRepositoryImpl(
      ref.watch(contactsSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
ContactsUseCase contactsUseCase(Ref ref) =>
    ContactsUseCase(ref.watch(contactsRepositoryProvider));

@Riverpod(keepAlive: true)
PushRepository pushRepository(Ref ref) {
  PushConnectionState readConnection() => ref.read(pushConnectionProvider);
  return PushRepositoryImpl(
    remote: PushRemoteRepositoryImpl(),
    sqlite: PushSqliteRepositoryImpl(
      ref.watch(pushSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
PushUseCase pushUseCase(Ref ref) =>
    PushUseCase(ref.watch(pushRepositoryProvider));

@Riverpod(keepAlive: true)
SocketRepository socketRepository(Ref ref) {
  SocketConnectionState readConnection() => ref.read(socketConnectionProvider);
  return SocketRepositoryImpl(
    remote: SocketRemoteRepositoryImpl(),
    sqlite: SocketSqliteRepositoryImpl(
      ref.watch(socketSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
SocketUseCase socketUseCase(Ref ref) =>
    SocketUseCase(ref.watch(socketRepositoryProvider));

@Riverpod(keepAlive: true)
StreamingRepository streamingRepository(Ref ref) {
  StreamingConnectionState readConnection() =>
      ref.read(streamingConnectionProvider);
  return StreamingRepositoryImpl(
    remote: StreamingRemoteRepositoryImpl(),
    sqlite: StreamingSqliteRepositoryImpl(
      ref.watch(streamingSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
StreamingUseCase streamingUseCase(Ref ref) =>
    StreamingUseCase(ref.watch(streamingRepositoryProvider));

@Riverpod(keepAlive: true)
FaceMeshService faceMeshService(Ref ref) {
  final service = FaceMeshService();
  ref.onDispose(service.close);
  return service;
}

@Riverpod(keepAlive: true)
FaceMeshRepository faceMeshRepository(Ref ref) {
  FaceMeshConnectionState readConnection() =>
      ref.read(faceMeshConnectionProvider);
  return FaceMeshRepositoryImpl(
    service: ref.watch(faceMeshServiceProvider),
    remote: FaceMeshRemoteRepositoryImpl(),
    sqlite: FaceMeshSqliteRepositoryImpl(
      ref.watch(faceMeshSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
FaceMeshUseCase faceMeshUseCase(Ref ref) =>
    FaceMeshUseCase(ref.watch(faceMeshRepositoryProvider));

@Riverpod(keepAlive: true)
IotMqttService iotMqttService(Ref ref) {
  final service = IotMqttService();
  ref.onDispose(service.dispose);
  return service;
}

@Riverpod(keepAlive: true)
IotRepository iotRepository(Ref ref) {
  IotConnectionState readConnection() => ref.read(iotConnectionProvider);
  final mqtt = ref.watch(iotMqttServiceProvider);
  return IotRepositoryImpl(
    remote: IotRemoteRepositoryImpl(mqtt),
    sqlite: IotSqliteRepositoryImpl(
      mqtt,
      ref.watch(iotSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
IotUseCase iotUseCase(Ref ref) =>
    IotUseCase(ref.watch(iotRepositoryProvider));

@Riverpod(keepAlive: true)
AiChatRepository aiChatRepository(Ref ref) {
  AiChatConnectionState readConnection() => ref.read(aiChatConnectionProvider);
  return AiChatRepositoryImpl(
    remote: AiChatRemoteRepositoryImpl(),
    sqlite: AiChatSqliteRepositoryImpl(
      ref.watch(aiChatSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
AiChatUseCase aiChatUseCase(Ref ref) =>
    AiChatUseCase(ref.watch(aiChatRepositoryProvider));
