import 'dart:async';
import 'package:flutter/material.dart';

class TrafficLightScreen extends StatefulWidget {
  @override
  _TrafficLightScreenState createState() => _TrafficLightScreenState();
}

class _TrafficLightScreenState extends State<TrafficLightScreen> {
  int _currentLight = 0; // 0 = Red, 1 = Yellow, 2 = Green
  int _countdown = 0; // Countdown timer in seconds
  Timer? _timer; // ใช้ Timer? เพื่อป้องกันปัญหา null

  void _changeLight() {
    _timer?.cancel(); // ยกเลิก Timer ก่อนเปลี่ยนไฟ
    setState(() {
      _currentLight = (_currentLight + 1) % 3;
      _startCountdown();
    });
  }

  void _startCountdown() {
    // กำหนดค่าของ _countdown ตามไฟจราจรปัจจุบัน
    if (_currentLight == 0) {
      _countdown = 30; // ไฟแดง 30 วินาที
    } else if (_currentLight == 1) {
      _countdown = 3; // ไฟเหลือง 3 วินาที
    } else {
      _countdown = 15; // ไฟเขียว 15 วินาที
    }

    // เริ่ม Timer ใหม่
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel(); // หยุด Timer เมื่อถึง 0
        _changeLight(); // เปลี่ยนไฟจราจร
      }
    });
  }

  double _getOpacity(int lightIndex) {
    return _currentLight == lightIndex ? 1.0 : 0.3;
  }

  @override
  void initState() {
    super.initState();
    _startCountdown(); // เริ่มไฟจราจรอัตโนมัติ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Traffic Light Animation')),
        backgroundColor: Color.fromARGB(255, 231, 157, 212),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_countdown', // แสดงตัวเลขนับถอยหลัง
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _getOpacity(0),
              child: _buildLight(Colors.red),
            ),
            SizedBox(height: 10),
            AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _getOpacity(1),
              child: _buildLight(Colors.yellow),
            ),
            SizedBox(height: 10),
            AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _getOpacity(2),
              child: _buildLight(Colors.green),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changeLight,
              child: Text('เปลี่ยนไฟ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLight(Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // ตรวจสอบก่อนยกเลิก Timer
    super.dispose();
  }
}
