import 'package:flutter_contacts/flutter_contacts.dart';

/// 디바이스에서 선택한 연락처 스냅샷
class ContactPreview {
  final String id;
  final String name;
  final String phone;
  final String email;

  const ContactPreview({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory ContactPreview.fromContact(Contact contact) {
    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
    final email = contact.emails.isNotEmpty ? contact.emails.first.address : '';

    return ContactPreview(
      id: contact.id,
      name: contact.displayName.trim(),
      phone: phone.trim(),
      email: email.trim(),
    );
  }

  bool get hasUploadData => name.isNotEmpty || phone.isNotEmpty || email.isNotEmpty;

  ContactPreview copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
  }) {
    return ContactPreview(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}
