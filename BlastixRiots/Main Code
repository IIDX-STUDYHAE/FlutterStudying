import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const Blastix());

class Blastix extends StatelessWidget {
  const Blastix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Center(
              child: Text('Blastix Riotz',
                  style: TextStyle(fontSize: 48, color: Colors.black87))),
        ),
        body: BlastixRiotz(),
      ),
    );
  }
}

class BlastixRiotz extends StatefulWidget {
  const BlastixRiotz({super.key});

  @override
  _BlastixRiotzState createState() => _BlastixRiotzState();
}

class _BlastixRiotzState extends State<BlastixRiotz> {
  bool _isGaming = false;
  int _clicks = 0;
  int _totalClicks = 0;
  int _pik = 0;
  Timer? _timer;
  List<String> _clickPattern = []; // 클릭 패턴을 저장할 리스트
  int _elapsedSeconds = 0; // 지난 시간을 초 단위로 저장

  void _doGaming() {
    if (!_isGaming) {
      setState(() {
        _isGaming = true;
        _clicks = 0;
        _totalClicks = 0;
        _pik = 0;
        _clickPattern.clear();
        _elapsedSeconds = 0; // 게임 시작 시 초기화
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _totalClicks += _clicks; // 현재 초의 클릭을 총 클릭에 추가
        _clicks = 0; // 다음 초로 넘어가면서 현재 클릭 수 초기화
        _elapsedSeconds++; // 시간 증가
      });
      if (timer.tick >= 15) {
        timer.cancel();
        setState(() {
          _isGaming = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _Click(String buttonId) {
    setState(() {
      _clicks++;
      _clickPattern.add(buttonId); // 클릭 패턴에 현재 클릭 버튼 추가

      // 패턴 체크: 최근 2번의 클릭이 AA 또는 BB 형태인지 확인
      if (_clickPattern.length >= 2) {
        String pattern = _clickPattern.take(2).join();
        if (pattern == 'AA' || pattern == 'BB') {
          _pik++;
          // 패턴이 일치하면 마지막 두 클릭만 남기고 나머지 제거
          _clickPattern = _clickPattern.sublist(_clickPattern.length - 2);
        } else {
          // 패턴이 일치하지 않으면 최신 클릭만 남기고 나머지 제거
          _clickPattern = _clickPattern.sublist(_clickPattern.length - 1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isGaming ? Colors.redAccent : Colors.orange,
      body: Center(
        child: _isGaming
            ? Gaming(
          totalClicks: _totalClicks,
          pik: _pik,
          onClickA: () => _Click('A'),
          onClickB: () => _Click('B'),
          elapsedSeconds: _elapsedSeconds,
        )
            : Analyze(totalClicks: _totalClicks, pik: _pik, toggle: _doGaming),
      ),
    );
  }
}

class Analyze extends StatelessWidget {
  final int totalClicks; // Click수. Analyze->Gaming으로 넘어갈 때 0으로 초기화
  final int pik; // 삑난 횟수
  final VoidCallback toggle;

  Analyze(
      {required this.totalClicks, required this.pik, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orange,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: toggle,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(180, 144),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Icon(Icons.fast_forward, size: 90, color: Colors.black87),
              ),
            ),
            Center(
              child: Text('트릴 bpm(16비트 기준): ${totalClicks * 2}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, color: Colors.white70)),
            ),
            Center(
              child: Text('삑난 횟수: $pik',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}

class Gaming extends StatelessWidget {
  final int totalClicks;
  final int pik;
  final VoidCallback onClickA;
  final VoidCallback onClickB;
  final int elapsedSeconds;

  Gaming(
      {required this.totalClicks,
        required this.pik,
        required this.onClickA,
        required this.onClickB,
        required this.elapsedSeconds});

  @override
  Widget build(BuildContext context) {
    double bpm = elapsedSeconds > 0 ? (totalClicks * 60 / elapsedSeconds) : 0; // BPM 계산

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 600,
            width: 360,
            child: Card(
              color: Colors.orange, // 배경색을 orange로 설정
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '삑난 횟수: $pik \n 16비트 기준 bpm환산 : ${bpm.toStringAsFixed(3)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 42, color: Colors.white),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRectangleButton('A', onClickA),
              _buildRectangleButton('B', onClickB),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRectangleButton(String id, VoidCallback onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 160, // 가로 길이 조절
        height: 60, // 세로 길이 조절
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        alignment: Alignment.center,
        child: Text(id, style: TextStyle(fontSize: 30, color: Colors.yellow)), // 버튼 ID 표시
      ),
    );
  }
}
