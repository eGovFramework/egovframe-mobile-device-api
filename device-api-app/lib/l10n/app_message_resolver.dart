import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/device_info_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/accelerator_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_opener_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_readwrite_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/gps_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_mgmt_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/interface_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/media_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/network_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/barcode_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/compass_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/contacts_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/push_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/socket_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/streaming_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/face_mesh_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/iot_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/ai_chat_message_keys.dart';

String resolveAppMessage(AppLocalizations l10n, String message) {
  if (message.startsWith(DeviceInfoMessageKeys.loadFailedPrefix)) {
    final error = message.substring(
      DeviceInfoMessageKeys.loadFailedPrefix.length,
    );
    return l10n.deviceInfoLoadFailed(error);
  }
  if (message.startsWith(DeviceInfoMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(
      DeviceInfoMessageKeys.uploadErrorPrefix.length,
    );
    return l10n.deviceInfoUploadError(error);
  }
  if (message.startsWith(DeviceInfoMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(
      DeviceInfoMessageKeys.listLoadErrorPrefix.length,
    );
    return l10n.deviceInfoListLoadError(error);
  }
  if (message.startsWith(DeviceInfoMessageKeys.genericErrorPrefix)) {
    final error = message.substring(
      DeviceInfoMessageKeys.genericErrorPrefix.length,
    );
    return l10n.deviceInfoGenericError(error);
  }

  if (message.startsWith(AcceleratorMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(
      AcceleratorMessageKeys.listLoadErrorPrefix.length,
    );
    return l10n.acceleratorListLoadError(error);
  }
  if (message.startsWith(AcceleratorMessageKeys.genericErrorPrefix)) {
    final error = message.substring(
      AcceleratorMessageKeys.genericErrorPrefix.length,
    );
    return l10n.acceleratorGenericError(error);
  }

  if (message.startsWith(NetworkMessageKeys.sendErrorPrefix)) {
    final error = message.substring(NetworkMessageKeys.sendErrorPrefix.length);
    return l10n.networkSendError(error);
  }
  if (message.startsWith(NetworkMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(
      NetworkMessageKeys.listLoadErrorPrefix.length,
    );
    return l10n.networkListLoadError(error);
  }
  if (message.startsWith(NetworkMessageKeys.deleteErrorPrefix)) {
    final error = message.substring(
      NetworkMessageKeys.deleteErrorPrefix.length,
    );
    return l10n.networkDeleteError(error);
  }

  if (message.startsWith(GpsMessageKeys.initErrorPrefix)) {
    final error = message.substring(GpsMessageKeys.initErrorPrefix.length);
    return l10n.gpsInitError(error);
  }
  if (message.startsWith(GpsMessageKeys.fetchFailedPrefix)) {
    final error = message.substring(GpsMessageKeys.fetchFailedPrefix.length);
    return l10n.gpsFetchFailed(error);
  }
  if (message.startsWith(GpsMessageKeys.saveErrorPrefix)) {
    final error = message.substring(GpsMessageKeys.saveErrorPrefix.length);
    return l10n.gpsSaveError(error);
  }
  if (message.startsWith(GpsMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(GpsMessageKeys.listLoadErrorPrefix.length);
    return l10n.gpsListLoadError(error);
  }
  if (message.startsWith(GpsMessageKeys.genericErrorPrefix)) {
    final error = message.substring(GpsMessageKeys.genericErrorPrefix.length);
    return l10n.gpsGenericError(error);
  }
  if (message.startsWith(MediaMessageKeys.permissionCheckErrorPrefix)) {
    final payload = message.substring(
      MediaMessageKeys.permissionCheckErrorPrefix.length,
    );
    final parts = payload.split('|');
    if (parts.length >= 2) {
      return l10n.mediaPermissionCheckError(
        parts.first,
        parts.sublist(1).join('|'),
      );
    }
  }
  if (message.startsWith(MediaMessageKeys.permissionGrantedPrefix)) {
    final label = message.substring(
      MediaMessageKeys.permissionGrantedPrefix.length,
    );
    return l10n.mediaPermissionGranted(label);
  }
  if (message.startsWith(MediaMessageKeys.permissionUnknownPrefix)) {
    final label = message.substring(
      MediaMessageKeys.permissionUnknownPrefix.length,
    );
    return l10n.mediaPermissionUnknown(label);
  }
  if (message.startsWith(MediaMessageKeys.localListFailedPrefix)) {
    final error = message.substring(
      MediaMessageKeys.localListFailedPrefix.length,
    );
    return l10n.mediaLocalListFailed(error);
  }
  if (message.startsWith(MediaMessageKeys.uploadSummaryPrefix)) {
    final payload = message.substring(
      MediaMessageKeys.uploadSummaryPrefix.length,
    );
    final parts = payload.split('|');
    return l10n.mediaUploadSummary(
      (int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0).toString(),
      (int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0).toString(),
    );
  }
  if (message.startsWith(MediaMessageKeys.deleteSummaryPrefix)) {
    final payload = message.substring(
      MediaMessageKeys.deleteSummaryPrefix.length,
    );
    final parts = payload.split('|');
    return l10n.mediaDeleteSummary(
      (int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0).toString(),
      (int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0).toString(),
    );
  }
  if (message.startsWith(MediaMessageKeys.imageSavedPrefix)) {
    return l10n.mediaImageSaved;
  }
  if (message.startsWith(MediaMessageKeys.videoSavedPrefix)) {
    return l10n.mediaVideoSaved;
  }
  if (message.startsWith(MediaMessageKeys.imagePickErrorPrefix)) {
    final error = message.substring(
      MediaMessageKeys.imagePickErrorPrefix.length,
    );
    return l10n.mediaImagePickError(error);
  }
  if (message.startsWith(MediaMessageKeys.videoPickErrorPrefix)) {
    final error = message.substring(
      MediaMessageKeys.videoPickErrorPrefix.length,
    );
    return l10n.mediaVideoPickError(error);
  }
  if (message.startsWith(MediaMessageKeys.imageSaveErrorPrefix)) {
    final error = message.substring(
      MediaMessageKeys.imageSaveErrorPrefix.length,
    );
    return l10n.mediaImageSaveError(error);
  }
  if (message.startsWith(MediaMessageKeys.videoSaveErrorPrefix)) {
    final error = message.substring(
      MediaMessageKeys.videoSaveErrorPrefix.length,
    );
    return l10n.mediaVideoSaveError(error);
  }
  if (message.startsWith(MediaMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(MediaMessageKeys.uploadErrorPrefix.length);
    return l10n.mediaUploadError(error);
  }
  if (message.startsWith(MediaMessageKeys.serverListFailedPrefix)) {
    final error = message.substring(
      MediaMessageKeys.serverListFailedPrefix.length,
    );
    return l10n.mediaServerListFailed(error);
  }
  if (message.startsWith(MediaMessageKeys.downloadFailedPrefix)) {
    final error = message.substring(
      MediaMessageKeys.downloadFailedPrefix.length,
    );
    return l10n.mediaDownloadFailedWithReason(error);
  }
  if (message.startsWith(MediaMessageKeys.serverDeleteFailedPrefix)) {
    final error = message.substring(
      MediaMessageKeys.serverDeleteFailedPrefix.length,
    );
    return l10n.mediaServerDeleteFailed(error);
  }
  if (message.startsWith(MediaMessageKeys.serverDeleteErrorPrefix)) {
    final error = message.substring(
      MediaMessageKeys.serverDeleteErrorPrefix.length,
    );
    return l10n.mediaServerDeleteError(error);
  }
  if (message.startsWith(MediaMessageKeys.downloadUrlErrorPrefix)) {
    final error = message.substring(
      MediaMessageKeys.downloadUrlErrorPrefix.length,
    );
    return l10n.mediaDownloadUrlError(error);
  }
  if (message.startsWith(FileReadWriteMessageKeys.listLoadingPrefix)) {
    return l10n.fileReadWriteListLoading;
  }
  if (message.startsWith(FileReadWriteMessageKeys.listUpdatedPrefix)) {
    final count =
        int.tryParse(
          message.substring(FileReadWriteMessageKeys.listUpdatedPrefix.length),
        ) ??
        0;
    return l10n.fileReadWriteListUpdated(count.toString());
  }
  if (message.startsWith(FileReadWriteMessageKeys.deletingSelectedPrefix)) {
    final count =
        int.tryParse(
          message.substring(
            FileReadWriteMessageKeys.deletingSelectedPrefix.length,
          ),
        ) ??
        0;
    return l10n.fileReadWriteDeletingSelected(count.toString());
  }
  if (message.startsWith(FileReadWriteMessageKeys.deleteSummaryPrefix)) {
    final payload = message.substring(
      FileReadWriteMessageKeys.deleteSummaryPrefix.length,
    );
    final parts = payload.split('|');
    return l10n.fileReadWriteDeleteSummary(
      (int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0).toString(),
      (int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0).toString(),
    );
  }
  if (message.startsWith(FileReadWriteMessageKeys.uploadingSelectedPrefix)) {
    final count =
        int.tryParse(
          message.substring(
            FileReadWriteMessageKeys.uploadingSelectedPrefix.length,
          ),
        ) ??
        0;
    return l10n.fileReadWriteUploadingSelected(count.toString());
  }
  if (message.startsWith(FileReadWriteMessageKeys.uploadSummaryPrefix)) {
    final payload = message.substring(
      FileReadWriteMessageKeys.uploadSummaryPrefix.length,
    );
    final parts = payload.split('|');
    return l10n.fileReadWriteUploadSummary(
      (int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0).toString(),
      (int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0).toString(),
    );
  }
  if (message.startsWith(FileReadWriteMessageKeys.listLoadFailedPrefix)) {
    final error = message.substring(
      FileReadWriteMessageKeys.listLoadFailedPrefix.length,
    );
    return l10n.fileReadWriteListLoadFailed(error);
  }
  if (message.startsWith(FileReadWriteMessageKeys.createFailedPrefix)) {
    final error = message.substring(
      FileReadWriteMessageKeys.createFailedPrefix.length,
    );
    return error.isEmpty
        ? l10n.fileReadWriteCreateFailed
        : l10n.fileReadWriteCreateFailedWith(error);
  }
  if (message.startsWith(FileReadWriteMessageKeys.readFailedPrefix)) {
    final error = message.substring(
      FileReadWriteMessageKeys.readFailedPrefix.length,
    );
    return l10n.fileReadWriteReadFailed(error);
  }
  if (message.startsWith(FileReadWriteMessageKeys.deleteFailedPrefix)) {
    final error = message.substring(
      FileReadWriteMessageKeys.deleteFailedPrefix.length,
    );
    return l10n.fileReadWriteDeleteFailed(error);
  }
  if (message.startsWith(FileReadWriteMessageKeys.uploadFailedPrefix)) {
    final error = message.substring(
      FileReadWriteMessageKeys.uploadFailedPrefix.length,
    );
    return l10n.fileReadWriteUploadFailed(error);
  }
  if (message.startsWith(FileReadWriteMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(
      FileReadWriteMessageKeys.uploadErrorPrefix.length,
    );
    return l10n.fileReadWriteUploadError(error);
  }
  if (message.startsWith(FileReadWriteMessageKeys.serverListFailedPrefix)) {
    final error = message.substring(
      FileReadWriteMessageKeys.serverListFailedPrefix.length,
    );
    return l10n.fileReadWriteServerListFailed(error);
  }
  if (message.startsWith(FileReadWriteMessageKeys.serverDeleteFailedPrefix)) {
    final error = message.substring(
      FileReadWriteMessageKeys.serverDeleteFailedPrefix.length,
    );
    return l10n.fileReadWriteServerDeleteFailed(error);
  }
  if (message.startsWith(FileReadWriteMessageKeys.importSuccessPrefix)) {
    final count = message.substring(
      FileReadWriteMessageKeys.importSuccessPrefix.length,
    );
    return l10n.fileReadWriteImportSuccess(count);
  }
  if (message.startsWith(FileReadWriteMessageKeys.importFailedPrefix)) {
    final error = message.substring(
      FileReadWriteMessageKeys.importFailedPrefix.length,
    );
    return error.isEmpty
        ? l10n.fileReadWriteImportFailed
        : '${l10n.fileReadWriteImportFailed} ($error)';
  }
  if (message.startsWith(FileOpenerMessageKeys.addFilesSummaryPrefix)) {
    final count =
        int.tryParse(
          message.substring(FileOpenerMessageKeys.addFilesSummaryPrefix.length),
        ) ??
        0;
    return l10n.fileOpenerAddFilesSummary(count.toString());
  }
  if (message.startsWith(FileOpenerMessageKeys.localListFailedPrefix)) {
    final error = message.substring(
      FileOpenerMessageKeys.localListFailedPrefix.length,
    );
    return l10n.fileOpenerLocalListFailed(error);
  }
  if (message.startsWith(FileOpenerMessageKeys.openErrorPrefix)) {
    final error = message.substring(
      FileOpenerMessageKeys.openErrorPrefix.length,
    );
    return l10n.fileOpenerOpenError(error);
  }
  if (message.startsWith(FileOpenerMessageKeys.pickErrorPrefix)) {
    final error = message.substring(
      FileOpenerMessageKeys.pickErrorPrefix.length,
    );
    return l10n.fileOpenerPickError(error);
  }
  if (message.startsWith(FileOpenerMessageKeys.deleteErrorPrefix)) {
    final error = message.substring(
      FileOpenerMessageKeys.deleteErrorPrefix.length,
    );
    return l10n.fileOpenerDeleteError(error);
  }
  if (message.startsWith(FileOpenerMessageKeys.serverListErrorPrefix)) {
    final error = message.substring(
      FileOpenerMessageKeys.serverListErrorPrefix.length,
    );
    return l10n.fileOpenerServerListError(error);
  }
  if (message.startsWith(FileOpenerMessageKeys.downloadErrorPrefix)) {
    final error = message.substring(
      FileOpenerMessageKeys.downloadErrorPrefix.length,
    );
    return l10n.fileOpenerDownloadError(error);
  }
  if (message.startsWith(FileOpenerMessageKeys.downloadSuccessPrefix)) {
    final fileName = message.substring(
      FileOpenerMessageKeys.downloadSuccessPrefix.length,
    );
    return l10n.fileOpenerDownloadSuccessWith(fileName);
  }

  if (message.startsWith(InterfaceMessageKeys.registerFailedPrefix)) {
    final error = message.substring(
      InterfaceMessageKeys.registerFailedPrefix.length,
    );
    return l10n.interfaceRegisterFailed(error);
  }
  if (message.startsWith(InterfaceMessageKeys.withdrawFailedPrefix)) {
    final error = message.substring(
      InterfaceMessageKeys.withdrawFailedPrefix.length,
    );
    return l10n.interfaceWithdrawFailed(error);
  }
  if (message.startsWith(InterfaceMessageKeys.genericErrorPrefix)) {
    final error = message.substring(
      InterfaceMessageKeys.genericErrorPrefix.length,
    );
    return l10n.interfaceGenericError(error);
  }

  if (message.startsWith(FileMgmtMessageKeys.cannotAccessDocumentsPrefix)) {
    final error = message.substring(
      FileMgmtMessageKeys.cannotAccessDocumentsPrefix.length,
    );
    return l10n.fileMgmtCannotAccessDocuments(error);
  }
  if (message.startsWith(FileMgmtMessageKeys.initErrorPrefix)) {
    final error = message.substring(
      FileMgmtMessageKeys.initErrorPrefix.length,
    );
    return l10n.fileMgmtInitError(error);
  }
  if (message.startsWith(FileMgmtMessageKeys.directoryLoadErrorPrefix)) {
    final error = message.substring(
      FileMgmtMessageKeys.directoryLoadErrorPrefix.length,
    );
    return l10n.fileMgmtDirectoryLoadError(error);
  }
  if (message.startsWith(FileMgmtMessageKeys.folderCreatedPrefix)) {
    final name = message.substring(
      FileMgmtMessageKeys.folderCreatedPrefix.length,
    );
    return l10n.fileMgmtFolderCreated(name);
  }
  if (message.startsWith(FileMgmtMessageKeys.folderCreateErrorPrefix)) {
    final error = message.substring(
      FileMgmtMessageKeys.folderCreateErrorPrefix.length,
    );
    return l10n.fileMgmtFolderCreateError(error);
  }
  if (message.startsWith(FileMgmtMessageKeys.sampleFileCreatedPrefix)) {
    final name = message.substring(
      FileMgmtMessageKeys.sampleFileCreatedPrefix.length,
    );
    return l10n.fileMgmtSampleFileCreated(name);
  }
  if (message.startsWith(FileMgmtMessageKeys.sampleFileCreateErrorPrefix)) {
    final error = message.substring(
      FileMgmtMessageKeys.sampleFileCreateErrorPrefix.length,
    );
    return l10n.fileMgmtSampleFileCreateError(error);
  }
  if (message.startsWith(FileMgmtMessageKeys.deletedCountPrefix)) {
    final count = int.tryParse(
      message.substring(FileMgmtMessageKeys.deletedCountPrefix.length),
    );
    return l10n.fileMgmtDeletedCount(count ?? 0);
  }
  if (message.startsWith(FileMgmtMessageKeys.deleteErrorPrefix)) {
    final error = message.substring(
      FileMgmtMessageKeys.deleteErrorPrefix.length,
    );
    return l10n.fileMgmtDeleteError(error);
  }
  if (message.startsWith(FileMgmtMessageKeys.copiedCountPrefix)) {
    final count = int.tryParse(
      message.substring(FileMgmtMessageKeys.copiedCountPrefix.length),
    );
    return l10n.fileMgmtCopiedCount(count ?? 0);
  }
  if (message.startsWith(FileMgmtMessageKeys.copyErrorPrefix)) {
    final error = message.substring(
      FileMgmtMessageKeys.copyErrorPrefix.length,
    );
    return l10n.fileMgmtCopyError(error);
  }
  if (message.startsWith(FileMgmtMessageKeys.movedCountPrefix)) {
    final count = int.tryParse(
      message.substring(FileMgmtMessageKeys.movedCountPrefix.length),
    );
    return l10n.fileMgmtMovedCount(count ?? 0);
  }
  if (message.startsWith(FileMgmtMessageKeys.moveErrorPrefix)) {
    final error = message.substring(
      FileMgmtMessageKeys.moveErrorPrefix.length,
    );
    return l10n.fileMgmtMoveError(error);
  }
  if (message.startsWith(FileMgmtMessageKeys.renameErrorPrefix)) {
    final error = message.substring(
      FileMgmtMessageKeys.renameErrorPrefix.length,
    );
    return l10n.fileMgmtRenameError(error);
  }

  if (message.startsWith(BarcodeMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(BarcodeMessageKeys.uploadErrorPrefix.length);
    return l10n.barcodeUploadError(error);
  }
  if (message.startsWith(BarcodeMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(BarcodeMessageKeys.listLoadErrorPrefix.length);
    return l10n.barcodeListLoadError(error);
  }
  if (message.startsWith(BarcodeMessageKeys.genericErrorPrefix)) {
    final error = message.substring(BarcodeMessageKeys.genericErrorPrefix.length);
    return l10n.barcodeGenericError(error);
  }
  if (message.startsWith(BarcodeMessageKeys.cameraErrorPrefix)) {
    final error = message.substring(BarcodeMessageKeys.cameraErrorPrefix.length);
    return l10n.barcodeCameraError(error);
  }

  if (message.startsWith(CompassMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(CompassMessageKeys.uploadErrorPrefix.length);
    return l10n.compassUploadError(error);
  }
  if (message.startsWith(CompassMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(CompassMessageKeys.listLoadErrorPrefix.length);
    return l10n.compassListLoadError(error);
  }
  if (message.startsWith(CompassMessageKeys.genericErrorPrefix)) {
    final error = message.substring(CompassMessageKeys.genericErrorPrefix.length);
    return l10n.compassGenericError(error);
  }
  if (message.startsWith(CompassMessageKeys.sensorErrorPrefix)) {
    final error = message.substring(CompassMessageKeys.sensorErrorPrefix.length);
    return l10n.compassSensorError(error);
  }

  if (message.startsWith(ContactsMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(ContactsMessageKeys.uploadErrorPrefix.length);
    return l10n.contactsUploadError(error);
  }
  if (message.startsWith(ContactsMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(ContactsMessageKeys.listLoadErrorPrefix.length);
    return l10n.contactsListLoadError(error);
  }
  if (message.startsWith(ContactsMessageKeys.genericErrorPrefix)) {
    final error = message.substring(ContactsMessageKeys.genericErrorPrefix.length);
    return l10n.contactsGenericError(error);
  }
  if (message.startsWith(ContactsMessageKeys.sensorErrorPrefix)) {
    final error = message.substring(ContactsMessageKeys.sensorErrorPrefix.length);
    return l10n.contactsSensorError(error);
  }
  if (message.startsWith(ContactsMessageKeys.contactsLoadErrorPrefix)) {
    final error = message.substring(ContactsMessageKeys.contactsLoadErrorPrefix.length);
    return l10n.contactsLoadError(error);
  }

  if (message.startsWith(PushMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(PushMessageKeys.uploadErrorPrefix.length);
    return l10n.pushUploadError(error);
  }
  if (message.startsWith(PushMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(PushMessageKeys.listLoadErrorPrefix.length);
    return l10n.pushListLoadError(error);
  }
  if (message.startsWith(PushMessageKeys.genericErrorPrefix)) {
    final error = message.substring(PushMessageKeys.genericErrorPrefix.length);
    return l10n.pushGenericError(error);
  }
  if (message.startsWith(PushMessageKeys.initErrorPrefix)) {
    final error = message.substring(PushMessageKeys.initErrorPrefix.length);
    return l10n.pushInitError(error);
  }

  if (message.startsWith(SocketMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(SocketMessageKeys.uploadErrorPrefix.length);
    return l10n.socketUploadError(error);
  }
  if (message.startsWith(SocketMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(SocketMessageKeys.listLoadErrorPrefix.length);
    return l10n.socketListLoadError(error);
  }
  if (message.startsWith(SocketMessageKeys.genericErrorPrefix)) {
    final error = message.substring(SocketMessageKeys.genericErrorPrefix.length);
    return l10n.socketGenericError(error);
  }
  if (message.startsWith(SocketMessageKeys.websocketErrorPrefix)) {
    final error = message.substring(SocketMessageKeys.websocketErrorPrefix.length);
    return l10n.socketWebsocketError(error);
  }

  if (message.startsWith(StreamingMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(StreamingMessageKeys.listLoadErrorPrefix.length);
    return l10n.streamingListLoadError(error);
  }
  if (message.startsWith(StreamingMessageKeys.genericErrorPrefix)) {
    final error = message.substring(StreamingMessageKeys.genericErrorPrefix.length);
    return l10n.streamingGenericError(error);
  }
  if (message.startsWith(StreamingMessageKeys.streamErrorPrefix)) {
    final error = message.substring(StreamingMessageKeys.streamErrorPrefix.length);
    return l10n.streamingStreamError(error);
  }

  if (message.startsWith(FaceMeshMessageKeys.pickErrorPrefix)) {
    final error = message.substring(FaceMeshMessageKeys.pickErrorPrefix.length);
    return l10n.faceMeshPickError(error);
  }
  if (message.startsWith(FaceMeshMessageKeys.detectErrorPrefix)) {
    final error =
        message.substring(FaceMeshMessageKeys.detectErrorPrefix.length);
    return l10n.faceMeshDetectError(error);
  }
  if (message.startsWith(FaceMeshMessageKeys.cameraErrorPrefix)) {
    final error =
        message.substring(FaceMeshMessageKeys.cameraErrorPrefix.length);
    return l10n.faceMeshCameraError(error);
  }
  if (message.startsWith(FaceMeshMessageKeys.genericErrorPrefix)) {
    final error =
        message.substring(FaceMeshMessageKeys.genericErrorPrefix.length);
    return l10n.faceMeshGenericError(error);
  }
  if (message.startsWith(FaceMeshMessageKeys.uploadErrorPrefix)) {
    final error =
        message.substring(FaceMeshMessageKeys.uploadErrorPrefix.length);
    return l10n.faceMeshUploadError(error);
  }
  if (message.startsWith(FaceMeshMessageKeys.listLoadErrorPrefix)) {
    final error =
        message.substring(FaceMeshMessageKeys.listLoadErrorPrefix.length);
    return l10n.faceMeshListLoadError(error);
  }

  if (message.startsWith(IotMessageKeys.connectErrorPrefix)) {
    final error = message.substring(IotMessageKeys.connectErrorPrefix.length);
    return l10n.iotConnectError(error);
  }
  if (message.startsWith(IotMessageKeys.publishErrorPrefix)) {
    final error = message.substring(IotMessageKeys.publishErrorPrefix.length);
    return l10n.iotPublishError(error);
  }
  if (message.startsWith(IotMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(IotMessageKeys.uploadErrorPrefix.length);
    return l10n.iotUploadError(error);
  }
  if (message.startsWith(IotMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(IotMessageKeys.listLoadErrorPrefix.length);
    return l10n.iotListLoadError(error);
  }
  if (message.startsWith(IotMessageKeys.genericErrorPrefix)) {
    final error = message.substring(IotMessageKeys.genericErrorPrefix.length);
    return l10n.iotGenericError(error);
  }

  if (message.startsWith(AiChatMessageKeys.askErrorPrefix)) {
    final error = message.substring(AiChatMessageKeys.askErrorPrefix.length);
    return l10n.aiChatAskError(error);
  }
  if (message.startsWith(AiChatMessageKeys.uploadErrorPrefix)) {
    final error = message.substring(AiChatMessageKeys.uploadErrorPrefix.length);
    return l10n.aiChatUploadError(error);
  }
  if (message.startsWith(AiChatMessageKeys.listLoadErrorPrefix)) {
    final error = message.substring(AiChatMessageKeys.listLoadErrorPrefix.length);
    return l10n.aiChatListLoadError(error);
  }
  if (message.startsWith(AiChatMessageKeys.genericErrorPrefix)) {
    final error = message.substring(AiChatMessageKeys.genericErrorPrefix.length);
    return l10n.aiChatGenericError(error);
  }

  return switch (message) {
    DeviceInfoMessageKeys.noUploadData => l10n.deviceInfoNoUploadData,
    DeviceInfoMessageKeys.emptyList => l10n.deviceInfoEmptyList,
    DeviceInfoMessageKeys.cannotLoad => l10n.deviceInfoCannotLoad,
    DeviceInfoMessageKeys.uploadFailed => l10n.deviceInfoUploadFailed,
    DeviceInfoMessageKeys.noUuid => l10n.commonNoUuid,
    DeviceInfoMessageKeys.uuidRequired => l10n.commonUuidRequired,
    DeviceInfoMessageKeys.uuidMismatch => l10n.commonUuidMismatch,
    DeviceInfoMessageKeys.invalidSerial => l10n.deviceInfoInvalidSerial,
    DeviceInfoMessageKeys.deleteFailed => l10n.deviceInfoDeleteFailed,
    AcceleratorMessageKeys.saveSuccess => l10n.acceleratorSaveSuccess,
    AcceleratorMessageKeys.emptyList => l10n.acceleratorEmptyList,
    AcceleratorMessageKeys.noUuid => l10n.commonNoUuid,
    AcceleratorMessageKeys.uuidMismatch => l10n.commonUuidMismatch,
    AcceleratorMessageKeys.deleteFailed => l10n.acceleratorDeleteFailed,
    AcceleratorMessageKeys.invalidSerial => l10n.acceleratorInvalidSerial,
    AcceleratorMessageKeys.transferFailed => l10n.acceleratorTransferFailed,
    NetworkMessageKeys.sendSuccess => l10n.networkSendSuccess,
    NetworkMessageKeys.sendFailed => l10n.networkSendFailed,
    NetworkMessageKeys.emptyList => l10n.networkEmptyList,
    NetworkMessageKeys.noUuid => l10n.commonNoUuid,
    NetworkMessageKeys.uuidRequired => l10n.commonUuidRequired,
    NetworkMessageKeys.uuidMismatch => l10n.commonUuidMismatch,
    NetworkMessageKeys.noCurrentInfo => l10n.networkNoCurrentInfo,
    NetworkMessageKeys.deleteSnMissing => l10n.networkDeleteSnMissing,
    NetworkMessageKeys.deleteFailed => l10n.networkDeleteFailed,
    NetworkMessageKeys.activeEmpty => l10n.networkActiveEmpty,
    NetworkMessageKeys.unknownQuality => l10n.networkUnknownQuality,
    GpsMessageKeys.saveSuccess => l10n.gpsSaveSuccess,
    GpsMessageKeys.emptyList => l10n.gpsEmptyList,
    GpsMessageKeys.noUuid => l10n.commonNoUuid,
    GpsMessageKeys.saveFailed => l10n.gpsSaveFailed,
    GpsMessageKeys.noLocation => l10n.gpsNoLocation,
    GpsMessageKeys.deleteFailed => l10n.gpsDeleteFailed,
    GpsMessageKeys.noSelection => l10n.gpsNoSelection,
    GpsMessageKeys.saveNoLocation => l10n.gpsSaveNoLocation,
    GpsMessageKeys.savingInProgress => l10n.gpsSavingInProgress,
    GpsMessageKeys.savedStatus => l10n.gpsSavedStatus,
    GpsMessageKeys.deletedStatus => l10n.gpsDeletedStatus,
    GpsMessageKeys.clearedStatus => l10n.gpsClearedStatus,
    GpsMessageKeys.uploadedStatus => l10n.gpsUploadedStatus,
    GpsMessageKeys.permissionGranted => l10n.gpsPermissionGranted,
    GpsMessageKeys.permissionDenied => l10n.gpsPermissionDenied,
    GpsMessageKeys.permissionPermanentlyDenied =>
      l10n.gpsPermissionPermanentlyDenied,
    GpsMessageKeys.permissionUnknown => l10n.gpsPermissionUnknown,
    MediaMessageKeys.noFilesToDelete => l10n.mediaNoFilesToDelete,
    MediaMessageKeys.noFilesToUpload => l10n.mediaNoFilesToUpload,
    MediaMessageKeys.noValidFilesToUpload => l10n.mediaNoValidFilesToUpload,
    MediaMessageKeys.saveSuccess => l10n.mediaSaveSuccess,
    MediaMessageKeys.noDeviceUuid => l10n.mediaNoDeviceUuid,
    MediaMessageKeys.uuidRequired => l10n.commonUuidRequired,
    MediaMessageKeys.uuidMismatch => l10n.commonUuidMismatch,
    MediaMessageKeys.serverListEmpty => l10n.mediaServerListEmpty,
    MediaMessageKeys.serverDeleted => l10n.mediaServerDeleted,
    MediaMessageKeys.uploadFailed => l10n.mediaUploadFailed,
    MediaMessageKeys.downloadFailed => l10n.mediaDownloadFailed,
    MediaMessageKeys.cameraPermissionRequired =>
      l10n.mediaCameraPermissionRequired,
    MediaMessageKeys.cameraPermissionGuide => l10n.mediaCameraPermissionGuide,
    MediaMessageKeys.imagePickCancelled => l10n.mediaImagePickCancelled,
    MediaMessageKeys.videoPickCancelled => l10n.mediaVideoPickCancelled,
    FileReadWriteMessageKeys.initialGuide => l10n.fileReadWriteInitialGuide,
    FileReadWriteMessageKeys.noLocalFiles => l10n.fileReadWriteNoLocalFiles,
    FileReadWriteMessageKeys.noServerFiles => l10n.fileReadWriteNoServerFiles,
    FileReadWriteMessageKeys.createSuccess => l10n.fileReadWriteCreateSuccess,
    FileReadWriteMessageKeys.uploadSuccess => l10n.fileReadWriteUploadSuccess,
    FileReadWriteMessageKeys.fileNotFound => l10n.fileReadWriteFileNotFound,
    FileReadWriteMessageKeys.noDeviceUuid => l10n.fileReadWriteNoDeviceUuid,
    FileReadWriteMessageKeys.noUploadFiles => l10n.fileReadWriteNoUploadFiles,
    FileReadWriteMessageKeys.noValidUploadFiles =>
      l10n.fileReadWriteNoValidUploadFiles,
    FileReadWriteMessageKeys.noFilesSelectedForUpload =>
      l10n.fileReadWriteNoFilesSelectedForUpload,
    FileReadWriteMessageKeys.createInProgress =>
      l10n.fileReadWriteCreateInProgress,
    FileReadWriteMessageKeys.importInProgress =>
      l10n.fileReadWriteImportInProgress,
    FileReadWriteMessageKeys.importFailed => l10n.fileReadWriteImportFailed,
    FileOpenerMessageKeys.noLocalFiles => l10n.fileOpenerNoLocalFiles,
    FileOpenerMessageKeys.noServerFiles => l10n.fileOpenerNoServerFiles,
    FileOpenerMessageKeys.openFailed => l10n.fileOpenerOpenFailed,
    FileOpenerMessageKeys.deleteFailed => l10n.fileOpenerDeleteFailed,
    FileOpenerMessageKeys.downloadSuccess => l10n.fileOpenerDownloadSuccess,
    FileOpenerMessageKeys.downloadFailed => l10n.fileOpenerDownloadFailed,
    InterfaceMessageKeys.loginSuccess => l10n.interfaceLoginSuccess,
    InterfaceMessageKeys.registerSuccess => l10n.interfaceRegisterSuccess,
    InterfaceMessageKeys.registerAccountExists =>
      l10n.interfaceRegisterAccountExists,
    InterfaceMessageKeys.withdrawSuccess => l10n.interfaceWithdrawSuccess,
    InterfaceMessageKeys.logoutSuccess => l10n.interfaceLogoutSuccess,
    InterfaceMessageKeys.loginInvalidCredentials =>
      l10n.interfaceLoginInvalidCredentials,
    InterfaceMessageKeys.loginUserNotFound => l10n.interfaceLoginUserNotFound,
    InterfaceMessageKeys.loginFailed => l10n.interfaceLoginFailed,
    InterfaceMessageKeys.unknownError => l10n.interfaceUnknownError,
    FileMgmtMessageKeys.initInProgress => l10n.fileMgmtInitInProgress,
    FileMgmtMessageKeys.noItemsToDelete => l10n.fileMgmtNoItemsToDelete,
    FileMgmtMessageKeys.noItemsToCopy => l10n.fileMgmtNoItemsToCopy,
    FileMgmtMessageKeys.noItemsToMove => l10n.fileMgmtNoItemsToMove,
    FileMgmtMessageKeys.renameSuccess => l10n.fileMgmtRenameSuccess,
    BarcodeMessageKeys.noScanData => l10n.barcodeNoScanData,
    BarcodeMessageKeys.emptyList => l10n.barcodeEmptyList,
    BarcodeMessageKeys.uploadFailed => l10n.barcodeUploadFailed,
    BarcodeMessageKeys.deleteFailed => l10n.barcodeDeleteFailed,
    BarcodeMessageKeys.noSelection => l10n.barcodeNoSelection,
    BarcodeMessageKeys.uuidRequired => l10n.commonUuidRequired,
    BarcodeMessageKeys.uuidMismatch => l10n.commonUuidMismatch,
    BarcodeMessageKeys.cameraUnavailable => l10n.barcodeCameraUnavailable,
    CompassMessageKeys.noHeadingData => l10n.compassNoHeadingData,
    CompassMessageKeys.emptyList => l10n.compassEmptyList,
    CompassMessageKeys.uploadFailed => l10n.compassUploadFailed,
    CompassMessageKeys.noUuid => l10n.commonNoUuid,
    CompassMessageKeys.deleteFailed => l10n.compassDeleteFailed,
    CompassMessageKeys.noSelection => l10n.compassNoSelection,
    CompassMessageKeys.sensorUnavailable => l10n.compassSensorUnavailable,
    ContactsMessageKeys.noHeadingData => l10n.contactsNoHeadingData,
    ContactsMessageKeys.emptyList => l10n.contactsEmptyList,
    ContactsMessageKeys.emptyDeviceContacts => l10n.contactsEmptyDeviceContacts,
    ContactsMessageKeys.uploadFailed => l10n.contactsUploadFailed,
    ContactsMessageKeys.noUuid => l10n.commonNoUuid,
    ContactsMessageKeys.deleteFailed => l10n.contactsDeleteFailed,
    ContactsMessageKeys.noSelection => l10n.contactsNoSelection,
    ContactsMessageKeys.writePermissionDenied => l10n.contactsWritePermissionDenied,
    ContactsMessageKeys.saveToDeviceFailed => l10n.contactsSaveToDeviceFailed,
    ContactsMessageKeys.sensorUnavailable => l10n.contactsSensorUnavailable,
    ContactsMessageKeys.permissionDenied => l10n.contactsPermissionDenied,
    PushMessageKeys.noDeviceData => l10n.pushNoDeviceData,
    PushMessageKeys.emptyList => l10n.pushEmptyList,
    PushMessageKeys.emptyMessageList => l10n.pushEmptyMessageList,
    PushMessageKeys.uploadFailed => l10n.pushUploadFailed,
    PushMessageKeys.noUuid => l10n.commonNoUuid,
    PushMessageKeys.deleteFailed => l10n.pushDeleteFailed,
    PushMessageKeys.notificationsUnavailable => l10n.pushNotificationsUnavailable,
    PushMessageKeys.initFailed => l10n.pushInitFailed,
    PushMessageKeys.fcmTokenFailed => l10n.pushFcmTokenFailed,
    PushMessageKeys.firebaseInitFailed => l10n.pushFirebaseInitFailed,
    PushMessageKeys.notificationFailed => l10n.pushNotificationFailed,
    PushMessageKeys.testMessageEmpty => l10n.pushTestMessageEmpty,
    PushMessageKeys.notInitialized => l10n.pushNotInitialized,
    PushMessageKeys.permissionDenied => l10n.pushPermissionDenied,
    SocketMessageKeys.noMessageData => l10n.socketNoMessageData,
    SocketMessageKeys.noNewMessages => l10n.socketNoNewMessages,
    SocketMessageKeys.emptyList => l10n.socketEmptyList,
    SocketMessageKeys.uploadFailed => l10n.socketUploadFailed,
    SocketMessageKeys.noUuid => l10n.commonNoUuid,
    SocketMessageKeys.deleteFailed => l10n.socketDeleteFailed,
    SocketMessageKeys.websocketNotConnected => l10n.socketWebsocketNotConnected,
    SocketMessageKeys.websocketUnavailable => l10n.socketWebsocketUnavailable,
    SocketMessageKeys.nicknameRequired => l10n.socketNicknameRequired,
    SocketMessageKeys.nicknameInvalid => l10n.socketNicknameInvalid,
    StreamingMessageKeys.emptyList => l10n.streamingEmptyList,
    StreamingMessageKeys.playCountUpdateFailed => l10n.streamingPlayCountUpdateFailed,
    StreamingMessageKeys.streamingRequiresServer => l10n.streamingRequiresServer,
    StreamingMessageKeys.videoFileNotFound => l10n.streamingVideoFileNotFound,
    FaceMeshMessageKeys.permissionDenied => l10n.faceMeshPermissionDenied,
    FaceMeshMessageKeys.noFacesDetected => l10n.faceMeshNoFacesDetected,
    FaceMeshMessageKeys.pickCancelled => l10n.faceMeshPickCancelled,
    FaceMeshMessageKeys.cameraUnavailable => l10n.faceMeshCameraUnavailable,
    FaceMeshMessageKeys.imageLoadFailed => l10n.faceMeshImageLoadFailed,
    FaceMeshMessageKeys.noDetectionData => l10n.faceMeshNoDetectionData,
    FaceMeshMessageKeys.emptyList => l10n.faceMeshEmptyList,
    FaceMeshMessageKeys.uploadFailed => l10n.faceMeshUploadFailed,
    FaceMeshMessageKeys.deleteFailed => l10n.faceMeshDeleteFailed,
    FaceMeshMessageKeys.noSelection => l10n.faceMeshNoSelection,
    FaceMeshMessageKeys.uuidRequired => l10n.commonUuidRequired,
    FaceMeshMessageKeys.uuidMismatch => l10n.commonUuidMismatch,
    IotMessageKeys.hostRequired => l10n.iotHostRequired,
    IotMessageKeys.portInvalid => l10n.iotPortInvalid,
    IotMessageKeys.deviceIdRequired => l10n.iotDeviceIdRequired,
    IotMessageKeys.notConnected => l10n.iotNotConnected,
    IotMessageKeys.topicRequired => l10n.iotTopicRequired,
    IotMessageKeys.payloadRequired => l10n.iotPayloadRequired,
    IotMessageKeys.noLogData => l10n.iotNoLogData,
    IotMessageKeys.noNewLogs => l10n.iotNoNewLogs,
    IotMessageKeys.noUuid => l10n.commonNoUuid,
    IotMessageKeys.deleteFailed => l10n.iotDeleteFailed,
    IotMessageKeys.emptyList => l10n.iotSavedEmptyList,
    AiChatMessageKeys.noQuestion => l10n.aiChatNoQuestion,
    AiChatMessageKeys.emptyList => l10n.aiChatEmptyList,
    AiChatMessageKeys.askFailed => l10n.aiChatAskFailed,
    AiChatMessageKeys.uploadFailed => l10n.aiChatUploadFailed,
    AiChatMessageKeys.noUuid => l10n.commonNoUuid,
    AiChatMessageKeys.deleteFailed => l10n.aiChatDeleteFailed,
    AiChatMessageKeys.noSelection => l10n.aiChatNoSelection,
    AiChatMessageKeys.serverRequired => l10n.aiChatServerRequired,
    _ => message,
  };
}
