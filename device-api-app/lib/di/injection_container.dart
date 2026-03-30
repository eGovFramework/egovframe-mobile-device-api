import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/data/repositories/accelerator_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/repositories/device_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/repositories/file_readwrite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/repositories/fileopener_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/repositories/gps_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/repositories/interface_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/repositories/media_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/repositories/network_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/accelerator_repository.dart';
// Data Sources (Services) - 직접 사용하지 않으므로 import 제거

// Repositories
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/device_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/file_readwrite_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/fileopener_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/gps_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/interface_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/media_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/network_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/accelerator_usecase.dart';
// Use Cases
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/device_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/file_readwrite_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/fileopener_server_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/gps_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/interface_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/media_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/network_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  getIt.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<AcceleratorRepository>(
    () => AcceleratorRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<GpsRepository>(
    () => GpsRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<FileRepository>(
    () => FileRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<ServerFileRepository>(
    () => ServerFileRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<InterfaceRepository>(
    () => InterfaceRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<NetworkRepository>(
    () => NetworkRepositoryImpl(),
  );

  // Use Cases
  getIt.registerLazySingleton<DeviceUseCase>(
    () => DeviceUseCase(getIt()),
  );
  
  getIt.registerLazySingleton<AcceleratorUseCase>(
    () => AcceleratorUseCase(getIt()),
  );
  
  getIt.registerLazySingleton<GpsUseCase>(
    () => GpsUseCase(getIt()),
  );
  
  getIt.registerLazySingleton<FileReadwriteUseCase>(
    () => FileReadwriteUseCase(getIt()),
  );
  
  getIt.registerLazySingleton<FileopenerServerUseCase>(
    () => FileopenerServerUseCase(getIt()),
  );
  
  getIt.registerLazySingleton<MediaUseCase>(
    () => MediaUseCase(getIt()),
  );
  
  getIt.registerLazySingleton<InterfaceUseCase>(
    () => InterfaceUseCase(getIt()),
  );
  
  getIt.registerLazySingleton<NetworkUseCase>(
    () => NetworkUseCase(getIt()),
  );
}
