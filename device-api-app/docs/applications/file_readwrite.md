# 파일 읽기/쓰기 (File Read/Write)

## 개요

파일 읽기/쓰기 기능은 로컬 파일을 생성, 조회, 삭제하고 서버와 파일을 주고받을 수 있는 기능입니다. 텍스트 파일을 생성하고 편집할 수 있으며, 로컬 파일 목록을 조회하고 미리보기를 제공합니다. 또한 파일을 서버로 업로드하거나 서버에서 다운로드할 수 있습니다.

## 주요 기능

### 1. 파일 생성
- 텍스트 파일 생성 및 편집 기능을 제공합니다
- 파일 이름과 내용을 입력하여 파일을 생성합니다
- 자동으로 .txt 확장자 추가

### 2. 파일 조회
- 로컬 파일 목록 조회 및 미리보기 기능을 제공합니다
- 텍스트 파일 내용 확인
- 이미지 및 비디오 파일 미리보기 지원

### 3. 파일 삭제
- 로컬 파일 삭제 기능을 제공합니다
- 다중 선택 후 일괄 삭제 가능

### 4. 파일 업로드
- 로컬 파일을 서버로 업로드하는 기능을 제공합니다
- 다중 파일 선택 후 일괄 업로드 가능
- 업로드 진행 상황 표시

### 5. 파일 다운로드
- 서버 파일을 로컬로 다운로드하는 기능을 제공합니다
- 서버 파일 목록에서 다운로드 가능

### 6. 서버 파일 관리
- 서버 파일 목록 조회 및 삭제 기능을 제공합니다
- 서버에 저장된 파일 정보 확인

## 아키텍처 구조

### Domain Layer
- **Entity**: `FileReadWriteInfo`
  - `sn`: 일련번호
  - `fileSn`: 파일 일련번호
  - `uuid`: 디바이스 고유 식별자
  - `fileName`: 파일 이름
  - `filePath`: 파일 경로
  - `fileSize`: 파일 크기
  - `uploadDate`: 업로드 날짜
  - `useYn`: 사용 여부

- **Repository**: `FileReadWriteRepository` (인터페이스)
- **UseCase**: `FileReadWriteUseCase`

### Data Layer
- **Service**: `FileReadWriteService`
  - 로컬 파일 읽기/쓰기
  - 파일 목록 조회
  - 서버 업로드/다운로드

- **Repository Implementation**: `FileReadWriteRepositoryImpl`

### Presentation Layer
- **Screen**: `FileReadWriteMainPage`
  - 파일 생성 다이얼로그
  - 파일 목록 표시
  - 파일 미리보기
  - 업로드/다운로드 기능

## 의존성

- `path_provider: ^2.1.2`: 파일 경로 관리
- `http: ^1.5.0`: 서버 통신
- `video_player: ^2.8.2`: 비디오 미리보기

## 화면 구성 및 사용 방법

### 메인 화면
<div style="width:300px; margin-bottom:10px;">
  <image src="images/fileReaderWriter_main.png" alt="파일 읽기/쓰기 메인 화면">
</div>

로컬 파일 목록이 표시되며, 상단에 "파일 생성"과 "서버 파일 목록" 버튼이 있습니다. 각 파일의 이름, 크기, 수정일 정보가 표시됩니다.

>**사용 방법**
- 상단의 "파일 생성" 버튼을 클릭하여 새 파일을 생성할 수 있습니다
- 파일을 탭하여 내용을 확인하거나 미리보기를 볼 수 있습니다
- 파일을 탭하여 선택한 후 하단의 "업로드" 버튼으로 서버에 업로드할 수 있습니다
- 파일을 탭하여 선택한 후 하단의 "삭제" 버튼으로 삭제할 수 있습니다
- 상단의 "서버 파일 목록" 버튼을 클릭하여 서버에 저장된 파일 목록을 확인할 수 있습니다

### 파일 생성 다이얼로그
<div style="width:300px; margin-bottom:10px; display:flex; gap:10px;">
  <image src="images/fileReaderWriter_create.png" alt="파일 읽기/쓰기 파일 생성 화면">
  <image src="images/fileReaderWriter_create-result.png" alt="파일 읽기/쓰기 파일 생성 화면">
</div>

파일 이름과 내용을 입력하여 새 텍스트 파일을 생성할 수 있습니다. 파일 이름에 확장자가 없으면 자동으로 .txt가 추가됩니다.

>**사용 방법**
- 파일 이름을 입력합니다 (예: example.txt)
- 파일 내용을 입력합니다
- "생성" 버튼을 클릭하여 파일을 생성합니다.

### 편집 모드
<div style="width:300px; margin-bottom:10px;">
  <image src="images/fileReaderWriter_editmode.png" alt="파일 읽기/쓰기 편집모드 화면">
</div>

>**사용 방법**
- 파일을 눌러 편집모드에 진입한 후 '업로드' 또는 '삭제' 기능을 수행할 수 있습니다.
- 여러 개의 파일을 선택할 수 있는 다중선택 기능을 제공합니다.

### 업로드
<div style="width:300px; margin-bottom:10px; display:flex; gap:10px;">
  <image src="images/fileReaderWriter_serverList.png" alt="파일 읽기/쓰기 서버 목록 화면">
  <image src="images/fileReaderWriter_upload.png" alt="파일 읽기/쓰기 로컬 업로드 화면">
  <image src="images/fileReaderWriter_upload-result.png" alt="파일 읽기/쓰기 로컬 업로드 화면">
</div>

</br>
로컬 디바이스에서 '업로드'버튼을 통해 서버로 파일을 업로드할 수 있습니다.</br>
*예시) 서버목록 확인(1개) > 로컬에서 파일 업로드(test.txt) > 서버목록에 추가된 파일 확인 (2개)


### 서버 목록 조회
<div style="width:300px; margin-bottom:10px;">
  <image src="images/fileReaderWriter_serverList.png" alt="파일 읽기/쓰기 서버 목록 화면">
</div>

서버에 저장된 파일 목록을 확인할 수 있습니다.

>**사용 방법**
- 상단의 "서버 파일 목록" 버튼을 클릭하여 서버에 저장된 파일 목록을 확인할 수 있습니다
- 서버에 저장된 모든 파일 목록을 조회합니다
- 각 파일의 일련번호, 파일명, 파일 크기, 업로드 날짜 등의 정보를 확인할 수 있습니다
- 목록은 최신순으로 정렬되어 표시됩니다

### 서버 목록 상세
<div style="width:300px; margin-bottom:10px;">
  <image src="images/fileReaderWriter_detail.png" alt="파일 읽기/쓰기 서버 상세 화면">
</div>

서버에 등록된 파일 목록을 눌러 파일에 대한 상세 정보를 확인하고 관리할 수 있습니다. </br>
삭제 버튼을 눌러 서버 목록에서 삭제할 수 있으나 삭제 후에도 로컬목록에서 삭제되지는 않습니다.

## 주의사항

- 파일 작업 시 저장소 권한이 필요합니다.
- 대용량 파일의 경우 업로드 및 다운로드에 시간이 소요될 수 있습니다.
- 서버 저장 기능을 사용하려면 웹서버가 실행 중이어야 합니다
- 텍스트 파일만 직접 편집할 수 있으며, 다른 형식의 파일은 미리보기만 가능합니다

## 기술적 특징

- **파일 I/O**: Dart의 `dart:io` 패키지를 사용한 파일 읽기/쓰기
  - 텍스트 파일은 UTF-8 인코딩으로 읽고 쓸 수 있습니다
  - 파일 이름에 확장자가 없으면 자동으로 .txt 확장자가 추가됩니다
- **지원 파일 형식**: 
  - 텍스트 파일: .txt
  - 이미지 파일: .jpg, .jpeg, .png, .gif, .bmp, .webp
  - 비디오 파일: .mp4, .avi, .mov, .wmv, .flv, .webm
  - 오디오 파일: .mp3, .wav, .aac, .ogg, .m4a
- **미디어 미리보기**: 이미지 및 비디오 파일의 인앱 미리보기 지원
  - 이미지는 `InteractiveViewer`를 사용하여 확대/축소가 가능합니다
  - 비디오는 `video_player` 패키지를 사용하여 재생할 수 있습니다
- **파일 선택**: 파일을 탭하여 선택/해제할 수 있으며, 선택된 파일은 시각적으로 강조됩니다
- **다중 파일 처리**: 여러 파일을 선택하여 일괄 작업 가능
  - 업로드 및 삭제 작업은 선택된 파일에 대해 일괄 처리됩니다
- **서버 연동**: RESTful API를 통한 파일 업로드/다운로드
  - 파일 업로드 시 multipart/form-data 형식을 사용합니다
  - 업로드 진행 상황은 각 파일별로 처리되며, 성공/실패 개수를 표시합니다
