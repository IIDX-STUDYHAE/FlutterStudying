코드는 플러터 기반으로 쓰였고, 따로 백앤드 기술 없이 플러터 2일 공부한 사람이 딱 짤만한 코드 느낌입니다.

시작화면에서 >>(fast_forward Icon)을 누르면 15초간 Gaming 상태가 되어서, 좌우측 하단에 A랑 B로 쓰여있는 버튼을 누릅니다 A-B-A-B-A-B 트릴의 속도를 측정해서 1초마다 상단에 트릴의 속도를 알려주고, 삑난 횟수도 알려줍니다. 아무래도 15초간 삑 안 내고 치는게 단순히 빠르게 치는것 보단 훨씬 중요하겠죠?

그냥 간단하게 위젯 공부 겸사겸사 만든거임

일단 지금은 이렇게 Flutter 코드만 대충 해두고, 수업 3주간 들은 뒤에 이 틀을 개선할 점들 싹 다 line by line으로 개선한 뒤에 앱다운 앱의 형태로 remaster할 예정







추후에 개선해야 할 점은 크게 2가지가 있습니다. 우선 첫 번째로 순수하게 성능이 구리다는 것입니다. 이럴 때 ffi 등 C 기반의 솔루션도 좋은 해답이 될 수 있을 것이고 아니면 삑을 잡는 매커니즘 자체를 좀 더 깔끔하게 해주면(지금은 AA가 동시에 입력되거나 BB가 동시에 입력되면 삑 횟수가 +1이 되는 구조인데 갤럭시로 사이터스같은거 해보신 분들은 알겠지만 이게 본질적으로 문제가 많은 코드지요..) 개선이 체감될 수 있을 것입니다. 아무래도 C 기반 메커니즘을 적용해서 이참에 0.01초 단위로 움직이는 남은시간 보여주는 위젯을 넣는 것이 제일 이상적이라 생각됩니다. 
그리고 2번째로 중간중간 리셋이 필요할 때를 대비하여 리셋하는 버튼을 넣어야 합니다. 이 리셋하는 버튼은 구현도 쉽지만 어디다가 둘지 정말 애매해서 안 넣었습니다. 일단 실수로 터치할 가능성이 0인 곳에 둬야 하는데 동시에 그 가능성이 0인 곳은 정보를 띄워야 하기에 가독성을 해칩니다. 
추가로 구현하고 싶은 점은, 'sns에 공유하기' 기능을 추가하고 싶습니다. 일단 3주간 계절수업을 듣고 강해진 뒤에 이 개선점들을 마구마구 구현하고 싶네요 감사합니다 
