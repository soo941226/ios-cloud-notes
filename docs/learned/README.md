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
  * [9. Keyboard (UIScene, UIWindow, Notification Center)](#9-keyboard-uiscene-uiwindow-notification-center)
  * [10. Animation](#10-animation)

<br>

---

<br>

### 1. UISplitViewController
| Theme | Description |
| --- | --- |
| Device & HIG | - iPad를 실제로 사용하지 않다보니, 이에 대한 UI나 UX는 고려하지 않고 있었다는 것을 깨달았다. <br> - 관련 문서들을 살펴보니, iOS와 iPadOS로 나뉘어져 있음에도 HIG에서는 iPad에 관련된 내용들이 iOS에 있는 것을 확인했다. 애플이 pad를 강력하게 밀고는 있지만, 아직은 과도기가 아닌가 하는 생각이 들었다 <br> - 그리고 이렇게 기기에 따라, 특히 size class에 따라 달라지는 UI/UX에 대한 요구사항 중 SplitView는, UISplitViewController를 통해 구현하는 것을 확인했다 |
| UISplitViewController.Style | - Double-column과 Triple-Column으로 구분된다 <br> - Double은 Primary와 Secondary의 UIViewController를 가지고 있게 된다 <br> - Triple은 여기에 supplementary를 더한다 <br> - 그리고 iOS14이후로 unspecified라고 하는 케이스가 추가 되었는데, 클래식한 스플릿뷰를 위함이라고 한다. 그런데 여기서 말하는 클래식이 무엇인지는 파악하지 못했다 <br> - 현재에는 Double-column만 사용했으나, Triple을 사용하는 것도 현재와 크게 다르지 않게 사용할 수 있을 것 같다 |
| Container for UIViewController | - 위의 Style에서 언뜻 언급한 것처럼, UISplitVC는 내부에 UIViewController를 갖고 있게 된다 <br> - 즉 UINavigationController와 유사한 역할을 하게 되는데, 실제로 SplitView는 내부에 UINavCtr를 만들어서 사용하기도 한다 <br> - UIViewCtr는 자신의 SplitViewCtr를 가리키는 weak 프로퍼티를 가지고, 이와 관련된 기본적인 기능들이 초기구현되어있다 <br> - 이것들을 잘 알고 사용하는 것도 좋지만, 필요한 기능들을 적재적소에 사용하기 위해서는 임의로 기능을 구현해도 괜찮다고 생각된다 <br> - SplitVC가 UIViewCtr의 container이기 때문에, 마찬가지의 특성을 갖는 NavCtr에 이것을 그대로 push할 수 없다. 약간의 트릭을, UIViewCtr안에 SplitVC를 만들어서 이것을 push 하는 형태로, 쓰면 가능은 하지만 권장하지 않는 방법이라고 한다 <br> - 나아가 애초에 어떤 형태로든 SplitVC를 Navigation-stack에 쌓는 것을 권장하지 않는다고 하는데, 생각해보면 그러한 UX는 경험해본 적이 없는 것 같다(다들 HIG를 잘 지키는구나 싶었다)  |
| isCollapsed <br> & SplitBehavior <br> & DisplayMode  | - 이번 프로젝트를 시작하면서 많이 난항을 겪었던 부분이다. 특히 SplitBehavior와 DisplayMode가  복합적으로 얽혀있기 때문에 둘을 잘 알고 조화롭게 사용할 수 있어야 한다 <br> - isCollapsed가 true면 ChildVC를 단 하나만 보여주게 된다, 즉 화면을 Split을 하지 않게 된다 <br> - isCollapsed가 false면 이때부터 화면을 split을 하게 된다. 특히 이 값은 Horizontal size-class가 Regular일 때 false가 된다 <br> - split이 된 이후로는 이것을 어떻게 split을 할 지를 결정해야 하는데, 특히 Split Behavior에 따라 가능한 DisplayMode가 달라지는 것을 먼저 알아야 한다 <br> - 그리고 이러한 값들은 read-only이기 때문에 곧바로 set 할 수 없고, preferred가 prefix로 붙은 값들을 통해 할당해야만 한다(preferredSplitBehavior, preferredDisplayMode) <br> - 마치 NumberFormatter의 locale과 numberStyle의 관계와 유사하다는 생각이 들었다 |

<br>

---

<br> 

### 2. Autolayout
| Theme | Description |
|---|---|
| Draw View Programmatically | - 스토리보드를 사용하면서 정확히 캐치하지 못하고 있던 특성들에 대해서, 코드를 사용하며 뷰를 그리게 되면서 조금 더 잘 이해하게 된 것 같았다 <br> - StackView를 활용하여 화면을 구현하고 이에 대한 Anchor을 다는 과정에서 UIViewCtr이 가지고 있는 view와 이에 대한 safeArea등이 매우 유기적으로 연결되어있고, 이것이 또 Application의 window와도 밀접하게 연관되어있는 것을 확인하면서 신기하고 재밌었다  |
| Intrinsic content-size | - 특히 UITextView와 시작으로 공부하게 됐다 <br> - Intrinsic content-size는 UIView가 기본적으로 어떤 frame을 가질지를 결정하는 값인데, subclass에 따라 그 값이 다르다 <br> - UITextView는 내부 컨텐츠, 즉 text만큼의 크기를 갖게 된다 <br> - 튜토리얼 문서였는지, WWDC였는지... 정확히 기억은 나지 않지만 일단 먼저 이 값을 고려하여 레이아웃을 구성하라고 했던 게 기억에 남는다|
| NSLayoutConstraint | - Storyboard에서 적용하던 constraint가 코드레벨에서 풀어진 것 <br> - class method로 activate를 가지고 있는데, 이를 통해 이 타입의 인스턴스들의 isActive를 모두 true로 만들 수 있다. 별 거 아닌데 보기에도 명료하고 참 좋은 경험이었다 |
| UIStackView | - axis, spacing, distribution, alignment 등을 통해 레이아웃을 재사용하기 쉬우면서, 또 유기적으로 연결될 수 있도록 도와준다 <br> - 알고는 있었지만 적극적으로 활용하지 못했었는데, 이번 프로젝트를 통해 적용해보면서 결과가 매우 깔끔해서 만족스러웠다 |
| CoreGraphics | - `CGPoint`: 2차원 좌표(x,y)를 가지고 있는 타입 <br> - `CGSize`: 2차원 넓이(width, height)를 가지고 있는 타입 <br> - `CGRect`: 좌표(CGPoint)와 넓이(CGSize)를 가지고 있는 2차원 사각형 <br> - `frame`: superView로부터의 CGRect <br> - `bounds`: self로부터의 CGRect -> subview들에게 영향을 끼침 <br> - `inset`: superView로부터의 set -> 간격, 마진 <br> - `offset`: self의 set -> bounds.point -> scrolling에 주로 사용 |
| layoutMarigns vs directionalLayoutMargins | - `layoutMarigns`: top, left, bottom, right를 사용한다 <br> - `directionalLayoutMargins`: top, leading, bottom, trailing을 사용한다 <br> - left와 right는 권장되지 않는 사용법이므로, directionalLayoutMargins을 사용하도록 해야겠다 |

<br> 

---

<br> 

### 3. UITraitCollection
| Theme | Description |
|---|---|
| UITraitCollection | - 유저의 디바이스 관련된 특징들을 표현하고 있는 타입 <br> - 뭐가 굉장히 많았는데, 일단은 필요한 size-classes만 확인을 했었다 <br> - `Size-classes`: 디바이스의 현재 넓이를 나타내는 값 -> 이를 통해 Orientation을 유추할 수 있다 <br> - 굳이 Autolayout 밖에서 이걸 언급하는 이유는... 아직 이것의 전부를 파악하지 못했기 때문에 여지를 남겨놓고 싶었다 |
| Size-Classes | - `Horizontal Size-class`: 수평크기 Regular 혹은 Compact <br> - `Vertical Size-class`: 수직크기 Regular 혹은 Compact <br> - 위의 두 값을 아울러 wRhR, wChR, wRhC, wChC와 같이 표현하고 이에 따라 디바이스의 크기나 Orientation등을 구분하게 된다.|

<br> 

---

<br> 

### 4. Dependency Manager
* Dependency Manager란 이름 그대로 Dependency, 종속성을 관리해주는 도구이다 

| Theme | Description |
|---|---|
| Cocoapods | - 85천개 이상의 라이브러리를 가지고 있다 -> 중앙화 되어있 -> 무겁다 <br> - 빌드가 오래 걸린다 <br> - 검색이 용이하다고 한다(실제로 용이한지는 모르겠다) |
| Carthage | - 관리하고 빌드하는 건 도와주지만, 실제로 설치하는 것 직접해야 한다고 한다 <br> - 손이 많이 가지만 퍼포먼스는 좋다고 한다 |
| Swift Package Manager, SPM | - First-party -> 이 이유 하나만으로 SPM을 쓰는 이유가 될 수 있다고 한다 <br> - 애플에서 지원을 하지만, 아직 버그가 많고 지원되지 않는 라이브러리도 있다고 한다(대표적으로 SwiftLint) |
| Mint  | - 내부적으로 SPM을 사용하는 종속성 관리 도구, 프로젝트 버전에 따라 빌드가 캐싱된다 <br> - 즉 같은 프로젝트라도 다른 버전에 따라 다른 종속성을 사용할 수 있다 <br> - 이번 프로젝트를 하면서 Code convention을 위해 SwiftLint을 적용하게 되었는데, SPM을 사용하다가 안되어서 내부적으로 SPM을 사용하는 이것을 사용했는데 아주 손쉽게 사용을 할 수 있어서 최선책으로는 SPM, 차선책으로는 Mint만 쓰기로 마음을 먹었다  |

<br>

---

<br>

### 5. Swift

| Theme | Description |
|---|---|
| SwiftLint | - 일관된 Code convention을 유지하도록 도와주는 도구 <br> - 사람도 최선을 다해야하지만 human error를 지적해주기에 정말 감사한 도구인 것 같다 <br> - 그럼에도 불구하고 놓치는 부분이 생길 수 있기 때문에 맹신해서는 안될 것 같다 |
| Comment | - `TODO`: `// TODO: - something to do` 해야할 일을 명시하기 위한 주석. 이걸 써놓으면 Xcode가 이걸 읽어서 warning을 띄워준다 <br> - `MARK`: `// MARK: - Something` 어떤 코드에 대한 description을 다는 주석. 특히 한 문서 내에서 코드를 구분할 때에 내용에 따라 코드를 MARK로 구분하게 되면 가독성이 매우 좋아지게 된다 <br> - TODO는 좋기는 하지만 그럼에도 불구하고 해야할 일을 적는다는 점에서, 이걸 적을 바에 그냥 그 일을 하는 게 나을 것이다. 즉 이걸 쓴다는 게 일을 미룬다는 점에서 좋은 것은 아닌 것 같다 <br> - MARK는 사용하는 것이 매우 좋은 경험으로 다가왔고, 코드를 더 명료하게 쓸 수 있게 된 것 같아 앞으로도 써야겠다 |
| init(coder:) | - Interface builder 를 통해 초기화가 될 때에 사용되는 초기화 메소드 <br> - 코드로 사용할 때에는 이것을 통해 초기화가 되면 안되기 때문에 fatalError를 던진다고 한다 <br> - Interface Builder → IB → @IBOutlet..... 🤦‍♂️|
| lazy, <br> closure | |
| Compile | |
| Value type | |
| Reference type | |
| Protocol | |
| Generic | | 

<br>

---

<br>

### 6. KeyChain, UserDefaults, KeyedArchiver

| Theme | Description |
|---|---|
|||

<br>

---

<br>

### 7. Coredata

| Theme | Description |
|---|---|
|||

<br>

---

<br>

### 8. Responder Chain

| Theme | Description |
|---|---|
|||

<br>

---

### 9. Keyboard (UIScene, UIWindow, Notification Center)

| Theme | Description |
|---|---|
|||

<br>

---

### 10. Animation

| Theme | Description |
|---|---|
|||

<br>
