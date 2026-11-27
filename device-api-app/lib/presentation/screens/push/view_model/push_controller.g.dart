// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PushMain)
const pushMainProvider = PushMainProvider._();

final class PushMainProvider
    extends $NotifierProvider<PushMain, PushMainState> {
  const PushMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushMainHash();

  @$internal
  @override
  PushMain create() => PushMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushMainState>(value),
    );
  }
}

String _$pushMainHash() => r'a3c6adb5c8b4cff8d5b169c19bcc4ba3408b2ee0';

abstract class _$PushMain extends $Notifier<PushMainState> {
  PushMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PushMainState, PushMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PushMainState, PushMainState>,
              PushMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PushList)
const pushListProvider = PushListProvider._();

final class PushListProvider
    extends $NotifierProvider<PushList, PushListState> {
  const PushListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushListHash();

  @$internal
  @override
  PushList create() => PushList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushListState>(value),
    );
  }
}

String _$pushListHash() => r'69db522201c2951cf51fe54d467135cd57e46248';

abstract class _$PushList extends $Notifier<PushListState> {
  PushListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PushListState, PushListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PushListState, PushListState>,
              PushListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
