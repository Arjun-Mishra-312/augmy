import 'package:echoar_package/echoar_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_obj/flutter_3d_obj.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class EchoARmodels extends StatefulWidget {
  EchoARmodels({Key key, this.keyword,this.keywords}) : super(key: key);

  final String keyword;
  final List<String> keywords;
  EchoAR echoAR;

  @override
  _EchoARmodelsState createState() => _EchoARmodelsState();
}

class _EchoARmodelsState extends State<EchoARmodels> {
  int _counter = 0;
  String _modelHologramPath = "";
  String _modelHologramPath2 = "";
  String _modelHologramPath3 = "";
  String value;
  bool isLoading = false;

  void _incrementCounter() async {
    if (widget.echoAR == null)
      widget.echoAR = EchoAR(apiKey: DotEnv.env['APIKEY']);
    String path = await widget.echoAR
        .getModelFromEntryId(DotEnv.env['Model1']);
    String path2 = await widget.echoAR
        .getModelFromEntryId(DotEnv.env['Model2']);
    String path3 = await widget.echoAR
        .getModelFromEntryId(DotEnv.env['Model3']);

    setState(() {
      _modelHologramPath = path;
      _modelHologramPath2 = path2;
      _modelHologramPath3 = path3;
      _counter++;
      isLoading = false;
      print(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: (_modelHologramPath == "" &&
                        _modelHologramPath2 == "" &&
                        _modelHologramPath3 == "")
                    ? Text("Press the button to start")
                    : ListView(
                        padding: EdgeInsets.all(15.0),
                        children: <Widget>[
                          SizedBox(
                            height: 100.0,
                          ),
                          _modelHologramPath3 != ""
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      Object3D(
                                        size: const Size(100.0, 100.0),
                                        path: _modelHologramPath3,
                                        asset: true,
                                        zoom: 80.0,
                                      ),
                                      Text('Primitive Cubic Unit Cell')
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 1.0,
                                ),
                          SizedBox(
                            height: 50.0,
                          ),
                          _modelHologramPath != ""
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      Object3D(
                                        size: const Size(100.0, 100.0),
                                        path: _modelHologramPath,
                                        asset: true,
                                        zoom: 80.0,
                                      ),
                                      Text('Body Centered Cubic Unit Cell')
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 1.0,
                                ),
                          SizedBox(
                            height: 50.0,
                          ),
                          _modelHologramPath2 != ""
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      Object3D(
                                        size: const Size(100.0, 100.0),
                                        path: _modelHologramPath2,
                                        asset: true,
                                        zoom: 80.0,
                                      ),
                                      Text('Face Centered Cubica Unit Cell')
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 1.0,
                                ),
                          SizedBox(
                            height: 50.0,
                          ),
                        ],
                      ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isLoading = true;
            });
            _incrementCounter();
          },
          tooltip: 'Increment',
          child: Icon(Icons.file_download),
        ),
      ),
    );
  }
}
