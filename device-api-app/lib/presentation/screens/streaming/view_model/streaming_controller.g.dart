// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StreamingList)
const streamingListProvider = StreamingListProvider._();

final class StreamingListProvider
    extends $NotifierProvider<StreamingList, StreamingListState> {
  const StreamingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamingListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamingListHash();

  @$internal
  @override
  StreamingList create() => StreamingList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamingListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreamingListState>(value),
    );
  }
}

String _$streamingListHash() => r'6b0cbad643dc9b84a9e30d300dee56b5f2687f76';

abstract class _$StreamingList extends $Notifier<StreamingListState> {
  StreamingListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StreamingListState, StreamingListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StreamingListState, StreamingListState>,
              StreamingListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
