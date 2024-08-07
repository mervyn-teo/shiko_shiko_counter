import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shiko_shiko_counter/donePage.dart';
import 'package:wear_plus/wear_plus.dart';
import 'package:shake_gesture/shake_gesture.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const MyApp(),
    '/finished': (context) => const donePage(),
  },
));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Timer timer;
  int defaultTime = 20;
  int shakeCount = 0;
  bool started = false;
  String startedText = 'start';
  

  @override
  Widget build(BuildContext context) {
    void startTimer() {
      // set timer
      timer = Timer.periodic(
        Duration(seconds: 1), 
        (timer) {
          // time ended
          if (defaultTime == 0) {
            // remove timer
            timer.cancel();

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
      // start detector

    }

    @override
    void dispose() {
      super.dispose();
      timer.cancel();
    }

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('time left:'),
              Text(
                defaultTime.toString(),
                style: TextStyle(
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
                      defaultTime = 20;
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
                ShakeGesture(
                  child: Placeholder(), 
                  onShake: () {
                    print('shaken');
                    if (started) {
                      shakeCount++;
                    }
                  }
                )
            ],
          )
        ),
      ),
    );
  }
}