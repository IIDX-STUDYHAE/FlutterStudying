//즐기는 법: https://dartpad.dev/ 사이트를 들어가면 flutter 를 WASM 형태로 돌릴 수 있도록 해놔서 웹에서 잘 돌아갑니다 복붙해서 하면 됩니당
//조작법: 왼노브 왼쪽으로: Q 왼노브 오른쪽으로: E 오른노브 왼쪽으로: I 오른노브 오른쪽으로: P 입니다. 추후에 사용자 지정으로 만들 예정


import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 색상 상수 클래스 밝은초록 #ADFF2F 밝은파랑 #00A1F4 레이시스 느낌의 핑크 #FF69B4 추후 시작 UI에서 설정할 수 있도록 세팅예정.
class GameColors {
  static const Color leftKnobColor = Color(0xFFFF69B4); // 왼쪽 노브 선
  static const Color leftIndicatorColor = Color(0xFFFF69B4); // 왼쪽 인디케이터+왼쪽 판정 불빛
  static const Color rightKnobColor = Color(0xFFADFF2F); // 오른쪽 노브 선
  static const Color rightIndicatorColor = Color(0xFFADFF2F); // 오른쪽 인디케이터+오른쪽 판정 불빛
}

void main() {
  runApp(KnobPracticeApp());
}

class KnobPracticeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KnobPracticeGame(),
    );
  }
}

class KnobPracticeGame extends StatefulWidget {
  @override
  _KnobPracticeGameState createState() => _KnobPracticeGameState();
}

class _KnobPracticeGameState extends State<KnobPracticeGame> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Offset> leftKnobPath = [];
  List<Offset> rightKnobPath = [];
  double leftKnobX = 100.0;
  double rightKnobX = 400.0;
  double leftIndicatorX = 100.0;
  double rightIndicatorX = 400.0;
  int leftKnobDirection = 0;
  int rightKnobDirection = 0;
  int userLeft = 0;
  int userRight = 0;
  int score = 0;
  double nspeed = 5.0;
  double ispeed = 20.0; 
  double judgmentLineY = 500.0;
  double leftSpeedMultiplier = 1.0;
  double rightSpeedMultiplier = 1.0;
  Timer? directionTimer;
  bool leftLightOn = false;
  bool rightLightOn = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..addListener(() {
        setState(() {
          // 노브 x좌표 이동
          leftKnobX += leftKnobDirection * nspeed * leftSpeedMultiplier;
          rightKnobX += rightKnobDirection * nspeed * rightSpeedMultiplier;
          // 인디케이터 x좌표 이동
          leftIndicatorX += userLeft * ispeed;
          rightIndicatorX += userRight * ispeed;
          // 정의역 0~650
          leftKnobX = leftKnobX.clamp(0.0, 650.0);
          rightKnobX = rightKnobX.clamp(0.0, 650.0);
          leftIndicatorX = leftIndicatorX.clamp(0.0, 650.0);
          rightIndicatorX = rightIndicatorX.clamp(0.0, 650.0);
          // 새로운 점 추가
          leftKnobPath.add(Offset(leftKnobX, 0));
          rightKnobPath.add(Offset(rightKnobX, 0));
          // 아래로 이동
          for (int i = 0; i < leftKnobPath.length; i++) {
            leftKnobPath[i] = Offset(leftKnobPath[i].dx, leftKnobPath[i].dy + nspeed);
          }
          for (int i = 0; i < rightKnobPath.length; i++) {
            rightKnobPath[i] = Offset(rightKnobPath[i].dx, rightKnobPath[i].dy + nspeed);
          }
          // 판정선에 도달한 점 처리
          if (leftKnobPath.isNotEmpty && leftKnobPath.first.dy >= judgmentLineY) {
            double knobXAtJudgment = leftKnobPath.first.dx;
            leftLightOn = (knobXAtJudgment - leftIndicatorX).abs() <= 40;
            if (leftLightOn) score += 5;
            else score -= 2;
            leftKnobPath.removeAt(0);
          }
          if (rightKnobPath.isNotEmpty && rightKnobPath.first.dy >= judgmentLineY) {
            double knobXAtJudgment = rightKnobPath.first.dx;
            rightLightOn = (knobXAtJudgment - rightIndicatorX).abs() <= 40;
            if (rightLightOn) score += 5;
            else score -= 2;
            rightKnobPath.removeAt(0);
          }
        });
      })..repeat();

    // 0.3초마다 노브 방향과 속도 갱신
    directionTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        leftKnobDirection = _getNewDirection(leftKnobX, leftKnobDirection);
        rightKnobDirection = _getNewDirection(rightKnobX, rightKnobDirection);
        leftSpeedMultiplier = 1.0 + math.Random().nextDouble() * 2.0; // 1~3배
        rightSpeedMultiplier = 1.0 + math.Random().nextDouble() * 2.0;
      });
    });
  }

  // 경계 처리 및 방향 결정
  int _getNewDirection(double x, int currentDirection) {
    if (x <= 0 && currentDirection == -1) return 1;
    if (x >= 650 && currentDirection == 1) return -1;
    return math.Random().nextInt(3) - 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    directionTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        setState(() {
          if (event is KeyDownEvent) {
            switch (event.logicalKey) {
              case LogicalKeyboardKey.keyQ:
                userLeft = -1;
                break;
              case LogicalKeyboardKey.keyE:
                userLeft = 1;
                break;
              case LogicalKeyboardKey.keyI:
                userRight = -1;
                break;
              case LogicalKeyboardKey.keyP:
                userRight = 1;
                break;
            }
          } else if (event is KeyUpEvent) {
            switch (event.logicalKey) {
              case LogicalKeyboardKey.keyQ:
              case LogicalKeyboardKey.keyE:
                userLeft = 0;
                break;
              case LogicalKeyboardKey.keyI:
              case LogicalKeyboardKey.keyP:
                userRight = 0;
                break;
            }
          }
        });
        return KeyEventResult.handled;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CustomPaint(
              painter: KnobPainter(leftKnobPath, rightKnobPath, judgmentLineY, leftIndicatorX, rightIndicatorX),
              child: Container(),
            ),
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Score: $score',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            // 왼쪽 노브 판정 불빛
            Positioned(
              bottom: 60,
              left: 60,
              child: Opacity(
                opacity: leftLightOn ? 1.0 : 0.0,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: GameColors.leftIndicatorColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: GameColors.leftIndicatorColor,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 오른쪽 노브 판정 불빛
            Positioned(
              bottom: 60,
              right: 60,
              child: Opacity(
                opacity: rightLightOn ? 1.0 : 0.0,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: GameColors.rightIndicatorColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: GameColors.rightIndicatorColor,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KnobPainter extends CustomPainter {
  final List<Offset> leftKnobPath;
  final List<Offset> rightKnobPath;
  final double judgmentLineY;
  final double leftIndicatorX;
  final double rightIndicatorX;

  KnobPainter(this.leftKnobPath, this.rightKnobPath, this.judgmentLineY, this.leftIndicatorX, this.rightIndicatorX);

  @override
  void paint(Canvas canvas, Size size) {
    // 비스듬한 3D 효과
    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(-math.pi / 6);
    canvas.transform(matrix.storage);

    // 왼쪽 노브 선
    final leftPaint = Paint()
      ..color = GameColors.leftKnobColor
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    if (leftKnobPath.length > 1) {
      canvas.drawPoints(PointMode.polygon, leftKnobPath, leftPaint);
    }

    // 오른쪽 노브 선
    final rightPaint = Paint()
      ..color = GameColors.rightKnobColor
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    if (rightKnobPath.length > 1) {
      canvas.drawPoints(PointMode.polygon, rightKnobPath, rightPaint);
    }

    // 판정선
    final judgmentPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(0, judgmentLineY),
      Offset(size.width, judgmentLineY),
      judgmentPaint,
    );

    // 왼쪽 인디케이터
    final leftIndicatorPaint = Paint()..color = GameColors.leftIndicatorColor;
    canvas.drawCircle(
      Offset(leftIndicatorX, judgmentLineY),
      10,
      leftIndicatorPaint,
    );

    // 오른쪽 인디케이터
    final rightIndicatorPaint = Paint()..color = GameColors.rightIndicatorColor;
    canvas.drawCircle(
      Offset(rightIndicatorX, judgmentLineY),
      10,
      rightIndicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
