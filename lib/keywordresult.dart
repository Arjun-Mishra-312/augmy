import 'package:chips_choice/chips_choice.dart';
import 'package:echoar_package/echoar_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_3d_obj/flutter_3d_obj.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class keywordresult extends StatefulWidget {
  keywordresult({Key key, this.keyword, this.keywords}) : super(key: key);

  String keyword;
  List<String> keywords;
  EchoAR echoAR;

  @override
  _keywordresultState createState() => _keywordresultState();
}

class _keywordresultState extends State<keywordresult> {
  static String api_key = DotEnv.env['YTAPIKEY'];
  YoutubeAPI ytapi = new YoutubeAPI(api_key);
  List<YT_API> ytResult = [];
  bool _isloading = false;
  int tag = 0;
  List<String> options = [];

  int _counter = 0;
  String _modelHologramPath = "";
  String _modelHologramPath2 = "";
  String _modelHologramPath3 = "";
  String _modelHologramPath4 = "";
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
    String path4 =
        await widget.echoAR.getModelFromEntryId(DotEnv.env['Model4']);

    setState(() {
      _modelHologramPath = path;
      _modelHologramPath2 = path2;
      _modelHologramPath3 = path3;
      _modelHologramPath4 = path4;
      _counter++;
      isLoading = false;
      print(path);
    });
  }

  callApi(String i) async {
    ytResult = await ytapi.search(i, type: 'video');
    print(ytResult[0].title);
    setState(() {
      _isloading = false;
    });
  }

  getkeyword() {
    setState(() {
      options = [];
    });
    widget.keywords != null
        ? widget.keywords.forEach(
            (element) {
              if (element.contains('face-centre')) {
                if (options.contains('Face-Centred Cubic Unit Cell')) {
                  return null;
                } else {
                  options.add('Face-Centred Cubic Unit Cell');
                }
              }
              if (element.contains('body-centre')) {
                if (options.contains('Body-Centred Cubic Unit Cell')) {
                  return null;
                } else {
                  options.add('Body-Centred Cubic Unit Cell');
                }
              }
              if (element.contains('primitive')) {
                if (options.contains('Primitive Cubic Unit Cell')) {
                  return null;
                } else {
                  options.add('Primitive Cubic Unit Cell');
                }
              }
            },
          )
        : null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getkeyword();
    widget.keyword != null ? callApi(widget.keyword) : callApi(options[0]);
    print(widget.keyword);
    _incrementCounter();
    // for (int i = 0; i < ytResult.length; i++) {
    //   print(ytResult[i].title);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(1, 14, 13, 18),
        body: _isloading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 42, top: 20),
                          child: Text(
                            widget.keyword != null
                                ? '${widget.keyword}'
                                : options[tag],
                            style: GoogleFonts.ubuntu(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.keywords != null
                        ? Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: ChipsChoice<int>.single(
                                value: tag,
                                choiceActiveStyle: C2ChoiceStyle(color: Color.fromRGBO(0, 0, 0, 1),borderColor: Colors.greenAccent),
                                onChanged: (val) => setState(() {
                                  tag = val;
                                  callApi(options[tag]);
                                }),
                                choiceItems: C2Choice.listFrom<int, String>(
                                  source: options,
                                  value: (i, v) => i,
                                  label: (i, v) => v,
                                  tooltip: (i, v) => v,
                                ),
                                choiceStyle: C2ChoiceStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                  borderColor: Colors.greenAccent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                wrapped: true,
                              ),
                            ),
                          )
                        : Container(),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 42),
                          child: Text(
                            'Related Searches',
                            style: GoogleFonts.ubuntu(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: ytResult.length,
                        itemBuilder: (BuildContext context, int index) =>
                            listItem(index),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 42, top: 12),
                          child: Text(
                            'Models',
                            style: GoogleFonts.ubuntu(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Models
                    Expanded(
                      flex: 8,
                      child: EchoARModels(options)
                    )
                    // Spacer(flex: 16),
                  ],
                ),
              ),
      ),
    );
  }

  Widget listItem(index) {
    return InkWell(
      onTap: () async {
        final _url = ytResult[index].url;
        await canLaunch(_url)
            ? await launch(_url)
            : throw 'Error launching URL';
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          color: Color.fromARGB(1, 14, 13, 18),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                // color: Colors.white,
                border: Border.all(color: Colors.white54)),
            height: 200,
            width: 200,
            child: Column(
              children: [
                Image.network(ytResult[index].thumbnail['high']['url'],
                    fit: BoxFit.fill),
                Text("${(ytResult[index].title)}",
                    style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: ytResult[index].title.length >= 30 ? 13 : 16,
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget EchoARModels(List<String> k) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.count(
            childAspectRatio: 0.753,
            crossAxisCount: 2,
            crossAxisSpacing: 60.0,
            mainAxisSpacing: 30.0,
            padding: EdgeInsets.all(30.0),
            children: k.contains("Primitive Cubic Unit Cell")
                ? <Widget>[
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
                  ]
                : k.contains("Body-Centred Cubic Unit Cell")
                    ? <Widget>[
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Object3D(
                                      size: const Size(100.0, 100.0),
                                      path: _modelHologramPath2,
                                      asset: true,
                                      zoom: 100.0,
                                    ),
                                    Text(
                                      'Face Centered Cubic Unit Cell',
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
                      ]
                    : <Widget>[
                        _modelHologramPath4 != ""
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Color.fromRGBO(255, 255, 255, 0.3),
                                      width: 1.64),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 6,),
                                        Object3D(
                                          size: const Size(100.0, 100.0),
                                          path: _modelHologramPath4,
                                          asset: true,
                                          zoom: 6.0,
                                          angleX: 90,
                                          angleY: 0,
                                          angleZ: 0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Nintendo Switch Lite',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 1.0,
                              ),
                      ],
          );
  }
}



