import 'package:egovframe_mobile_deviceapi_app/data/barcode/datasources/barcode_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/repositories/barcode_repository.dart';

typedef BarcodeConnectionReader = BarcodeConnectionState Function();

class BarcodeSqliteRepositoryImpl implements BarcodeRepository {
  final BarcodeSqliteService _service;
  final BarcodeConnectionReader _readConnection;

  BarcodeSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<bool> uploadBarcodeInfo(BarcodeInfo info) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.uploadBarcodeInfo(dbFileName, info);
  }

  @override
  Future<List<BarcodeInfo>> getBarcodeList(String deviceUuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getBarcodeList(dbFileName, deviceUuid);
  }

  @override
  Future<bool> deleteBarcodeInfo(
    BarcodeInfo info,
    String deviceUuid,
  ) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteBarcodeInfo(dbFileName, info, deviceUuid);
  }
}
