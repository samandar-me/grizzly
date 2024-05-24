import 'package:flutter/material.dart';
import 'package:grizzly/music_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black,brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MusicListPage(),
    );
  }
}

