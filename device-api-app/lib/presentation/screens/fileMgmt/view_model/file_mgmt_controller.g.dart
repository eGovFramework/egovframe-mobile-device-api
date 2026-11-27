// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_mgmt_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FileMgmtMain)
const fileMgmtMainProvider = FileMgmtMainProvider._();

final class FileMgmtMainProvider
    extends $NotifierProvider<FileMgmtMain, FileMgmtMainState> {
  const FileMgmtMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileMgmtMainProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileMgmtMainHash();

  @$internal
  @override
  FileMgmtMain create() => FileMgmtMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileMgmtMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileMgmtMainState>(value),
    );
  }
}

String _$fileMgmtMainHash() => r'5a324c500a896cb8f2978bc5878ec79fcce01f0a';

abstract class _$FileMgmtMain extends $Notifier<FileMgmtMainState> {
  FileMgmtMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FileMgmtMainState, FileMgmtMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FileMgmtMainState, FileMgmtMainState>,
              FileMgmtMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
