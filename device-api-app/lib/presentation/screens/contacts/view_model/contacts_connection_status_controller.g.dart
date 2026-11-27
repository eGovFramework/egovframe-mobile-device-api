// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactsConnectionStatus)
const contactsConnectionStatusProvider = ContactsConnectionStatusProvider._();

final class ContactsConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          ContactsConnectionStatus,
          ContactsConnectionStatusSnapshot
        > {
  const ContactsConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsConnectionStatusHash();

  @$internal
  @override
  ContactsConnectionStatus create() => ContactsConnectionStatus();
}

String _$contactsConnectionStatusHash() =>
    r'ceb45eb85f78999b2dedaadfa114cbc24198197c';

abstract class _$ContactsConnectionStatus
    extends $AsyncNotifier<ContactsConnectionStatusSnapshot> {
  FutureOr<ContactsConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ContactsConnectionStatusSnapshot>,
              ContactsConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ContactsConnectionStatusSnapshot>,
                ContactsConnectionStatusSnapshot
              >,
              AsyncValue<ContactsConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
