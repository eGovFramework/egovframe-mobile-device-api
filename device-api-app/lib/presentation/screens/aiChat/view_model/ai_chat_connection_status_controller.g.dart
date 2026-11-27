// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiChatConnectionStatus)
const aiChatConnectionStatusProvider = AiChatConnectionStatusProvider._();

final class AiChatConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          AiChatConnectionStatus,
          AiChatConnectionStatusSnapshot
        > {
  const AiChatConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatConnectionStatusHash();

  @$internal
  @override
  AiChatConnectionStatus create() => AiChatConnectionStatus();
}

String _$aiChatConnectionStatusHash() =>
    r'2b26f42f23899ac55974ea1e8e91d994e6f12342';

abstract class _$AiChatConnectionStatus
    extends $AsyncNotifier<AiChatConnectionStatusSnapshot> {
  FutureOr<AiChatConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<AiChatConnectionStatusSnapshot>,
              AiChatConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AiChatConnectionStatusSnapshot>,
                AiChatConnectionStatusSnapshot
              >,
              AsyncValue<AiChatConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
