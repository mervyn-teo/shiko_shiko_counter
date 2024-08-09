import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'package:sqflite/sqflite.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Timer timer;
  int defaultTime = 5;
  int shakeCount = 0;
  bool started = false;
  String startedText = 'start';
  

  @override
  Widget build(BuildContext context) {
    void startTimer() {
      // set timer
      timer = Timer.periodic(
        Duration(seconds: 1), 
        (timer) async {
          // time ended
          if (defaultTime == 0) {
            // remove timer
            timer.cancel();
            var database = await getDatabase();
            var values = {
              'time' : DateTime.now().millisecondsSinceEpoch,
              'reps' : shakeCount
            }; 
            database.insert('shiko_records', values,);
            final dbRes = await database.query('shiko_records');
            for (var element in dbRes) {
              print(element['id']);
              print(element['reps']);
            }
            Navigator.pushNamed(
              context, 
              '/finished', 
              arguments: {'shakeCount' : shakeCount});
          } else {
            setState(
              () {
                defaultTime--;
              }
            );
          }
      });
    }

    @override
    void dispose() {
      super.dispose();
      timer.cancel();
    }

    return MaterialApp(
      home: Scaffold(
        body: ShakeGesture(
          onShake: () {
                      if (started) {
                        shakeCount++;
                      }
                    },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('time left:'),
                Text(
                  defaultTime.toString(),
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.deepPurple,
                  ),),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                    ),
                  color: Colors.amberAccent,
                  child: Text(startedText),
                  onPressed: () {
                    setState(() {
                      if (started) {
                        startedText = 'start';
                        defaultTime = 5;
                        timer.cancel();
                        started = !started;
                      } else {
                        startedText = 'stop';
                        started = !started;
                        startTimer();
                      }
                    });
                  },
                  ),
              ],
            )
          ),
        ),
      ),
    );
  }

  Future<Database> getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(  
      version: 1,
      join(await getDatabasesPath(), 'shiko_database.db'),
      // initialise db if it doesnt exists
      onCreate: (db, version) {
        return db.execute(
          // time here is unix time
          'CREATE TABLE shiko_records(id INTEGER PRIMARY KEY, time INTEGER, reps INTEGER)',
        );
      },
    );
    return database;
  }

}