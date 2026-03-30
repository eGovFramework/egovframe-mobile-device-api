import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
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
