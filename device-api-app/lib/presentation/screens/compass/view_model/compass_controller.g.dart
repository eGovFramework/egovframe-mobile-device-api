// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compass_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CompassMain)
const compassMainProvider = CompassMainProvider._();

final class CompassMainProvider
    extends $NotifierProvider<CompassMain, CompassMainState> {
  const CompassMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compassMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compassMainHash();

  @$internal
  @override
  CompassMain create() => CompassMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompassMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompassMainState>(value),
    );
  }
}

String _$compassMainHash() => r'd4e351ca57515f5882eea37d009ac6bcc98c6e0b';

abstract class _$CompassMain extends $Notifier<CompassMainState> {
  CompassMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CompassMainState, CompassMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CompassMainState, CompassMainState>,
              CompassMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CompassList)
const compassListProvider = CompassListProvider._();

final class CompassListProvider
    extends $NotifierProvider<CompassList, CompassListState> {
  const CompassListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compassListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compassListHash();

  @$internal
  @override
  CompassList create() => CompassList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompassListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompassListState>(value),
    );
  }
}

String _$compassListHash() => r'14af12167f7536bc904d755940b684219802a20e';

abstract class _$CompassList extends $Notifier<CompassListState> {
  CompassListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CompassListState, CompassListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CompassListState, CompassListState>,
              CompassListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
