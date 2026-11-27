import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/state/contacts_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/view_model/contacts_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/widgets/contacts_connection_resolver.dart';

class ContactsDeviceListPage extends ConsumerStatefulWidget {
  const ContactsDeviceListPage({super.key});

  @override
  ConsumerState<ContactsDeviceListPage> createState() =>
      _ContactsDeviceListPageState();
}

class _ContactsDeviceListPageState extends ConsumerState<ContactsDeviceListPage> {
  final Set<String> _selectedIds = {};

  ContactsMain get _notifier => ref.read(contactsMainProvider.notifier);

  void _clearSelection() {
    setState(_selectedIds.clear);
  }

  void _toggleSelection(ContactPreview contact) {
    if (!contact.hasUploadData) return;

    setState(() {
      if (_selectedIds.contains(contact.id)) {
        _selectedIds.remove(contact.id);
      } else {
        _selectedIds.add(contact.id);
      }
    });
  }

  List<ContactPreview> _selectedContacts(ContactsMainState mainState) {
    return mainState.deviceContacts
        .where((contact) => _selectedIds.contains(contact.id))
        .toList();
  }

  Future<void> _uploadSelectedContacts() async {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.read(contactsMainProvider);
    final selectedContacts = _selectedContacts(mainState);

    if (selectedContacts.isEmpty) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.contactsNoHeadingData,
      );
      return;
    }

    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.contactsSaveTitle,
      message: l10n.contactsSaveConfirmCount(selectedContacts.length),
    );
    if (!confirmed || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(l10n.contactsUploading),
            ],
          ),
        );
      },
    );

    final result = await _notifier.uploadContacts(selectedContacts);

    if (!mounted) return;
    Navigator.of(context).pop();

    switch (result) {
      case ContactsUploadBatchSuccess(:final count):
        _clearSelection();
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.contactsSaveSuccessCount(count),
        );
      case ContactsUploadBatchFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(contactsMainProvider);
    final notifier = ref.read(contactsMainProvider.notifier);
    final hasSelection = _selectedIds.isNotEmpty;

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.contacts,
      title: hasSelection
          ? l10n.contactsSelectedCount(_selectedIds.length)
          : l10n.contactsToggleButton,
      mainFunctionBody: mainState.isLoadingContacts
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: notifier.loadDeviceContacts,
              color: EgovColor.primary50,
              child: _buildListContent(
                context,
                l10n: l10n,
                mainState: mainState,
              ),
            ),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.uploadButton(
            text: l10n.contactsSaveButton,
            onServerConnected: _uploadSelectedContacts,
            resolveConnection: ContactsConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }

  Widget _buildListContent(
    BuildContext context, {
    required AppLocalizations l10n,
    required ContactsMainState mainState,
  }) {
    if (mainState.deviceContacts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              l10n.contactsEmptyDeviceContacts,
              textAlign: TextAlign.center,
              style: EgovText.regular.copyWith(color: EgovColor.gray60),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: mainState.deviceContacts.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InfoBox(
              text: _selectedIds.isEmpty
                  ? l10n.contactsStatusOff
                  : l10n.contactsSelectedCount(_selectedIds.length),
            ),
          );
        }

        final contact = mainState.deviceContacts[index - 1];
        final isSelected = _selectedIds.contains(contact.id);

        return Material(
          color: isSelected ? EgovColor.primary5 : EgovColor.white100,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _toggleSelection(contact),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? EgovColor.primary30 : EgovColor.gray20,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isSelected ? EgovColor.primary50 : EgovColor.gray50,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.person_outline,
                    color: isSelected ? EgovColor.primary50 : EgovColor.gray50,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name.isNotEmpty
                              ? contact.name
                              : l10n.contactsListItemUuid,
                          style: EgovText.medium.copyWith(
                            color: EgovColor.gray90,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (contact.phone.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            contact.phone,
                            style: EgovText.caption.copyWith(
                              color: EgovColor.gray70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
