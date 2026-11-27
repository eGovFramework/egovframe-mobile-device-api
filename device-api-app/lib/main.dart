import 'package:egovframe_mobile_deviceapi_app/data/push/datasources/firebase_messaging_service.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/loading_page.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SqliteConfig.downloadsMethodChannel =
      'egovframe_mobile_deviceapi_app/downloads';
  if (kDebugMode) {
    SqliteConfig.onLog = appLog;
  }

  await FirebaseMessagingService.initializeFirebase();
  
  // 화면 회전을 세로 모드로 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World Flutter',
      locale: const Locale('ko', 'KR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0072B2)),
        useMaterial3: true,
        fontFamily: 'Pretendard GOV',
      ),
      home: const LoadingPage(),
    );
  }
}
