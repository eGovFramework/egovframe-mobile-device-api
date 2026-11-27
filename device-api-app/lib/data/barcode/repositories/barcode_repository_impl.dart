import 'package:egovframe_mobile_deviceapi_app/data/barcode/repositories/barcode_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/barcode/repositories/barcode_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/repositories/barcode_repository.dart';

class BarcodeRepositoryImpl implements BarcodeRepository {
  final BarcodeRemoteRepositoryImpl _remote;
  final BarcodeSqliteRepositoryImpl _sqlite;
  final BarcodeConnectionReader _readConnection;

  BarcodeRepositoryImpl({
    required BarcodeRemoteRepositoryImpl remote,
    required BarcodeSqliteRepositoryImpl sqlite,
    required BarcodeConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  BarcodeRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<bool> uploadBarcodeInfo(BarcodeInfo info) =>
      _active.uploadBarcodeInfo(info);

  @override
  Future<List<BarcodeInfo>> getBarcodeList(String deviceUuid) =>
      _active.getBarcodeList(deviceUuid);

  @override
  Future<bool> deleteBarcodeInfo(BarcodeInfo info, String deviceUuid) =>
      _active.deleteBarcodeInfo(info, deviceUuid);
}
