# 𝞪. 이번 프로젝트를 통해 학습한 것

* 목차
  * [1. UISplitViewController](#1-uisplitviewcontroller)
  * [2. Autolayout](#2-autolayout)
  * [3. UITraitCollection](#3-uitraitcollection)
  * [4. Dependency Manager](#4-dependency-manager)
  * [5. Swift](#5-swift)
  * [6. Keychain, UserDefaults, KeyedArchiver](#6-keychain-userdefaults-keyedarchiver)
  * [7. Coredata](#7-coredata)
  * [8. Responder Chain](#8-responder-chain)
  * [9. Keyboard (UIScene, UIWindow)](#9-keyboard-uiscene-uiwindow)
  * [10. Animation](#10-animation)

<br>

---

<br>

### 1. UISplitViewController
| Theme | Description |
| :---: | :--- |
| Device & HIG | - iPad를 실제로 사용하지 않다보니, 이에 대한 UI나 UX는 고려하지 않고 있었다는 것을 깨달았다. <br> - 관련 문서들을 살펴보니, iOS와 iPadOS로 나뉘어져 있음에도 HIG에서는 iPad에 관련된 내용들이 iOS에 있는 것을 확인했다. 애플이 pad를 강력하게 밀고는 있지만, 아직은 과도기가 아닌가 하는 생각이 들었다 <br> - 그리고 이렇게 기기에 따라, 특히 size class에 따라 달라지는 UI/UX에 대한 요구사항 중 SplitView는, UISplitViewController를 통해 구현하는 것을 확인했다 |
| UISplitViewController.Style | - Double-column과 Triple-Column으로 구분된다 <br> - Double은 Primary와 Secondary의 UIViewController를 가지고 있게 된다 <br> - Triple은 여기에 supplementary를 더한다 <br> - 그리고 iOS14이후로 unspecified라고 하는 케이스가 추가 되었는데, 클래식한 스플릿뷰를 위함이라고 한다. 그런데 여기서 말하는 클래식이 무엇인지는 파악하지 못했다 <br> - 현재에는 Double-column만 사용했으나, Triple을 사용하는 것도 현재와 크게 다르지 않게 사용할 수 있을 것 같다 |
| Container for UIViewController | - 위의 Style에서 언뜻 언급한 것처럼, UISplitVC는 내부에 UIViewController를 갖고 있게 된다 <br> - 즉 UINavigationController와 유사한 역할을 하게 되는데, 실제로 SplitView는 내부에 UINavCtr를 만들어서 사용하기도 한다 <br> - UIViewCtr는 자신의 SplitViewCtr를 가리키는 weak 프로퍼티를 가지고, 이와 관련된 기본적인 기능들이 초기구현되어있다 <br> - 이것들을 잘 알고 사용하는 것도 좋지만, 필요한 기능들을 적재적소에 사용하기 위해서는 임의로 기능을 구현해도 괜찮다고 생각된다 <br> - SplitVC가 UIViewCtr의 container이기 때문에, 마찬가지의 특성을 갖는 NavCtr에 이것을 그대로 push할 수 없다. 약간의 트릭을, UIViewCtr안에 SplitVC를 만들어서 이것을 push 하는 형태로, 쓰면 가능은 하지만 권장하지 않는 방법이라고 한다 <br> - 나아가 애초에 어떤 형태로든 SplitVC를 Navigation-stack에 쌓는 것을 권장하지 않는다고 하는데, 생각해보면 그러한 UX는 경험해본 적이 없는 것 같다(다들 HIG를 잘 지키는구나 싶었다)  |
| isCollapsed <br> & SplitBehavior <br> & DisplayMode  | - 이번 프로젝트를 시작하면서 많이 난항을 겪었던 부분이다. 특히 SplitBehavior와 DisplayMode가  복합적으로 얽혀있기 때문에 둘을 잘 알고 조화롭게 사용할 수 있어야 한다 <br> - isCollapsed가 true면 ChildVC를 단 하나만 보여주게 된다, 즉 화면을 Split을 하지 않게 된다 <br> - isCollapsed가 false면 이때부터 화면을 split을 하게 된다. 특히 이 값은 Horizontal size-class가 Regular일 때 false가 된다 <br> - split이 된 이후로는 이것을 어떻게 split을 할 지를 결정해야 하는데, 특히 Split Behavior에 따라 가능한 DisplayMode가 달라지는 것을 먼저 알아야 한다 <br> - 그리고 이러한 값들은 read-only이기 때문에 곧바로 set 할 수 없고, preferred가 prefix로 붙은 값들을 통해 할당해야만 한다(preferredSplitBehavior, preferredDisplayMode) <br> - 마치 NumberFormatter의 locale과 numberStyle의 관계와 유사하다는 생각이 들었다 |

<br>

---

<br> 

### 2. Autolayout
| Theme | Description |
| :---: | :--- |
| Draw View Programmatically | - 스토리보드를 사용하면서 정확히 캐치하지 못하고 있던 특성들에 대해서, 코드를 사용하며 뷰를 그리게 되면서 조금 더 잘 이해하게 된 것 같았다 <br> - StackView를 활용하여 화면을 구현하고 이에 대한 Anchor을 다는 과정에서 UIViewCtr이 가지고 있는 view와 이에 대한 safeArea등이 매우 유기적으로 연결되어있고, 이것이 또 Application의 window와도 밀접하게 연관되어있는 것을 확인하면서 신기하고 재밌었다  |
| Intrinsic content-size | - 특히 UITextView와 시작으로 공부하게 됐다 <br> - Intrinsic content-size는 UIView가 기본적으로 어떤 frame을 가질지를 결정하는 값인데, subclass에 따라 그 값이 다르다 <br> - UITextView는 내부 컨텐츠, 즉 text만큼의 크기를 갖게 된다 <br> - 튜토리얼 문서였는지, WWDC였는지... 정확히 기억은 나지 않지만 일단 먼저 이 값을 고려하여 레이아웃을 구성하라고 했던 게 기억에 남는다|
| NSLayoutConstraint | - Storyboard에서 적용하던 constraint가 코드레벨에서 풀어진 것 <br> - class method로 activate를 가지고 있는데, 이를 통해 이 타입의 인스턴스들의 isActive를 모두 true로 만들 수 있다. 별 거 아닌데 보기에도 명료하고 참 좋은 경험이었다 |
| UIStackView | - axis, spacing, distribution, alignment 등을 통해 레이아웃을 재사용하기 쉬우면서, 또 유기적으로 연결될 수 있도록 도와준다 <br> - 알고는 있었지만 적극적으로 활용하지 못했었는데, 이번 프로젝트를 통해 적용해보면서 결과가 매우 깔끔해서 만족스러웠다 |
| CoreGraphics | - `CGPoint`: 2차원 좌표(x,y)를 가지고 있는 타입 <br> - `CGSize`: 2차원 넓이(width, height)를 가지고 있는 타입 <br> - `CGRect`: 좌표(CGPoint)와 넓이(CGSize)를 가지고 있는 2차원 사각형 <br> - `frame`: superView로부터의 CGRect <br> - `bounds`: self로부터의 CGRect -> subView들에게 영향을 끼침 <br> - `inset`: superView로부터의 set -> 간격, 마진 <br> - `offset`: self의 set -> bounds.point -> scrolling에 주로 사용 |
| layoutMarigns vs directionalLayoutMargins | - `layoutMarigns`: top, left, bottom, right를 사용한다 <br> - `directionalLayoutMargins`: top, leading, bottom, trailing을 사용한다 <br> - left와 right는 권장되지 않는 사용법이므로, directionalLayoutMargins을 사용하도록 해야겠다 |

<br> 

---

<br> 

### 3. UITraitCollection
| Theme | Description |
| :---: | :--- |
| UITraitCollection | - 유저의 디바이스 관련된 특징들을 표현하고 있는 타입 <br> - 뭐가 굉장히 많았는데, 일단은 필요한 size-classes만 확인을 했었다 <br> - `Size-classes`: 디바이스의 현재 넓이를 나타내는 값 -> 이를 통해 Orientation을 유추할 수 있다 <br> - 굳이 Autolayout 밖에서 이걸 언급하는 이유는... 아직 이것의 전부를 파악하지 못했기 때문에 여지를 남겨놓고 싶었다 |
| Size-Classes | - `Horizontal Size-class`: 수평크기 Regular 혹은 Compact <br> - `Vertical Size-class`: 수직크기 Regular 혹은 Compact <br> - 위의 두 값을 아울러 wRhR, wChR, wRhC, wChC와 같이 표현하고 이에 따라 디바이스의 크기나 Orientation등을 구분하게 된다.|

<br> 

---

<br> 

### 4. Dependency Manager
* Dependency Manager란 이름 그대로 Dependency, 종속성을 관리해주는 도구이다 

| Theme | Description |
| :---: | :--- |
| Cocoapods | - 85천개 이상의 라이브러리를 가지고 있다 -> 중앙화 되어있 -> 무겁다 <br> - 빌드가 오래 걸린다 <br> - 검색이 용이하다고 한다(실제로 용이한지는 모르겠다) |
| Carthage | - 관리하고 빌드하는 건 도와주지만, 실제로 설치하는 것 직접해야 한다고 한다 <br> - 손이 많이 가지만 퍼포먼스는 좋다고 한다 |
| Swift Package Manager, SPM | - First-party -> 이 이유 하나만으로 SPM을 쓰는 이유가 될 수 있다고 한다 <br> - 애플에서 지원을 하지만, 아직 버그가 많고 지원되지 않는 라이브러리도 있다고 한다(대표적으로 SwiftLint) |
| Mint  | - 내부적으로 SPM을 사용하는 종속성 관리 도구, 프로젝트 버전에 따라 빌드가 캐싱된다 <br> - 즉 같은 프로젝트라도 다른 버전에 따라 다른 종속성을 사용할 수 있다 <br> - 이번 프로젝트를 하면서 Code convention을 위해 SwiftLint을 적용하게 되었는데, SPM을 사용하다가 안되어서 내부적으로 SPM을 사용하는 이것을 사용했는데 아주 손쉽게 사용을 할 수 있어서 최선책으로는 SPM, 차선책으로는 Mint만 쓰기로 마음을 먹었다  |

<br>

---

<br>

### 5. Swift

* Not specified

| Theme | Description |
| :---: | :--- |
| SwiftLint | - 일관된 Code convention을 유지하도록 도와주는 도구 <br> - 사람도 최선을 다해야하지만 human error를 지적해주기에 정말 감사한 도구인 것 같다 <br> - 그럼에도 불구하고 놓치는 부분이 생길 수 있기 때문에 맹신해서는 안될 것 같다 |
| Comment | - `TODO`: `// TODO: - something to do` 해야할 일을 명시하기 위한 주석. 이걸 써놓으면 Xcode가 이걸 읽어서 warning을 띄워준다 <br> - `MARK`: `// MARK: - Something` 어떤 코드에 대한 description을 다는 주석. 특히 한 문서 내에서 코드를 구분할 때에 내용에 따라 코드를 MARK로 구분하게 되면 가독성이 매우 좋아지게 된다 <br> - TODO는 좋기는 하지만 그럼에도 불구하고 해야할 일을 적는다는 점에서, 이걸 적을 바에 그냥 그 일을 하는 게 나을 것이다. 즉 이걸 쓴다는 게 일을 미룬다는 점에서 좋은 것은 아닌 것 같다 <br> - MARK는 사용하는 것이 매우 좋은 경험으로 다가왔고, 코드를 더 명료하게 쓸 수 있게 된 것 같아 앞으로도 써야겠다 |
| init(coder:) | - Interface builder 를 통해 초기화가 될 때에 사용되는 초기화 메소드 <br> - 코드로 사용할 때에는 이것을 통해 초기화가 되면 안되기 때문에 fatalError를 던진다고 한다 <br> - Interface Builder → IB → @IBOutlet..... 🤦‍♂️|
| Repository pattern | - 디자인 패턴의 하나 <br> - data-access에 대해서 특히 캡슐화를 해서 이에 대한 인터페이스를 제공하는 타입을 만들고 <br> - 내부에서는 어떻게 돌아가던지 상관없이 컨트롤러나 뷰에서는 잘 동작하게끔 하는 것 <br> - 여기서의 인터페이스를 `facade`라고 하는 것 같다. 건축용어라고 하셨는데 아주 딱 들어맞는 것 같다. 건축용어가 프로그래밍을 할 때 쓰이다니 뭔가 신선하기도 하고 묘하기도 하고... 재밌다 <br> - 모든 data-access를 책임지기 때문에 이 타입은 굉장히 무거워질 수 밖에 없을 것 같은데, 이 안에서도 다시 부분을 나누어서 관리를 하는 게 좋을 것 같다|
| lazy, <br> closure | - 둘 다 프로퍼티를 초기화 할 수는 있지만 <br> - lazy의 경우에는 해당 프로퍼티에 처음 접근하기 전까지는 초기화가 되지 않기 때문에 정말로 초기화가 필요한 값일 경우에는, 반드시 인스턴스가 만들어진 뒤에 한번 접근을 해놓아야 한다 <br> - lazy의 경우에는 멤버 메소드를 사용할 수 있다는 점에서 깔끔한 문서를 작성할 수 있지만, 해당 프로퍼티가 thread-safe하지 않기 때문에 발생할 수 있는 문제점들을 고려해야 한다 <br> - 익명 클로저를 통한 초기화의 경우에는 클로저가 단지 기능을 하는 블록 단위라는 점에서, 이게 언제 어디에 있던 수행할 수 있기 때문에 아주 편리하게 값을 초기화 해놓을 수 있다 |
| Debouncing | - 처음에는 텍스트뷰의 컨텐츠가 변경될 때마다 이것을 상위뷰에 알리고 있었다 <br> - 하지만 알린 후에 생기는 사이드 이팩트를 고려하면, 지금은 짐작할 수 있더라도 나중에는 오버헤드를 짐작할 수 없게 될 여지가 있었다 <br> - 이러한 이슈들과 함께 동기 캠퍼인 Geon이 쓰로틀링과 디바운싱이라는 기법이 있다는 것을 알려주셨고, 특히 디바운싱을 반영하셨다고 하시며 알려주셔서 적극적으로 활용하게 되었다 |

* Performance(With WWDC)

| Theme | Description |
| :---: | :--- |
| Compile | - Swift의 Compiler는 우리가 작성한 코드가 런타임때에 최고의 성능을 발휘하도록 많은 일을 한다 <br> - 특히 배운 것 중 중요한 것은 ARC와 Method dispatch(특히 Static dispatch)가 있겠다 <br> - Dynamic dispatch: 런타임에 메소드를 찾는 것 <br> - Static dispatch: 빌드 시 메소드를 미리 가져다 놓는 식으로, 코드를 기계가 읽기 쉽게 하는 것 |
| Value type | - 구조체와 열거형이 있다 <br> - value가 곧 identity이다 <br> - stack에 저장된다 <br> - stack에 저장된다고 해서 반드시 성능에 유리한 것은 아니다 <br> -- a. 만약 내부에 reference type을 프로퍼티로 가지고 있게 된다면, 프로퍼티들은 모두 ARC에 의해 관리된다 <br> -- b. struct는 값을 복사하기 때문에, a의 인스턴스를 복사하면 이게 가지고 있는 reference를 복사하고 이에 대한 retain을 하게 된다 <br> -- c. 특히 이런 복사가 많아진다 수많은 value가 복사되고, 하나의 참조에 대해 무수히 많은 reference들이 복사되고 retain-release를 하게 되어 성능에 불리해지게 된다 <br> -- d. 따라서 내부에 reference type을 많이 가지고 있다면 애초부터 class로 정의하는 게 성능에 유리할 수 있다 <br> -- e. 혹은 애초부터 reference를 없애거나... enum을 활용하거나 해서...|
| Reference type | - 클래스와 클로저가 있다 <br> - reference가 곧 identity이다 <br> - heap에 저장된다 <br> - 다형성polymorphism을 추구하기 위한 방법으로 상속을 지원한다 <br> - 상속을 지원하기 때문에, 호출 시점에 해당 클래스를 어떤 이름으로 부르느냐에 따라서, 상속관계 중 누구의 메소드를 호출할 것인지 파악해야할 여지가 있다 -> Dynamic dispatch를 할 수 밖에 없게 된다 <br> - 이러한 여지를 없애기 위한 방법으로 private와 final을 적절히 활용하면 Dynamic dispatch에 대한 오버헤드를 줄일 수 있고, 극단적으로는 Static dispatch도 가능하게 된다 |
| Protocol | - 프로토콜을 통해 구현된 타입은  Existential Container(EC)를 통해 값을 저장한다 <br> - EC는 stack에 저장된다 -> protocol 자체는 일단 값타입이라고 볼 수 있겠다 <br> - EC는 value buffer, value witness table(VWT), protocol witness table(PWT)로 구성된다 <br> - value buffer: 타입의 사이즈가 3word가 넘어가면 값은 head에 reference를 여기에 저장한다. 아니라면 여기에 그대로 값을 저장한다 <br> - VWT: 만약 value buffer가 heap을 가리키고 있다면, 이 VWT를 통해 ARC처럼 값의 life-cycle을 관리하게 된다 <br> PWT: protocol을 통해 구현된 각각의 타입은 각각의 PWT를 가지고 있으며 dynamic dispatch를 이 테이블을 통해 구현하게 된다 → 클래스의 dynamic dispatch보다는 오버헤드가 적기 때문에 권장된다  |
| Generic | - Generic은 타입을 특정함으로써, 컴파일 과정에서 해당 코드가 호출될 때에 어떤 값을 사용하는지 명확히 추론할 수 있도록 도와준다 <br> - 컴파일 때에 이러한 메소드들을 미리 다 만들어놓고 연결하는 방법, 즉 static dispatch를 가능하게 한다 | 

<br>

---

<br>

### 6. KeyChain, UserDefaults, KeyedArchiver

| Theme | Description |
| :---: | :--- |
| Keychain | - 암호화된 데이터베이스, 앱을 뜯어도 보이지 않는다 <br> - 키체인 영역은 앱의 샌드박스 외부에 존재하기 때문에 앱을 삭제해도 키체인 데이터는 남아있고, 따로 삭제를 해야한다 <br> - iOS는 키체인이 1개, macOS는 여러개 <br> - 헝가리안 표기법 중 k-: Konstante, 옛날에 코딩할 때는 Xcode가 이게 let인지 var인지 바로 알려주지 않았기 때문에 이렇게 이름을 통해 명시했다고 한다 |
| UserDefaults | - 서로 다른 유형의 데이터들에 대해서 단순 저장을 가능하게 해주는 클래스 <br> - 공식 문서를 참고하면 위치는 Sandbox/Document/Library/Preferences일 것이라고 짐작된다 <br> - 앱의 sandbox내에 있기 때문에 앱을 삭제하면 함께 삭제된다 <br> - 암호화를 거치지 않았고 앱을 뜯어보면 보이기 때문에, 이러한 점을 고려하여 신중히 사용해야 한다고 한다 <br> - Sandbox내의 영역이라는 점에서 기본적으로 앱 간의 공유가 불가능하지만, 따로 설정을 해줄 수도 있다. |
| NSKeyedArchiver | - Objective-C를 활발히 사용할 때에 Codable처럼 사용하던 클래스 <br> - encode한 binary를 디스크에 저장하거나, 해당 binary를 decode하여 불러오거나... <br> - 디스크와 직접 상호작용한다는 점에서, 지역성과 영속성을 갖추고 있을 것이라고 짐작된다 |

<br>

---

<br>

### 7. CoreData

| Theme | Description |
| :---: | :--- |
| CoreData stack | - Persistent container -> NSPersistentContainer <br> - Model -> NSMangedObjectModel <br> - Context -> NSMangedObjectContext <br> - Store Coordinator -> NSPersistentStoreCoordinator |
| NSPersistentContainer | - Core Data Stack 그 자체라고 봐도 무방한 요소 <br> - Model, Context, Store coordinator 를 가지고 있다 <br> - 프로젝트를 만들 때에 CoreData를 사용한다고 체크해놓으면, AppDelegate에 이에 대한 구현부가 미리 작성되어있다|
| NSManagedObjectModel | - xcdatamodeld 파일에 정의된 내용들을 다시 코드 레벨에서  풀어주는 타입, 말그대로 모델 그 자체 <br> - 이게 바뀌면 마이그레이션을 해야하는데, <br> - 런타임에 바뀌면 old와 new를 구분해서 old는 삭제시키는 게 아니라 depreacted를 시켜야한다고 한다 <br> - 각각의 모델마다 context를 가지고 있다  <br> - Entity → DB에 저장되어 있는 타입, 기록 <br> - Model → Swift에서 사용하고 정의하면서, 현실 세상을 반영하는 타입|
| NSMangedObjectContext | - 위의 모델을 조작하고, 변경을 추적하는 타입 <br> - 이번 프로젝트를 하면서 가장 많이 사용하게 된 타입 -> 실제로 중요한 타입 <br> - 스토어에 반영되기 전, 메모리 내에서 모델을 관리하는 타입 <br> - 컨텍스트-컨텍스트, 컨텍스트-스토어 등의 관계를 가질 수 있고, 하위 타입에서 변경이 일어나면 상위 타입에게 알려주어야 한다 → 루트 컨텍스트가 존재하며 이는 반드시 스토어와 연결되어있다 <br> - 부모 컨텍스트의 경우 다양한 자식 컨텍스트로부터 리퀘스트를 받을 수 있기 때문에, thread-safe를 고려해야 한다 <br> - 루트 컨텍스트가 스토어에 커밋하기 전까지는, 자식 컨텍스트의 커밋은 스토어에 반영되지 않는다(in-memory) <br> - insertedObjects, updatedObjects, deletedObjects라는 프로퍼티들을 통해 이러한 내용들을 기록 및 유지하고 있다 <br> - context.save() 를 하게 되면 store에 내용을 반영하면서, registeredObjects에 데이터를 동기화한다|
| NSPersistentStoreCoordinator | - Context와 Store 사이에서, Context의 요구대로 값을 입력하거나, 값을 전달해주는 타입 <br> - Coordinator는 작업을 동시성과는 상반되게 동작한다. 즉 작업을 직렬화한 뒤 동작한다. 때문에 멀티스레드 환경에서 사용하고 싶다면, 그만큼의 Coordinator를 생성할 필요가 있다 |
| NSFetchedResultsController | - 코어데이터로부터 Retrieve한 결과를 관리하고, View와 연동할 수 있도록 도와주는 컨트롤러 <br> - UITableViewDataSource와 연동해서 쓸 수 있다는 특징이 있다고 한다 <br> - 데이터 내에서 section을 만들거나, 어떤 특징으로 솔팅을 하거나(NSSortDescriptor)...|
| NSFetchRequest | - 위의 컨트롤러에서, 실제로 Retrieve를 할 때에 사용하는 타입|

<br>

---

<br>

### 8. Responder Chain

| Theme | Description |
| :---: | :--- |
| Event Propagation | - 가장 앞에 있는 View 요소가 이벤트를 수신하는 매체가 된 뒤, <br> - 자신의 위에 존재하는 UIResponder에게 이벤트를 전파한다 <br> - 뷰의 계층 구조 내에서 이러한 동작이 반복되다가 이 이벤트를 캐치하여 동작하는 UIResponder가 있으면 전파를 멈추고 해당 동작을 실행한다 |
| Gesture Recognizer | - 이벤트의 bridge라고 이해할 수 있겠다. Responder chain을 통한 전파가 아니라, 곧장 특정 객체에게 알려주는 것|

<br>

---

### 9. Keyboard (UIScene, UIWindow)

* `UIScene`: UI를 표현하는 타입 (View X)
* `UIWindow`: 화면에 UI를 나타낼 때, 그 도화지가 되어주는 타입 (View O)
* UIViewController와 UIViewController.view 의 관계처럼 UIScene과 UIWindow도 같은 관계를 갖는다고 이해했다 <br> - 특히 키보드 관련 이슈를 해결하다가 공부를 하게 됐다 <br> - 키보드를 띄운 듸 LLDB를 켜게 되면 앱은 아래와 같은 계층구조를 표현하게 된다 <br> ---UIWindowScene <br> -------UIWindow <br> -------UITextEffectsWindow <br> ---_UIKeyboardWindowScene <br> ------- UIRemoteKeyboardWindow 
* 먼저 UIWindowScene은 UIScene을 상속받는 UI를 표현하고 있는 인스턴스다
* UIWindow는 내가 작성한 ViewController나 View가 올라가게 되는 도화지이다
* UITextEffectsWinodw에 대한 내용은 XCode내에서는 찾을 수 없었다. 정확히 무엇인지는 도통 모르겠지만... 아래 scene에서 표현하는 키보드를 매핑하는 타입이라고 짐작된다
* 그리고 _UIKeyboardWindowScene이라고 하는, private한 UIKeyboardWindowScene이라는 scene이 하나 생성된다
* 이 안에는 UIRemoteKeyboardWIndow라고 하는 도화지가 존재한다. 여기에 진짜 키보드 뷰가 그려진다
* 즉 한 앱에서 2개의 Scene과, 즉 3개의 도화지가 있는 셈이다. 도화지가 서로 다르다는 점에서, 또 각각 Foreground active라고 하는 키워드를 달고 있다는 점에서, 이 때 각각의 scene을 각각의 앱으로 볼 수 있을 것 같다
* 그런데 또 곰곰히 생각을 해보니, 앞서 표현한 앱은 좀 올드한 앱이고, 개발하는 입장에서는 그냥 scene이라고 표현하는 게 적절할 것 같다
* 즉 키보드처럼 iOS에서 scene을 제공하는 경우를 제외한다면, 일반적인 경우에는 scene은 하나만 존재할 것이다
* 그렇다면 window는? 이라는 질문에 대해서는 조금 고민이 필요하겠지만, UIWindowScene은 특히 그 정의부터 여러개의 윈도우를 매니징할 수 있기 때문에 충분히 가능한 것이라고 말할 수 있겠다

<br>

---

### 10. Animation

| Theme | Description |
| :---: | :--- |
| Possible properties | - frame <br> - bounds <br> - center <br> - transform <br> - alpha <br> - backgroundColor <br> - backgroundColor를 제외하면 모두 CG요소인데... 억지로 끼워맞추자면 Core한 요소들에만 애니메이션을 준다고 말할 수 있겠다 |
| Usage | `animate`: 간단한 애니메이션에 유용 <br> `animateKeyFrames`: 해당 클로저 안에서 addKeyframe을 호출해서 애니메이션을 구현|

<br>