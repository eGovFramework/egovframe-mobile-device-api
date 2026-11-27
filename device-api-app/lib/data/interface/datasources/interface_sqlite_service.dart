import 'package:egovframe_mobile_deviceapi_app/config/interface_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/password_encryption.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef InterfaceSqliteSetupStatus = SqliteSetupStatus;

class InterfaceSqliteService {
  final FeatureTableService _featureTable;

  InterfaceSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => InterfaceSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<InterfaceSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<InterfaceSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  Future<Map<String, dynamic>> login(String fileName, String id, String password) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) {
      return {
        'success': false,
        'message': 'SQLite DB가 준비되지 않았습니다.',
      };
    }

    final row = await _findActiveAccount(fileName, id, password);
    if (row == null) {
      return {
        'success': true,
        'data': <String, dynamic>{'interfaceInfo': null},
      };
    }

    return {
      'success': true,
      'data': {
        'interfaceInfo': _rowToInterfaceInfoMap(row),
      },
    };
  }

  Future<Map<String, dynamic>> register(
    String fileName,
    String id,
    String password,
    String email,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) {
      return {
        'success': false,
        'message': 'SQLite DB가 준비되지 않았습니다.',
      };
    }

    final existing = await _findByUserId(fileName, id);
    if (existing != null) {
      return {
        'success': false,
        'message': '이미 존재하는 계정입니다.',
      };
    }

    final encryptedPassword = PasswordEncryption.hashPassword(password);
    final uuid = await DeviceUuidUtil.getDeviceUuid();

    final inserted = await _featureTable.insertRow(
      fileName,
      _schema,
      {
        'userId': id,
        'userPw': encryptedPassword,
        'emails': email,
        'uuid': uuid,
        'useYn': 'Y',
      },
    );

    if (!inserted) {
      return {
        'success': false,
        'message': '회원가입에 실패했습니다.',
      };
    }

    return {
      'success': true,
      'data': {
        'interfaceInfo': {
          'userId': id,
          'userPw': '',
          'emails': email,
          'uuid': uuid,
          'useYn': 'Y',
        },
      },
    };
  }

  Future<bool> checkAccountExists(
    String fileName,
    String id,
    String password,
    String email,
  ) async {
    final result = await login(fileName, id, password);
    if (result['success'] == true && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      return data['interfaceInfo'] != null;
    }
    return false;
  }

  Future<Map<String, dynamic>> getUserInfo(
    String fileName,
    String userId,
    String userPw,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) {
      return {
        'success': false,
        'message': 'SQLite DB가 준비되지 않았습니다.',
      };
    }

    final row = await _findActiveAccount(fileName, userId, userPw);
    if (row == null) {
      return {
        'success': false,
        'message': '인터페이스 정보를 찾을 수 없습니다.',
      };
    }

    final userInfo = UserInfo.fromJson(_rowToInterfaceInfoMap(row));
    return {
      'success': true,
      'data': userInfo.toJson(),
    };
  }

  Future<Map<String, dynamic>> withdraw(
    String fileName,
    String userId,
    String userPw,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) {
      return {
        'success': false,
        'message': 'SQLite DB가 준비되지 않았습니다.',
      };
    }

    final row = await _findActiveAccount(fileName, userId, userPw);
    if (row == null) {
      return {
        'success': false,
        'message': '계정을 찾을 수 없습니다.',
      };
    }

    final deactivated = await _featureTable.updateRow(
      fileName,
      _schema,
      {'useYn': 'N'},
      {'userId': userId},
    );

    if (!deactivated) {
      final deleted = await _featureTable.deleteRow(
        fileName,
        _schema,
        {'userId': userId},
      );
      if (!deleted) {
        return {
          'success': false,
          'message': '회원탈퇴에 실패했습니다.',
        };
      }
    }

    return {
      'success': true,
      'data': {'resultState': 'OK'},
    };
  }

  Future<Map<String, Object?>?> _findActiveAccount(
    String fileName,
    String userId,
    String password,
  ) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    for (final row in rows) {
      final id = '${row['userId'] ?? row['USERID'] ?? ''}';
      final pw = '${row['userPw'] ?? row['USERPW'] ?? ''}';
      final useYn = '${row['useYn'] ?? row['USEYN'] ?? 'Y'}';
      if (id == userId &&
          useYn.toUpperCase() != 'N' &&
          PasswordEncryption.matches(password, pw)) {
        return row;
      }
    }
    return null;
  }

  Future<Map<String, Object?>?> _findByUserId(String fileName, String userId) async {
    final rows = await _featureTable.queryRows(
      fileName,
      _schema,
      filterColumn: 'userId',
      filterValue: userId,
    );
    if (rows.isEmpty) {
      final all = await _featureTable.queryRows(fileName, _schema);
      for (final row in all) {
        final id = '${row['userId'] ?? row['USERID'] ?? ''}';
        if (id == userId) return row;
      }
      return null;
    }
    return rows.first;
  }

  Map<String, dynamic> _rowToInterfaceInfoMap(Map<String, Object?> row) {
    return {
      'userId': row['userId'] ?? row['USERID'] ?? '',
      'userPw': '',
      'emails': row['emails'] ?? row['EMAILS'] ?? '',
      'uuid': row['uuid'] ?? row['UUID'] ?? '',
      'deviceUuid': row['uuid'] ?? row['UUID'] ?? '',
      'useYn': row['useYn'] ?? row['USEYN'] ?? 'Y',
      'isActive': '${row['useYn'] ?? row['USEYN'] ?? 'Y'}'.toUpperCase() != 'N',
    };
  }
}
