import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_table_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view_model/sqlite_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SqliteTableDataPage extends ConsumerStatefulWidget {
  final String fileName;
  final String tableName;

  const SqliteTableDataPage({
    super.key,
    required this.fileName,
    required this.tableName,
  });

  @override
  ConsumerState<SqliteTableDataPage> createState() =>
      _SqliteTableDataPageState();
}

class _SqliteTableDataPageState extends ConsumerState<SqliteTableDataPage> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _disposeControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  Future<void> _showRowDialog({
    required List<String> columns,
    required Map<String, Object?>? initialRow,
    required Future<String?> Function(Map<String, Object?>) onSubmit,
    required String title,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    _disposeControllers();
    for (final column in columns) {
      final initial = initialRow?[column];
      _controllers[column] = TextEditingController(text: '${initial ?? ''}');
    }

    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: columns
                .map(
                  (column) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllers[column],
                      decoration: InputDecoration(
                        labelText: column,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
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

    if (submitted != true || !mounted) return;

    final values = <String, Object?>{};
    for (final column in columns) {
      final text = _controllers[column]!.text.trim();
      if (text.isNotEmpty) {
        values[column] = text;
      }
    }

    if (values.isEmpty) {
      showToast(
        context,
        message: l10n.sqliteInsertValueRequired,
        variant: ToastVariant.error,
      );
      return;
    }

    final error = await onSubmit(values);
    if (!mounted) return;

    if (error != null) {
      showToast(
        context,
        message: _mapError(l10n, error),
        variant: ToastVariant.error,
      );
    }
  }

  String _mapError(AppLocalizations l10n, String error) {
    return switch (error) {
      'update_failed' => l10n.sqliteUpdateFailed,
      'delete_failed' => l10n.sqliteDeleteFailed,
      _ => error,
    };
  }

  Future<void> _onInsert(List<String> columns) {
    final l10n = AppLocalizations.of(context)!;
    return _showRowDialog(
      columns: columns,
      initialRow: null,
      title: l10n.sqliteInsertRowTitle,
      onSubmit: (values) => ref
          .read(
            sqliteTableDataProvider(
              fileName: widget.fileName,
              tableName: widget.tableName,
            ).notifier,
          )
          .insertRow(values),
    );
  }

  Future<void> _onUpdate(List<String> columns, Map<String, Object?> row) {
    final l10n = AppLocalizations.of(context)!;
    return _showRowDialog(
      columns: columns,
      initialRow: row,
      title: l10n.sqliteUpdateRowTitle,
      onSubmit: (values) => ref
          .read(
            sqliteTableDataProvider(
              fileName: widget.fileName,
              tableName: widget.tableName,
            ).notifier,
          )
          .updateRow(values, row),
    );
  }

  Future<void> _onDelete(Map<String, Object?> row) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPromptDialog(
      context,
      title: l10n.sqliteDeleteRowTitle,
      message: l10n.sqliteDeleteRowMessage,
    );

    if (confirmed != true || !mounted) return;

    final error = await ref
        .read(
          sqliteTableDataProvider(
            fileName: widget.fileName,
            tableName: widget.tableName,
          ).notifier,
        )
        .deleteRow(row);
    if (!mounted) return;

    if (error != null) {
      showToast(
        context,
        message: _mapError(l10n, error),
        variant: ToastVariant.error,
      );
    }
  }

  void _showRowActions(List<String> columns, Map<String, Object?> row) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: EgovColor.white100,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.sqliteUpdateRowButton),
              onTap: () {
                Navigator.pop(context);
                _onUpdate(columns, row);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: EgovColor.point50,
              ),
              title: Text(
                l10n.sqliteDeleteRowButton,
                style: const TextStyle(color: EgovColor.point50),
              ),
              onTap: () {
                Navigator.pop(context);
                _onDelete(row);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(
      sqliteTableDataProvider(
        fileName: widget.fileName,
        tableName: widget.tableName,
      ),
    );
    final columns = state.displayColumns;

    return FeatureShell(
      title: widget.tableName,
      currentAppTargetPage: 'sqlite',
      popToApiMainCount: 2,
      guidePage: SqliteFunctionPage(databaseName: widget.fileName),
      mainFunctionBody: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : columns.isEmpty
          ? Center(
              child: Text(
                l10n.sqliteEmptyTableData,
                style: EgovText.regular.copyWith(color: EgovColor.gray40),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            EgovColor.primary5,
                          ),
                          columnSpacing: 24,
                          horizontalMargin: 16,
                          columns: columns
                              .map(
                                (column) => DataColumn(
                                  label: Text(
                                    column,
                                    style: EgovText.captionBold,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              )
                              .toList(),
                          rows: state.rows
                              .map(
                                (row) => DataRow(
                                  onLongPress: () =>
                                      _showRowActions(columns, row),
                                  cells: columns
                                      .map(
                                        (column) => DataCell(
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${row[column] ?? ''}',
                                              style: EgovText.bodySmall,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          onTap: () =>
                                              _showRowActions(columns, row),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    l10n.sqliteRowActionHint,
                    style: EgovText.caption.copyWith(color: EgovColor.gray40),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.sqliteSchemaButton,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SqliteTableSchemaPage(
                    fileName: widget.fileName,
                    tableName: widget.tableName,
                  ),
                ),
              );
            },
            normalColor: EgovColor.secondary50,
          ),
          CustomButton(
            text: l10n.sqliteInsertRowButton,
            onTap: columns.isEmpty ? null : () => _onInsert(columns),
          ),
        ],
      ),
    );
  }
}
