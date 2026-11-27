// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactsMain)
const contactsMainProvider = ContactsMainProvider._();

final class ContactsMainProvider
    extends $NotifierProvider<ContactsMain, ContactsMainState> {
  const ContactsMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsMainHash();

  @$internal
  @override
  ContactsMain create() => ContactsMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsMainState>(value),
    );
  }
}

String _$contactsMainHash() => r'cc59c6fb96fa261808e3955f5dcfe3c81e6fa8cc';

abstract class _$ContactsMain extends $Notifier<ContactsMainState> {
  ContactsMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ContactsMainState, ContactsMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContactsMainState, ContactsMainState>,
              ContactsMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ContactsList)
const contactsListProvider = ContactsListProvider._();

final class ContactsListProvider
    extends $NotifierProvider<ContactsList, ContactsListState> {
  const ContactsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsListHash();

  @$internal
  @override
  ContactsList create() => ContactsList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsListState>(value),
    );
  }
}

String _$contactsListHash() => r'c83c803319f36730335024f27c087c242d398f22';

abstract class _$ContactsList extends $Notifier<ContactsListState> {
  ContactsListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ContactsListState, ContactsListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContactsListState, ContactsListState>,
              ContactsListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
