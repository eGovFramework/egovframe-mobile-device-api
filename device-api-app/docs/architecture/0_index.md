# Clean Architecture 가이드

> **이 가이드는 본 프로젝트에 적용된 Clean Architecture 패턴을 설명합니다.**

## Clean Architecture란?
![cleanArchitecture](../images/CleanArchitecture.jpg)

Clean Architecture는 로버트 C. 마틴(Robert C. Martin)이 제안한 소프트웨어 아키텍처 패턴으로, **의존성 역전 원칙(Dependency Inversion Principle)**을 중심으로 설계된 아키텍처입니다.

> [Clean Architecture- Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

### 핵심 개념

Clean Architecture는 소프트웨어를 **동심원 구조**로 구성하며, 각 레이어는 명확한 책임을 가지고 있습니다.</br>
    ![clena architecture layers](../images/CleanArchitecture_layerdi.jpg.png)

### 주요 특징

1. **의존성 방향**: 외부 레이어는 내부 레이어에 의존하지만, 내부 레이어는 외부 레이어에 의존하지 않음
2. **비즈니스 로직 독립성**: Domain 레이어는 프레임워크나 외부 라이브러리에 의존하지 않음
3. **테스트 용이성**: 각 레이어를 독립적으로 테스트 가능
4. **유지보수성**: 변경 사항이 다른 레이어에 영향을 최소화

### 프로젝트의 Clean Architecture 구조

1. **Domain 레이어는 순수 Dart 코드**: 외부 의존성 없이 비즈니스 로직에 집중
2. **의존성 방향**: Presentation → Domain ← Data
3. **인터페이스 기반 설계**: Repository 인터페이스를 통한 느슨한 결합
4. **Use Case 중심**: 비즈니스 로직을 Use Case로 명확히 분리
5. **의존성 주입**: GetIt을 통한 런타임 의존성 관리

## MVVM이 아닌 Clean Architecture 적용 이유

### 1. **복잡한 데이터 소스 관리**

이 프로젝트는 다양한 데이터 소스를 다룹니다:

- **로컬 데이터**: 디바이스 정보, GPS 위치, 파일 시스템
- **서버 API**: 디바이스 정보 업로드, 목록 조회
- **플랫폼 API**: Android/iOS 네이티브 기능

Clean Architecture를 통해 각 데이터 소스를 독립적으로 관리하고, 필요 시 쉽게 교체할 수 있습니다.

### 2. **다양한 기능 모듈**

프로젝트는 9개의 주요 기능 모듈을 포함합니다. 각 모듈이 동일한 아키텍처 패턴을 따르므로, 코드 일관성과 유지보수성이 향상됩니다.

### 3. **테스트 가능성**

Domain 레이어가 외부 의존성 없이 순수 Dart 코드로 작성되어 있어, 단위 테스트 작성이 용이합니다.

### 4. **의존성 관리**

GetIt을 사용한 의존성 주입을 통해:

- 런타임에 의존성 교체 가능
- Mock 객체 주입으로 테스트 용이
- 싱글톤 패턴으로 리소스 관리

## 가이드 목차

### 1. [프로젝트 구조](./project_structure.md)
- 프로젝트 디렉토리 구조
- 각 레이어의 역할과 위치
- 모듈별 구조 예시

### 2. [레이어 구조](./layers.md)
- Presentation Layer 상세 설명
- Domain Layer 상세 설명
- Data Layer 상세 설명
- 레이어 간 의존성 규칙

### 3. [의존성 역전 원칙](./dependency_inversion.md)
- 의존성 방향과 흐름
- 의존성 역전의 구현
- 단계별 설명

### 4. [실제 코드 예시](./examples.md)
- Device Info 기능 전체 예시
- 각 레이어별 코드 설명
- 실제 프로젝트 코드 기반

### 5. [의존성 주입](./dependency_injection.md)
- GetIt을 사용한 의존성 주입
- 의존성 주입 설정
- 실제 사용 예시

### 6. [에러 처리](./error_handling.md)
- 통합 에러 핸들러
- 에러 타입별 처리
- 실제 사용 예시