// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IotMain)
const iotMainProvider = IotMainProvider._();

final class IotMainProvider extends $NotifierProvider<IotMain, IotMainState> {
  const IotMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iotMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iotMainHash();

  @$internal
  @override
  IotMain create() => IotMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IotMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IotMainState>(value),
    );
  }
}

String _$iotMainHash() => r'834a8e8d837ba2a0625f7de8f20884d767ace4d4';

abstract class _$IotMain extends $Notifier<IotMainState> {
  IotMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IotMainState, IotMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IotMainState, IotMainState>,
              IotMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(IotSavedList)
const iotSavedListProvider = IotSavedListProvider._();

final class IotSavedListProvider
    extends $NotifierProvider<IotSavedList, IotSavedListState> {
  const IotSavedListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iotSavedListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iotSavedListHash();

  @$internal
  @override
  IotSavedList create() => IotSavedList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IotSavedListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IotSavedListState>(value),
    );
  }
}

String _$iotSavedListHash() => r'a6391588b55976d1452eaca4a509e92cabefbe98';

abstract class _$IotSavedList extends $Notifier<IotSavedListState> {
  IotSavedListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IotSavedListState, IotSavedListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IotSavedListState, IotSavedListState>,
              IotSavedListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
