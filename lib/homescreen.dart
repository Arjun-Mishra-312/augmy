import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:augmy/keywordresult.dart';
import 'package:google_fonts/google_fonts.dart';
import 'echo_ar.dart';

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
              keyword: keyword,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(1, 14, 13, 18),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "search",
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 20),
                  prefixIcon: Icon(Icons.search, color: Colors.white, size: 28),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _controller.text.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => keywordresult(
                                  keyword: _controller.text,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white54, width: 3),
                    gapPadding: 4,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white54, width: 3),
                    gapPadding: 4,
                  ),
                ),
                cursorColor: Colors.white54,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(1, 14, 13, 18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white54),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/camera.png', width: 60,),
                        Text("Scan", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700))
                      ],
                    ),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
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
*/
