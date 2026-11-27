// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaConnectionStatus)
const mediaConnectionStatusProvider = MediaConnectionStatusProvider._();

final class MediaConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          MediaConnectionStatus,
          MediaConnectionStatusSnapshot
        > {
  const MediaConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaConnectionStatusHash();

  @$internal
  @override
  MediaConnectionStatus create() => MediaConnectionStatus();
}

String _$mediaConnectionStatusHash() =>
    r'056b365d6f44c12b146a26eac9e13ecdf22627d5';

abstract class _$MediaConnectionStatus
    extends $AsyncNotifier<MediaConnectionStatusSnapshot> {
  FutureOr<MediaConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<MediaConnectionStatusSnapshot>,
              MediaConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<MediaConnectionStatusSnapshot>,
                MediaConnectionStatusSnapshot
              >,
              AsyncValue<MediaConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
