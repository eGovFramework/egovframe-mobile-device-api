import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_database_detail.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view_model/sqlite_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/sqlite_file_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class SqliteMainPage extends ConsumerStatefulWidget {
  const SqliteMainPage({super.key});

  @override
  ConsumerState<SqliteMainPage> createState() => _SqliteMainPageState();
}

class _SqliteMainPageState extends ConsumerState<SqliteMainPage> {
  final _dbNameController = TextEditingController();
  final _importNameController = TextEditingController();
  final _versionController = TextEditingController(text: '1');

  @override
  void dispose() {
    _dbNameController.dispose();
    _importNameController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  SqliteMain get _notifier => ref.read(sqliteMainProvider.notifier);

  Future<void> _showCreateDatabaseDialog() async {
    final l10n = AppLocalizations.of(context)!;
    _dbNameController.clear();
    _versionController.text = '1';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sqliteCreateDatabaseTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _dbNameController,
              decoration: InputDecoration(
                labelText: l10n.sqliteDatabaseNameLabel,
                hintText: l10n.sqliteDatabaseNameHint,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _versionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.sqliteInitialVersionLabel,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final name = _dbNameController.text.trim();
    if (name.isEmpty) {
      _showMessage(l10n.sqliteDatabaseNameRequired, ToastVariant.error);
      return;
    }

    final version = int.tryParse(_versionController.text.trim()) ?? 1;
    final error = await _notifier.createDatabase(name, version: version);
    if (!mounted) return;

    if (error != null) {
      _showMessage(_mapCreateError(l10n, error), ToastVariant.error);
    } else {
      _showMessage(l10n.sqliteCreateDatabaseSuccess, ToastVariant.success);
    }
  }

  Future<void> _importDatabase() async {
    final l10n = AppLocalizations.of(context)!;
    FilePickerResult? result;

    try {
      result = await FilePicker.pickFiles(type: FileType.any);
    } on PlatformException {
      if (!mounted) return;
      _showMessage(l10n.commonSqliteImportFileNotFound, ToastVariant.error);
      return;
    }

    if (result == null || result.files.isEmpty || !mounted) return;

    final pickedFile = result.files.single;
    final pickedPath = pickedFile.path;
    if (pickedPath == null) {
      _showMessage(l10n.commonSqliteImportFileNotFound, ToastVariant.error);
      return;
    }

    if (!await SqliteFileValidator.isValidImportFile(
      pickedPath,
      displayName: pickedFile.name,
    )) {
      if (!mounted) return;
      _showMessage(l10n.commonSqliteInvalidImportFileType, ToastVariant.error);
      return;
    }

    if (!mounted) return;

    _importNameController.text = pickedFile.name.replaceAll(
      RegExp(r'\.(db|sqlite|sqlite3)$', caseSensitive: false),
      '',
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commonSqliteImportButton),
        content: TextField(
          controller: _importNameController,
          decoration: InputDecoration(
            labelText: l10n.sqliteDatabaseNameLabel,
            hintText: l10n.sqliteDatabaseNameHint,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final name = _importNameController.text.trim();
    if (name.isEmpty) {
      _showMessage(l10n.sqliteDatabaseNameRequired, ToastVariant.error);
      return;
    }

    final error = await _notifier.importDatabase(pickedPath, name);
    if (!mounted) return;

    if (error != null) {
      _showMessage(_mapCreateError(l10n, error), ToastVariant.error);
    } else {
      _showMessage(l10n.sqliteImportDatabaseSuccess, ToastVariant.success);
    }
  }

  Future<void> _exportToDownloads(String fileName) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _notifier.exportDatabase(fileName);
    if (!mounted) return;

    if (result == null) {
      _showMessage(l10n.sqliteExportFailed, ToastVariant.error);
      return;
    }

    final (message, variant) = switch (result) {
      'database_not_found' => (l10n.sqliteExportFailed, ToastVariant.error),
      'downloads_unavailable' => (
        l10n.sqliteDownloadsUnavailable,
        ToastVariant.error,
      ),
      _ => (l10n.sqliteExportSuccess(result), ToastVariant.success),
    };
    _showMessage(message, variant);
  }

  Future<void> _shareDatabase(String fileName) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _notifier.prepareDatabaseShare(fileName);
    if (!mounted) return;

    if (result == null || result == 'database_not_found') {
      _showMessage(l10n.sqliteShareFailed, ToastVariant.error);
      return;
    }

    if (!await File(result).exists()) {
      _showMessage(l10n.sqliteShareFailed, ToastVariant.error);
      return;
    }

    try {
      final baseName = result.replaceAll('\\', '/').split('/').last;
      await Share.shareXFiles(
        [
          XFile(
            result,
            name: baseName,
            mimeType: 'application/octet-stream',
          ),
        ],
        subject: fileName.replaceAll('.db', ''),
        text: baseName,
      );
    } on MissingPluginException {
      _showMessage(l10n.sqliteShareRequiresRestart, ToastVariant.error);
    }
  }

  String _mapCreateError(AppLocalizations l10n, String error) {
    return switch (error) {
      'invalid_database_name' => l10n.commonSqliteInvalidDatabaseName,
      'database_already_exists' => l10n.commonSqliteDatabaseAlreadyExists,
      'import_file_not_found' => l10n.commonSqliteImportFileNotFound,
      _ => error,
    };
  }

  Future<void> _confirmDelete(String fileName) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPromptDialog(
      context,
      title: l10n.sqliteDeleteDatabaseTitle,
      message: l10n.sqliteDeleteDatabaseMessage(fileName),
    );

    if (confirmed != true || !mounted) return;

    final error = await _notifier.deleteDatabase(fileName);
    if (!mounted) return;

    if (error != null) {
      _showMessage(error, ToastVariant.error);
    } else {
      _showMessage(l10n.sqliteDeleteDatabaseSuccess, ToastVariant.success);
    }
  }

  void _showMessage(String message, ToastVariant variant) {
    showToast(context, message: message, variant: variant);
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(sqliteMainProvider);

    return FeatureShell(
      title: l10n.sqliteAppTitle,
      currentAppTargetPage: 'sqlite',
      guidePage: const SqliteFunctionPage(),
      mainFunctionBody: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _notifier.loadDatabases,
              color: EgovColor.primary50,
              child: state.databases.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.35,
                          child: Center(
                            child: Text(
                              l10n.sqliteEmptyDatabaseList,
                              style: EgovText.regular.copyWith(
                                color: EgovColor.gray40,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: state.databases.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final database = state.databases[index];
                        return _DatabaseCard(
                          database: database,
                          sizeLabel: _formatSize(database.sizeBytes),
                          modifiedLabel: l10n.sqliteModifiedAt(
                            database.modifiedAt.toLocal().toString().substring(
                              0,
                              16,
                            ),
                          ),
                          exportLabel: l10n.sqliteExportDatabase,
                          shareLabel: l10n.sqliteShareDatabase,
                          deleteLabel: l10n.sqliteDeleteDatabase,
                          onOpen: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SqliteDatabaseDetailPage(
                                  fileName: database.fileName,
                                ),
                              ),
                            );
                          },
                          onExport: () => _exportToDownloads(database.fileName),
                          onShare: () => _shareDatabase(database.fileName),
                          onDelete: () => _confirmDelete(database.fileName),
                        );
                      },
                    ),
            ),
      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.commonSqliteImportButton,
            onTap: _importDatabase,
            normalColor: EgovColor.secondary50,
          ),
          CustomButton(
            text: l10n.sqliteCreateDatabaseButton,
            onTap: _showCreateDatabaseDialog,
          ),
        ],
      ),
    );
  }
}

class _DatabaseCard extends StatelessWidget {
  final DatabaseInfo database;
  final String sizeLabel;
  final String modifiedLabel;
  final String exportLabel;
  final String shareLabel;
  final String deleteLabel;
  final VoidCallback onOpen;
  final VoidCallback onExport;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const _DatabaseCard({
    required this.database,
    required this.sizeLabel,
    required this.modifiedLabel,
    required this.exportLabel,
    required this.shareLabel,
    required this.deleteLabel,
    required this.onOpen,
    required this.onExport,
    required this.onShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EgovColor.white100,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: EgovColor.gray20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: EgovColor.primary5,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.storage,
                  color: EgovColor.primary50,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      database.displayName,
                      style: EgovText.medium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: EgovColor.gray90,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$sizeLabel · v${database.version}',
                      style: EgovText.caption,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      modifiedLabel,
                      style: EgovText.caption,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'export':
                      onExport();
                    case 'share':
                      onShare();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'export', child: Text(exportLabel)),
                  PopupMenuItem(value: 'share', child: Text(shareLabel)),
                  PopupMenuItem(value: 'delete', child: Text(deleteLabel)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
