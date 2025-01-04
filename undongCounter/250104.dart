import 'package:flutter/material.dart';
import 'dart:async';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.cyan,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
      ),
      themeMode: _themeMode,
      home: Undong(toggleTheme: _toggleTheme),
    );
  }
}

class Undong extends StatelessWidget {
  final Function(bool) toggleTheme;

  const Undong({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Center(
          child: Text('Undong Counter', style: TextStyle(fontSize: 48, color: Colors.black87)),
        ),
      ),
      body: MainScreen(toggleTheme: toggleTheme),
    );
  }
}

class MainScreen extends StatelessWidget {
  final Function(bool) toggleTheme;

  const MainScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // play 아이콘의 기능
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(192, 144),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Icon(Icons.play_circle_outline, size: 90, color: isDarkMode ? Colors.white : Colors.black87),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 메뉴 아이콘의 기능
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(64, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Icon(Icons.menu, size: 64, color: isDarkMode ? Colors.white : Colors.black87),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen(toggleTheme: toggleTheme)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(64, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Icon(Icons.settings, size: 64, color: isDarkMode ? Colors.white : Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final Function(bool) toggleTheme;

  SettingsScreen({required this.toggleTheme});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}





class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notificationConsent = false;
  bool _autoSaveToGallery = false;
  bool _isLoggedIn = false; // 로그인 상태

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        backgroundColor: theme.brightness == Brightness.dark ? Colors.grey[800] : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _isLoggedIn ? _buildLoggedInAccount(theme) : _buildLoginForm(theme),
                if (_isLoggedIn) SizedBox(height: 64),
                _buildSwitchTile('다크 모드', _darkMode, (value) {
                  setState(() {
                    _darkMode = value;
                    widget.toggleTheme(_darkMode);
                  });
                }),
                _buildSwitchTile('알림 수신 동의', _notificationConsent, (value) => setState(() => _notificationConsent = value)),
                _buildSwitchTile('갤러리 자동 저장', _autoSaveToGallery, (value) => setState(() => _autoSaveToGallery = value)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInAccount(ThemeData theme) {
    return ListTile(
      leading: Icon(Icons.account_circle, color: theme.brightness == Brightness.dark ? Colors.white : null),
      title: Text('계정'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('1234', style: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white : null)),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isLoggedIn = false; // 로그아웃 시 로그인 상태 변경
                });
              },
              child: Text('로그아웃', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      onTap: () {
        // 계정 디테일 페이지로 이동하거나 계정 관련 작업 수행
      },
    );
  }

  Widget _buildLoginForm(ThemeData theme) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'ID',
            labelStyle: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white : null),
          ),
        ),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: '비밀번호',
            labelStyle: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white : null),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoggedIn = true; // 로그인 성공 시 로그인 상태 변경
                });
              },
              child: Text('로그인'),
            ),
            ElevatedButton(
              onPressed: () {
                // 회원가입 페이지로 이동
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
      value: value,
      onChanged: onChanged,
    );
  }
}
