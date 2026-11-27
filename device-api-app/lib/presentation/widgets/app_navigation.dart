import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/view/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/application_list_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/view/device_info_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileMgmt/view/file_mgmt_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/view/file_readwrite_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/view/fileOpener_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/view/gps_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/view/interface_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/view/media_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/view/network_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/view/barcode_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/view/compass_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/view/contacts_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/view/push_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view/socket_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/view/streaming_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view/face_mesh_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view/iot_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view/ai_chat_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_main.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// 앱 목록·API 화면 간 공통 내비게이션
class AppNavigation {
  AppNavigation._();

  static Widget? pageForTarget(String targetPage) {
    switch (targetPage) {
      case 'device_info_page':
        return const DeviceInfoPage();
      case 'accelerator_info_page':
        return const AcceleratorInfoPage();
      case 'device_file_mgmt':
        return const FileMgmtPage();
      case 'gps':
        return const GpsMainPage();
      case 'file_readWrite':
        return const FileReadWriteMainPage();
      case 'media':
        return const MediaScreen();
      case 'interface':
        return const InterfaceScreen();
      case 'network':
        return const NetworkScreen();
      case 'file_opener':
        return const FileOpenerScreen();
      case 'barcode':
        return const BarcodePage();
      case 'compass':
        return const CompassPage();
      case 'contacts':
        return const ContactsPage();
      case 'push':
        return const PushPage();
      case 'socket':
        return const SocketPage();
      case 'streaming':
        return const StreamingPage();
      case 'faceMesh':
        return const FaceMeshPage();
      case 'iot':
        return const IotPage();
      case 'aiChat':
        return const AiChatPage();
      case 'sqlite':
        return const SqliteMainPage();
      default:
        return null;
    }
  }

  static void navigateToAppList(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) =>
            ApplicationListMain(title: l10n.applicationListTitle),
      ),
      (route) => false,
    );
  }

  static void navigateToTarget(
    BuildContext context,
    String targetPage, {
    bool replace = true,
  }) {
    final page = pageForTarget(targetPage);
    if (page == null) return;

    final route = MaterialPageRoute(builder: (context) => page);
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }
}
