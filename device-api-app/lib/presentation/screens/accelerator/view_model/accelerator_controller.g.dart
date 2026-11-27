// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accelerator_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AcceleratorMain)
const acceleratorMainProvider = AcceleratorMainProvider._();

final class AcceleratorMainProvider
    extends $NotifierProvider<AcceleratorMain, AcceleratorMainState> {
  const AcceleratorMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceleratorMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceleratorMainHash();

  @$internal
  @override
  AcceleratorMain create() => AcceleratorMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceleratorMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceleratorMainState>(value),
    );
  }
}

String _$acceleratorMainHash() => r'96f749397f7479dd09ddab6c7c4f8806cd44bb3e';

abstract class _$AcceleratorMain extends $Notifier<AcceleratorMainState> {
  AcceleratorMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AcceleratorMainState, AcceleratorMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AcceleratorMainState, AcceleratorMainState>,
              AcceleratorMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AcceleratorList)
const acceleratorListProvider = AcceleratorListProvider._();

final class AcceleratorListProvider
    extends $NotifierProvider<AcceleratorList, AcceleratorListState> {
  const AcceleratorListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceleratorListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceleratorListHash();

  @$internal
  @override
  AcceleratorList create() => AcceleratorList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceleratorListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceleratorListState>(value),
    );
  }
}

String _$acceleratorListHash() => r'89771029d34ec1a9f5a1a939a57d57722d6e50aa';

abstract class _$AcceleratorList extends $Notifier<AcceleratorListState> {
  AcceleratorListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AcceleratorListState, AcceleratorListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AcceleratorListState, AcceleratorListState>,
              AcceleratorListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AcceleratorDetail)
const acceleratorDetailProvider = AcceleratorDetailFamily._();

final class AcceleratorDetailProvider
    extends $NotifierProvider<AcceleratorDetail, AcceleratorDetailState> {
  const AcceleratorDetailProvider._({
    required AcceleratorDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'acceleratorDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$acceleratorDetailHash();

  @override
  String toString() {
    return r'acceleratorDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AcceleratorDetail create() => AcceleratorDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceleratorDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceleratorDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AcceleratorDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$acceleratorDetailHash() => r'dfdaf54488429ed27a51ca41daac4774cd772dc1';

final class AcceleratorDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          AcceleratorDetail,
          AcceleratorDetailState,
          AcceleratorDetailState,
          AcceleratorDetailState,
          int
        > {
  const AcceleratorDetailFamily._()
    : super(
        retry: null,
        name: r'acceleratorDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AcceleratorDetailProvider call(int sn) =>
      AcceleratorDetailProvider._(argument: sn, from: this);

  @override
  String toString() => r'acceleratorDetailProvider';
}

abstract class _$AcceleratorDetail extends $Notifier<AcceleratorDetailState> {
  late final _$args = ref.$arg as int;
  int get sn => _$args;

  AcceleratorDetailState build(int sn);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AcceleratorDetailState, AcceleratorDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AcceleratorDetailState, AcceleratorDetailState>,
              AcceleratorDetailState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
