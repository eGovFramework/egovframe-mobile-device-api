import 'package:egovframe_mobile_deviceapi_app/config/device_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/datasources/device_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';
import 'package:egovframe_mobile_deviceapi_app/di/device_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/sqlite_file_validator.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/sqlite_import_error_mapper.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceConnectionResolver {
  static final DeviceServerConnectionService _networkService =
      DeviceServerConnectionService();

  static Future<bool> checkServerConnection({
    required BuildContext context,
    bool showErrorToast = true,
  }) async {
    try {
      final result = await _networkService.checkServerConnection();
      if (result == ServerConnectionResult.connected) {
        return true;
      }
      if (showErrorToast && context.mounted) {
        _showServerConnectionErrorToast(context, result);
      }
      return false;
    } catch (e) {
      appLog('Device server check failed: $e');
      if (showErrorToast && context.mounted) {
        _showServerConnectionErrorToast(
          context,
          ServerConnectionResult.serverUnreachable,
        );
      }
      return false;
    }
  }

  static Future<bool> resolveConnection({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final connection = ref.read(deviceConnectionProvider);
    if (connection.isSqlite) {
      return _validateCurrentSqlite(context, ref);
    }
    return checkServerConnection(context: context);
  }

  static Future<bool> enableSqliteToggle({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final sqliteService = ref.read(deviceSqliteServiceProvider);
    final matchedDatabases = await sqliteService.findDatabasesWithFeatureTable();

    if (!context.mounted) return false;

    if (matchedDatabases.isEmpty) {
      final setupStatus = await sqliteService.validateAnyDatabase();
      if (!context.mounted) return false;
      await _showSqliteSetupGuide(context, ref, setupStatus);
      return false;
    }
    final selectedDb = matchedDatabases.length == 1
        ? matchedDatabases.first
        : await _pickDatabase(context, matchedDatabases);

    if (selectedDb == null || !context.mounted) {
      return false;
    }

    ref.read(deviceConnectionProvider.notifier).useSqlite(selectedDb);

    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      showStatusToast(
        context,
        variant: StatusVariant.success,
        title: l10n.commonSqliteConnectedTitle,
        message: l10n.commonSqliteConnectedMessage(selectedDb),
      );
    }

    return true;
  }

  static Future<bool> _validateCurrentSqlite(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final connection = ref.read(deviceConnectionProvider);
    final dbFileName = connection.sqliteDbFileName;
    if (dbFileName == null) return false;

    final status =
        await ref.read(deviceSqliteServiceProvider).validateSetup(dbFileName);
    if (status == SqliteSetupStatus.ready) {
      return true;
    }

    if (!context.mounted) return false;
    ref.read(deviceConnectionProvider.notifier).useServer();
    await _showSqliteSetupGuide(context, ref, status);
    return false;
  }

  static Future<void> _showSqliteSetupGuide(
    BuildContext context,
    WidgetRef ref,
    SqliteSetupStatus status,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final message = switch (status) {
      SqliteSetupStatus.noDatabase => l10n.commonSqliteSetupNoDatabase(DeviceSqliteSchema.tableName),
      SqliteSetupStatus.noFeatureTable => l10n.commonSqliteSetupNoTable(
          DeviceSqliteSchema.tableName,
        ),
      SqliteSetupStatus.ready => l10n.commonSqliteSetupNoDatabase(DeviceSqliteSchema.tableName),
    };

    final importDb = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.commonSqliteSetupTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonClose),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.commonSqliteImportButton),
          ),
        ],
      ),
    );

    if (importDb == true && context.mounted) {
      await importDatabaseFile(context, ref);
    }
  }

  static Future<void> importDatabaseFile(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    FilePickerResult? pickerResult;

    try {
      pickerResult = await FilePicker.pickFiles(type: FileType.any);
    } on PlatformException catch (e) {
      appLog('DB import file picker failed: $e');
      if (!context.mounted) return;
      showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.commonSqliteImportFileNotFound,
      );
      return;
    }

    if (pickerResult == null || pickerResult.files.isEmpty || !context.mounted) {
      return;
    }

    final picked = pickerResult.files.single;
    final pickedPath = picked.path;
    if (pickedPath == null) {
      if (!context.mounted) return;
      showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.commonSqliteImportFileNotFound,
      );
      return;
    }

    if (!await SqliteFileValidator.isValidImportFile(
      pickedPath,
      displayName: picked.name,
    )) {
      if (!context.mounted) return;
      showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.commonSqliteInvalidImportFileType,
      );
      return;
    }

    if (!context.mounted) return;

    final nameController = TextEditingController(
      text: picked.name.replaceAll(RegExp(r'\.(db|sqlite|sqlite3)$'), ''),
    );

    final targetName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.commonSqliteImportTitle),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n.commonSqliteImportNameLabel,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonClose),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              dialogContext,
              nameController.text.trim(),
            ),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );

    if (targetName == null || targetName.isEmpty || !context.mounted) return;

    try {
      await ref
          .read(deviceSqliteServiceProvider)
          .importDatabase(pickedPath, targetName);

      if (!context.mounted) return;

      final fileName =
          targetName.endsWith('.db') ? targetName : '$targetName.db';
      final hasTable = await ref
          .read(deviceSqliteServiceProvider)
          .hasFeatureTable(fileName);

      if (!context.mounted) return;

      if (hasTable) {
        ref.read(deviceConnectionProvider.notifier).useSqlite(fileName);
        showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSqliteConnectedTitle,
          message: l10n.commonSqliteConnectedMessage(fileName),
        );
      } else {
        showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: l10n.commonSqliteSetupNoTable(DeviceSqliteSchema.tableName),
        );
      }
    } on ArgumentError catch (e) {
      if (!context.mounted) return;
      showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: mapSqliteImportError(l10n, e),
      );
    } on StateError catch (e) {
      if (!context.mounted) return;
      showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: mapSqliteImportError(l10n, e),
      );
    } catch (e) {
      if (!context.mounted) return;
      showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: mapSqliteImportError(l10n, e),
      );
    }
  }

  static Future<bool> pickAndConnectDatabase({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final sqliteService = ref.read(deviceSqliteServiceProvider);
    final matchedDatabases = await sqliteService.findDatabasesWithFeatureTable();
    if (!context.mounted) return false;
    if (matchedDatabases.isEmpty) return false;

    final selectedDb = matchedDatabases.length == 1
        ? matchedDatabases.first
        : await _pickDatabase(context, matchedDatabases);

    if (selectedDb == null || !context.mounted) return false;

    ref.read(deviceConnectionProvider.notifier).useSqlite(selectedDb);

    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      showStatusToast(
        context,
        variant: StatusVariant.success,
        title: l10n.commonSqliteConnectedTitle,
        message: l10n.commonSqliteConnectedMessage(selectedDb),
      );
    }
    return true;
  }

  static Future<String?> _pickDatabase(
    BuildContext context,
    List<String> databases,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(l10n.commonSqlitePickDatabaseTitle),
        children: databases
            .map(
              (fileName) => SimpleDialogOption(
                onPressed: () => Navigator.pop(dialogContext, fileName),
                child: Text(fileName),
              ),
            )
            .toList(),
      ),
    );
  }

  static void _showServerConnectionErrorToast(
    BuildContext context,
    ServerConnectionResult result,
  ) {
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final message = switch (result) {
      ServerConnectionResult.serverDbError => l10n.serverDbErrorMessage,
      ServerConnectionResult.networkUnavailable =>
        l10n.serverNetworkUnavailableMessage,
      ServerConnectionResult.connected => l10n.serverConnectionErrorMessage,
      ServerConnectionResult.serverUnreachable =>
        l10n.serverConnectionErrorMessage,
    };
    showStatusToast(
      context,
      variant: StatusVariant.error,
      title: l10n.serverConnectionErrorTitle,
      message: message,
    );
  }
}
