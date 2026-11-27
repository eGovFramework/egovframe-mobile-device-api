import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view_model/sqlite_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SqliteTableSchemaPage extends ConsumerStatefulWidget {
  final String fileName;
  final String tableName;

  const SqliteTableSchemaPage({
    super.key,
    required this.fileName,
    required this.tableName,
  });

  @override
  ConsumerState<SqliteTableSchemaPage> createState() =>
      _SqliteTableSchemaPageState();
}

class _SqliteTableSchemaPageState extends ConsumerState<SqliteTableSchemaPage> {
  final _nameController = TextEditingController();
  SqliteColumnType _type = SqliteColumnType.text;
  bool _notNull = false;
  bool _unique = false;
  final _defaultController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _defaultController.dispose();
    super.dispose();
  }

  Future<void> _showAddColumnSheet() async {
    final l10n = AppLocalizations.of(context)!;
    _nameController.clear();
    _defaultController.clear();
    setState(() {
      _type = SqliteColumnType.text;
      _notNull = false;
      _unique = false;
    });

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: EgovColor.white100,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, sheetSetState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.sqliteAddColumnTitle, style: EgovText.title),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.sqliteColumnNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<SqliteColumnType>(
                  key: ValueKey(_type),
                  initialValue: _type,
                  decoration: InputDecoration(
                    labelText: l10n.sqliteColumnTypeLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: SqliteColumnType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.sqlName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      sheetSetState(() => _type = value);
                    }
                  },
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(l10n.sqliteNotNull),
                  value: _notNull,
                  activeColor: EgovColor.primary50,
                  checkColor: EgovColor.white100,
                  onChanged: (value) =>
                      sheetSetState(() => _notNull = value ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(l10n.sqliteUnique),
                  value: _unique,
                  activeColor: EgovColor.primary50,
                  checkColor: EgovColor.white100,
                  onChanged: (value) =>
                      sheetSetState(() => _unique = value ?? false),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _defaultController,
                  decoration: InputDecoration(
                    labelText: l10n.sqliteDefaultValueLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: l10n.sqliteAddColumnButton,
                  isLoading: _isSubmitting,
                  onTap: _isSubmitting ? null : _submitAddColumn,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitAddColumn() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage(l10n.sqliteColumnNameRequired);
      return;
    }

    setState(() => _isSubmitting = true);
    final error = await ref
        .read(
          sqliteTableSchemaProvider(
            fileName: widget.fileName,
            tableName: widget.tableName,
          ).notifier,
        )
        .addColumn(
          ColumnDefinition(
            name: name,
            type: _type,
            notNull: _notNull,
            unique: _unique,
            defaultValue: _defaultController.text.trim().isEmpty
                ? null
                : _defaultController.text.trim(),
          ),
        );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      _showMessage(_mapError(l10n, error));
      return;
    }

    Navigator.pop(context);
  }

  String _mapError(AppLocalizations l10n, String error) {
    return switch (error) {
      'invalid_column_name' => l10n.sqliteInvalidColumnName,
      _ => error,
    };
  }

  void _showMessage(String message) {
    showToast(context, message: message, variant: ToastVariant.error);
  }

  Widget _buildColumnTile(ColumnInfo column) {
    final badges = <String>[
      column.type.sqlName,
      if (column.isPrimaryKey) 'PK',
      if (column.notNull) 'NOT NULL',
      if (column.defaultValue != null) 'DEFAULT',
    ];
    return Material(
      color: EgovColor.white100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: EgovColor.gray20),
      ),
      child: ListTile(
        title: Text(column.name, style: EgovText.medium),
        subtitle: Text(badges.join(' · '), style: EgovText.caption),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(
      sqliteTableSchemaProvider(
        fileName: widget.fileName,
        tableName: widget.tableName,
      ),
    );

    return FeatureShell(
      title: l10n.sqliteSchemaTitle(widget.tableName),
      currentAppTargetPage: 'sqlite',
      popToApiMainCount: 2,
      guidePage: SqliteFunctionPage(databaseName: widget.fileName),
      mainFunctionBody: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.schema == null
          ? Center(
              child: Text(
                state.errorMessage ?? l10n.sqliteEmptyTableData,
                style: EgovText.regular.copyWith(color: EgovColor.gray40),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(l10n.sqliteColumnsTitle, style: EgovText.subtitle),
                const SizedBox(height: 8),
                ...state.schema!.columns.map(
                  (column) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildColumnTile(column),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.sqliteIndexesTitle, style: EgovText.subtitle),
                const SizedBox(height: 8),
                if (state.schema!.indexes.isEmpty)
                  Text(
                    l10n.sqliteEmptyIndexes,
                    style: EgovText.caption.copyWith(color: EgovColor.gray40),
                  )
                else
                  ...state.schema!.indexes.map(
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: EgovColor.white100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: EgovColor.gray20),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.speed,
                            color: EgovColor.primary50,
                          ),
                          title: Text(index, style: EgovText.medium),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      bottomBar: state.schema == null
          ? null
          : BottomButtonRow(
              buttons: [
                CustomButton(
                  text: l10n.sqliteAddColumnButton,
                  onTap: _showAddColumnSheet,
                ),
              ],
            ),
    );
  }
}
