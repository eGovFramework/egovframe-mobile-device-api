// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeviceConnectionStatus)
const deviceConnectionStatusProvider = DeviceConnectionStatusProvider._();

final class DeviceConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          DeviceConnectionStatus,
          DeviceConnectionStatusSnapshot
        > {
  const DeviceConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceConnectionStatusHash();

  @$internal
  @override
  DeviceConnectionStatus create() => DeviceConnectionStatus();
}

String _$deviceConnectionStatusHash() =>
    r'859f0ad347ba07ad1b88b48429cfb13857fc7905';

abstract class _$DeviceConnectionStatus
    extends $AsyncNotifier<DeviceConnectionStatusSnapshot> {
  FutureOr<DeviceConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<DeviceConnectionStatusSnapshot>,
              DeviceConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DeviceConnectionStatusSnapshot>,
                DeviceConnectionStatusSnapshot
              >,
              AsyncValue<DeviceConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
