import 'package:egovframe_mobile_deviceapi_app/config/ai_chat_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef AiChatSqliteSetupStatus = SqliteSetupStatus;

class AiChatSqliteService {
  final FeatureTableService _featureTable;

  AiChatSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => AiChatSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<AiChatSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<AiChatSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> uploadAiChatInfo(String fileName, AiChatInfo info) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;

    final sn = await _featureTable.nextMaxIntColumn(
      fileName,
      _schema,
      'sn',
      filterColumn: 'uuid',
      filterValue: info.uuid,
    );

    return _featureTable.insertRow(fileName, _schema, {
      'sn': sn,
      'uuid': info.uuid,
      'question': info.question,
      'answer': info.answer,
      'chatMode': info.chatMode,
      'modelNm': info.modelNm,
      'sessionId': info.sessionId,
      'useYn': info.useYn,
      'questionTimestamp': info.questionTimestamp,
      'answerTimestamp': info.answerTimestamp,
    });
  }

  Future<List<AiChatInfo>> getAiChatList(String fileName) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToAiChatInfo)
        .where((item) => item.useYn == 'Y')
        .toList()
      ..sort((a, b) => b.sn.compareTo(a.sn));
  }

  Future<bool> deleteAiChatInfo(
    String fileName,
    AiChatInfo info,
    String deviceUuid,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (info.sn <= 0 || deviceUuid.isEmpty || info.uuid != deviceUuid) {
      return false;
    }

    return _featureTable.deleteRow(fileName, _schema, {
      'sn': info.sn,
      'uuid': deviceUuid,
    });
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  AiChatInfo _rowToAiChatInfo(Map<String, Object?> row) {
    return AiChatInfo.fromJson({
      'sn': _readSn(row),
      'uuid': row['uuid'] ?? row['UUID'],
      'question': row['question'] ?? row['QUESTION'],
      'answer': row['answer'] ?? row['ANSWER'],
      'chatMode': row['chatMode'] ?? row['CHAT_MODE'],
      'modelNm': row['modelNm'] ?? row['MODEL_NM'],
      'sessionId': row['sessionId'] ?? row['SESSION_ID'],
      'useYn': row['useYn'] ?? row['useyn'] ?? row['USEYN'],
      'questionTimestamp':
          row['questionTimestamp'] ??
          row['QUESTION_TIMESTAMP'] ??
          row['timestamp'] ??
          row['TIMESTAMP'],
      'answerTimestamp':
          row['answerTimestamp'] ?? row['ANSWER_TIMESTAMP'],
    });
  }

  int _readSn(Map<String, Object?> row) {
    final raw = row['sn'] ?? row['SN'] ?? row['__rowid__'];
    if (raw is int) return raw;
    return int.tryParse('$raw') ?? 0;
  }
}
