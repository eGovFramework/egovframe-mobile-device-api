import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/view/streaming_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/view_model/streaming_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/widgets/streaming_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/widgets/streaming_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/widgets/streaming_connection_resolver.dart';

import 'streaming_description.dart';

class StreamingPage extends ConsumerWidget {
  const StreamingPage({super.key});

  Future<void> _navigateToList(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StreamingListPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return FeatureShell(
      currentAppTargetPage: 'streaming',
      title: l10n.streamingApiTitle,
      guidePage: const StreamingFunctionPage(),
      mainFunctionBody: RefreshIndicator(
        onRefresh: () async {
          await ref.read(streamingConnectionStatusProvider.notifier).refresh();
        },
        color: EgovColor.primary50,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: StreamingOverview(
            footer: const StreamingConnectionBar(),
          ),
        ),
      ),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.streamingListButton,
            onServerConnected: () => _navigateToList(context),
            resolveConnection: StreamingConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }
}
