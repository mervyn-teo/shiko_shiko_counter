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
            const Text('Reps done:'),
            Text(
              arguments['shakeCount'].toString(),
              style: const TextStyle(
                      fontSize: 40,
                      color: Colors.deepPurple,
                    ),),
            MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                    ),
                  color: Colors.amberAccent,
                  child: const Text('Another one'),
                  onPressed: () {
                    Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);                 
                  },
                  ),
          ],
        )
      )
    );
  }
}