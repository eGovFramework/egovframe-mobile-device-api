// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeviceInfoMain)
const deviceInfoMainProvider = DeviceInfoMainProvider._();

final class DeviceInfoMainProvider
    extends $NotifierProvider<DeviceInfoMain, DeviceInfoMainState> {
  const DeviceInfoMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceInfoMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceInfoMainHash();

  @$internal
  @override
  DeviceInfoMain create() => DeviceInfoMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceInfoMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceInfoMainState>(value),
    );
  }
}

String _$deviceInfoMainHash() => r'2a302742b4c9acc9011da9d4e84606dcfcfbc379';

abstract class _$DeviceInfoMain extends $Notifier<DeviceInfoMainState> {
  DeviceInfoMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DeviceInfoMainState, DeviceInfoMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeviceInfoMainState, DeviceInfoMainState>,
              DeviceInfoMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DeviceList)
const deviceListProvider = DeviceListFamily._();

final class DeviceListProvider
    extends $NotifierProvider<DeviceList, DeviceListState> {
  const DeviceListProvider._({
    required DeviceListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'deviceListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deviceListHash();

  @override
  String toString() {
    return r'deviceListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DeviceList create() => DeviceList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceListState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deviceListHash() => r'11f99703818a816b40fa7eccaa08e402404414f9';

final class DeviceListFamily extends $Family
    with
        $ClassFamilyOverride<
          DeviceList,
          DeviceListState,
          DeviceListState,
          DeviceListState,
          String
        > {
  const DeviceListFamily._()
    : super(
        retry: null,
        name: r'deviceListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeviceListProvider call(String uuid) =>
      DeviceListProvider._(argument: uuid, from: this);

  @override
  String toString() => r'deviceListProvider';
}

abstract class _$DeviceList extends $Notifier<DeviceListState> {
  late final _$args = ref.$arg as String;
  String get uuid => _$args;

  DeviceListState build(String uuid);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<DeviceListState, DeviceListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeviceListState, DeviceListState>,
              DeviceListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DeviceDetail)
const deviceDetailProvider = DeviceDetailFamily._();

final class DeviceDetailProvider
    extends $NotifierProvider<DeviceDetail, DeviceDetailState> {
  const DeviceDetailProvider._({
    required DeviceDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'deviceDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deviceDetailHash();

  @override
  String toString() {
    return r'deviceDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DeviceDetail create() => DeviceDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deviceDetailHash() => r'cdbecf95bbd6c58241312adb777c9e1effe7e446';

final class DeviceDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          DeviceDetail,
          DeviceDetailState,
          DeviceDetailState,
          DeviceDetailState,
          int
        > {
  const DeviceDetailFamily._()
    : super(
        retry: null,
        name: r'deviceDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeviceDetailProvider call(int sn) =>
      DeviceDetailProvider._(argument: sn, from: this);

  @override
  String toString() => r'deviceDetailProvider';
}

abstract class _$DeviceDetail extends $Notifier<DeviceDetailState> {
  late final _$args = ref.$arg as int;
  int get sn => _$args;

  DeviceDetailState build(int sn);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<DeviceDetailState, DeviceDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeviceDetailState, DeviceDetailState>,
              DeviceDetailState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
