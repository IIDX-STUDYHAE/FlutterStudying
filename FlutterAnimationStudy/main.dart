//AnimationJongRyu에서 screenUtil을 적용해다라고 ai에 부탁함. 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // screen_util 패키지 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize(); // ScreenUtil 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // ScreenUtilInit으로 감싸기
      designSize: const Size(720, 1280), // 디자인 기준 화면 크기 (임의 값)
      minTextAdapt: true, // 텍스트 크기 자동 조절
      splitScreenMode: true, // 분할 화면 모드 지원
      builder: (context, child) {
        return MaterialApp(home: BallRollingApp());
      },
    );
  }
}

class BallRollingApp extends StatefulWidget {
  @override
  _BallRollingAppState createState() => _BallRollingAppState();
}

class _BallRollingAppState extends State<BallRollingApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yAnimation; // Y축 애니메이션
  String _selectedCurveName = 'linear'; // 초기 상태

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
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    _updateAnimation();
    _controller.forward();
  }

  // 애니메이션 업데이트 (곡선 변경 시 호출)
  void _updateAnimation() {
    _yAnimation = Tween<double>(begin: -100.h, end: 100.h).animate(
      // Y축 범위 조정
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
            // 흰색 텍스트 박스 (화면 상단에서 약간 아래, 좌우 안쪽으로 이동)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w), // 좌우 패딩 적용
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity, // 부모의 전체 너비 사용
                  height: 32.h,
                  margin: EdgeInsets.only(
                    top: 8.h + 50.h,
                  ), // 기존 top 마진 + 50dp 아래로 이동
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      _curveMap[_selectedCurveName]!['description'],
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
            ),
            // 기준선 (화면 중앙 Y축)
            // 공 애니메이션 (화면 중앙 Y축 기준 움직임)
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _yAnimation.value), // Y축으로만 움직임
                    child: Container(
                      width: 80.w, // 너비 상대적으로 조정
                      height: 80.h, // 높이 상대적으로 조정
                      decoration: const BoxDecoration(
                        color: Color(0xFF000000),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
            // 드롭다운 메뉴 (화면 하단에서 약간 위로, 좌우 안쪽으로 이동)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w), // 좌우 패딩 적용
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 16.h + 50.h,
                  ), // 기존 bottom 패딩 + 50dp 위로 이동
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // 드롭다운 위젯 배경 흰색
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.r,
                          offset: Offset(2.w, 2.h),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCurveName,
                      style: TextStyle(fontSize: 24.sp, color: Colors.black),
                      dropdownColor: Colors.white, // 드롭다운 메뉴 배경 흰색
                      iconSize: 36.w,
                      itemHeight: 60.h,
                      items:
                          _curveMap.keys.map((curveName) {
                            return DropdownMenuItem<String>(
                              value: curveName,
                              child: Text(
                                curveName,
                                style: TextStyle(fontSize: 24.sp),
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
