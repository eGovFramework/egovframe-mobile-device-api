// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IotConnectionStatus)
const iotConnectionStatusProvider = IotConnectionStatusProvider._();

final class IotConnectionStatusProvider
    extends $AsyncNotifierProvider<IotConnectionStatus, IotDataSourceSnapshot> {
  const IotConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iotConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iotConnectionStatusHash();

  @$internal
  @override
  IotConnectionStatus create() => IotConnectionStatus();
}

String _$iotConnectionStatusHash() =>
    r'727154a43ec1d0f705c694b711c1bfa055ed2b6e';

abstract class _$IotConnectionStatus
    extends $AsyncNotifier<IotDataSourceSnapshot> {
  FutureOr<IotDataSourceSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<IotDataSourceSnapshot>, IotDataSourceSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<IotDataSourceSnapshot>,
                IotDataSourceSnapshot
              >,
              AsyncValue<IotDataSourceSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
