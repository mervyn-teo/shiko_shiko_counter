import 'package:flutter/material.dart';
import 'package:shiko_shiko_counter/donePage.dart';
import 'package:shiko_shiko_counter/homePage.dart';
import 'package:shiko_shiko_counter/graphic.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const MyApp(),
    '/finished': (context) => const donePage(),
    '/charts' : (context) => const chart(),
  },
));