// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(httpClient)
const httpClientProvider = HttpClientProvider._();

final class HttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  const HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$httpClientHash() => r'1bf6eabbdd814851d2512b83b0f42d9f74d55940';

@ProviderFor(deviceInfoPlugin)
const deviceInfoPluginProvider = DeviceInfoPluginProvider._();

final class DeviceInfoPluginProvider
    extends
        $FunctionalProvider<
          DeviceInfoPlugin,
          DeviceInfoPlugin,
          DeviceInfoPlugin
        >
    with $Provider<DeviceInfoPlugin> {
  const DeviceInfoPluginProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceInfoPluginProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceInfoPluginHash();

  @$internal
  @override
  $ProviderElement<DeviceInfoPlugin> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceInfoPlugin create(Ref ref) {
    return deviceInfoPlugin(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceInfoPlugin value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceInfoPlugin>(value),
    );
  }
}

String _$deviceInfoPluginHash() => r'3d2cf8d84a03b8302a84b14be241ffb9e7e2d5c1';

@ProviderFor(networkService)
const networkServiceProvider = NetworkServiceProvider._();

final class NetworkServiceProvider
    extends $FunctionalProvider<NetworkService, NetworkService, NetworkService>
    with $Provider<NetworkService> {
  const NetworkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkServiceHash();

  @$internal
  @override
  $ProviderElement<NetworkService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkService create(Ref ref) {
    return networkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkService>(value),
    );
  }
}

String _$networkServiceHash() => r'd735498741d1fb7f995af475d3dbb5b41c2c9dc2';

@ProviderFor(accelerometerService)
const accelerometerServiceProvider = AccelerometerServiceProvider._();

final class AccelerometerServiceProvider
    extends
        $FunctionalProvider<
          AccelerometerService,
          AccelerometerService,
          AccelerometerService
        >
    with $Provider<AccelerometerService> {
  const AccelerometerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accelerometerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accelerometerServiceHash();

  @$internal
  @override
  $ProviderElement<AccelerometerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccelerometerService create(Ref ref) {
    return accelerometerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccelerometerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccelerometerService>(value),
    );
  }
}

String _$accelerometerServiceHash() =>
    r'f618dd6fd09bc2537c60893de6fa953d9ffc7fa8';

@ProviderFor(fileManagementService)
const fileManagementServiceProvider = FileManagementServiceProvider._();

final class FileManagementServiceProvider
    extends
        $FunctionalProvider<
          FileManagementService,
          FileManagementService,
          FileManagementService
        >
    with $Provider<FileManagementService> {
  const FileManagementServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileManagementServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileManagementServiceHash();

  @$internal
  @override
  $ProviderElement<FileManagementService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileManagementService create(Ref ref) {
    return fileManagementService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileManagementService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileManagementService>(value),
    );
  }
}

String _$fileManagementServiceHash() =>
    r'5e29065f10945c05679d9048be045d3e77549d59';

@ProviderFor(fileMgmtRepository)
const fileMgmtRepositoryProvider = FileMgmtRepositoryProvider._();

final class FileMgmtRepositoryProvider
    extends
        $FunctionalProvider<
          FileMgmtRepository,
          FileMgmtRepository,
          FileMgmtRepository
        >
    with $Provider<FileMgmtRepository> {
  const FileMgmtRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileMgmtRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileMgmtRepositoryHash();

  @$internal
  @override
  $ProviderElement<FileMgmtRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileMgmtRepository create(Ref ref) {
    return fileMgmtRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileMgmtRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileMgmtRepository>(value),
    );
  }
}

String _$fileMgmtRepositoryHash() =>
    r'6fd277343e8ee4ac4a139e5e157611ed673a5153';

@ProviderFor(fileMgmtUseCase)
const fileMgmtUseCaseProvider = FileMgmtUseCaseProvider._();

final class FileMgmtUseCaseProvider
    extends
        $FunctionalProvider<FileMgmtUseCase, FileMgmtUseCase, FileMgmtUseCase>
    with $Provider<FileMgmtUseCase> {
  const FileMgmtUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileMgmtUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileMgmtUseCaseHash();

  @$internal
  @override
  $ProviderElement<FileMgmtUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FileMgmtUseCase create(Ref ref) {
    return fileMgmtUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileMgmtUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileMgmtUseCase>(value),
    );
  }
}

String _$fileMgmtUseCaseHash() => r'c8b5dfce744ab30d712c9aff67165deec6f5419c';

@ProviderFor(deviceRepository)
const deviceRepositoryProvider = DeviceRepositoryProvider._();

final class DeviceRepositoryProvider
    extends
        $FunctionalProvider<
          DeviceRepository,
          DeviceRepository,
          DeviceRepository
        >
    with $Provider<DeviceRepository> {
  const DeviceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceRepositoryHash();

  @$internal
  @override
  $ProviderElement<DeviceRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceRepository create(Ref ref) {
    return deviceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceRepository>(value),
    );
  }
}

String _$deviceRepositoryHash() => r'0c98bdf9bfc8f4e75d1463a532c16febd77de1ab';

@ProviderFor(acceleratorRepository)
const acceleratorRepositoryProvider = AcceleratorRepositoryProvider._();

final class AcceleratorRepositoryProvider
    extends
        $FunctionalProvider<
          AcceleratorRepository,
          AcceleratorRepository,
          AcceleratorRepository
        >
    with $Provider<AcceleratorRepository> {
  const AcceleratorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceleratorRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceleratorRepositoryHash();

  @$internal
  @override
  $ProviderElement<AcceleratorRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AcceleratorRepository create(Ref ref) {
    return acceleratorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceleratorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceleratorRepository>(value),
    );
  }
}

String _$acceleratorRepositoryHash() =>
    r'49170f446f8c4fbe98565d5c70d76c4f7e7360c1';

@ProviderFor(gpsRepository)
const gpsRepositoryProvider = GpsRepositoryProvider._();

final class GpsRepositoryProvider
    extends $FunctionalProvider<GpsRepository, GpsRepository, GpsRepository>
    with $Provider<GpsRepository> {
  const GpsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gpsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gpsRepositoryHash();

  @$internal
  @override
  $ProviderElement<GpsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GpsRepository create(Ref ref) {
    return gpsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GpsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GpsRepository>(value),
    );
  }
}

String _$gpsRepositoryHash() => r'3b6427ea06f747e7098fbbdaa3f5ddeef12c8035';

@ProviderFor(fileRepository)
const fileRepositoryProvider = FileRepositoryProvider._();

final class FileRepositoryProvider
    extends $FunctionalProvider<FileRepository, FileRepository, FileRepository>
    with $Provider<FileRepository> {
  const FileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileRepositoryHash();

  @$internal
  @override
  $ProviderElement<FileRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FileRepository create(Ref ref) {
    return fileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileRepository>(value),
    );
  }
}

String _$fileRepositoryHash() => r'82f74613cc70e4bfcb31720132ed6875ca1d3bee';

@ProviderFor(serverFileRepository)
const serverFileRepositoryProvider = ServerFileRepositoryProvider._();

final class ServerFileRepositoryProvider
    extends
        $FunctionalProvider<
          ServerFileRepository,
          ServerFileRepository,
          ServerFileRepository
        >
    with $Provider<ServerFileRepository> {
  const ServerFileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverFileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverFileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerFileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerFileRepository create(Ref ref) {
    return serverFileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerFileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerFileRepository>(value),
    );
  }
}

String _$serverFileRepositoryHash() =>
    r'78b4589fc5f4e5a9f39b101cd2f6d4ccf9d6ad82';

@ProviderFor(mediaRepository)
const mediaRepositoryProvider = MediaRepositoryProvider._();

final class MediaRepositoryProvider
    extends
        $FunctionalProvider<MediaRepository, MediaRepository, MediaRepository>
    with $Provider<MediaRepository> {
  const MediaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaRepositoryHash();

  @$internal
  @override
  $ProviderElement<MediaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaRepository create(Ref ref) {
    return mediaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaRepository>(value),
    );
  }
}

String _$mediaRepositoryHash() => r'c7f23ba8c037bf95f37265e60fcf574de6fe7c8d';

@ProviderFor(interfaceRepository)
const interfaceRepositoryProvider = InterfaceRepositoryProvider._();

final class InterfaceRepositoryProvider
    extends
        $FunctionalProvider<
          InterfaceRepository,
          InterfaceRepository,
          InterfaceRepository
        >
    with $Provider<InterfaceRepository> {
  const InterfaceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interfaceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interfaceRepositoryHash();

  @$internal
  @override
  $ProviderElement<InterfaceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InterfaceRepository create(Ref ref) {
    return interfaceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterfaceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterfaceRepository>(value),
    );
  }
}

String _$interfaceRepositoryHash() =>
    r'dde8fbdb79acf4e2ac170fbaf97d65dd2909d1f5';

@ProviderFor(networkRepository)
const networkRepositoryProvider = NetworkRepositoryProvider._();

final class NetworkRepositoryProvider
    extends
        $FunctionalProvider<
          NetworkRepository,
          NetworkRepository,
          NetworkRepository
        >
    with $Provider<NetworkRepository> {
  const NetworkRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkRepositoryHash();

  @$internal
  @override
  $ProviderElement<NetworkRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NetworkRepository create(Ref ref) {
    return networkRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkRepository>(value),
    );
  }
}

String _$networkRepositoryHash() => r'f7eb8ce4f0c5f451dabf703a9d6f022f04ab5977';

@ProviderFor(deviceUseCase)
const deviceUseCaseProvider = DeviceUseCaseProvider._();

final class DeviceUseCaseProvider
    extends $FunctionalProvider<DeviceUseCase, DeviceUseCase, DeviceUseCase>
    with $Provider<DeviceUseCase> {
  const DeviceUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeviceUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceUseCase create(Ref ref) {
    return deviceUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceUseCase>(value),
    );
  }
}

String _$deviceUseCaseHash() => r'984a63bd7448e80f870403774df738ef2143a210';

@ProviderFor(acceleratorUseCase)
const acceleratorUseCaseProvider = AcceleratorUseCaseProvider._();

final class AcceleratorUseCaseProvider
    extends
        $FunctionalProvider<
          AcceleratorUseCase,
          AcceleratorUseCase,
          AcceleratorUseCase
        >
    with $Provider<AcceleratorUseCase> {
  const AcceleratorUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceleratorUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceleratorUseCaseHash();

  @$internal
  @override
  $ProviderElement<AcceleratorUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AcceleratorUseCase create(Ref ref) {
    return acceleratorUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceleratorUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceleratorUseCase>(value),
    );
  }
}

String _$acceleratorUseCaseHash() =>
    r'28403dbc89f77524319ba71aca7a55fc2ab95820';

@ProviderFor(gpsUseCase)
const gpsUseCaseProvider = GpsUseCaseProvider._();

final class GpsUseCaseProvider
    extends $FunctionalProvider<GpsUseCase, GpsUseCase, GpsUseCase>
    with $Provider<GpsUseCase> {
  const GpsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gpsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gpsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GpsUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GpsUseCase create(Ref ref) {
    return gpsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GpsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GpsUseCase>(value),
    );
  }
}

String _$gpsUseCaseHash() => r'00f63eb3b1094d33e1ed4be5a6161fbd96a4637f';

@ProviderFor(fileReadwriteUseCase)
const fileReadwriteUseCaseProvider = FileReadwriteUseCaseProvider._();

final class FileReadwriteUseCaseProvider
    extends
        $FunctionalProvider<
          FileReadwriteUseCase,
          FileReadwriteUseCase,
          FileReadwriteUseCase
        >
    with $Provider<FileReadwriteUseCase> {
  const FileReadwriteUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileReadwriteUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileReadwriteUseCaseHash();

  @$internal
  @override
  $ProviderElement<FileReadwriteUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileReadwriteUseCase create(Ref ref) {
    return fileReadwriteUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileReadwriteUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileReadwriteUseCase>(value),
    );
  }
}

String _$fileReadwriteUseCaseHash() =>
    r'e066ff8ba4ef37701da7c170707a163a9ccc84f0';

@ProviderFor(fileopenerServerUseCase)
const fileopenerServerUseCaseProvider = FileopenerServerUseCaseProvider._();

final class FileopenerServerUseCaseProvider
    extends
        $FunctionalProvider<
          FileopenerServerUseCase,
          FileopenerServerUseCase,
          FileopenerServerUseCase
        >
    with $Provider<FileopenerServerUseCase> {
  const FileopenerServerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileopenerServerUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileopenerServerUseCaseHash();

  @$internal
  @override
  $ProviderElement<FileopenerServerUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileopenerServerUseCase create(Ref ref) {
    return fileopenerServerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileopenerServerUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileopenerServerUseCase>(value),
    );
  }
}

String _$fileopenerServerUseCaseHash() =>
    r'b0ce3e6613d6ffc6383979c1b0f663d492d69223';

@ProviderFor(mediaUseCase)
const mediaUseCaseProvider = MediaUseCaseProvider._();

final class MediaUseCaseProvider
    extends $FunctionalProvider<MediaUseCase, MediaUseCase, MediaUseCase>
    with $Provider<MediaUseCase> {
  const MediaUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaUseCaseHash();

  @$internal
  @override
  $ProviderElement<MediaUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaUseCase create(Ref ref) {
    return mediaUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaUseCase>(value),
    );
  }
}

String _$mediaUseCaseHash() => r'a43ad4b234f1848c12799d97b886a101a5b81fa2';

@ProviderFor(interfaceUseCase)
const interfaceUseCaseProvider = InterfaceUseCaseProvider._();

final class InterfaceUseCaseProvider
    extends
        $FunctionalProvider<
          InterfaceUseCase,
          InterfaceUseCase,
          InterfaceUseCase
        >
    with $Provider<InterfaceUseCase> {
  const InterfaceUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interfaceUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interfaceUseCaseHash();

  @$internal
  @override
  $ProviderElement<InterfaceUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InterfaceUseCase create(Ref ref) {
    return interfaceUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterfaceUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterfaceUseCase>(value),
    );
  }
}

String _$interfaceUseCaseHash() => r'2ea85ad52bfea392d5b82b8ba3fd2c486fed7f39';

@ProviderFor(networkUseCase)
const networkUseCaseProvider = NetworkUseCaseProvider._();

final class NetworkUseCaseProvider
    extends $FunctionalProvider<NetworkUseCase, NetworkUseCase, NetworkUseCase>
    with $Provider<NetworkUseCase> {
  const NetworkUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkUseCaseHash();

  @$internal
  @override
  $ProviderElement<NetworkUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkUseCase create(Ref ref) {
    return networkUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkUseCase>(value),
    );
  }
}

String _$networkUseCaseHash() => r'd0b1af49c523e840fb36c28533416765663a528b';

@ProviderFor(barcodeRepository)
const barcodeRepositoryProvider = BarcodeRepositoryProvider._();

final class BarcodeRepositoryProvider
    extends
        $FunctionalProvider<
          BarcodeRepository,
          BarcodeRepository,
          BarcodeRepository
        >
    with $Provider<BarcodeRepository> {
  const BarcodeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeRepositoryHash();

  @$internal
  @override
  $ProviderElement<BarcodeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BarcodeRepository create(Ref ref) {
    return barcodeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarcodeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarcodeRepository>(value),
    );
  }
}

String _$barcodeRepositoryHash() => r'fa76c95fae2080d335639d2a7260c8e9de9bd4ed';

@ProviderFor(barcodeUseCase)
const barcodeUseCaseProvider = BarcodeUseCaseProvider._();

final class BarcodeUseCaseProvider
    extends $FunctionalProvider<BarcodeUseCase, BarcodeUseCase, BarcodeUseCase>
    with $Provider<BarcodeUseCase> {
  const BarcodeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeUseCaseHash();

  @$internal
  @override
  $ProviderElement<BarcodeUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BarcodeUseCase create(Ref ref) {
    return barcodeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarcodeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarcodeUseCase>(value),
    );
  }
}

String _$barcodeUseCaseHash() => r'd275fd49b41e5f2d3ccd9e09905742f9eb6e9a1f';

@ProviderFor(compassRepository)
const compassRepositoryProvider = CompassRepositoryProvider._();

final class CompassRepositoryProvider
    extends
        $FunctionalProvider<
          CompassRepository,
          CompassRepository,
          CompassRepository
        >
    with $Provider<CompassRepository> {
  const CompassRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compassRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compassRepositoryHash();

  @$internal
  @override
  $ProviderElement<CompassRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompassRepository create(Ref ref) {
    return compassRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompassRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompassRepository>(value),
    );
  }
}

String _$compassRepositoryHash() => r'6d6e8111ff6058a4fbfddcc4c0f09a82e8d4b9d0';

@ProviderFor(compassUseCase)
const compassUseCaseProvider = CompassUseCaseProvider._();

final class CompassUseCaseProvider
    extends $FunctionalProvider<CompassUseCase, CompassUseCase, CompassUseCase>
    with $Provider<CompassUseCase> {
  const CompassUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compassUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compassUseCaseHash();

  @$internal
  @override
  $ProviderElement<CompassUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CompassUseCase create(Ref ref) {
    return compassUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompassUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompassUseCase>(value),
    );
  }
}

String _$compassUseCaseHash() => r'7de283dad5df42da2c59880fe553eac9902e65db';

@ProviderFor(contactsRepository)
const contactsRepositoryProvider = ContactsRepositoryProvider._();

final class ContactsRepositoryProvider
    extends
        $FunctionalProvider<
          ContactsRepository,
          ContactsRepository,
          ContactsRepository
        >
    with $Provider<ContactsRepository> {
  const ContactsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContactsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContactsRepository create(Ref ref) {
    return contactsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsRepository>(value),
    );
  }
}

String _$contactsRepositoryHash() =>
    r'217bd033dd52ef043600d1a61caeae1358d8ef0e';

@ProviderFor(contactsUseCase)
const contactsUseCaseProvider = ContactsUseCaseProvider._();

final class ContactsUseCaseProvider
    extends
        $FunctionalProvider<ContactsUseCase, ContactsUseCase, ContactsUseCase>
    with $Provider<ContactsUseCase> {
  const ContactsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsUseCaseHash();

  @$internal
  @override
  $ProviderElement<ContactsUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ContactsUseCase create(Ref ref) {
    return contactsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsUseCase>(value),
    );
  }
}

String _$contactsUseCaseHash() => r'95b6696f58fe7759a8e704327855cab2aa01431b';

@ProviderFor(pushRepository)
const pushRepositoryProvider = PushRepositoryProvider._();

final class PushRepositoryProvider
    extends $FunctionalProvider<PushRepository, PushRepository, PushRepository>
    with $Provider<PushRepository> {
  const PushRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRepositoryHash();

  @$internal
  @override
  $ProviderElement<PushRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushRepository create(Ref ref) {
    return pushRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushRepository>(value),
    );
  }
}

String _$pushRepositoryHash() => r'4983e66ff79049f88d388431a78ae617861fd005';

@ProviderFor(pushUseCase)
const pushUseCaseProvider = PushUseCaseProvider._();

final class PushUseCaseProvider
    extends $FunctionalProvider<PushUseCase, PushUseCase, PushUseCase>
    with $Provider<PushUseCase> {
  const PushUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushUseCaseHash();

  @$internal
  @override
  $ProviderElement<PushUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushUseCase create(Ref ref) {
    return pushUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushUseCase>(value),
    );
  }
}

String _$pushUseCaseHash() => r'e51e5ae1db06e2275f630329ab4312260a0eb635';

@ProviderFor(socketRepository)
const socketRepositoryProvider = SocketRepositoryProvider._();

final class SocketRepositoryProvider
    extends
        $FunctionalProvider<
          SocketRepository,
          SocketRepository,
          SocketRepository
        >
    with $Provider<SocketRepository> {
  const SocketRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketRepositoryHash();

  @$internal
  @override
  $ProviderElement<SocketRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SocketRepository create(Ref ref) {
    return socketRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocketRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocketRepository>(value),
    );
  }
}

String _$socketRepositoryHash() => r'1c21e17221a6f39e273808dea37100bfae372428';

@ProviderFor(socketUseCase)
const socketUseCaseProvider = SocketUseCaseProvider._();

final class SocketUseCaseProvider
    extends $FunctionalProvider<SocketUseCase, SocketUseCase, SocketUseCase>
    with $Provider<SocketUseCase> {
  const SocketUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketUseCaseHash();

  @$internal
  @override
  $ProviderElement<SocketUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SocketUseCase create(Ref ref) {
    return socketUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocketUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocketUseCase>(value),
    );
  }
}

String _$socketUseCaseHash() => r'ed9533d74fc710e2b9129ef989daccc9d872e2a7';

@ProviderFor(streamingRepository)
const streamingRepositoryProvider = StreamingRepositoryProvider._();

final class StreamingRepositoryProvider
    extends
        $FunctionalProvider<
          StreamingRepository,
          StreamingRepository,
          StreamingRepository
        >
    with $Provider<StreamingRepository> {
  const StreamingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamingRepositoryHash();

  @$internal
  @override
  $ProviderElement<StreamingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StreamingRepository create(Ref ref) {
    return streamingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreamingRepository>(value),
    );
  }
}

String _$streamingRepositoryHash() =>
    r'dd1a8e8c21a665ac68b5169a3294d031b2e08e9e';

@ProviderFor(streamingUseCase)
const streamingUseCaseProvider = StreamingUseCaseProvider._();

final class StreamingUseCaseProvider
    extends
        $FunctionalProvider<
          StreamingUseCase,
          StreamingUseCase,
          StreamingUseCase
        >
    with $Provider<StreamingUseCase> {
  const StreamingUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamingUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamingUseCaseHash();

  @$internal
  @override
  $ProviderElement<StreamingUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StreamingUseCase create(Ref ref) {
    return streamingUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamingUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreamingUseCase>(value),
    );
  }
}

String _$streamingUseCaseHash() => r'eade0d6739fce537d858e10a9f196b25be7545e7';

@ProviderFor(faceMeshService)
const faceMeshServiceProvider = FaceMeshServiceProvider._();

final class FaceMeshServiceProvider
    extends
        $FunctionalProvider<FaceMeshService, FaceMeshService, FaceMeshService>
    with $Provider<FaceMeshService> {
  const FaceMeshServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceMeshServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceMeshServiceHash();

  @$internal
  @override
  $ProviderElement<FaceMeshService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FaceMeshService create(Ref ref) {
    return faceMeshService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaceMeshService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaceMeshService>(value),
    );
  }
}

String _$faceMeshServiceHash() => r'd45736600469d36a3bdc250f44863d2cceafa482';

@ProviderFor(faceMeshRepository)
const faceMeshRepositoryProvider = FaceMeshRepositoryProvider._();

final class FaceMeshRepositoryProvider
    extends
        $FunctionalProvider<
          FaceMeshRepository,
          FaceMeshRepository,
          FaceMeshRepository
        >
    with $Provider<FaceMeshRepository> {
  const FaceMeshRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceMeshRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceMeshRepositoryHash();

  @$internal
  @override
  $ProviderElement<FaceMeshRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FaceMeshRepository create(Ref ref) {
    return faceMeshRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaceMeshRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaceMeshRepository>(value),
    );
  }
}

String _$faceMeshRepositoryHash() =>
    r'013c5663688c6e7e0d44e31db35b3bc900ca5321';

@ProviderFor(faceMeshUseCase)
const faceMeshUseCaseProvider = FaceMeshUseCaseProvider._();

final class FaceMeshUseCaseProvider
    extends
        $FunctionalProvider<FaceMeshUseCase, FaceMeshUseCase, FaceMeshUseCase>
    with $Provider<FaceMeshUseCase> {
  const FaceMeshUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceMeshUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceMeshUseCaseHash();

  @$internal
  @override
  $ProviderElement<FaceMeshUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FaceMeshUseCase create(Ref ref) {
    return faceMeshUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaceMeshUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaceMeshUseCase>(value),
    );
  }
}

String _$faceMeshUseCaseHash() => r'2fe35a49af3bc71d1bfcd38728dc22076572317c';

@ProviderFor(iotMqttService)
const iotMqttServiceProvider = IotMqttServiceProvider._();

final class IotMqttServiceProvider
    extends $FunctionalProvider<IotMqttService, IotMqttService, IotMqttService>
    with $Provider<IotMqttService> {
  const IotMqttServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iotMqttServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iotMqttServiceHash();

  @$internal
  @override
  $ProviderElement<IotMqttService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IotMqttService create(Ref ref) {
    return iotMqttService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IotMqttService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IotMqttService>(value),
    );
  }
}

String _$iotMqttServiceHash() => r'4214ae863fa621b618775e74b031fa07c8455229';

@ProviderFor(iotRepository)
const iotRepositoryProvider = IotRepositoryProvider._();

final class IotRepositoryProvider
    extends $FunctionalProvider<IotRepository, IotRepository, IotRepository>
    with $Provider<IotRepository> {
  const IotRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iotRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iotRepositoryHash();

  @$internal
  @override
  $ProviderElement<IotRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IotRepository create(Ref ref) {
    return iotRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IotRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IotRepository>(value),
    );
  }
}

String _$iotRepositoryHash() => r'cdad08ba922f6953710f8d92185040e89185b6a4';

@ProviderFor(iotUseCase)
const iotUseCaseProvider = IotUseCaseProvider._();

final class IotUseCaseProvider
    extends $FunctionalProvider<IotUseCase, IotUseCase, IotUseCase>
    with $Provider<IotUseCase> {
  const IotUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iotUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iotUseCaseHash();

  @$internal
  @override
  $ProviderElement<IotUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IotUseCase create(Ref ref) {
    return iotUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IotUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IotUseCase>(value),
    );
  }
}

String _$iotUseCaseHash() => r'66ccde7cd99ab5ac5d0e7dc233aaba535b4eca0c';

@ProviderFor(aiChatRepository)
const aiChatRepositoryProvider = AiChatRepositoryProvider._();

final class AiChatRepositoryProvider
    extends
        $FunctionalProvider<
          AiChatRepository,
          AiChatRepository,
          AiChatRepository
        >
    with $Provider<AiChatRepository> {
  const AiChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiChatRepository create(Ref ref) {
    return aiChatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatRepository>(value),
    );
  }
}

String _$aiChatRepositoryHash() => r'87cdf1fcaa1637c23cc441709ee454d5c9b0fba1';

@ProviderFor(aiChatUseCase)
const aiChatUseCaseProvider = AiChatUseCaseProvider._();

final class AiChatUseCaseProvider
    extends $FunctionalProvider<AiChatUseCase, AiChatUseCase, AiChatUseCase>
    with $Provider<AiChatUseCase> {
  const AiChatUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatUseCaseHash();

  @$internal
  @override
  $ProviderElement<AiChatUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiChatUseCase create(Ref ref) {
    return aiChatUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatUseCase>(value),
    );
  }
}

String _$aiChatUseCaseHash() => r'435822d2ca570d99ca7ffd83e31de2923add714d';
