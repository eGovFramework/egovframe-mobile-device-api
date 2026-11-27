import 'package:egovframe_mobile_deviceapi_app/config/ai_chat_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view_model/ai_chat_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_connection_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 채팅 영역을 줄이지 않도록 한 줄만 보여주고, 탭하면 연결 카드를 시트로 연다.
class AiChatConnectionBar extends ConsumerWidget {
  const AiChatConnectionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statusAsync = ref.watch(aiChatConnectionStatusProvider);
    final hint = l10n.connectionBarHint;

    final (title, color) = statusAsync.when(
      loading: () => (l10n.commonConnectionStatusChecking, EgovColor.gray40),
      error: (_, __) => (l10n.commonConnectionDisconnected, EgovColor.danger50),
      data: (snapshot) => switch (snapshot.activeSource) {
        AiChatDataSourceStatus.externalServer => (
            l10n.commonConnectionExternalServer,
            EgovColor.success50,
          ),
        AiChatDataSourceStatus.sqlite => (
            l10n.commonConnectionSqlite,
            EgovColor.primary50,
          ),
        AiChatDataSourceStatus.disconnected => (
            l10n.commonConnectionDisconnected,
            EgovColor.danger50,
          ),
      },
    );

    final detail = statusAsync.maybeWhen(
      data: (snapshot) => switch (snapshot.activeSource) {
        AiChatDataSourceStatus.sqlite => l10n.commonConnectionSqliteDetail(
            snapshot.statusDetail,
            AiChatSqliteSchema.tableName,
          ),
        _ => snapshot.statusDetail,
      },
      orElse: () => hint,
    );

    return FeatureConnectionBar(
      title: title,
      detail: detail,
      statusColor: color,
      hint: hint,
      isConnected: color == EgovColor.success50 || color == EgovColor.primary50,
      sheetChild: const AiChatConnectionStatusCard(),
    );
  }
}
