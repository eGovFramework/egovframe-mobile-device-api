# 문서 뷰어 (File Opener)

## 개요

문서 뷰어 기능은 다양한 형식의 문서 파일을 열고 관리할 수 있는 기능입니다. PDF, Word, Excel, PowerPoint 등의 파일을 지원하며, 로컬 파일 목록을 조회하고 관리할 수 있습니다. 또한 웹서버에서 파일을 다운로드할 수 있습니다.

## 주요 기능

### 1. 파일 열기
- 다양한 형식의 파일을 열어볼 수 있습니다
- PDF, Word, Excel, PowerPoint 등 지원
- 파일 형식에 맞는 외부 앱을 실행하여 파일을 엽니다

### 2. 파일 관리
- 로컬 파일 목록을 조회하고 관리할 수 있습니다
- 파일 추가, 삭제 기능 제공

### 3. 서버 파일
- 서버에서 파일을 다운로드할 수 있습니다
- 서버 파일 목록 조회 및 다운로드 기능

### 4. 파일 검색
- 파일명이나 확장자로 검색할 수 있습니다
- 파일 타입별 필터링 지원

### 5. 파일 정렬
- 이름, 크기, 날짜순으로 정렬할 수 있습니다
- 오름차순/내림차순 선택 가능

### 6. 외부 앱 실행
- 파일 형식에 맞는 외부 앱을 실행하여 파일을 엽니다
- 지원되지 않는 파일 형식의 경우 권장 앱 다운로드 안내

## 아키텍처 구조

### Domain Layer
- **Entity**: `FileOpenerInfo`
  - `fileName`: 파일 이름
  - `filePath`: 파일 경로
  - `fileSize`: 파일 크기
  - `fileType`: 파일 타입 (document, text, spreadsheet, presentation, other)
  - `fileExtension`: 파일 확장자
  - `lastModified`: 수정일

- **Repository**: `FileOpenerRepository` (인터페이스)
- **UseCase**: `FileOpenerServerUseCase`

### Data Layer
- **Service**: `FileOpenerService`
  - 로컬 파일 목록 조회
  - 파일 열기
  - 파일 삭제
  - 서버 파일 다운로드

- **Repository Implementation**: `FileOpenerRepositoryImpl`

### Presentation Layer
- **Screen**: `FileOpenerScreen`
  - 파일 목록 표시
  - 파일 타입별 아이콘 표시
  - 파일 열기/삭제 기능
  - 서버 파일 목록 조회

## 의존성

- `open_file: ^3.3.2`: 파일 열기 기능
- `file_picker: ^8.0.0+1`: 파일 선택 기능
- `url_launcher: ^6.2.5`: 외부 앱 실행

## 화면 구성 및 사용 방법

### 메인 화면
<div style="width:300px; margin-bottom:10px;">
  <image src="images/fileOpener_main.png" alt="문서 뷰어 메인 화면">
</div>

로컬 파일 목록이 표시되며, 하단에 "파일 추가"와 "서버 목록" 버튼이 있습니다. 파일 타입에 따라 다른 색상의 아이콘이 표시됩니다.

>>**사용 방법**
- 하단의 "파일 추가" 버튼을 클릭하여 파일을 추가할 수 있습니다
- 파일 목록에서 파일을 탭하면 파일 형식에 맞는 외부 앱이 실행됩니다
- 파일 옆의 열기 아이콘을 클릭하여 파일을 열 수 있습니다
- 파일 옆의 삭제 아이콘을 클릭하여 파일을 삭제할 수 있습니다
- 하단의 "서버 목록" 버튼을 클릭하여 서버에 저장된 파일 목록을 확인할 수 있습니다

### 파일 미리보기
<div style="width:300px; margin-bottom:10px; display:flex; gap:10px;">
  <image src="images/fileOpener_preview-pdf.png" alt="문서 뷰어 미리보기 화면(pdf)">
  <image src="images/fileOpener_preview-hwp.png" alt="문서 뷰어 미리보기 화면(hwp)">
</div>
*좌측- pdf 파일 미리보기 / 우측 - hwp 파일 미리보기

>**사용 방법:**
- 파일을 탭하면 해당 파일 형식을 지원하는 외부 앱이 실행됩니다
- pdf파일의 경우 기본적으로 설치된 html 형식으로 미리보기가 실행되지만 지원되지 않는 파일 형식의 경우 권장 앱 다운로드 안내가 표시됩니다


### 서버 목록 조회

<div style="width:300px; margin-bottom:10px;">
  <image src="images/fileOpener_serverList.png" alt="문서 뷰어 서버 목록 화면">
</div>

서버에 저장된 파일 목록을 확인할 수 있습니다.

>**사용 방법:**
- 메인화면에서 "서버 목록" 버튼을 클릭하여 서버에 저장된 파일 목록을 확인할 수 있습니다
- 서버에 저장된 모든 파일 목록을 조회합니다
- 각 파일의 파일명, 파일 크기, 파일 타입, 업로드 날짜 등의 정보를 확인할 수 있습니다
- 파일 타입에 따라 다른 색상의 아이콘이 표시됩니다
- 목록은 최신순으로 정렬되어 표시됩니다

### 서버 목록 다운로드
<div style="width:300px; margin-bottom:10px;">
  <image src="images/fileOpener_serverDownload.png" alt="문서 뷰어 서버 다운로드 화면">
</div>

서버에 저장된 파일을 로컬로 다운로드할 수 있습니다.

>**사용 방법:**
- 각 파일의 다운로드 버튼을 클릭하여 서버에서 로컬로 파일을 다운로드할 수 있습니다
- 다운로드된 파일은 앱의 문서 디렉토리에 저장되며, 로컬 파일 목록에서 확인할 수 있습니다
- 다운로드된 파일은 외부 앱으로 열 수 있습니다
- 각 파일의 삭제 버튼을 클릭하여 서버에서 파일을 삭제할 수 있습니다
- 삭제된 파일은 서버에서 영구적으로 제거되며 복구할 수 없습니다
- 로컬에 다운로드된 파일은 삭제되지 않습니다

## 주의사항

- 일부 파일 형식은 외부 앱이 필요할 수 있습니다
- 파일을 열기 위해서는 해당 파일 형식을 지원하는 앱이 설치되어 있어야 합니다
- 서버 파일 다운로드를 사용하려면 웹서버가 실행 중이어야 합니다
- 대용량 파일의 경우 다운로드에 시간이 소요될 수 있습니다

## 기술적 특징

- **다양한 파일 형식 지원**: PDF, Word, Excel, PowerPoint 등 다양한 문서 형식 지원
  - Document: .pdf
  - Text: .txt, .md, .doc, .docx
  - Spreadsheet: .xls, .xlsx, .csv
  - Presentation: .ppt, .pptx
- **외부 앱 연동**: 파일 형식에 맞는 외부 앱 자동 실행
  - `open_file` 패키지를 사용하여 시스템의 기본 앱으로 파일을 엽니다
  - 지원되지 않는 파일 형식의 경우 권장 앱 다운로드 안내를 제공합니다
- **파일 타입 분류**: 파일 확장자에 따른 자동 분류 및 아이콘 표시
  - 파일 확장자를 분석하여 자동으로 타입을 분류합니다
  - 각 타입별로 다른 색상과 아이콘을 사용하여 시각적으로 구분합니다
- **파일 정렬 및 필터링**: 이름, 크기, 날짜순으로 정렬할 수 있으며, 파일 타입별 필터링을 지원합니다
- **서버 연동**: RESTful API를 통한 파일 다운로드
  - 서버에서 파일을 다운로드하여 로컬에 저장할 수 있습니다
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
