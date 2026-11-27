// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BarcodeConnectionStatus)
const barcodeConnectionStatusProvider = BarcodeConnectionStatusProvider._();

final class BarcodeConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          BarcodeConnectionStatus,
          BarcodeConnectionStatusSnapshot
        > {
  const BarcodeConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeConnectionStatusHash();

  @$internal
  @override
  BarcodeConnectionStatus create() => BarcodeConnectionStatus();
}

String _$barcodeConnectionStatusHash() =>
    r'3a195f545ce4814e1eae0221d6cbf98626374fbf';

abstract class _$BarcodeConnectionStatus
    extends $AsyncNotifier<BarcodeConnectionStatusSnapshot> {
  FutureOr<BarcodeConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<BarcodeConnectionStatusSnapshot>,
              BarcodeConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<BarcodeConnectionStatusSnapshot>,
                BarcodeConnectionStatusSnapshot
              >,
              AsyncValue<BarcodeConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
