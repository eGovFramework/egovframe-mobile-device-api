// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaConnection)
const mediaConnectionProvider = MediaConnectionProvider._();

final class MediaConnectionProvider
    extends $NotifierProvider<MediaConnection, MediaConnectionState> {
  const MediaConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaConnectionHash();

  @$internal
  @override
  MediaConnection create() => MediaConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaConnectionState>(value),
    );
  }
}

String _$mediaConnectionHash() => r'c9d68e76e820ad330c574e1991ac0f66c3cd5d75';

abstract class _$MediaConnection extends $Notifier<MediaConnectionState> {
  MediaConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MediaConnectionState, MediaConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MediaConnectionState, MediaConnectionState>,
              MediaConnectionState,
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

@ProviderFor(mediaSqliteService)
const mediaSqliteServiceProvider = MediaSqliteServiceProvider._();

final class MediaSqliteServiceProvider
    extends
        $FunctionalProvider<
          MediaSqliteService,
          MediaSqliteService,
          MediaSqliteService
        >
    with $Provider<MediaSqliteService> {
  const MediaSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<MediaSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MediaSqliteService create(Ref ref) {
    return mediaSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaSqliteService>(value),
    );
  }
}

String _$mediaSqliteServiceHash() =>
    r'ac53a256872875cc60e06bb7eec170f18e9915f6';
