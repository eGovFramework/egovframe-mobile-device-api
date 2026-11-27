// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BarcodeMain)
const barcodeMainProvider = BarcodeMainProvider._();

final class BarcodeMainProvider
    extends $NotifierProvider<BarcodeMain, BarcodeMainState> {
  const BarcodeMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeMainHash();

  @$internal
  @override
  BarcodeMain create() => BarcodeMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarcodeMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarcodeMainState>(value),
    );
  }
}

String _$barcodeMainHash() => r'e4880c33071c209fdf7a13bb96e6f97b4e9a87ec';

abstract class _$BarcodeMain extends $Notifier<BarcodeMainState> {
  BarcodeMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BarcodeMainState, BarcodeMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BarcodeMainState, BarcodeMainState>,
              BarcodeMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BarcodeList)
const barcodeListProvider = BarcodeListProvider._();

final class BarcodeListProvider
    extends $NotifierProvider<BarcodeList, BarcodeListState> {
  const BarcodeListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeListHash();

  @$internal
  @override
  BarcodeList create() => BarcodeList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarcodeListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarcodeListState>(value),
    );
  }
}

String _$barcodeListHash() => r'12d67c04a6694399152ad4c45f4a5328c99f5644';

abstract class _$BarcodeList extends $Notifier<BarcodeListState> {
  BarcodeListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BarcodeListState, BarcodeListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BarcodeListState, BarcodeListState>,
              BarcodeListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
