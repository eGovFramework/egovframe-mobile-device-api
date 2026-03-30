import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

class CommonTable extends StatelessWidget {
  final String title;
  final List<Map<String, String>> data;

  const CommonTable({
    super.key,
    required this.title,
    required this.data,
  });

    @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: EgovColor.white100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: EgovColor.black10,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: EgovColor.black10.withOpacity(0.38),
            blurRadius: 28,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: EgovColor.secondary5,
              border: Border(
                bottom: BorderSide(
                  color: EgovColor.secondary10,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              title,
              style: EgovText.medium.copyWith(
                color: EgovColor.gray95,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          // 테이블 내용
          ...data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == data.length - 1;

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: EgovColor.white100,
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(
                          color: EgovColor.secondary10,
                          width: 1,
                        ),
                      ),
              ),
              child: Row(
                children: [
                  // 라벨 컬럼
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        item['label']!,
                        style: EgovText.medium.copyWith(
                          color: EgovColor.gray70,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  // 값 컬럼
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        item['value']!,
                        style: EgovText.regular.copyWith(
                          color: EgovColor.gray70,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
                     }).toList(),
         ],
       ),
     ),
   );
 }
}
