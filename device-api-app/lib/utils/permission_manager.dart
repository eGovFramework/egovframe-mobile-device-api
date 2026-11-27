import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// 권한 관리를 위한 유틸리티 클래스
class PermissionManager {
  /// 위치 권한을 요청하는 메서드
  static Future<PermissionStatus> requestLocationPermission() async {
    try {
      // 위치 서비스 활성화 확인
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return PermissionStatus.denied;
      }

      // 현재 권한 상태 확인
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // 권한 요청
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return PermissionStatus.permanentlyDenied;
      }

      return permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always
          ? PermissionStatus.granted
          : PermissionStatus.denied;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  /// 연락처 권한을 요청하는 메서드
  static Future<PermissionStatus> requestContactsPermission() async {
    try {
      final permission = await FlutterContacts.requestPermission(
        readonly: true,
      );
      return permission ? PermissionStatus.granted : PermissionStatus.denied;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  /// 카메라 권한을 요청하는 메서드
  static Future<PermissionStatus> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  /// 저장소 권한을 요청하는 메서드
  static Future<PermissionStatus> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        if (sdkInt >= 33) {
          final status = await Permission.photos.request();
          return status;
        } else {
          final status = await Permission.storage.request();
          return status;
        }
      } else {
        final status = await Permission.photos.request();
        return status;
      }
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  /// 권한 상태에 따른 사용자 친화적 메시지 반환
  static String getPermissionMessage(
    PermissionStatus status,
    String permissionType, {
    AppLocalizations? l10n,
  }) {
    String fallback(
      String granted,
      String denied,
      String permanent,
      String restricted,
      String limited,
      String provisional,
    ) {
      return switch (status) {
        PermissionStatus.granted => granted,
        PermissionStatus.denied => denied,
        PermissionStatus.permanentlyDenied => permanent,
        PermissionStatus.restricted => restricted,
        PermissionStatus.limited => limited,
        PermissionStatus.provisional => provisional,
      };
    }

    if (l10n == null) {
      return fallback(
        '$permissionType permission granted.',
        '$permissionType permission denied. Enable it in Settings.',
        '$permissionType permission permanently denied. Allow it in app settings.',
        '$permissionType permission is restricted.',
        '$permissionType permission is limited.',
        '$permissionType permission is provisionally granted.',
      );
    }

    switch (status) {
      case PermissionStatus.granted:
        return l10n.permissionGranted(permissionType);
      case PermissionStatus.denied:
        return l10n.permissionDenied(permissionType);
      case PermissionStatus.permanentlyDenied:
        return l10n.permissionPermanentlyDenied(permissionType);
      case PermissionStatus.restricted:
        return l10n.permissionRestricted(permissionType);
      case PermissionStatus.limited:
        return l10n.permissionLimited(permissionType);
      case PermissionStatus.provisional:
        return l10n.permissionProvisional(permissionType);
    }
  }

  /// 권한 설정 화면으로 이동하는 다이얼로그 표시
  static Future<void> showPermissionSettingsDialog(
    BuildContext context,
    String permissionType,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.permissionRequiredTitle(permissionType)),
          content: Text(l10n.permissionRequiredMessage(permissionType)),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.commonCancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(l10n.commonOpenSettings),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  /// 모든 권한을 한번에 요청하는 메서드
  static Future<Map<String, PermissionStatus>> requestAllPermissions() async {
    final results = <String, PermissionStatus>{};

    results['location'] = await requestLocationPermission();
    results['contacts'] = await requestContactsPermission();
    results['camera'] = await requestCameraPermission();
    results['storage'] = await requestStoragePermission();

    return results;
  }
}
