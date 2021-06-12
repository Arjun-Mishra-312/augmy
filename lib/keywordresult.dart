import 'package:augmy/echo_ar.dart';
import 'package:echoar_package/echoar_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class keywordresult extends StatefulWidget {
  keywordresult({Key key, this.keyword}) : super(key: key);

  String keyword;

  @override
  _keywordresultState createState() => _keywordresultState();
}

class _keywordresultState extends State<keywordresult> {
  static String api_key = DotEnv.env['YTAPIKEY'];
  YoutubeAPI ytapi = new YoutubeAPI(api_key);
  List<YT_API> ytResult = [];
  bool _isloading = true;
  callApi() async {
    ytResult = await ytapi.search(widget.keyword, type: 'video');
    print(ytResult[0].title);
    setState(() {
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
    print(widget.keyword);
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
                            '${widget.keyword}',
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
                      child: EchoARmodels(),
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
}
