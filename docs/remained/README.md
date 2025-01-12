# 𝞈. 남겨진 것들....😅

* 목차
    * [1. isTest -> Debug Target](#1-istest---debug-target)
    * [2. Debouncing, Throttling](#2-debouncing-throttling)
    * [3. Naming](#3-naming)
    * [4. UI/UX](#4-uiux)
    * [5. Keyboard](#5-keyboard)
    * [6. CoreData 관련한 Error handling](#6-coredata--error-handling)

<br>

---

<br>

### 1. isTest -> Debug Target, Repository pattern with facade
* 처음에 Coredata를 거치지 않고, JSON 파일을 통해 모델이 정상적으로 동작을 하는지 확인하던 코드가
* Coredata를 반영한 뒤에는 사용하지 않는 코드가 되어버리는 이슈가 있었다
* 이를 isTest라고 하는 bool 값으로 분기를 하였으나 올라프가 Debug target를 활용하는 게 어떻겠냐는 이야기를 해주셨다
* 아니면 사용하지 않는 코드는 아예 삭제를 하는 게 추후 소스코드를 관리하는 것에 매우 용이하며, 혹시 필요하다면 git을 활용하여 해당 코드를 가져오는 게 좋다는 말씀을 해주셨다
* 그리고 Repository pattern, facade라고 하는 키워드를 함께 알려주셨다
* 이러한 내용들을 공부하는 과정에서, 나는 그럼에도 불구하고 이 코드들은 앞으로 사용하지 않을 코드라는 생각이 들었고 과감하게 코드를 삭제하게 되었다
* 그래서 Compiler Control Statements, Repository pattern나 facade와 같은 개념은 공부만 하고 직접 반영은 하지 못해서 아쉬움으로 남는다

<br>

---

<br>

### 2. Debouncing, Throttling
* 디바운싱과 쓰로틀링이라는 키워드를 접했지만, 공부할 내용들이 너무 많다 보니 당장 잘 배울 수 있는 디바운싱만 공부하고 적용하여 아쉬움이 남는다
* 특히 이 내용들이 명확하게 구분되고 서로 다른 필요성을 가지고 있다는 것은 읽었으나, 정확히 이해하지 않고 넘어간 부분이 아쉽게 느껴진다. 추후에라도 필요하게 되면 진득이 시간을 두고 공부해봐야겠다

<br>

---

<br>

### 3. Naming

* 언제나 어렵지만 쉽게 해결이 되지 않는 문제인 것 같다
* 특히 SOLID를 준수하는 타입을 구현하려는 노력 속에서, 이 이름이라는 것이 더더욱 그 가치가 높아지는 것 같아서 머리가 아파왔다. 이따금 대충 짓고 넘어가기도 했다... 깊은 반성을 하면서 고쳤지만 더 많은 문서를 보고 고민을 하면서 보편적이고 힘있는 이름을 짓도록 노력해야겠다

<br>

---

<br>

### 4. UI/UX
* 프로젝트의 진도보다는, 공부와 이슈를 처리하는 것에만 전념해서 iPad환경에서의 UX를 고려하는 것을 잊게 되었다
* 이 과정에서 특히 메모를 생성하는 시점이, 특히 secondary에 진입 후 내용을 작성하는 게 완전히 완료된 시점이었는데,
* 이 때 완료되었다, 라고 판단했던 로직이 wC에서만 합리적이고 wR의 경우에는 화면이 스플릿되기 때문에 합리적이지 않게 되어서, 전체적인 코드를 다시 생각해야 했었다
* 하지만 추석을 앞두었다는 점, 전체적인 코드가 다시 바뀌어야한다는 스트레스 등이 겹쳐져 일단은 미루게 되었다.
* 이제 와서 생각해보면 당장은 스트레스가 맞긴 했지만, 다시 생각하고 공부를 할 수 있는 좋은 기회였던 것 같은데... 추후에라도 여유가 생길 때에 고민을 해볼 필요가 있을 것 같다

<br>

---

<br>

### 5. Keyboard

* 키보드와 관련하여 UITextView에서 발생했던 이슈는 해결을 하였으나, 키보드가 가지고 있는 그 자체의 이슈는 해결하지 못했다
* 키보드 자체의 이슈가 무엇인가 하니, 애플에서 제공하는 private button과 관련하여 layout 이슈가 계속해서 발생하는 것이었는데, 특히 HIG를 지키지 않는 사이즈에 대한 경고였다
* 애플에서 제공을 했다는 점에서 이 책임은 애플에게 있는 것 같았지만, 그럼에도 불구하고 경고는 경고이기 때문에 어떻게 처리를 할 수 있는 방법이 없나 고민을 하게 되었다
* 하지만 애플의 private type이기 때문에 접근할 수 있는 방법이 생각이 나지 않았다는 점과 HIG를 중요시하는 애플임에도 불구하고 이러한 이슈를 해결하지 않은 채 키보드를 제공하고 있다는 점에서, 혹시 다른 이유가 있기 때문에 이러한 상태로 제공을 하는 건 아닐까 하는 생각에...
* 일단은 이 이슈를 해결하는 것은 멈추고 다른 공부에 전념하게 되었다
* 해결할 수 있는 방법이 있긴 할지 호기심으로 남아있다

<br>

---

<br>

### 6. CoreData 관련한 Error handling

* 특히 이슈가 발생할 수 있는 시점은 아래와 같았다
  * NSPersistentCloudKitContainer.loadPersistentStores{ ... }
  * persistentContainer.context.save()
  * persistentContainer.context.fetch()
* loadPersistentStores의 경우 결국 CoreData에 접근을 하지 못하는 것이었는데, 처음에는 falalError를 띄우게 해놓았었다
  * 극단적이라는 생각이 들기는 했지만 따로 어떤 처리를 해야할지 전혀 감을 잡지 못했기 때문이었는데, 올라프의 말씀으로는 이와 관련한 내용도 alert을 띄워 사용자에게 어떤 이슈가 발생했고 어떻게 조치를 하는 게 좋을지 이야기를 해주는 게 좋다고 하셨다
  * 이에 대한 피드백을 처리하려고 했으나, 타입 내부에서 closure를 통해 초기화되고 있을 때에, 에러를 어떻게 뷰까지 전파를 할 것인지 쉬운 방법이 떠오르지 않았다
  * Notification을 활용할 수 있을 것인지... 아니면 이에 대한 내용을 result타입으로 처리하여 컨트롤러도 이 책임을 지게 할 것인지...
  * 고민만 하다가 해결하지는 못하고 일단 TODO 주석으로 남겨놓았는데 특히 생각이 많이 나는 코드다
* save의 경우 성공이나 실패했을 때 따로 어떤 유저와의 상호작용은 하지 않고 print를 통해 개발중에 확인만 할 수 있게 해놓았는데,
  * 실패하는 경우가 있기는 할 것인지... 의문이 들었고
  * 성공하는 경우에는 이렇게 유저에게 별다른 피드백을 주지 않는 게 더 자연스러운 UX를 제공하는 것 같아 괜찮다는 생각이 들었다
  * 다만 실패했을 경우에는... fatalError를 주는 게 적절할 것 같다는 생각이 들기도 했고, 또 어떤 면에서는 유저가 긴 메모를 작성했는데 실패하여 앱이 꺼지고 메모가 날라가버리면... 너무 치명적이라는 생각이 들기도 했다
  * 그렇다면 어떻게 할 것인가... 에 대해서는 올라프의 말씀처럼 alert을 띄우는 형식으로 대체하였으나, 더 좋은 방법이 있을지 아니면 애초에 발생하지 않을 이슈이기 때문에 고려를 하지 않아도 괜찮을지 고민이 된다
* fetch의 경우는 save보다 그 중요도가 높다는 생각이 들었는데
  * 애초에 읽기부터 실패한다면, 유저에게 의도치 않은 고생을 시킬 수 있다는 점에서 아예 앱을 꺼버리는 게 자연스러울 것 같다는 생각이 들었기 때문이다
  * 그럼에도 불구하고 일단 상호작용은 중요하다는 생각이 들기도 했고... 아직은 공부가 더 필요한 부분인 것 같다
  * 하지만 fatalError보다는 alert을 띄우는 게, 유저도 어떤 액션을 취할 수 있게 만들기 때문에 더 합리적이고 이기적이지 않은 생각이라는 생각이 들었다