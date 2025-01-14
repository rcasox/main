import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 쉽게 다루기 위해 추가


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/survey': (context) => SurveyScreen(),
      },
    );
  }
}

class User {
  String memberId;
  String phoneNumber;
  String password;

  User(this.memberId, this.phoneNumber, this.password);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<User> users = [];
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/22.mp4') // 올바른 자산 경로 사용
      ..setLooping(true) // 반복 재생 설정
      ..initialize().then((_) {
        setState(() {}); // 비디오 초기화가 완료되면 화면을 갱신
        _controller.play(); // 비디오 자동 재생
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_controller.value.isInitialized)
              AspectRatio(
                aspectRatio: 10 / 4,
                child: VideoPlayer(_controller),
              ),
            TextField(
              controller: memberIdController,
              decoration: InputDecoration(labelText: '회원번호'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String memberId = memberIdController.text;
                String password = passwordController.text;

                bool loginSuccess = users.any((user) =>
                user.memberId == memberId && user.password == password);

                if (loginSuccess) {
                  Navigator.pushNamed(context, '/survey'); // 설문 페이지로 이동
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('로그인 실패'),
                      content: Text('회원번호나 비밀번호가 잘못되었습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('확인'),
                        )
                      ],
                    ),
                  );
                }
              },
              child: Text('로그인'),
            ),
            TextButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/signup');
                if (result != null && result is User) {
                  setState(() {
                    users.add(result);
                  });
                }
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: memberIdController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: '전화번호'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String memberId = memberIdController.text;
                String phoneNumber = phoneNumberController.text;
                String password = passwordController.text;

                if (memberId.isNotEmpty &&
                    phoneNumber.isNotEmpty &&
                    password.isNotEmpty) {
                  User newUser = User(memberId, phoneNumber, password);
                  Navigator.pop(context, newUser);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('오류'),
                      content: Text('모든 필드를 입력하세요.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('확인'),
                        )
                      ],
                    ),
                  );
                }
              },
              child: Text('계정 생성'),
            ),
          ],
        ),
      ),
    );
  }
}





class SarcFPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sarc-F 설문')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60.0), // 오른쪽 여백 추가
              child: Image.asset(
                'dog4.png', // 여기에 실제 이미지 경로를 입력하세요.
                height: 400,
              ),
            ),
            SizedBox(width: 20), // 이미지와 텍스트 사이 여백
            Text(
              'Sarc-F 설문',
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/survey');
              },
              child: Text('시작하기', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}


class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int _currentQuestionIndex = 0;
  int surveyScore = 0; // 설문 점수

  List<Map<String, dynamic>> questions = [
    {
      'question': '무게 4.5kg을 들어서 나르는 것이 얼마나 어려운가요?',
      'choices': [
        '전혀 어렵지 않다.',
        '조금 어렵다.',
        '매우 어렵다.',
      ],
    },
    {
      'question': '방 안 한 쪽 끝에서 다른 쪽 끝까지 걷는 것이 얼마나 어려운가요?',
      'choices': [
        '전혀 어렵지 않다.',
        '조금 어렵다.',
        '매우 어렵다./보조기(지팡이 등)를 사용해야 가능/할 수 없다.'
      ],
    },
    {
      'question': '의자에서 일어나 침대로, 혹은 침대에서 의자로 옮기는 것이 얼마나 어려운가요?',
      'choices': [
        '전혀 어렵지 않다.',
        '조금 어렵다.',
        '매우 어렵다/도움 없이는 할 수 없다.',
      ],
    },
    {
      'question': '10개의 계단을 쉬지 않고 오르는 것이 얼마나 어려운가요?',
      'choices': [
        '전혀 어렵지 않다.',
        '조금 어렵다.',
        '매우 어렵다/할 수 없다.',
      ],
    },
    {
      'question': '지난 1년 동안 몇 번이나 넘어지셨나요?',
      'choices': [
        '전혀 없다.',
        '1-3회',
        '4회 이상',
      ],
    },
  ];

  void _nextQuestion(int score) {
    setState(() {
      surveyScore += score; // 선택된 점수 누적
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RapidTappingPage(surveyScore: surveyScore), // surveyScore 전달
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설문 조사')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '${_currentQuestionIndex + 1}. ${questions[_currentQuestionIndex]['question']}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 40),
            Column(
              children: List.generate(
                questions[_currentQuestionIndex]['choices'].length,
                    (index) {
                  return GestureDetector(
                    onTap: () => _nextQuestion(index),
                    child: ChoiceButton(
                      score: index,
                      label: questions[_currentQuestionIndex]['choices'][index],
                      isSelected: false,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final int score;
  final String label;
  final bool isSelected;

  ChoiceButton({required this.score, required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isSelected ? Colors.green : Colors.blue, width: 2),
          ),
          child: Center(child: Text(score.toString(), style: TextStyle(fontSize: 24))),
        ),
        SizedBox(width: 16),
        Expanded(child: Text(label, textAlign: TextAlign.left)),
      ],
    );
  }
}

class RapidTappingPage extends StatefulWidget {
  final int surveyScore;  // 3번 설문 점수 전달

  RapidTappingPage({required this.surveyScore});

  @override
  _RapidTappingPageState createState() => _RapidTappingPageState();
}

class _RapidTappingPageState extends State<RapidTappingPage> {
  int touchCount = 0;
  bool isTesting = false;
  int seconds = 60;
  Timer? timer;

  void startTest() {
    setState(() {
      touchCount = 0;
      isTesting = true;
      seconds = 60;
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        stopTest();
      }
    });
  }

  void stopTest() {
    timer?.cancel();
    setState(() {
      isTesting = false;
    });

    // 5-times STS 페이지로 터치 횟수를 전달
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiveTimesSTSPage(
          surveyScore: widget.surveyScore, // 설문 점수 전달
          touchCount: touchCount, // 터치 횟수 전달
        ),
      ),
    );
  }

  void incrementTouch() {
    if (isTesting) {
      setState(() {
        touchCount++;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool isFeatureEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rapid Tapping')),
      body: Center(
        child: isTesting
            ? GestureDetector(
          onTap: incrementTouch,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue.withOpacity(0.5),
            child: Center(
              child: Text(
                '터치 수: $touchCount\n남은 시간: $seconds초',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'dog.jpg', // 여기에 실제 이미지 경로를 입력하세요.
              height: 300,
            ),
            Text('60초 동안 터치하세요!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startTest,
              child: Text('테스트 시작'),
            ),
          ],
        ),

      ),
    );
  }
}

class FiveTimesSTSPage extends StatefulWidget {
  final int surveyScore;  // 3번 설문 점수 전달
  final int touchCount;   // 4번 페이지에서 전달받은 터치 횟수

  FiveTimesSTSPage({required this.surveyScore, required this.touchCount});

  @override
  _FiveTimesSTSPageState createState() => _FiveTimesSTSPageState();
}

class _FiveTimesSTSPageState extends State<FiveTimesSTSPage> {
  Timer? timer;
  int elapsedTime = 0;
  bool isRunning = false;

  void startTimer() {
    setState(() {
      isRunning = true;
      elapsedTime = 0;
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        elapsedTime++;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });

    // ResultPage로 데이터를 전달
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          surveyScore: widget.surveyScore, // 설문 점수 전달
          touchCount: widget.touchCount,   // 터치 횟수 전달
          stsTime: elapsedTime,            // STS 타이머 시간 전달
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('5-times CST')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'dog.png', // 여기에 실제 이미지 경로를 입력하세요.
              height: 400,
            ),
            SizedBox(height: 20),
            Text('타이머: $elapsedTime초', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isRunning) {
                  stopTimer();
                } else {
                  startTimer();
                }
              },
              child: Text(isRunning ? '종료' : '시작'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int surveyScore;
  final int touchCount;
  final int stsTime;

  ResultPage({required this.surveyScore, required this.touchCount, required this.stsTime});

  String getIntensity() {
    int riskCount = 0;

    // 설문 점수 판단
    if (surveyScore >= 4) {
      riskCount++;
    }

    // 터치 횟수 판단
    if (touchCount <= 450) {
      riskCount++;
    }

    // 5-times STS 시간 판단
    if (stsTime >= 12) {
      riskCount++;
    }

    // 위험도 평가
    if (riskCount >= 2) {
      return '하';
    } else if (riskCount == 1) {
      return '중';
    } else {
      return '상';
    }
  }

  @override
  Widget build(BuildContext context) {
    String intensity = getIntensity();
    String imagePath;

    // intensity에 따라 이미지 경로 설정
    if (intensity == '상') {
      imagePath = 'dog10.png'; // 상에 해당하는 이미지 경로
    } else if (intensity == '중') {
      imagePath = 'dog9.png'; // 중에 해당하는 이미지 경로
    } else {
      imagePath = 'dog8.png'; // 하에 해당하는 이미지 경로
    }

    return Scaffold(
      appBar: AppBar(title: Text('결과')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 200), // 결과에 따라 이미지 표시
            Text('운동 강도: $intensity', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 다음 화면으로 이동 (HomeScreen)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainHomePage()), // HomeScreen으로 연결
                );
              },
              child: Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}


void lmain() {
  runApp(MaterialApp(
    home: MainHomePage(),
    routes: {
       '/training': (context) => TrainingPage(),
       '/report': (context) => ReportPage(),
       '/plants': (context) => Plants(),
       '/settings': (context) => SettingsPage(),
    },
  ));
}

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0; // 현재 선택된 탭의 인덱스

  // 각 탭에 연결될 페이지들
  final List<Widget> _pages = [
    TrainingPage(),   // 훈련 페이지 위젯
    ReportPage(),     // 리포트 페이지 위젯
    Plants(),     // 식물 키우기 페이지 위젯
    SettingsPage(),   // 내 설정 페이지 위젯
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메인 화면')),
      body: _pages[_currentIndex], // 현재 선택된 탭의 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // 선택된 탭의 인덱스
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 선택된 탭 업데이트
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '훈련',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '리포트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.next_plan),
            label: '식물키우기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '내 설정',
          ),
        ],
        type: BottomNavigationBarType.fixed, // 탭이 4개 이상일 때 사용
      ),
    );
  }
}




class TrainingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '훈련 페이지',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TrainingPage(),
    );
  }
}

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  String _selectedArea = '';  // 선택된 집중 부위 저장

  // 부위 선택을 처리하는 함수
  void _selectArea(String area) {
    setState(() {
      _selectedArea = area;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmptyPage(area: area)), // 새로운 페이지로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('훈련 페이지')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 체중감량 & 건강유지부터 18일째까지 네모로 묶기
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                children: [
                  // 체중감량 & 건강유지 텍스트를 가운데 정렬
                  Center(
                    child: Text(
                      '체중감량 & 건강유지',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),

                  // 목표 진행 상황 및 게이지
                  Text(
                    '목표 진행 상황:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // 진행률을 나타내는 게이지
                  LinearProgressIndicator(
                    value: 0.6, // 진행 상태 (60%)
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 20),

                  // 18일째 텍스트 추가
                  Text(
                    '18일째',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 집중 부위 선택
            Text(
              '집중 부위 선택:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // 두 줄로 배치된 정사각형
            Column(
              children: [
                // 첫 번째 줄 (전신, 엉덩이 및 다리)
                Row(
                  children: [
                    _buildAreaBox('전신'),
                    _buildAreaBox('엉덩이 및 다리'),
                  ],
                ),
                SizedBox(height: 20),
                // 두 번째 줄 (복근, 팔)
                Row(
                  children: [
                    _buildAreaBox('복근'),
                    _buildAreaBox('팔'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),



            // 선택된 집중 부위 표시
            if (_selectedArea.isNotEmpty) ...[
              Text(
                '선택된 부위: $_selectedArea',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],

            // 하단 배너 부분 (훈련, 리포트, 내 설정)
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBanner(
                      context,
                      icon: Icons.fitness_center,
                      label: '훈련',
                      onTap: () {
                        // 훈련 화면으로 이동
                      },
                    ),
                    _buildBanner(
                      context,
                      icon: Icons.bar_chart,
                      label: '리포트',
                      onTap: () {
                        // 리포트 화면으로 이동
                      },
                    ),
                    _buildBanner(
                      context,
                      icon: Icons.settings,
                      label: '내 설정',
                      onTap: () {
                        // 설정 화면으로 이동
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 집중 부위 선택을 위한 정사각형을 만드는 함수
  Widget _buildAreaBox(String area) {
    bool isSelected = _selectedArea == area;
    double boxSize = 150.0; // 정사각형의 크기 설정

    return Expanded(
      child: GestureDetector(
        onTap: () => _selectArea(area),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5), // 간격 조정
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey,
              width: 2,
            ),
          ),
          width: boxSize,  // 정사각형의 너비
          height: boxSize, // 정사각형의 높이
          child: Center(
            child: Text(
              area,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 배너를 만드는 함수
  Widget _buildBanner(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// 빈 페이지를 나타내는 클래스
class EmptyPage extends StatelessWidget {
  final String area;

  EmptyPage({required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$area 페이지')),
      body: Center(
        child: Text(
          '$area 페이지는 비어 있습니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


class ReportPage extends StatelessWidget {
  final int todaySteps = 7500;
  final double waterIntake = 2.0;
  final double sleepHours = 7.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('리포트')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportItem('오늘 걸음 수', '$todaySteps 걸음'),
            _buildReportItem('물 섭취량', '${waterIntake.toStringAsFixed(1)} L'),
            _buildReportItem('수면 시간', '${sleepHours.toStringAsFixed(1)} 시간'),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 18)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}


class Plants extends StatefulWidget {
  @override
  _PlantsState createState() => _PlantsState();
}

class _PlantsState extends State<Plants> {
  double growthPercentage = 0.0;
  Timer? growthTimer;

  @override
  void initState() {
    super.initState();
    startGrowthTimer();
  }

  @override
  void dispose() {
    growthTimer?.cancel();
    super.dispose();
  }

  void startGrowthTimer() {
    growthTimer = Timer.periodic(Duration(minutes: 6), (timer) {
      setState(() {
        if (growthPercentage < 100) {
          growthPercentage += 0.1;
        } else {
          growthTimer?.cancel();
          showCongratulationsScreen();
        }
      });
    });
  }

  void useReward(double value) {
    setState(() {
      growthPercentage += value;
      if (growthPercentage >= 100) {
        growthPercentage = 100;
        growthTimer?.cancel();
        showCongratulationsScreen();
      }
    });
  }

  void resetGrowth() {
    setState(() {
      growthPercentage = 0.0; // 게이지 초기화
    });
    startGrowthTimer(); // 타이머 다시 시작
  }

  void showCongratulationsScreen() {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CongratulationsScreen(resetGrowthCallback: resetGrowth),
        ),
      );
    });
  }

  String getPlantImage() {
    if (growthPercentage < 20) {
      return 'assets/0.jpg'; // 새싹 이미지
    } else if (growthPercentage < 40) {
      return 'assets/1.jpg'; // 식물 이미지
    } else if (growthPercentage < 60) {
      return 'assets/2.jpg'; // 꽃 이미지
    } else if (growthPercentage < 80) {
      return 'assets/3.jpg'; // 나무 이미지
    } else {
      return 'assets/4.jpg'; // 완전한 식물 이미지
    }
  }

  void showCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CalendarScreen(),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식물 키우기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Growth: ${growthPercentage.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    getPlantImage(),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: growthPercentage / 100,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.calendar_today, size: 40, color: Colors.blue),
                    onPressed: () => showCalendar(context),
                  ),
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(Icons.opacity, size: 40, color: Colors.blue),
                    onPressed: () {
                      useReward(1.0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('물을 줄게요. 1% 성장했어요!')),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(Icons.nature, size: 40, color: Colors.blue),
                    onPressed: () {
                      useReward(5.0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('영양제를 줄게요. 5% 성장했어요!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Text(
            'Attendance Calendar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  bool isSunday = date.weekday == DateTime.sunday;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${date.day}'),
                      Icon(
                        isSunday ? Icons.nature : Icons.opacity,
                        color: isSunday ? Colors.orange : Colors.blue,
                        size: 20,
                      ),
                    ],
                  );
                },
              ),
              headerStyle: HeaderStyle(formatButtonVisible: false),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class CongratulationsScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final VoidCallback resetGrowthCallback;

  CongratulationsScreen({required this.resetGrowthCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Congratulations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🌟 오래 기다렸죠? 성장을 축하드려요! 🌟',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: '전화번호',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: '주소',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  resetGrowthCallback();
                  Navigator.pop(context);
                },
                child: Text('배송받기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final ValueNotifier<DateTime> _selectedDay;
  late final ValueNotifier<DateTime> _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = ValueNotifier(DateTime.now());
    _focusedDay = ValueNotifier(DateTime.now());
  }

  @override
  void dispose() {
    _selectedDay.dispose();
    _focusedDay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 프로필 영역
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 동그란 프로필 이미지
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/profile_image.png'),
                    ),
                    SizedBox(height: 10),
                    // 환영 문구
                    Text(
                      '이예찬님! 환영합니다',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // 기록, 칼로리, 분
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProfileInfo('기록', '0'),
                        _buildProfileInfo('칼로리', '0'),
                        _buildProfileInfo('분', '0'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // 내 운동
              _buildSettingBox(
                '내 운동',
                Icons.fitness_center,
                    () {
                  // 내 운동 클릭 시 동작 추가
                },
              ),
              SizedBox(height: 20),


              // 이번주 레이블 및 시간, 칼로리 정보
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // '이번주' 레이블
                    Text(
                      '이번주',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // 시간과 칼로리 정보 (각각 상자에 담기)
                    Row(
                      children: [
                        // 시간 상자
                        Expanded(
                          child: _buildInfoBox('시간', '0분'),
                        ),
                        SizedBox(width: 10), // 두 상자 사이에 간격
                        // 칼로리 상자
                        Expanded(
                          child: _buildInfoBox('칼로리', '0 kcal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // 달력
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay.value,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay.value, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay.value = selectedDay;
                      _focusedDay.value = focusedDay;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),

              // 하단 배너 추가 (아이콘만 포함)

            ],
          ),
        ),
      ),
    );
  }

  // 프로필 정보 항목 (기록, 칼로리, 분 등)
  Widget _buildProfileInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  // 내 운동과 데이터 백업/복원 상자
  Widget _buildSettingBox(String label, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            SizedBox(width: 15),
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // 시간과 칼로리 정보를 위한 상자
  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
  }
