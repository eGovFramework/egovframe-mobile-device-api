# 가속도계 (Accelerator)

## 개요

가속도계 기능은 디바이스의 3축 가속도 정보를 실시간으로 모니터링하고 시각화하는 기능입니다. Three.js 기반의 3D 도형을 통해 가속도 변화를 직관적으로 확인할 수 있으며, 수집된 데이터를 서버에 저장하고 관리할 수 있습니다.

## 주요 기능

### 1. 실시간 가속도 정보 조회
- 디바이스 API를 통해 현재 가속도 정보를 실시간으로 호출
- X축, Y축, Z축 가속도 값을 모니터링 창에 표시
- 3D 도형을 통해 가속도 방향으로 도형 회전 시각화

### 2. 가속도 정보 저장
- 현재 가속도 정보를 서버에 저장
- Interface API를 통해 RESTful 방식으로 서버 전송
- 디바이스 UUID와 타임스탬프 정보 포함

### 3. 가속도 정보 목록 조회
- 서버에 저장된 가속도 정보 목록을 리스트 형태로 출력
- 저장된 데이터의 상세 정보 확인 가능

### 4. 리스트 삭제
- 서버 내의 가속도 정보 목록 삭제 기능

## 아키텍처 구조

### Domain Layer
- **Entity**: `AcceleratorInfo`
  - `uuid`: 디바이스 고유 식별자
  - `xAxis`: X축 가속도 값
  - `yAxis`: Y축 가속도 값
  - `zAxis`: Z축 가속도 값
  - `timestamp`: 타임스탬프
  - `useYn`: 사용 여부

- **Repository**: `AcceleratorRepository` (인터페이스)
- **UseCase**: `AcceleratorUseCase`

### Data Layer
- **Service**: `AccelerometerService`
  - 가속도계 센서 스트림 관리
  - 가속도 데이터 수집 및 처리
  - 서버 전송 로직

- **Repository Implementation**: `AcceleratorRepositoryImpl`

### Presentation Layer
- **Screen**: `AcceleratorInfoPage`
  - 실시간 가속도 정보 표시
  - 3D 도형 시각화 (`ThreeDCube`)
  - 가속도 값 표시 (`AccelerationDisplay`)
  - 저장 및 목록 조회 기능

## 의존성

- `sensors_plus: ^4.0.2`: 가속도계 센서 데이터 수집

## 화면 구성 및 사용 방법

### 메인 화면
<div style="width:300px; margin-bottom:10px;">
  <image src="images/accelerator_main.png" alt="가속도계 메인 화면">
</div>

앱 실행 시 자동으로 가속도계 센서가 활성화됩니다. 화면 상단의 3D 도형이 디바이스 움직임에 따라 회전하며, 하단에 X, Y, Z축 가속도 값이 실시간으로 표시됩니다.

>**사용 방법**
- 앱을 실행하면 자동으로 가속도 정보가 수집됩니다
- 디바이스를 움직이면 3D 도형이 해당 방향으로 회전합니다
- 하단의 "저장" 버튼을 클릭하면 현재 가속도 정보가 서버에 저장됩니다
- 하단의 "목록" 버튼을 클릭하면 서버에 저장된 가속도 정보 목록을 확인할 수 있습니다

### 3D 도형 시각화
Three.js 기반의 3D 도형을 통해 가속도 변화를 직관적으로 확인할 수 있습니다. 디바이스를 기울이면 도형이 해당 방향으로 회전합니다.

### 가속도 정보 표시
X축, Y축, Z축 가속도 값과 타임스탬프가 실시간으로 표시됩니다. 각 축의 값을 통해 디바이스의 움직임을 정확히 파악할 수 있습니다.

### 가속도 목록 조회
<div style="width:300px; margin-bottom:10px;">
  <image src="images/accelerator_list.png" alt="가속도 정보 목록">
</div>

서버에 저장된 가속도 정보 목록을 확인할 수 있습니다.

>**사용 방법:**
- 서버에 저장된 모든 가속도 정보 목록을 조회합니다
- 각 항목의 UUID, X축, Y축, Z축 가속도 값, 타임스탬프 정보를 확인할 수 있습니다
- 목록은 최신순으로 정렬되어 표시됩니다
- "목록 삭제"를 눌러 목록을 전부 삭제할 수 있습니다.

### 가속도 상세 정보
<div style="width:300px; margin-bottom:10px;">
  <image src="images/accelerator_detail.png" alt="가속도 정보 목록">
</div>

서버에 저장된 가속도의 상세한 정보를 확인할 수 있습니다.

### 서버 목록 삭제
<div style="width:300px; display:flex; gap:10px; margin-bottom:10px;">
  <image src="images/accelerator_delete(1).png" alt="가속도 정보 목록">
  <image src="images/accelerator_delete(2).png" alt="가속도 정보 목록">
</div>

서버에 저장된 가속도 정보를 삭제할 수 있습니다.

>**사용 방법:**
- 개별 삭제: 가속도 정보 상세 화면에서 각 항목의 삭제 버튼을 클릭하여 개별 항목을 삭제할 수 있습니다
- 일괄 삭제: 가속도 목록의 "목록 삭제" 버튼을 클릭하여 모든 가속도 정보를 한 번에 삭제할 수 있습니다
- 삭제된 데이터는 서버에서 영구적으로 제거되며 복구할 수 없습니다

## 주의사항

- 앱이 백그라운드로 이동하면 가속도계 센서가 자동으로 중지됩니다
- 앱이 포그라운드로 복귀하면 센서가 자동으로 재시작됩니다
- 서버 저장 기능을 사용하려면 웹서버가 실행 중이어야 합니다
- 배터리 사용량이 증가할 수 있습니다

## 기술적 특징

- **실시간 스트리밍**: `sensors_plus` 패키지를 사용한 실시간 가속도 데이터 수집
- **3D 시각화**: Three.js 기반 3D 도형을 통한 직관적인 가속도 표현
- **생명주기 관리**: 앱 생명주기에 따른 센서 자동 제어
  - 앱이 백그라운드로 이동하면 센서 스트림이 자동으로 중지되어 배터리 소모를 방지합니다
  - 앱이 포그라운드로 복귀하면 센서가 자동으로 재시작됩니다
- **데이터 형식**: 가속도 값은 double 타입으로 저장되며, 타임스탬프는 밀리초 단위 Unix timestamp를 사용합니다
- **서버 통신**: Interface API를 통해 RESTful 방식으로 서버에 전송되며, 디바이스 UUID와 함께 저장됩니다
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
