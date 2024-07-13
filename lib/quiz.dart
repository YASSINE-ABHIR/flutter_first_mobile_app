import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  _QuizStart createState() => _QuizStart();
}

class _QuizStart extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        foregroundColor: Colors.cyan[50],
        title: const Text('Challenge your knowledge'),
      ),
      /*body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.cyan[200],
                    foregroundColor: Colors.cyan[900],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuizWidget()));
                  },
                  child: Image.asset('assets/images/start.png'),
                ),
              ),
            ),
          ],
        ),
      ),*/
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.cyan[200],
                    foregroundColor: Colors.cyan[900],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuizWidget()));
                    },
                  child: Image.asset('assets/images/start.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizWidget extends StatefulWidget {
  const QuizWidget({super.key});

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<QuizWidget> {
  int currentQuestion = 0;
  int score = 0;

  final List<Map<String, Object>> quiz = [
    {
      'title': 'Who owns Flutter?',
      'answers': [
        {'answer': 'Microsoft', 'correct': false},
        {'answer': 'Meta', 'correct': false},
        {'answer': 'Alphabet Inc.', 'correct': true},
      ]
    },
    {
      'title': 'Who is the founder of Dart?',
      'answers': [
        {'answer': 'Navneet Dalal', 'correct': false},
        {'answer': 'Ken Dart', 'correct': true},
        {'answer': 'Mehul Nariyawala', 'correct': false},
      ]
    },
    {
      'title': 'Who is the founder of Instagram?',
      'answers': [
        {'answer': 'Mark Zuckerberg', 'correct': false},
        {'answer': 'Kevin Systrom', 'correct': true},
        {'answer': 'Bill Gates', 'correct': false},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Colors.orange,
      ),
      body: currentQuestion >= quiz.length
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score : ${(score / quiz.length * 100).round()} %',
              style: const TextStyle(color: Colors.black87, fontSize: 22),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[900],
                foregroundColor: Colors.cyan[200]
              ),
              onPressed: () {
                setState(() {
                  currentQuestion = 0;
                  score = 0;
                });
              },
              child: const Text(
                'Restart ...',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
      )
          : ListView(
        children: <Widget>[
          ListTile(
            title: Center(
              child: Text(
                'Question : ${currentQuestion + 1}/${quiz.length}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ),
          ListTile(
            title: Center(
              child: Text(
                '${quiz[currentQuestion]['title']} ?',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          ),
          ...(quiz[currentQuestion]['answers'] as List<Map<String, Object>>).map((answer) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[900],
                  foregroundColor: Colors.cyan[50]
                ),
                onPressed: () {
                  setState(() {
                    if (answer['correct'] == true) {
                      ++score;
                    }
                    ++currentQuestion;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      answer['answer'] as String,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
