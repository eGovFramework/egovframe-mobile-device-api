import 'dart:convert';

import 'package:flutter/services.dart';

class TextService {
  static Map<String, dynamic>? _textData;
  
  // JSON 파일 로드
  static Future<void> loadTextData() async {
    try {
      // 먼저 data/feature_data.json을 시도
      try {
        final String jsonString = await rootBundle.loadString('data/feature_data.json');
        _textData = json.decode(jsonString);
        return;
      } catch (e) {
        // feature_data.json이 없으면 text_data.json 시도
        final String jsonString = await rootBundle.loadString('assets/text_data.json');
        _textData = json.decode(jsonString);
        return;
      }
    } catch (e) {
      print('JSON 파일 로드 실패: $e');
    }
  }
  
  // 특정 섹션의 데이터 가져오기
  static Map<String, dynamic>? getSectionData(String section, String key) {
    return _textData?[section]?[key];
  }
  
  // 특정 섹션의 제목 가져오기
  static String? getTitle(String section, String key) {
    final data = _textData?[section]?[key];
    return data?['title'];
  }
  
  // 특정 섹션의 내용 가져오기
  static String? getContent(String section, String key) {
    final data = _textData?[section]?[key];
    return data?['content'];
  }
  
  // 특정 섹션의 리스트 데이터 가져오기
  static List<String>? getListData(String section, String key) {
    final data = _textData?[section]?[key];
    return data?['items']?.cast<String>();
  }
  
  // 전체 섹션 데이터 가져오기
  static Map<String, dynamic>? getSection(String section) {
    return _textData?[section];
  }
}

