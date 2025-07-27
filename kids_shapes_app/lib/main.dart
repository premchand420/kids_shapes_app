import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

void main() => runApp(KidsShapesApp());

class KidsShapesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Shapes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final FlutterTts tts = FlutterTts();

  Future<void> _speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.speak(text);
  }

  Widget _buildShape({
    required String name,
    required Color color,
    required Widget shapeWidget,
  }) {
    return GestureDetector(
      onTap: () => _speak(name),
      child: Column(
        children: [
          AnimatedShapeWidget(child: shapeWidget),
          SizedBox(height: 10),
          Text(name, style: TextStyle(fontSize: 24)),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Shapes'),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => QuizPage(),
              ));
            },
          )
        ],
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildShape(
              name: 'Circle',
              color: Colors.red,
              shapeWidget: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            _buildShape(
              name: 'Square',
              color: Colors.green,
              shapeWidget: Container(
                width: 100,
                height: 100,
                color: Colors.green,
              ),
            ),
            _buildShape(
              name: 'Rectangle',
              color: Colors.orange,
              shapeWidget: Container(
                width: 140,
                height: 80,
                color: Colors.orange,
              ),
            ),
            _buildShape(
              name: 'Triangle',
              color: Colors.blue,
              shapeWidget: CustomPaint(
                size: Size(100, 100),
                painter: TrianglePainter(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedShapeWidget extends StatefulWidget {
  final Widget child;
  const AnimatedShapeWidget({required this.child});

  @override
  _AnimatedShapeWidgetState createState() => _AnimatedShapeWidgetState();
}

class _AnimatedShapeWidgetState extends State<AnimatedShapeWidget>
    with SingleTickerProviderStateMixin {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    _triggerAnimation();
  }

  void _triggerAnimation() {
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() => _animate = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _animate ? 1 : 0,
      duration: Duration(milliseconds: 700),
      curve: Curves.easeIn,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.bounceOut,
        transform: _animate
            ? Matrix4.identity()
            : Matrix4.translationValues(0, 50, 0),
        child: widget.child,
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final FlutterTts tts = FlutterTts();
  final List<String> shapes = ['Circle', 'Square', 'Rectangle', 'Triangle'];
  late String currentQuestion;

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    final rand = Random();
    currentQuestion = shapes[rand.nextInt(shapes.length)];
    setState(() {});
    tts.speak("Find the $currentQuestion");
  }

  void _handleAnswer(String answer) {
    if (answer == currentQuestion) {
      tts.speak("Correct! Good job!");
    } else {
      tts.speak("Oops! Try again.");
    }
    Future.delayed(Duration(seconds: 2), _nextQuestion);
  }

  Widget _buildQuizShape(String name, Color color, Widget shapeWidget) {
    return GestureDetector(
      onTap: () => _handleAnswer(name),
      child: Column(
        children: [
          shapeWidget,
          SizedBox(height: 10),
          Text(name, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shape Quiz"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tap the $currentQuestion", style: TextStyle(fontSize: 22)),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuizShape(
                'Circle',
                Colors.red,
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              _buildQuizShape(
                'Square',
                Colors.green,
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuizShape(
                'Rectangle',
                Colors.orange,
                Container(
                  width: 100,
                  height: 60,
                  color: Colors.orange,
                ),
              ),
              _buildQuizShape(
                'Triangle',
                Colors.blue,
                CustomPaint(
                  size: Size(80, 80),
                  painter: TrianglePainter(color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}