// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiChatMain)
const aiChatMainProvider = AiChatMainProvider._();

final class AiChatMainProvider
    extends $NotifierProvider<AiChatMain, AiChatMainState> {
  const AiChatMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatMainHash();

  @$internal
  @override
  AiChatMain create() => AiChatMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatMainState>(value),
    );
  }
}

String _$aiChatMainHash() => r'9e34efb45719ffe643ba51d262b2708ffdc91a62';

abstract class _$AiChatMain extends $Notifier<AiChatMainState> {
  AiChatMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AiChatMainState, AiChatMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiChatMainState, AiChatMainState>,
              AiChatMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AiChatList)
const aiChatListProvider = AiChatListProvider._();

final class AiChatListProvider
    extends $NotifierProvider<AiChatList, AiChatListState> {
  const AiChatListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatListHash();

  @$internal
  @override
  AiChatList create() => AiChatList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatListState>(value),
    );
  }
}

String _$aiChatListHash() => r'b01a78bdfd1fbe37ae9d4c75348c10a0e1d4001d';

abstract class _$AiChatList extends $Notifier<AiChatListState> {
  AiChatListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AiChatListState, AiChatListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiChatListState, AiChatListState>,
              AiChatListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
