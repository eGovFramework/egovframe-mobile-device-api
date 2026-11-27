import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/state/contacts_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/view/contacts_device_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/view/contacts_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/view_model/contacts_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/view_model/contacts_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/widgets/contacts_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/widgets/contacts_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/widgets/contacts_connection_resolver.dart';

import 'contacts_description.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  ContactsMain get _notifier => ref.read(contactsMainProvider.notifier);

  Future<void> _navigateToDeviceContactList() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactsDeviceListPage()),
    );
  }

  Future<void> _navigateToList() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactsListPage()),
    );
  }

  Widget _buildMainFunctionBody(ContactsMainState mainState) {
    if (mainState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          _notifier.loadDeviceContacts(),
          ref.read(contactsConnectionStatusProvider.notifier).refresh(),
        ]);
      },
      color: EgovColor.primary50,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: ContactsOverview(
          deviceContacts: mainState.deviceContacts,
          isLoadingContacts: mainState.isLoadingContacts,
          onReloadContacts: _notifier.loadDeviceContacts,
          onNavigateToContactList: _navigateToDeviceContactList,
          statusNotice: mainState.loadError == null
              ? null
              : resolveAppMessage(
                  AppLocalizations.of(context)!,
                  mainState.loadError!,
                ),
          footer: const ContactsConnectionBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(contactsMainProvider);

    return FeatureShell(
      currentAppTargetPage: 'contacts',
      title: l10n.contactsApiTitle,
      guidePage: const ContactsFunctionPage(),
      mainFunctionBody: _buildMainFunctionBody(mainState),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.contactsListButton,
            onServerConnected: _navigateToList,
            resolveConnection: ContactsConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }
}
