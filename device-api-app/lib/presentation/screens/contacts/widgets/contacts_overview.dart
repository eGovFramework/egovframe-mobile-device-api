import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

class ContactsOverview extends StatelessWidget {
  final List<ContactPreview> deviceContacts;
  final bool isLoadingContacts;
  final VoidCallback onReloadContacts;
  final VoidCallback? onNavigateToContactList;
  final String? statusNotice;
  final Widget? footer;

  const ContactsOverview({
    super.key,
    required this.deviceContacts,
    required this.isLoadingContacts,
    required this.onReloadContacts,
    this.onNavigateToContactList,
    this.statusNotice,
    this.footer,
  });

  String _statusText(AppLocalizations l10n) {
    if (isLoadingContacts) {
      return l10n.contactsStatusOn;
    }
    if (statusNotice != null && statusNotice!.isNotEmpty) {
      return statusNotice!;
    }
    if (deviceContacts.isNotEmpty) {
      return l10n.contactsStatusOff;
    }
    return l10n.contactsStatusEmptyDevice;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final contactCount = deviceContacts.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoBox(text: _statusText(l10n)),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              l10n.contactsToggleButton,
              style: EgovText.subtitle.copyWith(color: EgovColor.gray90),
            ),
            const Spacer(),
            IconButton(
              onPressed: isLoadingContacts ? null : onReloadContacts,
              icon: Icon(
                Icons.refresh,
                color: isLoadingContacts
                    ? EgovColor.gray40
                    : EgovColor.primary50,
              ),
              tooltip: l10n.commonRefresh,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (isLoadingContacts)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          _DeviceContactCountCard(
            countLabel: l10n.contactsDeviceCount(contactCount),
            hintLabel: contactCount == 0
                ? l10n.contactsDeviceCountHintEmpty
                : l10n.contactsDeviceCountHint,
            onTap: onNavigateToContactList,
          ),
        if (footer != null) ...[
          const SizedBox(height: 16),
          footer!,
        ],
      ],
    );
  }
}

class _DeviceContactCountCard extends StatelessWidget {
  final String countLabel;
  final String hintLabel;
  final VoidCallback? onTap;

  const _DeviceContactCountCard({
    required this.countLabel,
    required this.hintLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EgovColor.white100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: EgovColor.gray20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.contacts_outlined,
                color: EgovColor.primary50,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      countLabel,
                      style: EgovText.medium.copyWith(
                        color: EgovColor.gray90,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hintLabel,
                      style: EgovText.caption.copyWith(
                        color: EgovColor.gray60,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: EgovColor.gray50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
