# 𝞫. 프로젝트를 진행하며 겪었던 고민들, 문제들

* 목차
    * [1. TableView, TableViewDelegate, TableViewDataSource, TableViewCell의 역할 및 책임...](#1-tableview-tableviewdelegate-tableviewdatasource-tableviewcell---)

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

### 4. Coredata
* 이번 프로젝트에서 가장 어려웠던 부분이면서, 가장 값진 부분이었던 것 같다

| Theme | Description |
|:---:|:---|
| CRUD의 사후처리 | |
| Retreive에 실패했을 때 어떻게 할 것인가 | |
| persistentContainer의 위치 | |
| CloudNote와 Memo | |
| isTest... | |

<br>

---

<br>

### 4. Autolayout

| Theme | Description |
|:---:|:---|
| UIStackView ||
| UITextView ||
| Keyboard ||