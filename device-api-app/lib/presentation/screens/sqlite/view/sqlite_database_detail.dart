import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_create_table.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_table_data.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_table_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view_model/sqlite_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SqliteDatabaseDetailPage extends ConsumerWidget {
  final String fileName;

  const SqliteDatabaseDetailPage({super.key, required this.fileName});

  Future<void> _openCreateTable(BuildContext context, WidgetRef ref) async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => SqliteCreateTablePage(fileName: fileName),
      ),
    );
    if (created == true) {
      await ref
          .read(sqliteDatabaseDetailProvider(fileName).notifier)
          .loadTables();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(sqliteDatabaseDetailProvider(fileName));

    return FeatureShell(
      title: state.fileName.replaceAll('.db', ''),
      currentAppTargetPage: 'sqlite',
      popToApiMainCount: 1,
      guidePage: SqliteFunctionPage(databaseName: fileName),
      mainFunctionBody: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref
                  .read(sqliteDatabaseDetailProvider(fileName).notifier)
                  .loadDetail(),
              color: EgovColor.primary50,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  if (state.tables.isEmpty)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.35,
                      child: Center(
                        child: Text(
                          l10n.sqliteEmptyTableList,
                          style: EgovText.regular.copyWith(
                            color: EgovColor.gray40,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...state.tables.map(
                      (table) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: EgovColor.white100,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: EgovColor.gray20),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SqliteTableDataPage(
                                    fileName: fileName,
                                    tableName: table.name,
                                  ),
                                ),
                              );
                            },
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
                                      Icons.table_chart_outlined,
                                      color: EgovColor.primary50,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          table.name,
                                          style: EgovText.medium.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: EgovColor.gray90,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          l10n.sqliteRowCount(table.rowCount),
                                          style: EgovText.caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      switch (value) {
                                        case 'data':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SqliteTableDataPage(
                                                    fileName: fileName,
                                                    tableName: table.name,
                                                  ),
                                            ),
                                          );
                                        case 'schema':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SqliteTableSchemaPage(
                                                    fileName: fileName,
                                                    tableName: table.name,
                                                  ),
                                            ),
                                          );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'data',
                                        child: Text(l10n.sqliteViewData),
                                      ),
                                      PopupMenuItem(
                                        value: 'schema',
                                        child: Text(l10n.sqliteViewSchema),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.sqliteCreateTableButton,
            onTap: () => _openCreateTable(context, ref),
          ),
        ],
      ),
    );
  }
}
