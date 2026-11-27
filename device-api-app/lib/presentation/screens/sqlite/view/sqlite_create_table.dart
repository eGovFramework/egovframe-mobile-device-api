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

class SqliteCreateTablePage extends ConsumerStatefulWidget {
  final String fileName;

  const SqliteCreateTablePage({super.key, required this.fileName});

  @override
  ConsumerState<SqliteCreateTablePage> createState() =>
      _SqliteCreateTablePageState();
}

class _ColumnDraft {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController defaultController = TextEditingController();
  final TextEditingController fkColumnController = TextEditingController();
  SqliteColumnType type = SqliteColumnType.text;
  bool isPrimaryKey = false;
  bool notNull = false;
  bool autoIncrement = false;
  bool unique = false;
  String? fkTable;
  ForeignKeyAction onDelete = ForeignKeyAction.noAction;
  ForeignKeyAction onUpdate = ForeignKeyAction.noAction;

  void dispose() {
    nameController.dispose();
    defaultController.dispose();
    fkColumnController.dispose();
  }
}

class _IndexDraft {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController columnsController = TextEditingController();
  bool unique = false;

  void dispose() {
    nameController.dispose();
    columnsController.dispose();
  }
}

class _SqliteCreateTablePageState extends ConsumerState<SqliteCreateTablePage> {
  final _tableNameController = TextEditingController();
  final List<_ColumnDraft> _columns = [_ColumnDraft()];
  final List<_IndexDraft> _indexes = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _tableNameController.dispose();
    for (final column in _columns) {
      column.dispose();
    }
    for (final index in _indexes) {
      index.dispose();
    }
    super.dispose();
  }

  void _addColumn() => setState(() => _columns.add(_ColumnDraft()));

  void _removeColumn(int index) {
    if (_columns.length == 1) return;
    setState(() {
      _columns[index].dispose();
      _columns.removeAt(index);
    });
  }

  void _addIndex() => setState(() => _indexes.add(_IndexDraft()));

  void _removeIndex(int index) {
    setState(() {
      _indexes[index].dispose();
      _indexes.removeAt(index);
    });
  }

  List<ColumnDefinition>? _buildColumns() {
    final result = <ColumnDefinition>[];
    for (final draft in _columns) {
      final name = draft.nameController.text.trim();
      if (name.isEmpty) continue;
      result.add(
        ColumnDefinition(
          name: name,
          type: draft.type,
          isPrimaryKey: draft.isPrimaryKey,
          notNull: draft.notNull,
          autoIncrement: draft.autoIncrement,
          unique: draft.unique,
          defaultValue: draft.defaultController.text.trim().isEmpty
              ? null
              : draft.defaultController.text.trim(),
          foreignKeyTable: draft.fkTable,
          foreignKeyColumn: draft.fkColumnController.text.trim().isEmpty
              ? null
              : draft.fkColumnController.text.trim(),
          onDelete: draft.onDelete,
          onUpdate: draft.onUpdate,
        ),
      );
    }
    return result.isEmpty ? null : result;
  }

  List<IndexDefinition> _buildIndexes() {
    final result = <IndexDefinition>[];
    for (final draft in _indexes) {
      final name = draft.nameController.text.trim();
      final columns = draft.columnsController.text
          .split(',')
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toList();
      if (name.isEmpty || columns.isEmpty) continue;
      result.add(
        IndexDefinition(name: name, columns: columns, unique: draft.unique),
      );
    }
    return result;
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final tableName = _tableNameController.text.trim();
    if (tableName.isEmpty) {
      _showMessage(l10n.sqliteTableNameRequired);
      return;
    }

    final columns = _buildColumns();
    if (columns == null) {
      _showMessage(l10n.sqliteColumnRequired);
      return;
    }

    setState(() => _isSubmitting = true);
    final error = await ref
        .read(sqliteDatabaseDetailProvider(widget.fileName).notifier)
        .createTable(tableName, columns, indexes: _buildIndexes());
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      _showMessage(_mapError(l10n, error));
      return;
    }

    Navigator.pop(context, true);
  }

  String _mapError(AppLocalizations l10n, String error) {
    return switch (error) {
      'invalid_table_name' => l10n.sqliteInvalidTableName,
      'columns_required' => l10n.sqliteColumnRequired,
      _ => error,
    };
  }

  void _showMessage(String message) {
    showToast(context, message: message, variant: ToastVariant.error);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final existingTables = ref
        .watch(sqliteDatabaseDetailProvider(widget.fileName))
        .tables
        .map((table) => table.name)
        .toList();

    return FeatureShell(
      title: l10n.sqliteCreateTableTitle,
      currentAppTargetPage: 'sqlite',
      popToApiMainCount: 2,
      guidePage: SqliteFunctionPage(databaseName: widget.fileName),
      mainFunctionBody: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.sqliteTableNameLabel, style: EgovText.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _tableNameController,
            decoration: InputDecoration(
              hintText: l10n.sqliteTableNameHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.sqliteColumnsTitle, style: EgovText.subtitle),
              TextButton.icon(
                onPressed: _addColumn,
                icon: const Icon(Icons.add),
                label: Text(l10n.sqliteAddColumn),
              ),
            ],
          ),
          ...List.generate(
            _columns.length,
            (index) => _buildColumnCard(index, l10n, existingTables),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.sqliteIndexesTitle, style: EgovText.subtitle),
              TextButton.icon(
                onPressed: _addIndex,
                icon: const Icon(Icons.add),
                label: Text(l10n.sqliteAddIndex),
              ),
            ],
          ),
          ...List.generate(_indexes.length, (index) => _buildIndexCard(index, l10n)),
        ],
      ),
      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.sqliteCreateTableButton,
            isLoading: _isSubmitting,
            onTap: _isSubmitting ? null : _submit,
          ),
        ],
      ),
    );
  }

  Widget _buildColumnCard(
    int index,
    AppLocalizations l10n,
    List<String> existingTables,
  ) {
    final draft = _columns[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.sqliteColumnLabel} ${index + 1}',
                    style: EgovText.captionBold,
                  ),
                ),
                if (_columns.length > 1)
                  IconButton(
                    onPressed: () => _removeColumn(index),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: EgovColor.point50,
                    ),
                  ),
              ],
            ),
            TextField(
              controller: draft.nameController,
              decoration: InputDecoration(
                labelText: l10n.sqliteColumnNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<SqliteColumnType>(
              key: ValueKey(draft.type),
              initialValue: draft.type,
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
                if (value == null) return;
                setState(() => draft.type = value);
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: draft.defaultController,
              decoration: InputDecoration(
                labelText: l10n.sqliteDefaultValueLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.sqlitePrimaryKey),
              value: draft.isPrimaryKey,
              onChanged: (value) =>
                  setState(() => draft.isPrimaryKey = value ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.sqliteNotNull),
              value: draft.notNull,
              onChanged: draft.isPrimaryKey
                  ? null
                  : (value) => setState(() => draft.notNull = value ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.sqliteUnique),
              value: draft.unique,
              onChanged: draft.isPrimaryKey
                  ? null
                  : (value) => setState(() => draft.unique = value ?? false),
            ),
            if (draft.isPrimaryKey && draft.type == SqliteColumnType.integer)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.sqliteAutoIncrement),
                value: draft.autoIncrement,
                onChanged: (value) =>
                    setState(() => draft.autoIncrement = value ?? false),
              ),
            if (existingTables.isNotEmpty) ...[
              const Divider(),
              Text(l10n.sqliteForeignKeyTitle, style: EgovText.captionBold),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                key: ValueKey(draft.fkTable),
                initialValue: draft.fkTable,
                decoration: InputDecoration(
                  labelText: l10n.sqliteForeignKeyTableLabel,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.sqliteNoForeignKey),
                  ),
                  ...existingTables.map(
                    (table) =>
                        DropdownMenuItem(value: table, child: Text(table)),
                  ),
                ],
                onChanged: (value) => setState(() => draft.fkTable = value),
              ),
              if (draft.fkTable != null) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: draft.fkColumnController,
                  decoration: InputDecoration(
                    labelText: l10n.sqliteForeignKeyColumnLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ForeignKeyAction>(
                  key: ValueKey('onDelete-${draft.onDelete}'),
                  initialValue: draft.onDelete,
                  decoration: InputDecoration(
                    labelText: l10n.sqliteOnDeleteLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: ForeignKeyAction.values
                      .map(
                        (action) => DropdownMenuItem(
                          value: action,
                          child: Text(action.sql),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => draft.onDelete = value);
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ForeignKeyAction>(
                  key: ValueKey('onUpdate-${draft.onUpdate}'),
                  initialValue: draft.onUpdate,
                  decoration: InputDecoration(
                    labelText: l10n.sqliteOnUpdateLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: ForeignKeyAction.values
                      .map(
                        (action) => DropdownMenuItem(
                          value: action,
                          child: Text(action.sql),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => draft.onUpdate = value);
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndexCard(int index, AppLocalizations l10n) {
    final draft = _indexes[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.sqliteIndexLabel} ${index + 1}',
                    style: EgovText.captionBold,
                  ),
                ),
                IconButton(
                  onPressed: () => _removeIndex(index),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: EgovColor.point50,
                  ),
                ),
              ],
            ),
            TextField(
              controller: draft.nameController,
              decoration: InputDecoration(
                labelText: l10n.sqliteIndexNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: draft.columnsController,
              decoration: InputDecoration(
                labelText: l10n.sqliteIndexColumnsLabel,
                hintText: l10n.sqliteIndexColumnsHint,
                border: const OutlineInputBorder(),
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.sqliteUniqueIndex),
              value: draft.unique,
              onChanged: (value) =>
                  setState(() => draft.unique = value ?? false),
            ),
          ],
        ),
      ),
    );
  }
}
