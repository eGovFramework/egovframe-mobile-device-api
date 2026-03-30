import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:flutter/material.dart';

class FileFunctionPage extends StatelessWidget {
  const FileFunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              'File Management API',
              style: EgovText.title.copyWith(
                color: EgovColor.primary50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '모바일 디바이스의 파일 시스템을 관리하는 API',
              style: EgovText.subtitle.copyWith(
                color: EgovColor.gray70,
              ),
            ),
            const SizedBox(height: 24),
            
            // API 개요
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EgovColor.primary5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EgovColor.primary20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description, color: EgovColor.primary50, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'API 개요',
                        style: EgovText.medium.copyWith(
                          color: EgovColor.primary50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'File Management API는 모바일 디바이스의 파일 시스템에 접근하여 파일과 폴더를 생성, 수정, 삭제, 복사, 이동할 수 있는 기능을 제공합니다. 앱의 문서 디렉토리 내에서 안전하게 파일 관리 작업을 수행할 수 있습니다.',
                    style: EgovText.regular.copyWith(
                      color: EgovColor.gray80,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 주요 기능
            Text(
              '주요 기능',
              style: EgovText.subtitle.copyWith(
                color: EgovColor.gray90,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            CommonTable(
              title: '파일 관리 기능',
              data: [
                {
                  'label': '폴더 생성',
                  'value': '새로운 디렉토리를 생성하여 파일을 체계적으로 관리'
                },
                {
                  'label': '파일 생성',
                  'value': '다양한 형식의 샘플 파일을 생성하여 기능 테스트'
                },
                {
                  'label': '파일 탐색',
                  'value': '디렉토리 구조를 시각적으로 탐색하고 파일 목록 확인'
                },
                {
                  'label': '파일 복사',
                  'value': '선택한 파일이나 폴더를 다른 위치에 복사본 생성'
                },
                {
                  'label': '파일 이동',
                  'value': '선택한 파일이나 폴더를 다른 디렉토리로 이동'
                },
                {
                  'label': '파일 삭제',
                  'value': '불필요한 파일이나 폴더를 안전하게 삭제'
                },
                {
                  'label': '파일 정보',
                  'value': '파일 크기, 수정일, 항목 수 등 상세 정보 표시'
                },
                {
                  'label': '다중 선택',
                  'value': '여러 파일을 동시에 선택하여 일괄 작업 수행'
                },
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 사용 방법
            Text(
              '사용 방법',
              style: EgovText.subtitle.copyWith(
                color: EgovColor.gray90,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // 기본 조작
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EgovColor.gray5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EgovColor.gray20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.touch_app, color: EgovColor.primary50, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '기본 조작',
                        style: EgovText.medium.copyWith(
                          color: EgovColor.gray90,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• 폴더 생성: 우상단 메뉴 → "새 폴더"\n'
                    '• 샘플 파일 생성: 우상단 메뉴 → "샘플 파일 생성"\n'
                    '• 폴더 진입: 폴더를 탭하여 하위 디렉토리로 이동\n'
                    '• 뒤로가기: 상단 뒤로가기 버튼으로 상위 디렉토리로 이동',
                    style: EgovText.regular.copyWith(
                      color: EgovColor.gray80,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 선택 모드 조작
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EgovColor.warning5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EgovColor.warning20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.checklist, color: EgovColor.warning50, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '선택 모드 조작',
                        style: EgovText.medium.copyWith(
                          color: EgovColor.warning50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• 선택 모드 진입: 파일이나 폴더를 길게 누르기\n'
                    '• 다중 선택: 체크박스를 탭하여 추가 선택\n'
                    '• 복사: 하단 "복사" 버튼으로 대상 폴더 선택\n'
                    '• 이동: 하단 "이동" 버튼으로 대상 폴더 선택\n'
                    '• 삭제: 하단 "삭제" 버튼으로 확인 후 삭제\n'
                    '• 선택 취소: 상단 X 버튼으로 선택 모드 종료',
                    style: EgovText.regular.copyWith(
                      color: EgovColor.gray80,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 지원 파일 형식
            Text(
              '지원 파일 형식',
              style: EgovText.subtitle.copyWith(
                color: EgovColor.gray90,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EgovColor.gray5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EgovColor.gray20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '텍스트 파일',
                    style: EgovText.medium.copyWith(
                      color: EgovColor.gray90,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• .txt - 일반 텍스트 파일\n'
                    '• .json - JSON 데이터 파일\n'
                    '• .md - 마크다운 문서 파일\n'
                    '• .log - 로그 파일\n'
                    '• .csv - CSV 데이터 파일',
                    style: EgovText.regular.copyWith(
                      color: EgovColor.gray70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '폴더',
                    style: EgovText.medium.copyWith(
                      color: EgovColor.gray90,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• 모든 폴더 생성 및 관리 지원\n'
                    '• 중첩된 폴더 구조 지원\n'
                    '• 폴더 내 항목 수 표시',
                    style: EgovText.regular.copyWith(
                      color: EgovColor.gray70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 주의사항
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EgovColor.danger5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EgovColor.danger20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: EgovColor.danger50, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '주의사항',
                        style: EgovText.medium.copyWith(
                          color: EgovColor.danger50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• 삭제된 파일은 복구할 수 없으므로 신중하게 선택하세요\n'
                    '• 앱의 문서 디렉토리 내에서만 작업이 가능합니다\n'
                    '• 시스템 파일이나 다른 앱의 파일은 접근할 수 없습니다\n'
                    '• 대용량 파일 작업 시 시간이 소요될 수 있습니다',
                    style: EgovText.regular.copyWith(
                      color: EgovColor.gray80,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
