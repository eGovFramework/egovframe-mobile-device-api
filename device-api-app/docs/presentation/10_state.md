# 10. Flutter State 초보자 가이드

> 목표: **Flutter에서 state가 무엇인지**, 화면이 언제 다시 그려지는지,  
> 어떤 방식으로 상태를 다루는지를 처음부터 이해한다.  
> 이 프로젝트 코드는 **예시**로만 쓴다.  
> 목차: [0_index](./0_index.md)

---

## 1. State란?

**State(상태)** = 시간이 지나며 **바뀔 수 있는 값**이고,  
그 값이 바뀌면 **화면도 그에 맞게 다시 보여줘야** 하는 정보.

| 예 | state인가? |
|----|------------|
| 버튼에 적힌 고정 글자 `'저장'` | 보통 아님 (상수 UI) |
| 지금 로딩 중인가? (`true`/`false`) | ✅ |
| 서버에서 받은 목록 20건 | ✅ |
| 체크박스로 고른 항목 | ✅ |
| 입력창에 사용자가 친 글자 | ✅ |

Flutter UI는 **함수처럼 “지금 state → 화면”** 으로 그려진다.  
state가 바뀌면 “다시 그려 줘”라고 알려야 한다.

```
state (데이터)  ──변경──►  프레임워크에 알림  ──►  build() 다시 실행  ──►  새 화면
```

---

## 2. 위젯과 build — 화면은 “설명서”

Flutter에서 화면에 보이는 것은 대부분 **Widget**이다.  
Widget은 “이렇게 그려라”는 **설정(설명)** 에 가깝고,  
실제로 그려지는 과정은 프레임워크가 `build` 결과를 가지고 수행한다.

```dart
@override
Widget build(BuildContext context) {
  // 지금 알고 있는 값으로 “이번 프레임의 UI 설명”을 반환
  return Text('안녕하세요');
}
```

- `build`는 **여러 번** 호출될 수 있다.
- 그래서 `build` 안에서 “서버에 저장” 같은 **부수 효과**를 넣으면 안 된다.
- state가 바뀌면 관련된 위젯의 `build`가 다시 돌고, 화면이 갱신된다.

---

## 3. StatelessWidget vs StatefulWidget

Flutter가 기본으로 제공하는 **두 가지 위젯 유형**이다.

### 3.1 `StatelessWidget` — 스스로 변하는 값이 없음

한 번 만들어질 때 받은 값(생성자 파라미터)으로만 그린다.  
위젯 **자신**이 “기억해서 바꾸는” 값이 없다.

```dart
class HelloLabel extends StatelessWidget {
  final String name;
  const HelloLabel({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('안녕, $name');
  }
}
```

- `name`이 바뀌려면 **부모**가 다른 값으로 이 위젯을 **다시 만들어** 넘겨야 한다.
- 이 프로젝트의 `InfoBox`, `CommonTable`, 많은 카드 위젯이 이런 형태에 가깝다.

### 3.2 `StatefulWidget` — 위젯이 값을 기억하고 바꿀 수 있음

두 클래스가 한 세트다.

| 클래스 | 역할 |
|--------|------|
| `StatefulWidget` | 설정(생성자 파라미터). 비교적 짧게 존재할 수 있음 |
| `State` | **오래 살아남으며** 값(`_count` 등)을 들고 `setState`로 갱신 |

```dart
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0; // ← 이 위젯의 state

  void _increment() {
    setState(() {
      _count++; // 값을 바꾼 뒤 “다시 그려”라고 알림
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_count'),
        ElevatedButton(onPressed: _increment, child: const Text('+1')),
      ],
    );
  }
}
```

### 3.3 `setState`가 하는 일

1. 괄호 안에서 state 필드를 수정한다.  
2. Flutter에게 “이 `State`에 연결된 UI를 다시 `build`해라”고 표시한다.  
3. 다음 프레임에 `build`가 다시 실행되어 새 UI가 반영된다.

```dart
// ❌ 이렇게만 하면 숫자는 바뀌어도 화면이 안 바뀔 수 있음
_count++;

// ✅ setState로 감싸야 다시 그림
setState(() {
  _count++;
});
```

**주의**
- `setState` 안에서 **오래 걸리는 await**(네트워크)를 직접 돌리지 않는 것이 좋다.  
  먼저 로딩 플래그를 `setState`로 켠 뒤, 비동기는 바깥에서 처리하는 식이 안전하다.
- 위젯이 이미 dispose된 뒤 `setState` 하면 에러 → `if (!mounted) return;` 패턴을 쓴다.

---

## 4. 이 프로젝트의 Page 위젯: `ConsumerStatefulWidget`

일반 `StatefulWidget`과 비슷하지만, **Riverpod**으로 앱 전역/기능 단위 state도 읽을 수 있다.

```dart
class FaceMeshListPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<FaceMeshListPage> createState() =>
      _FaceMeshListPageState();
}

class _FaceMeshListPageState
    extends ConsumerState<FaceMeshListPage> {
  // State 클래스 필드 = 아래 “위젯 로컬 state”
  final Set<String> _selectedGroupIds = {};

  @override
  Widget build(BuildContext context) {
    // Riverpod으로 “바깥에 있는” state 구독
    final listState = ref.watch(faceMeshListProvider);
    ...
  }
}
```

초보자가 기억할 것:

- `State` / `ConsumerState` **필드** + `setState` → 위젯이 직접 드는 state  
- `ref.watch(provider)` →  다른곳(Notifier 등)에 있는 state를 **구독**

---

## 5. State를 나누는 대표적인 기준 (Flutter 공식 개념에 가깝게)

실무·문서에서 자주 쓰는 구분이다.

### 5.1 Ephemeral state (일시적 / UI state)

- **한 위젯(또는 한 화면) 안에서만** 쓰임  
- 예: 체크 선택, 애니메이션 진행, 페이지뷰 인덱스, 텍스트 필드 포커스  
- 보통 **`StatefulWidget` + `setState`** 로 충분  

### 5.2 App state (앱/기능 state)

- **여러 화면**이 보거나, **네트워크·DB·센서**와 이어짐  
- 예: 로그인 사용자, 장바구니, 서버 목록, GPS 좌표 스트림  
- `setState`만으로 올리기 버거움 → **상태 관리 라이브러리** 또는 상위에서의 체계적 전달  

이 프로젝트의 app/기능 state는 주로 **Riverpod Notifier**가 담당한다.  
(다른 앱은 Provider, Bloc, GetX 등을 쓰기도 한다. “Flutter 필수”가 아니라 **선택**이다.)

```
Ephemeral  →  위젯 State + setState
App/기능   →  이 프로젝트: Riverpod (view_model + state 모델)
```

---

## 6. 데이터가 위에서 아래로 흐른다

Flutter의 기본 방향:

```
부모(state를 알거나 가짐)
  → 자식에게 생성자로 값 전달 (props)
    → 손자는 받아서 그리기만
```

```dart
// 부모
ThreeDCube(xAxis: accelState.xAxis, ...)

// 자식은 보통 Stateless — 값을 “들고” 바꾸지 않고 표시만
class ThreeDCube extends StatelessWidget {
  final double xAxis;
  ...
}
```

자손이 “선택됐다”고 부모에게 알릴 때는:

- 콜백을 넘긴다: `onTap: () => _toggleSelection(item)`  
- 또는 공유 app state(Notifier)를 바꾼다  

자식이 마음대로 부모 private 필드를 직접 수정하지는 않는다.

---

## 7. 다시 그려짐(rebuild)을 이해하자

### 7.1 언제 rebuild되나? (개념)

- `setState` 호출  
- 부모가 rebuild되면서 자식 설정도 다시 만듦  
- Riverpod `ref.watch`가 구독한 값이 바뀔 때  
- `InheritedWidget`/Theme 등이 바뀔 때 등  

### 7.2 `const`와 rebuild

```dart
const SizedBox(height: 30),
const AcceleratorConnectionStatusCard(),
```

`const` 위젯은 값이 고정이라, 부모가 다시 빌드되어도 **같은 인스턴스를 재사용**하기 쉬워 불필요한 작업을 줄인다.  
state에 따라 바뀌는 위젯에는 `const`를 붙일 수 없다.

### 7.3 build는 싸게, 효과는 밖으로

```dart
// build 안
final listState = ref.watch(...);  // 읽기 OK
return ListView(...);              // UI 설명 OK

// build 안 X — 매 빌드마다 저장/요청하면 위험
await saveToServer();              // 부수 효과는 버튼 onTap, initState, Notifier 메서드에서
```

---

## 8. “위젯이 아닌” state 홀더들

화면에 안 그려지지만 state 역할을 하는 객체가 많다.

| 종류 | 역할 | 갱신과 UI |
|------|------|-----------|
| `TextEditingController` | 입력 문자열 | listener 또는 입력과 연결된 `TextField` |
| `ScrollController` | 스크롤 위치 | 필요 시 listener |
| `AnimationController` | 애니메이션 진행 | `AnimatedBuilder` 등 |
| `FocusNode` | 포커스 | Focus 위젯과 함께 |

```dart
late final TextEditingController _controller;

@override
void initState() {
  super.initState();
  _controller = TextEditingController();
}

@override
void dispose() {
  _controller.dispose(); // 메모리 누수 방지
  super.dispose();
}
```

**규칙:** `Controller`를 만들면 보통 `dispose`에서 해제한다.

---

## 9. 상위에게 state를 올리는 것 (Lifting state up)

형제가 같은 값을 봐야 하면, 그 값은 **공통 부모**가 가진다.

```
Wrong:  자식A가 선택 state 가짐 / 자식B는 모름
Right:  부모가 selected 가짐 → A, B에 전달 + onChanged 콜백
```

화면 전체·앱 전체로 범위가 커지면 “부모 State” 대신 **Riverpod 같은 외부 store**로 올리는 것과 같은 아이디어다.

---

## 10. Riverpod으로 app/기능 state 다루기 (이 프로젝트)

Flutter 핵심 API는 아니다. **이 저장소가 선택한 도구**다.  
개념만 익히면 된다.

### 10.1 Provider / Notifier 역할

| 개념 | 의미 |
|------|------|
| Provider | “이 state(또는 Notifier)에 대한 주소” |
| Notifier | state를 들고, `reload` 같은 **변경 메서드**를 가짐 |
| `ref.watch` | 구독. 값 변하면 **이 위젯 build 다시** |
| `ref.read` | 지금 한 번 읽기/Notifier 메서드 호출. (보통 클릭 핸들러) |

### 10.2 불변 state + `copyWith`

```dart
state = state.copyWith(isLoading: true);
// 나중에
state = state.copyWith(isLoading: false, faceMeshList: items);
```

기존 객체의 필드를 몰래 바꾸지 않고, **새 state 객체**로 갈아끼운다.  
그래야 구독자가 “변했다”고 알기 쉽다.

### 10.3 비동기 흐름 (전형적인 패턴)

```
1) state = loading
2) await usecase / API
3) state = success(data) 또는 error(message)
4) watch 중인 Page가 자동으로 다시 build
```

로딩 스피너·에러 문구·목록은 전부 **그 state 필드**를 보고 분기한다.

---

## 11. initState / dispose / 생명주기 (State 객체)

`State` 객체는 대략 이런 순서를 갖는다.

| 시점 | 메서드 | 하는 일 |
|------|--------|---------|
| 처음 생성 | `initState` | 컨트롤러 생성, 리스너 등록, 첫 로드 예약 |
| 매 갱신 | `build` | UI 설명 |
| 제거 | `dispose` | 컨트롤러·observer 해제 |

이 프로젝트 예: 가속도 화면이 앱 생명주기에 맞춰 센서를 켜고 끈다 (`WidgetsBindingObserver`).  
“값이 바뀜”뿐 아니라 **구독 시작/종료**도 state 관리의 일부다.

---

## 12. mounted

비동기 작업 후 화면이 이미 닫혔을 수 있다.

```dart
final result = await notifier.reload();
if (!mounted) return;  // State가 아직 트리에 있을 때만
setState(() { ... });
```

`ConsumerState` / `State` 모두 `mounted`를 제공한다.

---

## 13. Key (가볍게)

같은 타입 위젯이 목록에서 섞일 때, Flutter가 “같은 위젯인지” 혼동하지 않게 `Key`를 준다.

```dart
ListTile(key: ValueKey(item.id), title: Text(item.name))
```

초보 단계에서는 “목록 아이템에 안정적인 id가 있으면 Key를 준다” 정도만 알아도 된다.

---

## 14. 한눈에 보는 도구 선택

| 상황 | 흔한 선택 |
|------|-----------|
| 토글, 선택, 간단 카운터 | `StatefulWidget` + `setState` |
| 입력창 텍스트 | `TextEditingController` (+ 필요 시 setState/listener) |
| 화면 전환 후에도 유지되는 목록·센서·로그인 | 상태 관리 (여기선 Riverpod Notifier) |
| 부모→자식 표시만 | 생성자 파라미터 (Stateless) |
| 자식→부모 알림 | 콜백 `VoidCallback` / `ValueChanged` |

---

## 15. 연습으로 읽기 좋은 프로젝트 파일

개념을 코드로 확인할 때:

| 보고 싶은 것 | 파일 |
|--------------|------|
| `setState` + 로컬 필드 | `faceMesh/view/face_mesh_list.dart` (`_selectedGroupIds`) |
| `watch`로 기능 state 표시 | `accelerator/view/accelerator_info.dart` |
| Notifier가 `state = copyWith` | `faceMesh/view_model/face_mesh_controller.dart` |
| state 모델 정의 | `faceMesh/state/face_mesh_state.dart` |
| Controller + dispose | 채팅/입력 있는 socket 등 `TextEditingController` 사용처 |

---

## 16. 체크리스트 (state를 건드릴 때)

- [ ] 이 값은 **시간이 지나면 바뀌고**, 바뀌면 UI를 갱신해야 하나?
- [ ] 한 위젯/화면만 쓰나, 여러 화면·서버와 연결되나?
- [ ] 로컬이면 `State` 필드 + `setState`인가?
- [ ] 기능 데이터면 Provider/Notifier에 두고 `watch`/`read`인가?
- [ ] `build` 안에 await 저장/요청을 넣지 않았나?
- [ ] 비동기 후 `mounted`를 확인했나?
- [ ] `TextEditingController` 등을 `dispose`했나?
- [ ] state를 바꿀 때 구독자가 알 수 있는 방식인가? (`setState` 또는 `state = copyWith`)
- [ ] `copyWith`에서 nullable을 null로 비울 때 `clearXxx` 플래그를 썼나? (규칙은 [Entity·State 작성 규칙](../architecture/7_entity_conventions.md))

---

## 17. 다음에 보면 좋은 것

- UI를 조립하는 법 → [Depth 가이드 0~9](./0_index.md)  
- 공식 문서: [Flutter — State management](https://docs.flutter.dev/data-and-backend/state-mgmt/intro)  
- 이 저장소의 Riverpod 패턴은 위 개념 위에 **팀 규칙으로 올린 층**이다. 화면 필드 추가와 `aiServerConnected`는 [Riverpod 화면 상태](../architecture/8_riverpod.md)를 본다.
