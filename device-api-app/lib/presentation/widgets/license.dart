import 'package:flutter/material.dart';

import 'infobox.dart';
import 'table.dart';

class License extends StatelessWidget {
  const License({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          InfoBox(
            text: '이 애플리케이션은 오픈소스 라이선스 하에 개발되었으며, Apache License 2.0을 따릅니다.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  CommonTable(
                    title: '라이선스 정보',
                    data: [
                      {'label': '라이선스', 'value': 'Apache License 2.0'},
                      {'label': '개발자', 'value': '전자정부 표준프레임워크'},
                      {'label': '버전', 'value': '5.0.0'},
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
