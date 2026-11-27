// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_readwrite_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FileReadWriteConnectionStatus)
const fileReadWriteConnectionStatusProvider =
    FileReadWriteConnectionStatusProvider._();

final class FileReadWriteConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          FileReadWriteConnectionStatus,
          FileReadWriteConnectionStatusSnapshot
        > {
  const FileReadWriteConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileReadWriteConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileReadWriteConnectionStatusHash();

  @$internal
  @override
  FileReadWriteConnectionStatus create() => FileReadWriteConnectionStatus();
}

String _$fileReadWriteConnectionStatusHash() =>
    r'97bbb77df8c83b0caedd4416092f92c20839d0b5';

abstract class _$FileReadWriteConnectionStatus
    extends $AsyncNotifier<FileReadWriteConnectionStatusSnapshot> {
  FutureOr<FileReadWriteConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<FileReadWriteConnectionStatusSnapshot>,
              FileReadWriteConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<FileReadWriteConnectionStatusSnapshot>,
                FileReadWriteConnectionStatusSnapshot
              >,
              AsyncValue<FileReadWriteConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
