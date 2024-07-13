import 'package:flutter/material.dart';
import 'quiz.dart';
import 'weather-form.dart';
import 'gallery.dart';

void main() => runApp(const MaterialApp(
  home: MyApp(),
));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('First App'),
          backgroundColor: Colors.cyan[900],
          foregroundColor: Colors.cyan[200],
        ),
        body: const Center(
            child: Text(
              'Hello',
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            )),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF006064), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Center(
                  child: CircleAvatar(
                    radius: 50,backgroundImage: AssetImage('assets/images/developer.png'),
                  ),
                ),
              ),
              ListTile(
                  title: const Text(
                    'Quiz', style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const Quiz()));
                  }),
              ListTile(
                  title: const Text(
                    'Weather form',style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WeatherForm()));
                  }),
              ListTile(
                  title: const Text(
                    'Gallery',style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Gallery()));
                  })
            ],
          ),
        ),
    );
  }
}
