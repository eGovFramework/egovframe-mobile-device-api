// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interface_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InterfaceConnectionStatus)
const interfaceConnectionStatusProvider = InterfaceConnectionStatusProvider._();

final class InterfaceConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          InterfaceConnectionStatus,
          InterfaceConnectionStatusSnapshot
        > {
  const InterfaceConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interfaceConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interfaceConnectionStatusHash();

  @$internal
  @override
  InterfaceConnectionStatus create() => InterfaceConnectionStatus();
}

String _$interfaceConnectionStatusHash() =>
    r'0bf470c608ce413dbd07d0617bcda9467540935a';

abstract class _$InterfaceConnectionStatus
    extends $AsyncNotifier<InterfaceConnectionStatusSnapshot> {
  FutureOr<InterfaceConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<InterfaceConnectionStatusSnapshot>,
              InterfaceConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<InterfaceConnectionStatusSnapshot>,
                InterfaceConnectionStatusSnapshot
              >,
              AsyncValue<InterfaceConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
