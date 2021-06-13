
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:google_fonts/google_fonts.dart';
import 'homescreen.dart';

Future<void> main() async {
  await DotEnv.load(fileName: '.env');
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'echoAR example app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.ubuntu().fontFamily,
        accentColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}
