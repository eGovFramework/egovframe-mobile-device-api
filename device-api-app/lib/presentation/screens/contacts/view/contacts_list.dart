import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';
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
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsListPage extends ConsumerStatefulWidget {
  const ContactsListPage({super.key});

  @override
  ConsumerState<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends ConsumerState<ContactsListPage> {
  final Set<int> _selectedSns = {};

  void _clearSelection() {
    setState(_selectedSns.clear);
  }

  void _toggleSelection(ContactsInfo item) {
    setState(() {
      if (_selectedSns.contains(item.sn)) {
        _selectedSns.remove(item.sn);
      } else {
        _selectedSns.add(item.sn);
      }
    });
  }

  List<ContactsInfo> _selectedItems(ContactsListState listState) {
    return listState.contactsList
        .where((item) => _selectedSns.contains(item.sn))
        .toList();
  }

  Future<void> _saveSelectedToDevice() async {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.read(contactsListProvider);
    final selectedItems = _selectedItems(listState);

    if (selectedItems.isEmpty) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.contactsNoSelection,
      );
      return;
    }

    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.contactsSaveToDeviceTitle,
      message: l10n.contactsSaveToDeviceConfirm(selectedItems.length),
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
              Expanded(child: Text(l10n.contactsSavingToDevice)),
            ],
          ),
        );
      },
    );

    final notifier = ref.read(contactsListProvider.notifier);
    final result = await notifier.saveSelectedToDevice(selectedItems);

    if (!mounted) return;
    Navigator.of(context).pop();

    switch (result) {
      case ContactsDeviceSaveBatchSuccess(
        :final count,
        :final skippedDuplicateCount,
      ):
        _clearSelection();
        if (count == 0 && skippedDuplicateCount > 0) {
          await showToast(
            context,
            variant: ToastVariant.info,
            message: l10n.contactsSaveToDeviceAlreadyOnDevice,
          );
        } else if (count > 0 && skippedDuplicateCount > 0) {
          await showStatusToast(
            context,
            variant: StatusVariant.success,
            title: l10n.commonSuccess,
            message: l10n.contactsSaveToDeviceSuccessWithSkipped(
              count,
              skippedDuplicateCount,
            ),
          );
        } else if (count > 0) {
          await showStatusToast(
            context,
            variant: StatusVariant.success,
            title: l10n.commonSuccess,
            message: l10n.contactsSaveToDeviceSuccess(count),
          );
        }
      case ContactsDeviceSaveBatchFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  Future<void> _deleteSelected() async {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.read(contactsListProvider);
    final selectedItems = _selectedItems(listState);

    if (selectedItems.isEmpty) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.contactsNoSelection,
      );
      return;
    }

    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.contactsDeleteAllTitle,
      message: l10n.contactsDeleteSelectedConfirm(selectedItems.length),
    );
    if (!confirmed || !mounted) return;

    final notifier = ref.read(contactsListProvider.notifier);
    final result = await notifier.deleteSelectedItems(selectedItems);

    if (!mounted) return;

    switch (result) {
      case ContactsDeleteBatchSuccess():
        _clearSelection();
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.contactsDeleteSelectedSuccess,
        );
        await notifier.reload();
      case ContactsDeleteBatchFailure(:final message):
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
    final listState = ref.watch(contactsListProvider);
    final notifier = ref.read(contactsListProvider.notifier);
    final hasSelection = _selectedSns.isNotEmpty;

    return PopScope(
      canPop: !hasSelection,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _clearSelection();
      },
      child: ApiFeatureShell(
        popToApiMainCount: 1,
        feature: ApiFeature.contacts,
        title: hasSelection
            ? l10n.contactsSelectedCount(_selectedSns.length)
            : l10n.contactsApiTitle,
        mainFunctionBody: listState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: _buildListContent(l10n, listState, notifier),
              ),
        bottomBar: hasSelection
            ? BottomButtonRow(
                buttons: [
                  CustomButton(
                    text: l10n.commonCancel,
                    onTap: _clearSelection,
                    normalColor: EgovColor.gray70,
                    icon: const Icon(
                      Icons.close,
                      color: EgovColor.white100,
                      size: 20,
                    ),
                  ),
                  CustomButton(
                    text: l10n.contactsSaveToDeviceButton,
                    onTap: _saveSelectedToDevice,
                    icon: const Icon(
                      Icons.contact_phone_outlined,
                      color: EgovColor.white100,
                      size: 20,
                    ),
                  ),
                  ServerConnectionButton(
                    text: l10n.contactsDeleteSelectedButton,
                    normalColor: EgovColor.point50,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: EgovColor.white100,
                      size: 20,
                    ),
                    onServerConnected: _deleteSelected,
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildListContent(
    AppLocalizations l10n,
    ContactsListState listState,
    ContactsList notifier,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: notifier.reload,
      );
    }

    if (listState.contactsList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.contactsEmptyList);
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: EgovColor.primary50,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listState.contactsList.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InfoBox(
                text: _selectedSns.isEmpty
                    ? l10n.contactsServerListSelectionHint
                    : l10n.contactsSelectedCount(_selectedSns.length),
              ),
            );
          }

          final item = listState.contactsList[index - 1];
          final isSelected = _selectedSns.contains(item.sn);

          return _SelectableServerContactTile(
            item: item,
            isSelected: isSelected,
            nameFallback: l10n.contactsListItemUuid,
            phoneLabel: l10n.contactsListItemDrc,
            emailLabel: l10n.contactsListItemAccrcy,
            onTap: () => _toggleSelection(item),
          );
        },
      ),
    );
  }
}

class _SelectableServerContactTile extends StatelessWidget {
  final ContactsInfo item;
  final bool isSelected;
  final String nameFallback;
  final String phoneLabel;
  final String emailLabel;
  final VoidCallback onTap;

  const _SelectableServerContactTile({
    required this.item,
    required this.isSelected,
    required this.nameFallback,
    required this.phoneLabel,
    required this.emailLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.name.isNotEmpty ? item.name : nameFallback;
    final phone = item.telno.isNotEmpty ? item.telno : '-';
    final email = item.emails.isNotEmpty ? item.emails : '-';

    return Material(
      color: isSelected ? EgovColor.primary5 : EgovColor.white100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? EgovColor.primary30 : EgovColor.gray20,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  isSelected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: isSelected ? EgovColor.primary50 : EgovColor.gray50,
                ),
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
                      title,
                      style: EgovText.medium.copyWith(
                        color: EgovColor.gray90,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$phoneLabel : $phone',
                      style: EgovText.caption.copyWith(
                        color: EgovColor.gray70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$emailLabel : $email',
                      style: EgovText.caption.copyWith(
                        color: EgovColor.gray70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
