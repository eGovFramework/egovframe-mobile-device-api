# 새 기능 등록

화면을 복사한 뒤에도 앱 목록과 서버에 올리려면 아래 파일을 같이 맞춰야 한다.  
어떤 화면을 복사할지는 [Flutter 활용 보완](../presentation/11_flutter_practices.md) 1절이다. 서버 CRUD는 GPS, 카메라·온디바이스는 얼굴 메시, 로컬 전용은 파일 관리를 본다.

`targetPage` 문자열은 `data/app_list_data.json`, `app_list.dart`, `app_navigation.dart`, `api_feature_shell_config.dart`에서 같아야 한다. 하나라도 다르면 목록에는 나와도 화면이 열리지 않거나, 셸의 다른 기능으로 넘어간다.

## 1. 앱에 올리기

| 순서 | 파일 | 넣을 것 |
|------|------|---------|
| 1 | `lib/domain/{feature}/` | entity, repository 인터페이스, usecase, sealed result |
| 2 | `lib/data/{feature}/` | service, remote·sqlite repository, facade |
| 3 | `lib/presentation/screens/{feature}/` | `state`, `view`, `view_model`, `widgets` |
| 4 | `lib/di/providers.dart` | `@Riverpod(keepAlive: true)` repository·usecase |
| 5 | `lib/di/{feature}_connection_provider.dart` | 서버/SQLite 모드. 로컬 전용이면 생략. [서버와 SQLite 전환](./11_server_sqlite_connection.md) |
| 6 | `data/app_list_data.json` | `title`, `subtitle`, `description`, `iconUrl`, `targetPage` |
| 7 | `lib/presentation/widgets/app_list.dart` | `targetPage` → 메인 페이지 |
| 8 | `lib/presentation/widgets/app_navigation.dart` | 같은 `targetPage` → 같은 페이지 |
| 9 | `lib/presentation/widgets/api_feature_shell_config.dart` | `ApiFeature`와 `targetPage`. 파일 관리·SQLite Manager는 `FeatureShell`만 쓴다 |
| 10 | `lib/config/app_config.dart` | `endpoint`, 테이블명, `getXxxUrl` |
| 11 | `lib/l10n/app_ko.arb`, `app_en.arb` | 같은 키. 절차는 [국제화](../presentation/12_l10n.md) |
| 12 | `lib/l10n/message_keys/{feature}_message_keys.dart` | 도메인 오류 키 |
| 13 | `lib/l10n/app_message_resolver.dart` | 키 → `l10n` 분기 |

코드 생성이 필요하면 `dart run build_runner build --delete-conflicting-outputs`, 문구를 넣었으면 `flutter gen-l10n`을 실행한다.

기능 설명 문구는 `*FunctionPage`와 l10n을 쓴다. `data/feature_data.json`은 예전 가이드 페이지용으로 남아 있다.

## 2. 서버에 올리기

device-api-web에 기능 패키지를 두고, 앱의 `endpoint`와 경로를 맞춘다.

| 넣을 것 | 위치 |
|---------|------|
| Controller·Service·DAO | `egovframework/hyb/mbl/{약어}/` |
| MyBatis XML | `src/main/resources/egovframework/hyb/mapper/mbl/{약어}/` |
| DDL | `script/mysql/ddl/deviceapi_all_create_mysql.sql` |
| Swagger 그룹 | `SpringDocConfig`. 번호는 기존 태그와 겹치지 않게 한다. IoT가 이미 `17`이면 AI 채팅은 `18`을 유지한다 |

목록 API가 빈 uuid에 HTTP 400을 주면, 앱 `probe`에도 기기 uuid를 붙인다. [기기 UUID](./10_device_uuid.md).

서버를 지운 기능의 mapper XML이 `target/classes`에 남으면 MyBatis 갱신이 실패하고 포트 9700이 내려갈 수 있다. 소스를 지운 뒤 `target`의 같은 mapper 디렉터리도 지우고 서버를 다시 띄운다.

## 3. SQLite를 둘 때

1. `config/{feature}_sqlite_schema.dart`에 `tableName`, `requiredColumns`, `optionalColumns`를 둔다. 컬럼은 MySQL 테이블과 맞춘다.
2. `di`의 `FeatureTableService`로 SQLite 서비스를 만든다.
3. 샘플 DB가 필요하면 `data/sql/`에 두고, 가져오기 안내는 Resolver가 담당한다.

## 4. 체크리스트

- [ ] `targetPage`가 JSON·`app_list`·`app_navigation`·셸 설정에서 같은가
- [ ] `providers.dart`에 usecase가 있고, 화면이 service를 직접 만들지 않는가
- [ ] 목록 API의 400 조건과 `probe` 쿼리가 같은가
- [ ] `app_ko.arb`와 `app_en.arb`를 같이 고치고 `flutter gen-l10n`을 돌렸는가
- [ ] `@riverpod`을 추가했으면 `build_runner`로 `*.g.dart`를 만들었는가
- [ ] 서버 mapper를 지웠으면 `target/classes`의 남은 XML도 지웠는가
