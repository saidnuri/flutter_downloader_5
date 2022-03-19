import 'dart:convert';

import 'package:flutter_downloader_5/dialog.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader_5/model.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(
    home: DemoApp(),
  ));
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool search = true;
  bool basla = false;
  late List<Model> videoResult;
  List myList = [];
  List percent = [];
  List myListLink = [];
  List isLoading = [];
  List isPlaying = [];
  late InterstitialAd _interstitialAd;

  AudioPlayer audioPlugin = AudioPlayer();
  late List videoResult1;
  final TextEditingController controller = TextEditingController();
  // TODO: Add _bannerAd

  Future<void> callAPI(String query) async {
    try {
      basla = true;
      myList.clear();
      percent.clear();
      myListLink.clear();
      isLoading.clear();
      isPlaying.clear();

      final response = await http.get(
          Uri.parse('https://fastapiairtablem.herokuapp.com/snc/' + query));
      videoResult1 = jsonDecode(response.body)['result']
          .map((data) => Model.fromJson(data))
          .toList();
      myList = List.generate(videoResult1.length, (index) => false);
      isPlaying = List.generate(videoResult1.length, (index) => false);
      myListLink = List.generate(videoResult1.length, (index) => "");
      percent = List.generate(videoResult1.length, (index) => 0.0);
      isLoading = List.generate(videoResult1.length, (index) => false);
      basla = false;
      // ignore: empty_catches
    } catch (e) {}
    setState(() {});
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-2567472206716852/7517473309',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  @override
  void initState() {
    super.initState();
    callAPI("fecr suresi");
    myBanner.load();
  }

  _indir(videoTitle, index, link) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        String savename = "$videoTitle.mp3";
        String savePath = dir.path + "/$savename";
        print(savePath);
        //output:  /storage/emulated/0/Download/banner.png

        try {
          await Dio().download(link.toString(), savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                percent[index] = received / total;
              });

              //you can build progressbar feature too
            }
          });
          return link;
        } on DioError catch (e) {
          print(e.message);
        }
      }
    } else {
      print("No permission to read and write.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    setState(() {});
                    callAPI(value);
                  },
                  style: const TextStyle(fontSize: 22.0, color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            controller.clear();
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          )),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          callAPI(controller.text);
                        },
                      ),
                      hintText: "Search...",
                      hintStyle: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        body: basla
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.blue,
              ))
            : Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: AdWidget(ad: myBanner),
                  ),
                  Expanded(
                    flex: 9,
                    child: ListView.builder(
                        itemCount: videoResult1.length,
                        itemBuilder: (context, index) {
                          return listItem(videoResult1[index], index);
                        }),
                  ),
                ],
              ),
      ),
    );
  }

  Widget listItem(
    Model video,
    int index,
  ) {
    return Card(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Image.network(video.thumbnails!.first.url.toString()),
                  ),
                  Text("Süre: " + video.duration.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(video.title.toString()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () async {
                            isLoading[index] = true;
                            setState(() {});
                            myListLink[index] == ""
                                ? myListLink[index] = await Dio().get(
                                    'https://fastapiairtablem.herokuapp.com/' +
                                        video.id.toString())
                                : myListLink[index] = myListLink[index];
                            setState(() {});
                            isLoading[index] = false;
                            _indir(video.title, index, myListLink[index]);
                          },
                          child: isLoading[index]
                              ? const CircularProgressIndicator()
                              : Row(
                                  children: const [
                                    Text(
                                      "Download",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Icon(
                                      Icons.download,
                                      size: 20,
                                      color: Colors.blue,
                                    )
                                  ],
                                )),
                      TextButton(
                        onPressed: () async {
                          isPlaying[index] = true;
                          setState(() {});

                          myListLink[index] == ""
                              ? myListLink[index] = await Dio().get(
                                  'https://fastapiairtablem.herokuapp.com/' +
                                      video.id.toString())
                              : myListLink[index];
                          isPlaying[index] = false;
                          audioPlugin.setUrl(myListLink[index].toString());
                          myList[index]
                              ? audioPlugin.pause()
                              : audioPlugin.play();
                          setState(() {
                            myList[index] = !myList[index];
                          });
                        },
                        child: isPlaying[index]
                            ? CircularProgressIndicator()
                            : Row(children: [
                                Text(
                                  myList[index] ? "Pause" : "Play",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                Icon(
                                  myList[index]
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                              ]),
                      ),
                    ],
                  ),
                  indicator(percent[index], 100)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget indicator(double perc, double width) {
  return LinearPercentIndicator(
    width: width,
    lineHeight: 20.0,
    center: Text((perc * 100).toStringAsFixed(0) + "%"),
    percent: perc,
    backgroundColor: Colors.grey,
    progressColor: Colors.blue,
  );
}
