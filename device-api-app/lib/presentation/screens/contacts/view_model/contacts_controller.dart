import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/usecases/contacts_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/contacts_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/state/contacts_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_controller.g.dart';

ContactsUseCase _contactsUseCase(Ref ref) => ref.read(contactsUseCaseProvider);

@riverpod
class ContactsMain extends _$ContactsMain {
  @override
  ContactsMainState build() {
    Future.microtask(_initialize);
    return ContactsMainState.initial();
  }

  Future<void> _initialize() async {
    final uuid = await _contactsUseCase(ref).getDeviceUuid();
    state = state.copyWith(isLoading: false, uuid: uuid);
    await loadDeviceContacts();
  }

  Future<void> loadDeviceContacts() async {
    state = state.copyWith(
      isLoadingContacts: true,
      clearLoadError: true,
    );

    final result = await _contactsUseCase(ref).loadDeviceContacts();

    switch (result) {
      case ContactsDeviceLoadSuccess(:final items):
        state = state.copyWith(
          isLoadingContacts: false,
          deviceContacts: items,
        );
      case ContactsDeviceLoadEmpty():
        state = state.copyWith(
          isLoadingContacts: false,
          deviceContacts: [],
        );
      case ContactsDeviceLoadFailure(:final message):
        state = state.copyWith(
          isLoadingContacts: false,
          deviceContacts: [],
          loadError: message,
        );
    }
  }

  Future<ContactsUploadBatchResult> uploadContacts(
    List<ContactPreview> contacts,
  ) async {
    final infos = contacts
        .where((contact) => contact.hasUploadData)
        .map(
          (contact) => ContactsInfo(
            // 서버(UUID별) MAX(SN)+1 채번
            sn: 0,
            name: contact.name,
            telno: contact.phone,
            emails: contact.email,
            useYn: 'Y',
            uuid: state.uuid,
          ),
        )
        .toList();

    if (infos.isEmpty) {
      return const ContactsUploadBatchFailure(ContactsMessageKeys.noHeadingData);
    }

    for (final info in infos) {
      final result = await _contactsUseCase(ref).uploadContactsToServer(info);
      if (result is ContactsUploadFailure) {
        return ContactsUploadBatchFailure(result.message);
      }
    }

    return ContactsUploadBatchSuccess(infos.length);
  }
}

@riverpod
class ContactsList extends _$ContactsList {
  @override
  ContactsListState build() {
    Future.microtask(reload);
    return ContactsListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _contactsUseCase(ref).loadContactsList();

    switch (result) {
      case ContactsListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          contactsList: items,
          errorMessage: '',
        );
      case ContactsListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          contactsList: [],
          errorMessage: '',
        );
      case ContactsListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          contactsList: [],
          errorMessage: message,
        );
    }
  }

  Future<ContactsDeleteBatchResult> deleteSelectedItems(
    List<ContactsInfo> items,
  ) async {
    return _contactsUseCase(ref).deleteContactsItems(items);
  }

  Future<ContactsDeviceSaveBatchResult> saveSelectedToDevice(
    List<ContactsInfo> items,
  ) async {
    return _contactsUseCase(ref).saveContactsToDevice(items);
  }
}
