import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/app_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:flutter/material.dart';

class ApplicationListMain extends StatefulWidget {
  const ApplicationListMain({super.key, required this.title});

  final String title;

  @override
  State<ApplicationListMain> createState() => _ApplicationListMainState();
}

class _ApplicationListMainState extends State<ApplicationListMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: const AppList(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          color: EgovColor.primary50,
          border: Border(
            top: BorderSide(
              color: EgovColor.gray30,
              width: 1,
            ),
          ),
        ),
        child: const Text(
          'Copyright 2025',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Pretendard GOV',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

