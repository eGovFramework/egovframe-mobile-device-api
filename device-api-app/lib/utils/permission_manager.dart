import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_logger.dart';

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
      AppLogger.e('위치 권한 요청 오류', e);
      return PermissionStatus.denied;
    }
  }

  /// 연락처 권한을 요청하는 메서드
  static Future<PermissionStatus> requestContactsPermission() async {
    try {
      final permission = await FlutterContacts.requestPermission(readonly: true);
      return permission ? PermissionStatus.granted : PermissionStatus.denied;
    } catch (e) {
      AppLogger.e('연락처 권한 요청 오류', e);
      return PermissionStatus.denied;
    }
  }

  /// 카메라 권한을 요청하는 메서드
  static Future<PermissionStatus> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status;
    } catch (e) {
      AppLogger.e('카메라 권한 요청 오류', e);
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
      AppLogger.e('저장소 권한 요청 오류', e);
      return PermissionStatus.denied;
    }
  }

  /// 권한 상태에 따른 사용자 친화적 메시지 반환
  static String getPermissionMessage(PermissionStatus status, String permissionType) {
    switch (status) {
      case PermissionStatus.granted:
        return '$permissionType 권한이 허용되었습니다.';
      case PermissionStatus.denied:
        return '$permissionType 권한이 거부되었습니다. 기능을 사용하려면 설정에서 권한을 허용해주세요.';
      case PermissionStatus.permanentlyDenied:
        return '$permissionType 권한이 영구적으로 거부되었습니다. 앱 설정에서 직접 권한을 허용해주세요.';
      case PermissionStatus.restricted:
        return '$permissionType 권한이 제한되었습니다.';
      case PermissionStatus.limited:
        return '$permissionType 권한이 제한적으로 허용되었습니다.';
      case PermissionStatus.provisional:
        return '$permissionType 권한이 임시적으로 허용되었습니다.';
    }
  }

  /// 권한 설정 화면으로 이동하는 다이얼로그 표시
  static Future<void> showPermissionSettingsDialog(
    BuildContext context, 
    String permissionType
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionType 권한 필요'),
          content: Text(
            '$permissionType 기능을 사용하려면 권한이 필요합니다.\n'
            '설정에서 권한을 허용하시겠습니까?'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('설정으로 이동'),
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
