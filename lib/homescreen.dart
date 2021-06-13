import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:augmy/keywordresult.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

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

  TextEditingController _controller = new TextEditingController();

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
        backgroundColor: Color.fromARGB(1, 14, 13, 18),
        body: Stack(
          children: [
            Align(
              alignment: Alignment(0, -0.2),
              child: Container(
                height: 450,
                width: 450,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.fromRGBO(30, 65, 122, 0.7),
                      Color.fromRGBO(26, 63, 57, 0)
                    ],
                    focalRadius: 1.5,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-2.4, -1.2),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.fromRGBO(30, 65, 122, 0.7),
                      Color.fromRGBO(26, 63, 57, 0)
                    ],
                    focalRadius: 1,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                // height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text("AugMy",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: _controller,
                        autofocus: false,
                        decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.1),
                          filled: true,
                          hintText: "search",
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 20),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.white, size: 28),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => keywordresult(
                                      keyword: _controller.text,
                                    ),
                                  ),
                                );
                              }),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.white54, width: 1),
                            gapPadding: 4,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.white54, width: 1),
                            gapPadding: 4,
                          ),
                        ),
                        cursorColor: Colors.white54,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    InkWell(
                      onTap: getImage,
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Container(
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white54),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 12,right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/camera.png',
                                  width: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text("Scan",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Spacer(),
                                Text(
                                  "To make your life easier, we're working to create an experience that will lead you to a whole new lifestyle. Digitally scan your textbooks and we'll help you visualize them. This is the closest experience to reality you can get.",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                Spacer(flex: 2),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
