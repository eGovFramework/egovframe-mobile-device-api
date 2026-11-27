// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fileopener_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FileOpenerConnectionStatus)
const fileOpenerConnectionStatusProvider =
    FileOpenerConnectionStatusProvider._();

final class FileOpenerConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          FileOpenerConnectionStatus,
          FileOpenerConnectionStatusSnapshot
        > {
  const FileOpenerConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileOpenerConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileOpenerConnectionStatusHash();

  @$internal
  @override
  FileOpenerConnectionStatus create() => FileOpenerConnectionStatus();
}

String _$fileOpenerConnectionStatusHash() =>
    r'0399259358102543ba2241730f85991d9fd8bfb1';

abstract class _$FileOpenerConnectionStatus
    extends $AsyncNotifier<FileOpenerConnectionStatusSnapshot> {
  FutureOr<FileOpenerConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<FileOpenerConnectionStatusSnapshot>,
              FileOpenerConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<FileOpenerConnectionStatusSnapshot>,
                FileOpenerConnectionStatusSnapshot
              >,
              AsyncValue<FileOpenerConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
