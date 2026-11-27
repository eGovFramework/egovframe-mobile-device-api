import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';

class ContactsMainState {
  final bool isLoading;
  final bool isLoadingContacts;
  final String? loadError;
  final String uuid;
  final List<ContactPreview> deviceContacts;

  const ContactsMainState({
    required this.isLoading,
    required this.isLoadingContacts,
    this.loadError,
    required this.uuid,
    required this.deviceContacts,
  });

  factory ContactsMainState.initial() {
    return const ContactsMainState(
      isLoading: true,
      isLoadingContacts: false,
      uuid: '',
      deviceContacts: [],
    );
  }

  ContactsMainState copyWith({
    bool? isLoading,
    bool? isLoadingContacts,
    String? loadError,
    bool clearLoadError = false,
    String? uuid,
    List<ContactPreview>? deviceContacts,
  }) {
    return ContactsMainState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingContacts: isLoadingContacts ?? this.isLoadingContacts,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      uuid: uuid ?? this.uuid,
      deviceContacts: deviceContacts ?? this.deviceContacts,
    );
  }
}

class ContactsListState {
  final bool isLoading;
  final List<ContactsInfo> contactsList;
  final String errorMessage;

  const ContactsListState({
    required this.isLoading,
    required this.contactsList,
    required this.errorMessage,
  });

  factory ContactsListState.initial() {
    return const ContactsListState(
      isLoading: true,
      contactsList: [],
      errorMessage: '',
    );
  }

  ContactsListState copyWith({
    bool? isLoading,
    List<ContactsInfo>? contactsList,
    String? errorMessage,
  }) {
    return ContactsListState(
      isLoading: isLoading ?? this.isLoading,
      contactsList: contactsList ?? this.contactsList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
