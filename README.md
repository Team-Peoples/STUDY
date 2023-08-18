# 피플즈

Github: https://github.com/DONG-WOON/STUDY

기간: 22.06.15 ~ 23.04.27

멤버: Choisang, Domb, EHD, Eddy, Ever, L, Lims

사용기술: Combine, Keychain, MVVM, Observable, TestFlight, UICollectionView, UISheetPresentationController, UITableView, UniversalLinks, UserDefaults

  

#  ****소개****

  

<aside>

💡 **쉽게 모이고, 같이 하자!**

**스터디/모임/프로젝트 운영을 도와주는 서비스, 피플즈**


</aside>

  

# 프로젝트 기간

  

- 22.06.15 ~ 22.06.27: 아이데이션 및 프로젝트 핵심기능 선정

- 22.07.02 ~ 23.04.01: iOS 앱 설계 및 개발

- 23.04.01 ~ 23.04.27: QA

- 배포완료

  

# ****내용 및 역할 (기여도)****

  

###  ****내용****

  

- 스터디원들간의 소통과 일정 관리를 위한 앱 개발

  

###  ****역할****

  

- 화면 단위 기능 및 모델 설계 (50%)

- 로그인, 스터디 생성, 공지사항, 스터디 정보, 캘린더, 스터디 일정, 출결 일부 담당 (90%)

- RESTful API 연동 (50%)

- 링크 초대를 위한 다이나믹링크 / 유니버셜 링크 구현 (100%)

- 앱 배포 전 테스트 (90%)

  

# 핵심 스킬

  

| 디자인 패턴 | 프레임워크 | 라이브러리 |
| ---                  | --- | --- |
| MVVM Pattern | ☑️ UICollectionViewController| SnapKit|
|Delegate Pattern | ☑️ UITableViewController|FSCalendar|
|Observer Pattern | ☑️ PHPickerView| Firebase |
|                |☑️ Notification ✅ KeyChain ✅ UserDefaults|DynamickLinks|
|                 |☑️ UISheetPresentaionController | Alamofire|

  

# 핵심 경험

  

### ✅ Keychain과 UserDefaults 활용
- Keychain을 사용하여 사용자의 민감한 정보를 안전하게 저장

### ✅ MVVM 아키텍처와 Observer 패턴 적용
- 비즈니스 로직과 네트워크 통신 분리

### ✅ Strong Reference Cycle 해결
- 클로저 콜백 방식을 사용하여 데이터 전달 및 이벤트 처리시 강한 순환 참조 문제 발생
- xcode의 Debug Memory Graph를 활용하여 문제 해결

### ✅ TestFlight를 사용한 베타 앱 빌드 및 QA 진행

### ✅ Universal Links 구현 (Firebase DynamicLinks)
- 앱에서 스터디 생성, 초대, 공유 기능 구현

### ✅ 반복 사용 UI Custom 구현

# 메인 설계 화면

![Simulator Screen Shot - iPhone 14 - 2023-03-14 at 11.53.04.png](%E1%84%91%E1%85%B5%E1%84%91%E1%85%B3%E1%86%AF%E1%84%8C%E1%85%B3%20b20a226b8ff7433083025bd367b19a54/Simulator_Screen_Shot_-_iPhone_14_-_2023-03-14_at_11.53.04.png)

  

![Simulator Screen Shot - iPhone 14 - 2023-03-14 at 11.42.49.png](%E1%84%91%E1%85%B5%E1%84%91%E1%85%B3%E1%86%AF%E1%84%8C%E1%85%B3%20b20a226b8ff7433083025bd367b19a54/Simulator_Screen_Shot_-_iPhone_14_-_2023-03-14_at_11.42.49.png)

  

![Simulator Screen Shot - iPhone 14 - 2023-03-14 at 11.40.13.png](%E1%84%91%E1%85%B5%E1%84%91%E1%85%B3%E1%86%AF%E1%84%8C%E1%85%B3%20b20a226b8ff7433083025bd367b19a54/Simulator_Screen_Shot_-_iPhone_14_-_2023-03-14_at_11.40.13.png)

  

![Simulator Screen Shot - iPhone 14 - 2023-03-14 at 11.42.20.png](%E1%84%91%E1%85%B5%E1%84%91%E1%85%B3%E1%86%AF%E1%84%8C%E1%85%B3%20b20a226b8ff7433083025bd367b19a54/Simulator_Screen_Shot_-_iPhone_14_-_2023-03-14_at_11.42.20.png)

  

![Simulator Screen Shot - iPhone 14 - 2023-03-14 at 11.41.44.png](%E1%84%91%E1%85%B5%E1%84%91%E1%85%B3%E1%86%AF%E1%84%8C%E1%85%B3%20b20a226b8ff7433083025bd367b19a54/Simulator_Screen_Shot_-_iPhone_14_-_2023-03-14_at_11.41.44.png)

  

![Simulator Screen Shot - iPhone 14 - 2023-03-14 at 11.41.51.png](%E1%84%91%E1%85%B5%E1%84%91%E1%85%B3%E1%86%AF%E1%84%8C%E1%85%B3%20b20a226b8ff7433083025bd367b19a54/Simulator_Screen_Shot_-_iPhone_14_-_2023-03-14_at_11.41.51.png)

  

![Simulator Screen Shot - iPhone 14 - 2023-03-14 at 11.55.38.png](%E1%84%91%E1%85%B5%E1%84%91%E1%85%B3%E1%86%AF%E1%84%8C%E1%85%B3%20b20a226b8ff7433083025bd367b19a54/Simulator_Screen_Shot_-_iPhone_14_-_2023-03-14_at_11.55.38.png)

  

![Simulator Screen Shot - iPhone 14 - 2023-03-14 at 11.40.48.png](%E1%84%91%E1%85%B5%E1%84%91%E1%85%B3%E1%86%AF%E1%84%8C%E1%85%B3%20b20a226b8ff7433083025bd367b19a54/Simulator_Screen_Shot_-_iPhone_14_-_2023-03-14_at_11.40.48.png)

  

### 로그인
- View의 재 사용성을 고려하여 코드 중복을 줄이고 유지 보수성과 확장성을 높임

### 스터디 생성
- CollectionViewFlowLayout를 사용하여 콘텐츠를 레이아웃에 맞게 표시
- Notification을 사용하여 "주제" 선택 요소를 observer로 전달

### 출결 규칙

- UITableViewCell layout을 설정하고, 사이즈를 자동 계산되도록 변경
- 필수 조건을 선택하지 않았을 경우 토스트 메시지를 띄우고, 메시지가 보이는 동안은 터치가 불가능하도록 구현

### 스터디 종료

- UISheetPresentationController를 이용하여 사용자 편의성을 향상

### 캘린더

- FSCalendar 라이브러리를 활용하여 커스텀 캘린더 구현
- 선택한 일정에 해당하는 정보를 업데이트하는 BottomSheet View 구현

### 스터디 일정생성

- 디자이너 및 기획자와 회의하여 스터디 일정 생성 시 사용자에세 발생할 수 있는 불편 사항과 문제점을 고려하여 구현

1. 이전 화면에서 선택한 날짜가 생성날짜 초기값이 되도록 구현
2. 시작시간과 종료시간의 역전이 불가능하도록 구현
3. 반복종료일을 선택시 시작날짜보다 빠를 수 없도록 구현

# 고민한점

1. **delegate pattern을 사용시 VC의 타입으로 delegate를 선언해도 괜찮은가?**

    Delegate Pattern에서 VC 타입으로 delegate를 선언하는 것은 바람직하지 않습니다. 이는 해당 VC가 뷰 계층 구조에서 맡은 역할과 무관하기 때문입니다. 대신 해당 VC에서 선언한 프로토콜을 사용하여 delegate 객체를 선언했습니다. 이렇게 하면 코드를 읽는 사람이 해당 VC에서 수행하는 작업을 더 쉽게 이해할 수 있습니다.

2. **빈번한 네트워크 통신에 대한 고민: 사용자의 경험 VS 리소스의 낭비**

    빈번한 네트워크 통신은 리소스 낭비가 될 수 있습니다. 따라서 NotificationCenter를 사용하여 필요한 시점에만 네트워크 통신을 하도록 구현하는 것으로 구현했습니다.

    [https://github.com/DONG-WOON/STUDY/pull/21](https://github.com/DONG-WOON/STUDY/pull/21)

3. **OAuth2.0프로토콜 적용을 위해 refreshToken 기능을 추가**

4. **TableView 또는 CollectionView에서 MVVM 아키텍처 적용**

    UI 로직과 비즈니스 로직을 분리하여 결합도가 낮출 수 있었습니다.

5. **네트워크 요청후 응답을 받아온 후 성공시 VC를 생성하고 화면전환하는 것은 비효율적인가?**

    성공시 VC를 생성하는것이 효율적입니다. 실패할 경우를 고려하여 미리 VC를 만들어 놓는 것은 메모리 낭비가 될 수 있다고 판단했습니다.

    [https://github.com/DONG-WOON/STUDY/pull/64](https://github.com/DONG-WOON/STUDY/pull/64)

6. **네이밍에 대한 고민: 메소드라면 반드시 동사형으로 시작해야하는가?**

    ex) filter라는 기능을 구현했지만, 사용할때는 studySchedule(at: selectedDate)로 사용

    Swift Naming Guide에 따르면, 메소드는 동사형으로 시작해야 합니다. 하지만 코드를 읽는 사람이 해당 메소드의 역할을 더 쉽게 이해할 수 있도록 네이밍 하였습니다.

    [https://github.com/DONG-WOON/STUDY/pull/65](https://github.com/DONG-WOON/STUDY/pull/65)

  

1. `extension` 을 사용하는 것이 효율적인가?**

    extension을 사용하여 기능을 구현하는 것은 새로운 객체를 만드는 것보다 컴파일 타임을 줄일 수 있습니다.

    특히 DateFormatter와 같이 빈번하게 사용되는 객체를 매번 생성하는 것은 비용이 많이 들기 때문에 extension을 사용하였고 퍼포먼스 테스트를 진행하였습니다.

    [Formatter Performance Test](https://www.notion.so/Formatter-Performance-Test-604c5da83322438690b6479cd5aed712?pvs=21)

    [https://github.com/DONG-WOON/STUDY/pull/68](https://github.com/DONG-WOON/STUDY/pull/68)

  

1. ****강제 언래핑 지양****

    빌드시 컴파일 오류가 발생하지 않고 엣지 케이스가 발생하지 않아서 문제가 없을 수 있지만, 앱을 테스트하고 피드백하는 과정에서 강제 언래핑을 사용한 변수가 nil인 상황으로 인해 앱이 크래시되는 문제가 발생했습니다.

    따라서 가능한 모든 강제 언래핑을 제거하고, nil coalescing 또는 if / guard let 바인딩을 사용하였습니다.

    [https://github.com/DONG-WOON/STUDY/pull/52](https://github.com/DONG-WOON/STUDY/pull/52)
