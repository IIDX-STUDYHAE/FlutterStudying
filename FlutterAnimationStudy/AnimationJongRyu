//후 더 더 더 더 더 열심히 의대생 CPA 로준 이런감성으루다가 매운맛모드로 공부를 합시다 할 수 있는 최대 역량에서 한 20퍼센트 더 뽑아낸단 마인드로!!
//이거 하고 좀 더 3D 애니메이션 라이브러리 관련해서 공부를 하고 싶은데 함수형언어 과제 남아있는게 너무 어려워서(다음주까지긴 한데) 일단 이거부터 마무리하고 더 공부하는거로 
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BallRollingApp());
  }
}

class BallRollingApp extends StatefulWidget {
  @override
  _BallRollingAppState createState() => _BallRollingAppState();
}

class _BallRollingAppState extends State<BallRollingApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  String _selectedCurveName = 'linear'; // 초기 상태

  //한 줄 요약 쿼리는 Grok3 AI의 도움을 받아서 생성했습니다. 
  final Map<String, Map<String, dynamic>> _curveMap = {
    'linear': {
      'curve': Curves.linear,
      'description': 'Moves at a constant speed',
    },
    'bounceIn': {
      'curve': Curves.bounceIn,
      'description': 'Bounces at the start',
    },
    'bounceInOut': {
      'curve': Curves.bounceInOut,
      'description': 'Bounces at start and end',
    },
    'bounceOut': {
      'curve': Curves.bounceOut,
      'description': 'Bounces at the end',
    },
    'decelerate': {
      'curve': Curves.decelerate,
      'description': 'Slows down gradually',
    },
    'ease': {'curve': Curves.ease, 'description': 'Smooth start and end'},
    'easeIn': {'curve': Curves.easeIn, 'description': 'Starts slow, ends fast'},
    'easeInSine': {
      'curve': Curves.easeInSine,
      'description': 'Sine-based slow start',
    },
    'easeInQuad': {
      'curve': Curves.easeInQuad,
      'description': 'Quadratic slow start',
    },
    'easeInCubic': {
      'curve': Curves.easeInCubic,
      'description': 'Cubic slow start',
    },
    'easeInQuart': {
      'curve': Curves.easeInQuart,
      'description': 'Quartic slow start',
    },
    'easeInQuint': {
      'curve': Curves.easeInQuint,
      'description': 'Quintic slow start',
    },
    'easeInExpo': {
      'curve': Curves.easeInExpo,
      'description': 'Exponential slow start',
    },
    'easeInCirc': {
      'curve': Curves.easeInCirc,
      'description': 'Circular slow start',
    },
    'easeInBack': {
      'curve': Curves.easeInBack,
      'description': 'Pulls back before starting',
    },
    'easeInOut': {
      'curve': Curves.easeInOut,
      'description': 'Slow start and end, fast middle',
    },
    'easeInOutSine': {
      'curve': Curves.easeInOutSine,
      'description': 'Sine-based smooth start and end',
    },
    'easeInOutQuad': {
      'curve': Curves.easeInOutQuad,
      'description': 'Quadratic smooth start and end',
    },
    'easeInOutCubic': {
      'curve': Curves.easeInOutCubic,
      'description': 'Cubic smooth start and end',
    },
    'easeInOutQuart': {
      'curve': Curves.easeInOutQuart,
      'description': 'Quartic smooth start and end',
    },
    'easeInOutQuint': {
      'curve': Curves.easeInOutQuint,
      'description': 'Quintic smooth start and end',
    },
    'easeInOutExpo': {
      'curve': Curves.easeInOutExpo,
      'description': 'Exponential smooth start and end',
    },
    'easeInOutCirc': {
      'curve': Curves.easeInOutCirc,
      'description': 'Circular smooth start and end',
    },
    'easeInOutBack': {
      'curve': Curves.easeInOutBack,
      'description': 'Pulls back at start, overshoots at end',
    },
    'easeOut': {
      'curve': Curves.easeOut,
      'description': 'Starts fast, ends slow',
    },
    'easeOutSine': {
      'curve': Curves.easeOutSine,
      'description': 'Sine-based slow end',
    },
    'easeOutQuad': {
      'curve': Curves.easeOutQuad,
      'description': 'Quadratic slow end',
    },
    'easeOutCubic': {
      'curve': Curves.easeOutCubic,
      'description': 'Cubic slow end',
    },
    'easeOutQuart': {
      'curve': Curves.easeOutQuart,
      'description': 'Quartic slow end',
    },
    'easeOutQuint': {
      'curve': Curves.easeOutQuint,
      'description': 'Quintic slow end',
    },
    'easeOutExpo': {
      'curve': Curves.easeOutExpo,
      'description': 'Exponential slow end',
    },
    'easeOutCirc': {
      'curve': Curves.easeOutCirc,
      'description': 'Circular slow end',
    },
    'easeOutBack': {
      'curve': Curves.easeOutBack,
      'description': 'Overshoots before ending',
    },
    'elasticIn': {
      'curve': Curves.elasticIn,
      'description': 'Elastic bounce at start',
    },
    'elasticInOut': {
      'curve': Curves.elasticInOut,
      'description': 'Elastic bounce at start and end',
    },
    'elasticOut': {
      'curve': Curves.elasticOut,
      'description': 'Elastic bounce at end',
    },
    'fastOutSlowIn': {
      'curve': Curves.fastOutSlowIn,
      'description': 'Fast start, slow end',
    },
    'fastLinearToSlowEaseIn': {
      'curve': Curves.fastLinearToSlowEaseIn,
      'description': 'Linear fast start, slow ease-in end',
    },
    'linearToEaseOut': {
      'curve': Curves.linearToEaseOut,
      'description': 'Linear start, ease-out end',
    },
    'slowMiddle': {
      'curve': Curves.slowMiddle,
      'description': 'Slows down in the middle',
    },
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _updateAnimation();
  }

  // 애니메이션 업데이트 (곡선 변경 시 호출)
  void _updateAnimation() {
    _xAnimation = Tween<double>(begin: -100, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: _curveMap[_selectedCurveName]!['curve'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 초록색 그라디언트 배경
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[200]!, Colors.green[600]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                width: 640,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    _curveMap[_selectedCurveName]!['description'],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 240 + MediaQuery.of(context).size.width / 2, // 화면 중심 기준
              top: MediaQuery.of(context).size.height / 2 - 50,
              child: Container(width: 10, height: 100, color: Colors.white),
            ),
            // 공 애니메이션
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_xAnimation.value, 0),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
            // 메뉴 (https://pub.dev/packages/curved_animation_controller 참조)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // 드롭다운 위젯 배경 흰색
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DropdownButton<String>(
                    value: _selectedCurveName,
                    style: TextStyle(
                      fontSize: 24, // 텍스트 크기
                      color: Colors.black,
                    ),
                    dropdownColor: Colors.white, // 드롭다운 메뉴 배경 흰색
                    iconSize: 36, // 화살표 아이콘 크기
                    itemHeight: 60, // 항목 높이
                    items:
                        _curveMap.keys.map((curveName) {
                          return DropdownMenuItem<String>(
                            value: curveName,
                            child: Text(
                              curveName,
                              style: TextStyle(fontSize: 24),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newCurveName) {
                      if (newCurveName != null) {
                        setState(() {
                          _selectedCurveName = newCurveName;
                          _updateAnimation(); // 새 곡선으로 애니메이션 업데이트
                          _controller.reset(); // 공 위치 리셋
                          _controller.forward(); // 애니메이션 재실행
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
