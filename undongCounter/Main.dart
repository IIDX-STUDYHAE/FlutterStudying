import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const undong_Counter());
}


class undong_Counter extends StatelessWidget{
  const undong_Counter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Center(
              child: Text('쉬는 시간 측정기',
                  style: TextStyle(fontSize: 48, color: Colors.black87))),
        ),
        body: counter(),
      ),
    );
  }
}

class counter extends StatefulWidget{
  const counter({super.key});
  @override
  _counterState createState()=>_counterState();
}



class _counterState extends State<counter>{
  bool _isCounting = false;
  Timer? _timer;
  int _nowTime = 0;


  void _doCounting(){
    if(!_isCounting){
      setState((){
        _isCounting = true;
        _nowTime = 50;//50부터 시작해서 0으로 내려가는 구조, 추후 ffi 기반으로 double형 리얼타임으로 개선
      });
      _startTimer();
    }
  }
  void _startTimer() {
    _timer?.cancel();
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  setState(() {
    --_nowTime;
  });
  if (timer.tick >= 50) {
  timer.cancel();
  setState(() {
  _isCounting = false;
  });
  }
  });
}
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:Colors.cyanAccent,
      body: Center(
        child: _isCounting?
            counting(
              nowTime: _nowTime
            )
            : beforeCounting(toggle: _doCounting),
      ),
    );
  }


}

class beforeCounting extends StatelessWidget {
  final VoidCallback toggle;
  beforeCounting({required this.toggle});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Center(
              child: ElevatedButton(
              onPressed: toggle,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(270, 216),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.lightGreenAccent
                ),
          child: const Icon(Icons.fast_forward, size: 90, color: Colors.black87),
        ),
              ),
          ] ,
        ),
      ),
    );
  }
}

class counting extends StatelessWidget{
  final int nowTime;//남은 시간을 int형으로. 추후에 C 기반 좀 더 리얼타임하게 개선할 예정
  counting({required this.nowTime});

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 600,
            width: 360,
            child: Card(
              color: Colors.cyanAccent,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '남은 시간: $nowTime',textAlign: TextAlign.center,
                  style: TextStyle(fontSize:64, color: Colors.black87),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }

}
