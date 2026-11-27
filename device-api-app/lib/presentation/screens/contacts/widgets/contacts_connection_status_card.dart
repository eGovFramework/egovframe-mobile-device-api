import 'package:egovframe_mobile_deviceapi_app/config/contacts_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/di/contacts_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/view_model/contacts_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/widgets/contacts_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_connection_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsConnectionStatusCard extends ConsumerStatefulWidget {
  const ContactsConnectionStatusCard({super.key});

  @override
  ConsumerState<ContactsConnectionStatusCard> createState() =>
      _ContactsConnectionStatusCardState();
}

class _ContactsConnectionStatusCardState
    extends ConsumerState<ContactsConnectionStatusCard> {
  bool _isToggling = false;

  Future<void> _onSqliteToggleChanged(bool enable) async {
    if (_isToggling) return;

    setState(() => _isToggling = true);
    try {
      if (enable) {
        final enabled = await ContactsConnectionResolver.enableSqliteToggle(
          context: context,
          ref: ref,
        );
        if (!enabled && mounted) {
          ref.read(contactsConnectionProvider.notifier).useServer();
        }
      } else {
        ref.read(contactsConnectionProvider.notifier).useServer();
      }

      await ref.read(contactsConnectionStatusProvider.notifier).refresh();
    } finally {
      if (mounted) {
        setState(() => _isToggling = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusAsync = ref.watch(contactsConnectionStatusProvider);
    final connection = ref.watch(contactsConnectionProvider);
    final sqliteOn = connection.isSqlite;

    return statusAsync.when(
      loading: () => _buildCard(
        context,
        l10n: l10n,
        title: l10n.commonConnectionStatusTitle,
        subtitle: l10n.commonConnectionStatusChecking,
        statusColor: EgovColor.gray40,
        sqliteOn: sqliteOn,
        toggleEnabled: false,
        showDbSelect: false,
      ),
      error: (_, __) => _buildCard(
        context,
        l10n: l10n,
        title: l10n.commonConnectionStatusTitle,
        subtitle: l10n.commonConnectionDisconnected,
        statusColor: EgovColor.danger50,
        sqliteOn: sqliteOn,
        toggleEnabled: !_isToggling,
        showDbSelect: false,
      ),
      data: (snapshot) {
        final (title, subtitle, color) = _resolveStatusPresentation(
          l10n,
          snapshot,
        );

        return _buildCard(
          context,
          l10n: l10n,
          title: title,
          subtitle: subtitle,
          statusColor: color,
          sqliteOn: snapshot.sqliteToggleOn,
          toggleEnabled: !_isToggling,
          tableHint: snapshot.sqliteReady
              ? l10n.commonConnectionSqliteTableReady(
                  ContactsSqliteSchema.tableName,
                )
              : l10n.commonConnectionSqliteTableMissing(
                  ContactsSqliteSchema.tableName,
                ),
          showDbSelect:
              snapshot.sqliteReady && snapshot.readyDatabases.length > 1,
        );
      },
    );
  }

  (String, String, Color) _resolveStatusPresentation(
    AppLocalizations l10n,
    ContactsConnectionStatusSnapshot snapshot,
  ) {
    return switch (snapshot.activeSource) {
      ContactsDataSourceStatus.externalServer => (
          l10n.commonConnectionExternalServer,
          snapshot.statusDetail,
          EgovColor.success50,
        ),
      ContactsDataSourceStatus.sqlite => (
          l10n.commonConnectionSqlite,
          l10n.commonConnectionSqliteDetail(
            snapshot.statusDetail,
            ContactsSqliteSchema.tableName,
          ),
          EgovColor.primary50,
        ),
      ContactsDataSourceStatus.disconnected => (
          l10n.commonConnectionDisconnected,
          l10n.commonConnectionDisconnectedDetail(snapshot.statusDetail),
          EgovColor.danger50,
        ),
    };
  }

  Widget _buildCard(
    BuildContext context, {
    required AppLocalizations l10n,
    required String title,
    required String subtitle,
    required Color statusColor,
    required bool sqliteOn,
    required bool toggleEnabled,
    String? tableHint,
    bool showDbSelect = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: EgovColor.white100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EgovColor.gray20),
        boxShadow: [
          BoxShadow(
            color: EgovColor.black10,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.cloud_sync_outlined, size: 18, color: statusColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: EgovText.medium.copyWith(
                          color: EgovColor.gray90,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: EgovText.caption.copyWith(
                    color: EgovColor.gray70,
                    height: 1.4,
                  ),
                ),
                if (tableHint != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    tableHint,
                    style: EgovText.caption.copyWith(
                      color: EgovColor.gray60,
                      fontSize: 11,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    TextButton.icon(
                      onPressed: _isToggling
                          ? null
                          : () async {
                              await ContactsConnectionResolver.importDatabaseFile(
                                context,
                                ref,
                              );
                              await ref
                                  .read(contactsConnectionStatusProvider.notifier)
                                  .refresh();
                            },
                      icon: const Icon(Icons.file_download_outlined, size: 16),
                      label: Text(l10n.commonSqliteImportButton),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    if (showDbSelect)
                      TextButton.icon(
                        onPressed: _isToggling
                            ? null
                            : () async {
                                await ContactsConnectionResolver
                                    .pickAndConnectDatabase(
                                  context: context,
                                  ref: ref,
                                );
                                await ref
                                    .read(contactsConnectionStatusProvider.notifier)
                                    .refresh();
                              },
                        icon: const Icon(Icons.storage_outlined, size: 16),
                        label: Text(l10n.commonSqliteSelectDatabaseButton),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                l10n.commonConnectionSqliteToggle,
                style: EgovText.caption.copyWith(
                  color: EgovColor.gray60,
                  fontSize: 11,
                ),
              ),
              Switch.adaptive(
                value: sqliteOn,
                onChanged: toggleEnabled ? _onSqliteToggleChanged : null,
                activeThumbColor: EgovColor.primary50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactsConnectionBar extends ConsumerWidget {
  const ContactsConnectionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statusAsync = ref.watch(contactsConnectionStatusProvider);
    final hint = l10n.connectionBarHint;

    final (title, color) = statusAsync.when(
      loading: () => (l10n.commonConnectionStatusChecking, EgovColor.gray40),
      error: (_, __) => (l10n.commonConnectionDisconnected, EgovColor.danger50),
      data: (snapshot) => switch (snapshot.activeSource) {
        ContactsDataSourceStatus.externalServer => (
            l10n.commonConnectionExternalServer,
            EgovColor.success50,
          ),
        ContactsDataSourceStatus.sqlite => (
            l10n.commonConnectionSqlite,
            EgovColor.primary50,
          ),
        ContactsDataSourceStatus.disconnected => (
            l10n.commonConnectionDisconnected,
            EgovColor.danger50,
          ),
      },
    );

    final detail = statusAsync.maybeWhen(
      data: (snapshot) => switch (snapshot.activeSource) {
        ContactsDataSourceStatus.sqlite => l10n.commonConnectionSqliteDetail(
            snapshot.statusDetail,
            ContactsSqliteSchema.tableName,
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
      sheetChild: const ContactsConnectionStatusCard(),
    );
  }
}
