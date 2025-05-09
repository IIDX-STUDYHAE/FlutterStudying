//startScreen UX 개선, 자잘한 위치조정
//일단 대충 어느 정도 틀은 완성된 상태입니다 내일 5월 9일에 1.1.4 Firestorm -완- 을 하고 싶네용 오호홍 

import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 색상 상수 클래스
class GameColors {
  static Color leftColor = Color(0xFFADFF2F); // 왼쪽 노브 선+인디케이터+판정불빛, 동적 변경 가능
  static Color rightColor = Color(0xFF00A1F4); // 오른쪽 노브 선+인디케이터+판정불빛, 동적 변경 가능
}

void main() {
  runApp(KnobPracticeApp());
}

class KnobPracticeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final List<Color> availableColors = [
    Color(0xFFADFF2F), // 밝은초록
    Color(0xFF00A1F4), // 밝은파랑
    Color(0xFFFF69B4), // 레이시스 느낌의 핑크
    Color(0xFFFFE135), // 옐로우
    Color(0xFFFFFFFF), // 흰색
  ];
  Color selectedLeftColor = GameColors.leftColor;
  Color selectedRightColor = GameColors.rightColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 중앙 Start 버튼
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KnobPracticeGame()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 24),
              ),
              child: Text('Start', style: TextStyle(color: Color(0xFF000000))),
            ),
          ),
          // 하단 설정 박스
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 왼쪽 노브 설정 박스
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Left Knob Color',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: availableColors.map((color) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLeftColor = color;
                                  GameColors.leftColor = color;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: selectedLeftColor == color
                                      ? Border.all(color: Colors.white, width: 3)
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Left Knob:\nQ: Left\nE: Right',
                          style: TextStyle(color: Colors.white, fontSize: 20, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // 오른쪽 노브 설정 박스
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Right Knob Color',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: availableColors.map((color) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRightColor = color;
                                  GameColors.rightColor = color;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: selectedRightColor == color
                                      ? Border.all(color: Colors.white, width: 3)
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Right Knob:\nI: Left\nP: Right',
                          style: TextStyle(color: Colors.white, fontSize: 20, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
  int remainingSeconds = 60; // 1분
  Timer? gameTimer;
  Timer? scoreTimer;
  
  // 판정 보정을 위한 추가 변수
  List<int> leftKnobDirectionHistory = List.filled(5, 0); // 노브 방향 (-1, 0, 1), 100ms (5틱)
  List<int> rightKnobDirectionHistory = List.filled(5, 0);
  List<int> leftIndicatorDirectionHistory = List.filled(5, 0); // 인디케이터 방향 (-1, 0, 1)
  List<int> rightIndicatorDirectionHistory = List.filled(5, 0);
  int historyIndex = 0; // 현재 틱 인덱스 (0~4 순환)
  double prevLeftKnobX = 100.0; // 직전 노브 x좌표
  double prevRightKnobX = 400.0;
  double prevLeftIndicatorX = 100.0; // 직전 인디케이터 x좌표
  double prevRightIndicatorX = 400.0;

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
          // 판정선 벗어난 점 제거
          if (leftKnobPath.isNotEmpty && leftKnobPath.first.dy > judgmentLineY + 3 * nspeed) {
            leftKnobPath.removeAt(0);
          }
          if (rightKnobPath.isNotEmpty && rightKnobPath.first.dy > judgmentLineY + 3 * nspeed) {
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
    
     // 0.02초마다 점수 판정, 메모리 활용 줄이되 보정 비스무리한 로직 구현
    int ironchi = 0; //이론치 계산용 변수
    scoreTimer = Timer.periodic(Duration(milliseconds: 20), (timer) {
       if (leftKnobPath.isNotEmpty)ironchi++;
  setState(() {
    // 현재 노브와 인디케이터 x좌표
    double leftKnobXAtJudgment = leftKnobPath.isNotEmpty && leftKnobPath.first.dy >= judgmentLineY
        ? leftKnobPath.first.dx
        : prevLeftKnobX;
    double rightKnobXAtJudgment = rightKnobPath.isNotEmpty && rightKnobPath.first.dy >= judgmentLineY
        ? rightKnobPath.first.dx
        : prevRightKnobX;

    // 노브 방향 계산
    int leftKnobDir = leftKnobXAtJudgment < prevLeftKnobX
        ? -1
        : leftKnobXAtJudgment > prevLeftKnobX
            ? 1
            : 0;
    int rightKnobDir = rightKnobXAtJudgment < prevRightKnobX
        ? -1
        : rightKnobXAtJudgment > prevRightKnobX
            ? 1
            : 0;

    // 인디케이터 방향 계산
    int leftIndicatorDir = leftIndicatorX < prevLeftIndicatorX
        ? -1
        : leftIndicatorX > prevLeftIndicatorX
            ? 1
            : 0;
    int rightIndicatorDir = rightIndicatorX < prevRightIndicatorX
        ? -1
        : rightIndicatorX > prevRightIndicatorX
            ? 1
            : 0;

    // 방향 히스토리 갱신
    leftKnobDirectionHistory[historyIndex] = leftKnobDir;
    rightKnobDirectionHistory[historyIndex] = rightKnobDir;
    leftIndicatorDirectionHistory[historyIndex] = leftIndicatorDir;
    rightIndicatorDirectionHistory[historyIndex] = rightIndicatorDir;

    // 왼쪽 노브 판정 
    bool leftDirectionBoolean = false;
    for (int i = 0; i < 5; i++) {
      if (leftKnobDirectionHistory[i] == leftIndicatorDirectionHistory[i]) {
        leftDirectionBoolean = true;
        break;
      }
    }
    if (leftKnobPath.isNotEmpty && leftKnobPath.first.dy >= judgmentLineY) {
      double distance = (leftKnobXAtJudgment - leftIndicatorX).abs();
      if (distance <= 30 && leftDirectionBoolean) {
        score += 100;
        leftIndicatorX = leftKnobXAtJudgment; 
        leftLightOn = true;
      } else if (distance <= 60 && leftDirectionBoolean) {
        score += 100; 
        leftLightOn = true;
      } else {
        leftLightOn = false;
      }
    } else {
      leftLightOn = false;
    }

    // 오른쪽 노브 판정 
    bool rightDirectionBoolean = false;
    for (int i = 0; i < 5; i++) {
      if (rightKnobDirectionHistory[i] == rightIndicatorDirectionHistory[i]) {
        rightDirectionBoolean = true;
        break;
      }
    }
    if (rightKnobPath.isNotEmpty && rightKnobPath.first.dy >= judgmentLineY) {
      double distance = (rightKnobXAtJudgment - rightIndicatorX).abs();
      if (distance <= 30 && rightDirectionBoolean) {
        score += 100;
        rightIndicatorX = rightKnobXAtJudgment; 
        rightLightOn = true;
      } else if (distance <= 60 && rightDirectionBoolean) {
        score += 100; 
        rightLightOn = true;
      } else {
        rightLightOn = false;
      }
    } else {
      rightLightOn = false;
    }

    // 직전 값 갱신
    prevLeftKnobX = leftKnobXAtJudgment;
    prevRightKnobX = rightKnobXAtJudgment;
    prevLeftIndicatorX = leftIndicatorX;
    prevRightIndicatorX = rightIndicatorX;

    // 히스토리 인덱스 순환
    historyIndex = (historyIndex + 1) % 5;
  });
});

    // 1분 타이머
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds--;
        if (remainingSeconds <= 0) {
          timer.cancel();
          scoreTimer?.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EndScreen(score: score, ironchi:ironchi),
            ),
          );
        }
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
    gameTimer?.cancel();
    scoreTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 타이머 포맷팅
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    String timeDisplay = 'Time: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

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
                child: Column(
                  children: [
                    Text(
                      'Score: $score',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 10),
                    Text(
                      timeDisplay,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
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
                    color: GameColors.leftColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: GameColors.leftColor,
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
                    color: GameColors.rightColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: GameColors.rightColor,
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

class EndScreen extends StatelessWidget {
  final int score;
  final int ironchi;

  EndScreen({required this.score, required this.ironchi});

  @override
  Widget build(BuildContext context) {
    final int maxScore = ironchi*200;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: TextStyle(color: Colors.white, fontSize: 36),
            ),
            SizedBox(height: 20),
            Text(
              'Final Score: $score',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 40),
            Text(
              'ironchi:${maxScore}',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            // 점수 진행 막대 그래프
            Container(
              width: 300,
              height: 20,
              child: CustomPaint(
                painter: ScoreProgressPainter(
                  score: score,
                  maxScore: maxScore,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 24),
              ),
              child: Text('Restart', style: TextStyle(color: Color(0xFF000000))),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreProgressPainter extends CustomPainter {
  final int score;
  final int maxScore;

  ScoreProgressPainter({required this.score, required this.maxScore});

  @override
  void paint(Canvas canvas, Size size) {
    // 배경: 흰색 테두리 (이론치)
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      borderPaint,
    );

    // 채움: 점수 비율로 핑크색
    final fillPaint = Paint()
      ..color = Color(0xFFFF69B4) // RASIS
      ..style = PaintingStyle.fill;
    double fillWidth = (score / maxScore).clamp(0.0, 1.0) * size.width;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, fillWidth, size.height),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
      ..color = GameColors.leftColor
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    if (leftKnobPath.length > 1) {
      canvas.drawPoints(PointMode.polygon, leftKnobPath, leftPaint);
    }

    // 오른쪽 노브 선
    final rightPaint = Paint()
      ..color = GameColors.rightColor
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
    final leftIndicatorPaint = Paint()..color = GameColors.leftColor;
    canvas.drawCircle(
      Offset(leftIndicatorX, judgmentLineY),
      10,
      leftIndicatorPaint,
    );

    // 오른쪽 인디케이터
    final rightIndicatorPaint = Paint()..color = GameColors.rightColor;
    canvas.drawCircle(
      Offset(rightIndicatorX, judgmentLineY),
      10,
      rightIndicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
