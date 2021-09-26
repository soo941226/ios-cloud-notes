# 𝞪. 이번 프로젝트를 통해 학습한 것

* 목차
  * [1. UISplitViewController](#1-uisplitviewcontroller)

<br>

---

<br>

### 1. UISplitViewController
| 주제 | 내용 |
| --- | --- |
| Device & HIG | - iPad를 실제로 사용하지 않다보니, 이에 대한 UI나 UX는 고려하지 않고 있었다는 것을 깨달았다. <br> - 관련 문서들을 살펴보니, iOS와 iPadOS로 나뉘어져 있음에도 HIG에서는 iPad에 관련된 내용들이 iOS에 있는 것을 확인했다. 애플이 pad를 강력하게 밀고는 있지만, 아직은 과도기가 아닌가 하는 생각이 들었다 <br> - 그리고 이렇게 기기에 따라, 특히 size class에 따라 달라지는 UI/UX에 대한 요구사항 중 SplitView는, UISplitViewController를 통해 구현하는 것을 확인했다 |
| UISplitViewController.Style | - Double-column과 Triple-Column으로 구분된다 <br> - Double은 Primary와 Secondary의 UIViewController를 가지고 있게 된다 <br> - Triple은 여기에 supplementary를 더한다 <br> - 그리고 iOS14이후로 unspecified라고 하는 케이스가 추가 되었는데, 클래식한 스플릿뷰를 위함이라고 한다. 그런데 여기서 말하는 클래식이 무엇인지 잘 모르겠다 |
| Container for UIViewController | - 위의 Style에서 언뜻 언급한 것처럼, UISplitVC는 내부에 UIViewController를 갖고 있게 된다 <br> - 즉 UINavigationController와 유사한 역할을 하게 되는데, 실제로 SplitView는 내부에 NavigationVC를 만들어서 사용하기도 한다 <br> - UIVC는 자신의 SplitVC를 가리키는 weak 프로퍼티를 가지고, 이와 관련된 기본적인 기능들이 초기구현되어있다 <br> - 이것들을 잘 알고 사용하는 것도 좋지만, 필요한 기능들을 적재적소에 사용하기 위해서는 임의로 기능을 구현해도 괜찮다고 생각된다 <br> - SplitVC가 UIVC의 container이기 때문에, 마찬가지의 특성을 갖는 NavigaitonVC에 이것을 그대로 push할 수 없다. UIVC안에 SplitVC를 만들어서 이것을 push 하는 것처럼, 트릭을 쓰면 가능은 하지만 권장하지 않는 방법이라고 한다 <br> - 나아가 애초에 어떤 형태로든 SplitVC를 Navigation-stack에 쌓는 것을 권장하지 않는다고 하는데, 생각해보면 그러한 UX는 경험해본 적이 없는 것 같다(다들 HIG를 잘 지키는구나 싶었다)  |
| isCollapsed <br> & SplitBehavior <br> & DisplayMode  | - 이번 프로젝트를 하면서 많이 난항을 겪었던 부분이다. 특히 SplitBehavior와 DisplayMode가  복합적으로 얽혀있기 때문에 둘을 잘 알고 조화롭게 사용할 수 있어야 한다 <br> - isCollapsed가 true면 ChildVC를 단 하나만 보여주게 된다, 즉 화면을 Split을 하지 않게 된다 <br> - isCollapsed가 false면 이때부터 화면을 split을 하게 된다. 특히 이 값은 Horizontal size-class가 Regular일 때 false가 된다 <br> - split이 된 이후로는 이것을 어떻게 split을 할 지를 결정해야 하는데, 특히 Split Behavior에 따라 가능한 DisplayMode가 달라지는 것을 먼저 알아야 한다 <br> - 그리고 이러한 값들은 read-only이기 때문에 곧바로 set 할 수 없고, preferred가 prefix로 붙은 값들을 통해 할당해야만 한다(preferredSplitBehavior, preferredDisplayMode) |
| Message Forwarding ||


<br>

---
