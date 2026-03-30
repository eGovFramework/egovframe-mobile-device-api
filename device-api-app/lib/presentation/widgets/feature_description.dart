import 'package:flutter/material.dart';

import 'infobox.dart';
import 'long_text_list_box.dart';
import 'table.dart';
import 'text_box.dart';

class FeatureDescription extends StatelessWidget {
  final Map<String, dynamic>? jsonData;
  final Widget? additionalContent;
  final String infoBoxText;
  final String tableTitle;
  final List<Map<String, String>> tableData;

  const FeatureDescription({
    super.key,
    this.jsonData,
    this.additionalContent,
    required this.infoBoxText,
    required this.tableTitle,
    required this.tableData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // infoBoxText를 항상 맨 위에 표시
        if (infoBoxText.isNotEmpty) ...[
          InfoBox(text: infoBoxText),
          const SizedBox(height: 16),
        ],
        
        // JSON 데이터가 있으면 위젯들 표시
        if (jsonData != null) ...[
          // title1 텍스트박스
          if (jsonData!['title1'] != null)
            TextBox(
              title: jsonData!['title1']['title'] ?? '',
              content: jsonData!['title1']['content'] ?? '',
            ),
          
          // featureDescription 리스트박스
          if (jsonData!['featureDescription'] != null)
            LongTextListBox(
              title: jsonData!['featureDescription']['title'] ?? '',
              items: (jsonData!['featureDescription']['items'] as List<dynamic>?)?.cast<String>() ?? [],
            ),
          
          // usageGuide 텍스트박스 (있는 경우)
          if (jsonData!['usageGuide'] != null)
            TextBox(
              title: jsonData!['usageGuide']['title'] ?? '',
              content: jsonData!['usageGuide']['content'] ?? '',
            ),
        ],
        
        // tableData 표시
        if (tableData.isNotEmpty) ...[
          const SizedBox(height: 16),
          CommonTable(
            title: tableTitle,
            data: tableData,
          ),
        ],
        
        // 추가 콘텐츠 (선택적)
        if (additionalContent != null) ...[
          const SizedBox(height: 16),
          additionalContent!,
        ],
      ],
    );
  }
} 
