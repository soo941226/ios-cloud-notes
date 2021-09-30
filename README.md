## iOS 커리어 스타터 캠프
### 동기화 메모장 프로젝트 저장소
### 수박: Camper, 올라프: Reviewer👍 <br> (2021.08.30. ~ 2021.09.17.)

<br>

* 목차
  * [𝞪. 이번 프로젝트를 통해 학습한 것](#𝞪-이번-프로젝트를-통해-학습한-것)
  * [𝞫. 프로젝트를 진행하며 겪었던 고민...](#𝞫-프로젝트를-진행하며-겪었던-고민)
  * [𝞈. 남겨진 것들....😅](#𝞈-남겨진-것들)

<br>

---

<br>

### 𝞪. 이번 프로젝트를 통해 학습한 것

[상세 내용](./docs/learned/README.md)

| Theme | Description |
| :---: | :--- |
| UISplitVIewController | - iPad와 iPhone을 아우를 수 있는 화면과 로직 개발 <br> - 컨테이너 뷰컨과 컨텐츠 뷰컨의 구분, 그 목적  |
| CoreData | - 기존에 사용되던 UserDefaults, Keychain, KeyedArchiver와의 차이 <br> - CoreDataStack과 그 stack을 구성하는 요소들, 각각의 목적 <br> - NSMangedObjectMdoel, NSManagedObjectContext, NSPersistentCoordinator, NSPersistentContainer... |
| Autolayout(Programmatically) | - 재사용하기 좋은 뷰를 어떻게 구현할 것인지, 이를 위해 StackView를 활용하는 방법 <br> - 코드 레벨에서 constraint를 가감하는 방법 <br> - CG란 무엇이고 Core는 무엇인가에 대해서 <br> - Intrinsic content size가 무엇인지에 대해서 <br> - leading과 trailing, left과 right에 의해 구분되는 타입들에 대해서 |
| Dependency Manager(with SwiftLint) | - Lint란 무엇이고 왜 SwiftLint를 사용하는지에 대해서 <br> - Dependency Manager란 무엇인가 <br> - Cocoapods, Carthage, Swift Package Manager, Mint의 차이 |

<br>

---

<br>

### 𝞫. 프로젝트를 진행하며 겪었던 고민...

[상세 내용](./docs/issue/README.md)

| Issue | Solution? |
| :---: | :--- |
| SOLID | - 각각의 타입의 역할에 대해서 고민을 하면서, 이 역할에 맞는 이름은 무엇이고 어디까지 책임을 지게 할 것인지, 어떤 내용에 대해서 얼마만큼 어디까지 전파를 할 것인지... <br> - 특히 primaryVC를 구현하면서 기능들이 복잡해짐에 따라 각각의 기능들을 최대한 재사용하기 쉽게 하기 위해, 각자의 역할을 명확히 구분하기 위해 애를 많이 썼다 |
| Swift Performance | - class와 struct의 선택 기준에 대해서 고민을 했다 <br> - class의 경우 dynamic dispatch와 static dispatch에 대해 고민하였고, 나아가 UIKit이 과연 항상 옳은가에 대해서 고민을 하게 됐다 |
| CoreData | - SOLID와 엮이는 부분이지만 Coredata는 특히 처음 사용하게된 타입이라는 점에서 분리하여 기록을 하고 싶었다 <br> - 각각의 기능들을 어떻게 분리할 것이고, 어떤 facade를 제공할 것인지... <br> - 에러에 대해서는 어떤 조치를 취할 것인지...| 
| Autolayout | - inset이 적용되지 않았을 때 왜 적용이 되지 않았는지 고민을 했고, 나아가 leading과 trailing, left와 right을 확실히 내 것으로 하기 위한 공부를 하게 됐다 <br> - StackView를 사용을 할 것인지 말 것인지, 사용을 하지 않는다면 왜 사용을 하지 않았는지 명확한 근거가 있어야만 할 것 같았다. 그렇지 않다면 StackView를 일단은 사용하고 보는 게 멀리 보았을 때, 특히 남들도 같이 코드를 작성할 때에 훨씬 좋은 방법이 될 거라는 걸 느꼈다|
| Memory | - 이전 프로젝트 고민에 이어서... static을 최대한 지양하는 방법으로 코드를 구현하려고 했다 <br> - 또한 사용되지 않는 요소들에 있어서는 반드시 nil로 초기화를 하려고 했다 <br> - 하지만 ARC가 이러한 역할을 이미 하고 있기도 한다는 점, 또 내가 이러한 행동을 하게됨으로써 의도치 않은 버그가 발생했다는 점에서... <br> - 너무 고생길을 걸었던 게 아닌가 싶기도 하고, 고민을 했다는 걸 칭찬받았다는 점에서 앞으로도 고민은 계속하는 게 좋은 것인가 싶기도 하고 잘 모르겠다|

* 아래의 링크는 제가 고민했던 질문들과, 올라프가 함께 고민해주시고 도와주신 Pull Request의 주소입니다.
  * [스텝1 PR](https://github.com/yagom-academy/ios-cloud-notes/pull/51)
  * [스텝2 PR](https://github.com/yagom-academy/ios-cloud-notes/pull/69)

<br>

---

<br>

### 𝞈. 남겨진 것들....😅

[상세 내용](./docs/remained/README.md)

| Remained | Hmm...🤔 |
| :---: | :--- |
| Debug Target | - Compiler Control Statements와 Repository pattern에 대해서 공부를 할 수 있는 키워드가 됐지만, 실제로 적용을 하지 못했다는 점에서 아쉬움이 남는다 |
| UITextView | - iPad와 iPhone에서 서로 일맥상통하지 않는 UX를 제공하고 있는 이슈가 있었으나, 프로젝트의 기간이 끝나서 미해결인 채로 남겨두게 되었다 <br> - 공부할 게 앞으로도 많기 때문에... 여유가 생겼을 때 돌아보는 것이 더 공부할 수 있는 동기도 될 것 같고 긍정적인 요소인 것 같다|
| Error Handling | - 많은 error에 대해서 일단은 alert을 띄우는 방향으로 가는 게 좋을 것 같다고 머릿속으로 결론을 내리긴 했지만, 그럼에도 불구하고 더 좋은 방법이 있진 않을까? 이러한 alert조차도 흐름을 끊는다는 점에서 최선의 방향일까 하는 고민이 남아있다 |
| Naming | - 언제나 어려운 이름짓기... 특히 타입의 역할을 대표할 수 있고 구분할 수 있는 이름을 지으려는 게 너무 어렵다 <br> - 앞으로도 계속 공부를 해야할 것 같다 |