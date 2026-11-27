import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// 푸시(FCM)를 쓸 때 넣는 Firebase 설정.
/// 값이 비어 있으면 앱은 켜지고, 푸시만 동작하지 않는다.
/// 콘솔에서 앱을 등록한 뒤 이 파일과 android/app/google-services.json,
/// ios/Runner/GoogleService-Info.plist 를 교체한다.
/// 절차는 docs/applications/push.md 를 본다.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported for FCM in this app.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_FIREBASE_API_KEY',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'your-firebase-project',
    storageBucket: 'your-firebase-project.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_FIREBASE_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'your-firebase-project',
    storageBucket: 'your-firebase-project.firebasestorage.app',
    iosBundleId: 'egovframework.mobile-deviceapi',
  );
}