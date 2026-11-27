import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/application_list_main.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _initializeApplication();
  }

  Future<void> _initializeApplication() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ApplicationListMain(title: l10n.applicationListTitle),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: EgovColor.gray0,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // 외곽선 레이어
                Text(
                  l10n.loadingSplashAppName,
                  style: TextStyle(
                    fontSize: 48,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = EgovColor.primary50,
                  ),
                ),
                Text(
                  l10n.loadingSplashAppName,
                  style: TextStyle(fontSize: 48, color: EgovColor.white100),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.loadingSplashFrameworkName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: EgovColor.primary50,
                fontFamily: 'Pretendard GOV',
              ),
            ),
            const SizedBox(height: 40),
            // 로딩바
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(EgovColor.primary50),
            ),
          ],
        ),
      ),
    );
  }
}
