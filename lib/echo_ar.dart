import 'package:echoar_package/echoar_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_obj/flutter_3d_obj.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class EchoARmodels extends StatefulWidget {
  EchoARmodels({Key key, this.keyword, this.keywords}) : super(key: key);

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
    String path = await widget.echoAR.getModelFromEntryId(DotEnv.env['Model1']);
    String path2 =
        await widget.echoAR.getModelFromEntryId(DotEnv.env['Model2']);
    String path3 =
        await widget.echoAR.getModelFromEntryId(DotEnv.env['Model3']);

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
  void initState() {
    setState(() {
      isLoading = true;
    });
    // TODO: implement initState
    super.initState();
    _incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.count(
            childAspectRatio: 0.753,
            crossAxisCount: 2,
            crossAxisSpacing: 60.0,
            mainAxisSpacing: 30.0,
            padding: EdgeInsets.all(30.0),
            children: <Widget>[
              _modelHologramPath3 != ""
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Color.fromRGBO(255, 255, 255, 0.3),
                            width: 1.64),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Object3D(
                            size: const Size(100.0, 100.0),
                            path: _modelHologramPath3,
                            asset: true,
                            zoom: 100.0,
                          ),
                          Text(
                            'Primitive Cubic Unit Cell',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 1.0,
                    ),
              _modelHologramPath != ""
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Color.fromRGBO(255, 255, 255, 0.3),
                            width: 1.64),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Object3D(
                            size: const Size(100.0, 100.0),
                            path: _modelHologramPath,
                            asset: true,
                            zoom: 100.0,
                          ),
                          Text(
                            'Body Centered Cubic Unit Cell',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 1.0,
                    ),
              _modelHologramPath2 != ""
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Color.fromRGBO(255, 255, 255, 0.3),
                            width: 1.64),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Object3D(
                            size: const Size(100.0, 100.0),
                            path: _modelHologramPath2,
                            asset: true,
                            zoom: 100.0,
                          ),
                          Text(
                            'Face Centered Cubica Unit Cell',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
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
          );
  }
}
