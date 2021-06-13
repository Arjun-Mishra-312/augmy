import 'dart:io';

import 'package:augmy/keywordresult.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  await DotEnv.load(fileName: '.env');
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  final picker = ImagePicker();
  String keyword;
  final textDetector = GoogleMlKit.instance.textDetector();
  List<String> keywords = [];

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    scanText();
  }
  Future scanText() async {
    setState(() {
      keywords = [];
    });
    showDialog(
        context: context,
        child: Center(
          child: CircularProgressIndicator(),
        ));
    final RecognisedText recognisedText =
        await textDetector.processImage(InputImage.fromFilePath(_image.path));
    String text = recognisedText.text;
    for (TextBlock block in recognisedText.textBlocks) {
      final Rect rect = block.blockRect;
      final List<Offset> cornerPoints = block.blockPoints;
      final String text = block.blockText;
      if (block.blockText != null) {
        keywords.add("${block.blockText}");
      }
      for (TextLine line in block.textLines) {
        // Same getters as TextBlock
        for (TextElement element in line.textElements) {
          // Same getters as TextBlock
        }
      }
      print(keywords);
    }
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => keywordresult(
              keywords: keywords,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: getImage,
                child: Text("Pick an Image"),
              ),
              SizedBox(
                height: 15,
              ),
              Text('OR'),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Search by keyword',
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(245, 100, 100, 0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  hintText: 'Search...',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  }
                },
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                },
              ),
              RaisedButton(
                onPressed: keyword != null && keyword != ''
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => keywordresult(
                              keyword: keyword,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text('Search'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
