import 'package:flutter/material.dart';

class donePage extends StatefulWidget {
  const donePage({super.key});

  @override
  State<donePage> createState() => _donePageState();
}

class _donePageState extends State<donePage> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Reps done:'),
            Text(arguments['shakeCount'].toString()),
          ],
        )
      )
    );
  }
}