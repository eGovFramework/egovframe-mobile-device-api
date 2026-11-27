// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiChatConnection)
const aiChatConnectionProvider = AiChatConnectionProvider._();

final class AiChatConnectionProvider
    extends $NotifierProvider<AiChatConnection, AiChatConnectionState> {
  const AiChatConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatConnectionHash();

  @$internal
  @override
  AiChatConnection create() => AiChatConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatConnectionState>(value),
    );
  }
}

String _$aiChatConnectionHash() => r'23c62782cb2cb42570a3063c5eb7e1dab864b07d';

abstract class _$AiChatConnection extends $Notifier<AiChatConnectionState> {
  AiChatConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AiChatConnectionState, AiChatConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiChatConnectionState, AiChatConnectionState>,
              AiChatConnectionState,
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

@ProviderFor(aiChatSqliteService)
const aiChatSqliteServiceProvider = AiChatSqliteServiceProvider._();

final class AiChatSqliteServiceProvider
    extends
        $FunctionalProvider<
          AiChatSqliteService,
          AiChatSqliteService,
          AiChatSqliteService
        >
    with $Provider<AiChatSqliteService> {
  const AiChatSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<AiChatSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiChatSqliteService create(Ref ref) {
    return aiChatSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatSqliteService>(value),
    );
  }
}

String _$aiChatSqliteServiceHash() =>
    r'ff7bed3289bb4240fcd262b0a95f55e53bc067c2';
