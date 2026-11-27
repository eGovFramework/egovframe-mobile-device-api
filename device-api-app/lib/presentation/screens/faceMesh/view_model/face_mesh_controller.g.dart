// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_mesh_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FaceMeshMain)
const faceMeshMainProvider = FaceMeshMainProvider._();

final class FaceMeshMainProvider
    extends $NotifierProvider<FaceMeshMain, FaceMeshMainState> {
  const FaceMeshMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceMeshMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceMeshMainHash();

  @$internal
  @override
  FaceMeshMain create() => FaceMeshMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaceMeshMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaceMeshMainState>(value),
    );
  }
}

String _$faceMeshMainHash() => r'31b97ceaa245ad213c405bd17d0f549b84b458c9';

abstract class _$FaceMeshMain extends $Notifier<FaceMeshMainState> {
  FaceMeshMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FaceMeshMainState, FaceMeshMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FaceMeshMainState, FaceMeshMainState>,
              FaceMeshMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FaceMeshList)
const faceMeshListProvider = FaceMeshListProvider._();

final class FaceMeshListProvider
    extends $NotifierProvider<FaceMeshList, FaceMeshListState> {
  const FaceMeshListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceMeshListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceMeshListHash();

  @$internal
  @override
  FaceMeshList create() => FaceMeshList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaceMeshListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaceMeshListState>(value),
    );
  }
}

String _$faceMeshListHash() => r'c28786db25802031496ea487ece9d37842e42dca';

abstract class _$FaceMeshList extends $Notifier<FaceMeshListState> {
  FaceMeshListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FaceMeshListState, FaceMeshListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FaceMeshListState, FaceMeshListState>,
              FaceMeshListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FaceMeshDetail)
const faceMeshDetailProvider = FaceMeshDetailFamily._();

final class FaceMeshDetailProvider
    extends $NotifierProvider<FaceMeshDetail, FaceMeshDetailState> {
  const FaceMeshDetailProvider._({
    required FaceMeshDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'faceMeshDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$faceMeshDetailHash();

  @override
  String toString() {
    return r'faceMeshDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FaceMeshDetail create() => FaceMeshDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaceMeshDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaceMeshDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FaceMeshDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$faceMeshDetailHash() => r'37a85c0be7fa06879b0c5dbf1140651ee346d876';

final class FaceMeshDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          FaceMeshDetail,
          FaceMeshDetailState,
          FaceMeshDetailState,
          FaceMeshDetailState,
          int
        > {
  const FaceMeshDetailFamily._()
    : super(
        retry: null,
        name: r'faceMeshDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FaceMeshDetailProvider call(int sn) =>
      FaceMeshDetailProvider._(argument: sn, from: this);

  @override
  String toString() => r'faceMeshDetailProvider';
}

abstract class _$FaceMeshDetail extends $Notifier<FaceMeshDetailState> {
  late final _$args = ref.$arg as int;
  int get sn => _$args;

  FaceMeshDetailState build(int sn);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<FaceMeshDetailState, FaceMeshDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FaceMeshDetailState, FaceMeshDetailState>,
              FaceMeshDetailState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
