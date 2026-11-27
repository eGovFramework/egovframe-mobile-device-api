// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StreamingConnection)
const streamingConnectionProvider = StreamingConnectionProvider._();

final class StreamingConnectionProvider
    extends $NotifierProvider<StreamingConnection, StreamingConnectionState> {
  const StreamingConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamingConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamingConnectionHash();

  @$internal
  @override
  StreamingConnection create() => StreamingConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamingConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreamingConnectionState>(value),
    );
  }
}

String _$streamingConnectionHash() =>
    r'1f9d6b18077c38b12cd2a9d15b1fd8f34506e893';

abstract class _$StreamingConnection
    extends $Notifier<StreamingConnectionState> {
  StreamingConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<StreamingConnectionState, StreamingConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StreamingConnectionState, StreamingConnectionState>,
              StreamingConnectionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(sqliteService)
const sqliteServiceProvider = SqliteServiceProvider._();

final class SqliteServiceProvider
    extends $FunctionalProvider<SqliteService, SqliteService, SqliteService>
    with $Provider<SqliteService> {
  const SqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sqliteServiceHash();

  @$internal
  @override
  $ProviderElement<SqliteService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SqliteService create(Ref ref) {
    return sqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SqliteService>(value),
    );
  }
}

String _$sqliteServiceHash() => r'2d68e0715f68f3b4487f7c8097df3c7778991ae9';

@ProviderFor(featureTableService)
const featureTableServiceProvider = FeatureTableServiceProvider._();

final class FeatureTableServiceProvider
    extends
        $FunctionalProvider<
          FeatureTableService,
          FeatureTableService,
          FeatureTableService
        >
    with $Provider<FeatureTableService> {
  const FeatureTableServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureTableServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureTableServiceHash();

  @$internal
  @override
  $ProviderElement<FeatureTableService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FeatureTableService create(Ref ref) {
    return featureTableService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeatureTableService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeatureTableService>(value),
    );
  }
}

String _$featureTableServiceHash() =>
    r'432c2831bc8ee63ad0b25735d6268165a942c7cc';

@ProviderFor(streamingSqliteService)
const streamingSqliteServiceProvider = StreamingSqliteServiceProvider._();

final class StreamingSqliteServiceProvider
    extends
        $FunctionalProvider<
          StreamingSqliteService,
          StreamingSqliteService,
          StreamingSqliteService
        >
    with $Provider<StreamingSqliteService> {
  const StreamingSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamingSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamingSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<StreamingSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StreamingSqliteService create(Ref ref) {
    return streamingSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamingSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreamingSqliteService>(value),
    );
  }
}

String _$streamingSqliteServiceHash() =>
    r'13f54c710a4ef8dc485eb7e44e5577665be48f73';
