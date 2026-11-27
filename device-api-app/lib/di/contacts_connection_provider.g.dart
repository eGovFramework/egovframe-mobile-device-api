// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactsConnection)
const contactsConnectionProvider = ContactsConnectionProvider._();

final class ContactsConnectionProvider
    extends $NotifierProvider<ContactsConnection, ContactsConnectionState> {
  const ContactsConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsConnectionHash();

  @$internal
  @override
  ContactsConnection create() => ContactsConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsConnectionState>(value),
    );
  }
}

String _$contactsConnectionHash() =>
    r'f948c4c505e32614a72f0a1b553b6c5aab2be178';

abstract class _$ContactsConnection extends $Notifier<ContactsConnectionState> {
  ContactsConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<ContactsConnectionState, ContactsConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContactsConnectionState, ContactsConnectionState>,
              ContactsConnectionState,
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

@ProviderFor(contactsSqliteService)
const contactsSqliteServiceProvider = ContactsSqliteServiceProvider._();

final class ContactsSqliteServiceProvider
    extends
        $FunctionalProvider<
          ContactsSqliteService,
          ContactsSqliteService,
          ContactsSqliteService
        >
    with $Provider<ContactsSqliteService> {
  const ContactsSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<ContactsSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContactsSqliteService create(Ref ref) {
    return contactsSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsSqliteService>(value),
    );
  }
}

String _$contactsSqliteServiceHash() =>
    r'df971740217515c2c3c49e9307dd0c99c4a3de86';
