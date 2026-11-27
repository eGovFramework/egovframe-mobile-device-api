// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaMain)
const mediaMainProvider = MediaMainProvider._();

final class MediaMainProvider
    extends $NotifierProvider<MediaMain, MediaMainState> {
  const MediaMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaMainHash();

  @$internal
  @override
  MediaMain create() => MediaMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaMainState>(value),
    );
  }
}

String _$mediaMainHash() => r'ca50d5d1563a95e8b309e8256effdd94ed323697';

abstract class _$MediaMain extends $Notifier<MediaMainState> {
  MediaMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MediaMainState, MediaMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MediaMainState, MediaMainState>,
              MediaMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MediaList)
const mediaListProvider = MediaListProvider._();

final class MediaListProvider
    extends $NotifierProvider<MediaList, MediaListState> {
  const MediaListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaListHash();

  @$internal
  @override
  MediaList create() => MediaList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaListState>(value),
    );
  }
}

String _$mediaListHash() => r'24a40a943b93edebf3b701d104eac2c24bf219b2';

abstract class _$MediaList extends $Notifier<MediaListState> {
  MediaListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MediaListState, MediaListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MediaListState, MediaListState>,
              MediaListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MediaDetail)
const mediaDetailProvider = MediaDetailFamily._();

final class MediaDetailProvider
    extends $NotifierProvider<MediaDetail, MediaDetailState> {
  const MediaDetailProvider._({
    required MediaDetailFamily super.from,
    required MediaFileInfo super.argument,
  }) : super(
         retry: null,
         name: r'mediaDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaDetailHash();

  @override
  String toString() {
    return r'mediaDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MediaDetail create() => MediaDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MediaDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaDetailHash() => r'8a5d21463de7ffdef42bbea9267a2b06f6fdc2b9';

final class MediaDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          MediaDetail,
          MediaDetailState,
          MediaDetailState,
          MediaDetailState,
          MediaFileInfo
        > {
  const MediaDetailFamily._()
    : super(
        retry: null,
        name: r'mediaDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MediaDetailProvider call(MediaFileInfo mediaFile) =>
      MediaDetailProvider._(argument: mediaFile, from: this);

  @override
  String toString() => r'mediaDetailProvider';
}

abstract class _$MediaDetail extends $Notifier<MediaDetailState> {
  late final _$args = ref.$arg as MediaFileInfo;
  MediaFileInfo get mediaFile => _$args;

  MediaDetailState build(MediaFileInfo mediaFile);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<MediaDetailState, MediaDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MediaDetailState, MediaDetailState>,
              MediaDetailState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
