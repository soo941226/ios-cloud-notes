# 𝞫. 프로젝트를 진행하며 겪었던 고민들, 문제들

* 목차
    * [1. TableView, TableViewDelegate, TableViewDataSource, TableViewCell의 역할 및 책임...](#1-tableview-tableviewdelegate-tableviewdatasource-tableviewcell---)
    * [2.Model의 type... struct vs class](#2-model-type-struct-vs-class)
    * [3.UISplitViewController with SOLID](#3-uisplitviewcontroller-with-solid)
    * [4.CoreData](#4-coredata)
    * [5.Autolayout](#5-autolayout)
    * [6.Concurrency Programming](#6-concurrency-programming)
    * [7.그 외](#7-else)

<br>

---

<br>

### 1. TableViewController, TableViewDelegate, TableViewDataSource, TableViewCell의 역할 및 책임...
* UITableViewDataSource가 셀과 데이터를 관리하는 것까지는 좋은데
* 실제로 cell의 contentView의 subView들에 대해서 데이터를 입력하는 과정은 DataSource가 하는 것이 좋은 것인지, 아니면 Delegate가 하는 것이 좋은 것인지...
* 이전 프로젝트 고민의 연장선인데, 이미지의 경우에는 이미지를 가져오는 비동기 작업이 끝난 시점에 셀이 보여져 있는지를 확인하면서, 또 해당 셀이 정말로 그 자리에서 요청을 한 게 맞는지를 IndexPath를 통해 확인하고자 한다면, UITableViewDelegate를 이용해서 확인을 한 뒤 거기서 셀의 이미지를 그리도록 했었다
* 하지만 텍스트의 경우에는 이에 대한 draw와 관련 내용들이 캡슐화되어 텍스트를 할당하기만 하면 알아서 그려지게 되어있었고...
* 고민을 하다가 데이터를 입력하는 건, 데이터를 관리하고 있는 DataSource에서 하고 이를 반영할지 말 것인지는 cell이 직접 결정하는 게 서로의 책임을 명확히 할 수 있겠다는 생각이 들었다
  ```
    class MyCell: UITableViewCell {
      ...
      func configure(model: Model) {
        self.a = model.a
        self.b = model.b
        ...
      }
    }
  ```
* 그래서 위와 같은 구조로 코드를 작성한 뒤, DataSource에서는 모델을 넘겨주는 식으로만 작성을 하게 되었다

<br>

---

<br>

### 2. Model의 type... struct vs class
* 1의 내용을 고민하면서, 또 Swift Performance를 공부하면서 Model을 어떤 타입으로 작성할지 고민하게 되었다
* 공부하기 이전에는 stack에 올리는 게 마냥 좋겠다는 생각이 들어서 struct으로 짜놓았으나
* Model은 앱의 계층구조 내에서 점점 깊숙한 곳으로 넘겨줘야 한다는 점, 그리고 그 때마다 copy가 발생할 것이라는 점
* 그리고 내부에 reference counting을 하는 String을 반드시 사용해야한다는 점을 생각하면서
* struct보다는 class가 더 유리하지 않을까 하는 생각이 들었다
* 또 cow를 고려하여, 넘겨줄 때마다 일어나는 copy가 변경이 일어나기 전까지는 reference를 copy하고 있는 것이라면 별 차이가 없지 않을까? 하는 생각도 들었다
* 하지만 이 궁금증을 해소할 수 있는 방법이 딱히 떠오르지 않았고, 그렇다고 한다면 확실한 것은 일단 reference를 copy하는 class로 구현하는 것이 더 확실하겠다는 생각이 들었다
* 그래서 Memo라고 하는 모델을 class로 변경하게 되었다
* 나아가 모든 class들은, 일단 final을 붙여 static dispatch가 가능하도록 리팩토링을 하게 되었다

<br>

---

<br>

### 3. UISplitViewController with SOLID
| Theme | Description |
|:---:|:---|
| Aspect | - 공식문서를 읽으면서, 컨텐츠를 나타내기 위한 ViewController라기 보다는, 제약이 더 많고 기능도 많은 NavigationController라고 여기게 되었다 <br> - 특히 childVC 간의 통신을 담당하는 컨트롤러라고 여기게 되었다 <br> - 그래서 통신과 관련된 부분은 모두 SplitVC에서 하는 형태로 코드를 짰다 <br> - 또 공통된 부분, 특히 Alert과 같은 경우에는 이를 캡슐화하여 childVC들에게 제공하는 형태로 코드를 짜게 되었다 |
| Delegation Pattern | - 처음에는 각각의 타입들이 서로 강하게 의존하고 있었다. 특히 SubVC들이 SplitVC를 강하게 알고 있었다 <br> - 이 부분을 올라프에게 피드백을 받은 뒤, SplitVC가 SubVC를 아는 것은, 알아야만 그 SubVC를 표현할 수 있으니 당연한 부분이지만, SubVC들이 SplitVC를 아는 것은 불필요한 내용들을 많이 알게 되는 것 같았다 <br> - 이러한 점에서 이전에 공부했던 Delegation pattern을 떠올렸고, Messenger라는 프로토콜을 구현하여 SplitVC는 이를 채택하게 한 뒤, SubVC들의 messenger가 자기 자신이라고 알려주는 형태로 구현하게 되었다 <br> 이후 messenger가 틀린 말은 아니지만 delegation pattern을 사용했다는 걸 좀 더 명료하게 표현하기 위해서 delegate로 이름을 바꾸게 되었다 |

<br>

---

<br>

### 4. CoreData
* 이번 프로젝트에서 가장 어려웠던 부분이면서, 가장 값진 부분이었던 것 같다

| Theme | Description |
|:---:|:---|
| CRUD의 사후처리 | - 정확히는 context.save()와 context.fetch()에서 throws를 어떻게 핸들링 할 것인지... 고민을 하게 됐다 <br> - 특히 이러한 내용이 UIView의 init(coder:)처럼 테스트시 정상 동작을 하면 무조건 정상 동작을 하는 동작인지, 아니면 런타임 때 달라질 수 있는 동작인지... <br> - 이에 대한 명확한 기준을 찾지 못했지만, 공식문서에서는 이에 대한 핸들링은 하도록 명시하고 있었기에 이를 따르게 되었다 <br> - 다만 실제로 유저의 상호작용까지는 어떤 처리를 해야할지 아직 공부가 부족하여 처리를 하지 못했다. 권장사항으로는 리포트를 해달라고 alert을 띄우거나, 유저가 그나마 덜 불편하도록 우회할 수 있는 방법을 제시한다고 한다|
| Retreive에 실패했을 때 어떻게 할 것인가 | - 이것은 특히 고민이었던 게, 애초에 모델을 가져오는 것부터가 문제라면 앱을 종료시키는 게 맞는 것인지, 아니면 그대로 두는 게 맞는 것인지 고민을 하였다 <br> - 특히 읽기부터가 안된다면, 이후의 context.save도 당연히 안될 것 같지만, 혹시 되더라도 기존 모델과 충돌을 일으키진 않을까... 하는걱정이 있기 때문이었다 <br> - 하지만 그렇다고 해서 fatalError를 던지는 것은 너무 극단적이라는 피드백을 받았기 때문에 alert을 띄우는 방향으로 가게 되었다 |
| persistentContainer의 위치 | - 처음 프로젝트 기본 구현에서는 AppDelegate가 들고 있고, 이를 SceneDelegate에 전달해주고 있었고, 여기서 다시 window.rootViewController에 전달해줄 수 있는 형태였다 <br> - 처음에는 기본 구현된 내용이기 때문에 자연스럽게 문제가 없다고 느꼈으나, 공식문서인지 튜토리얼인지에서 앱의 launch가 오래걸리면 iOS에서 강제로 앱을 종료시킨다고 하는 글을 읽게 되었다 <br> - 그래서 CoreData가 특히 AppDelegate에서 초기화가 되는 부분이 마음에 걸렸고, 그렇게 고민하다 보니 SceneDelegate에서 AppDelegate를 알아야하는 것도 마음에 걸렸다 <br> - 그러면서도 SceneDelegate의 기본구현된 내용은 필요한 내용이라고 여겨졌고... SceneDelegate가 CoreData를 알아야한다는 점 때문에, 절충안으로 SplitViewController에 넣게 되었다 <br> - 특히 SceneDelegate는 어차피 SplitViewController를 알아야 하고, SplitViewController는 메시지를 포워딩 해주는 타입이라는 점에서... <br> - 하지만 막상 구현해놓고 보니 차츰 CoreData의 extension이 너무 많아지게 되었고, 아예 다른 CoreDataManager라고 하는 다른 타입으로 분리하여, CoreDataManager가 persistentContainer를 가지고 있고, CoreDataManager을 SplitVC에서 가지고 있는 것으로 바꾸게 되었다|
| CloudNote와 Memo | - 처음에 Cloudnote를 사용하지 않고 JSON을 통해 모델이 적합한지를 테스트하는 과정에서 사용되던 Memo가, CoreData를 사용하게 되면서 타입이 중복되는 게 아닌가 하는 의문이 들었다 <br> - 이후 Entity, Model 등의 용어를 확인하는 과정에서 VO를 확인할 수 있었고, 굳이 분류를 하자면 CloudNote는 entity, Memo는 VO로 현재의 구조를 유지해도 괜찮을 것 같겠다는 생각이 들었다 <br> - 특히 entity인 CloudNote는 NSManagedObjectModel를 상속받고 있는데, 이 내용이 굉장히 무겁고 복잡하기 때문에 View에서는 이러한 내용들은 애초에 알 필요가 없기 때문에 현재의 구조를 유지하기로 마음을 굳혔다|

<br>

---

<br>

### 5. Autolayout

| Theme | Description |
|:---:|:---|
| UIStackView | - 처음에는 StackView를 사용하는 것 자체가 일단 하나의 뷰를 더 쌓아야한다는 점에서 내 입장이나 컴퓨터의 입장이나 오버헤드가 발생한다는 생각이 들었다 <br> - 특히 스토리보드도 아니고, 코드레벨에서 이것을 사용하는 게 아주 번거롭다는 생각이 들었다 <br> - 즉 도전하지 않고 일단 그럴 것이라는 안일한 생각을 했었는데, 막상 사용을 해보니 오히려 다양한 조건들을 생략할 수 있게 되어서 더 깔끔하고 좋은 코드가 나오게 되었다 <br>  |
| UITextView | - 이번 프로젝트에서 거의 모든 이슈들이 이 타입이 원인이 되어 생기게 되었다 <br> - 그만큼 징글징글하지만 덕분에 많은 걸 공부할 수 있었기 때문에 애증이 깊다 <br> - Intrinsic content size, Notification Center, Scrolling, CoreGraphics, Constraints, Autolayout, UIScene, UIWindow, Navigation, Delegation Pattern 등등... <br> - 이것 자체는 그냥 텍스트를 write하는 뷰이기 때문에 사용하는 것 자체는 무리가 없었으나, 제대로 사용하기 위해서 많은 걸 공부해야만 했다...|
| Keyboard | - 앞서 언급한 UITextView 때문에 드러난 이슈. <br> - 특히 UITextView의 anchor를 safeArea에 달아놓았었는데, 키보드가 나타났을 때 이 safeArea는 변화하지 않는데 화면 아래에서 새로 올라오는 Scene과 Window에 의해 UITextView가 가려지게 되었다... <br> - 이에 대한 문제를 해결하려고 하면서 공식문서를 살펴보았으나 직관적인 해결법은 찾을 수 없었고, 스오플을 참고하여 NotificationCenter를 통해 문제를 해결하는 코드를 찾아볼 수 있었다 <br> - 이후 NotificationCenter을 살펴보던 중 Keyboard에 대한 Notification이 있었고, 이걸 NSValue로 캐스팅하여 현재 나타난 키보드의 CGRect를 얻을 수 있게 되었다 <br> - 이후 constraints를 키보드가 toggle 될 때마다 변경은 해주었는데,  LLDB를 켜보니 런타임에 constraints가 계속해서 겹겹이 쌓이는 이슈를 발견할 수 있었다 <br> - 생각해보면 스토리보드에서도 constraints를 계속해서 추가 할 수 있었던 것을 떠올렸고, 이에 따라 동적으로 어떤 constraints를 삭제하거나 isActive의 값을 변경할 필요가 생기게 되었다 <br> - 다시 공식문서에서 관련 내용들을 검색하게 되었고 현재의 코드처럼 키보드가 사라지면 heightAnchor를 삭제한 뒤 bottomAnchor를 safeArea에 달고, 키보드가 나타나면 bottomAnchor를 해제한 뒤 heightAnchor를 (현재 기기의 높이 - 키보드 높이)의 형태로 추가한 뒤 활성화하도록 하였다 <br> - 특히 heightAnchor를 삭제하는 이유는, size-class가 충분히 바뀔 여지가 있었고 이에 따라 anchor의 위치를 적절히 조절해야할 필요성이 있기 때문이었다 |   

<br>

---

<br>

### 6. Concurrency Programming

* 처음에는 이 주제에 대해서 티끌만큼도 고민을 하지 않고 있었다
* 그런데 올라프가 persistentContainer.viewContext가 main-thread에 바인딩이 되고, 이것의 메소드들도 메인스레드에서 동작한다고 이야기를 하시면서, I.O.와 같은 작업은 오버헤드가 크다는 것을 언급하신 뒤 머리를 한대 얻어맞은 것 같았다
* 즉 in-memory의 내용들은 그렇다 치더라도, context.save와 context.fetch처럼 결국 store에 영향을 끼치는 내용들은 아주 큰 딜레이가 발생할 수 있다는 점이 눈에 들어왔다
* 그래서 이와 관련된 내용들을 공부하면서 올라프의 말씀이 맞다는 걸 다시 한 번 확인할 수 있었고, 멀티스레드를 활용하도록 코드를 리팩토링 하였다
* 특히 이 과정에서 n번 스레드로 돌려주는 내용들은 이미 context에 이미 구현이 되어있어서, n번 스레드에서 1번 스레드로 돌아오는 내용만 특히 신경을 써서 코드를 작성하게 되었다

<br>

---

<br>

### 7. 그 외

| Theme | description |
| :---: | :--- |
| Memory | - static을 극단적으로 지양하고, 사용되지 않는 요소들에 nil을 할당하여 메모리를 최적화하는 시도를 많이 해보았다 <br> - 하지만 그렇게 함으로써 의도치 않은 버그들이, 예를 들면 orientation이 바뀌었을 때 적절한 화면이 나오지 않는 것, 발생하였고 이럴 바에는 그냥 내버려두는 게 나을 거라는 말을 듣게 되었다 <br> - 그럼에도 불구하고 이러한 생각이나 시도는 좋다는 칭찬을 듣기도 했는데... <br> - 아무래도 미련이 많이 남는다. 이러이러한 것은 더 좋은 방법이 있어서 버그가 없지 않았을까? 와 같은... |
| Naming | - 이번 프로젝트에서 특히 많이 지적을 받았고, 이와 관련하여 서로 의사소통에 문제가 발생되는 경우가 있었다 <br> - 당연히 문제는 나에게 있었고, 이를 고치려는 시도를 많이 하면서 특히 애를 써서 이름을 지었지만 그럼에도 불구하고 완벽한 네이밍은... 작성하지 못했던 것 같다. 앞으로도 해결해야할 숙제인 것 같아서 재밌으면서도 좀 머리가 아프다😇 |