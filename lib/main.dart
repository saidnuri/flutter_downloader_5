import 'dart:convert';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader_5/model.dart';

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoApp(),
    );
  }
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
  AudioPlayer audioPlugin = AudioPlayer();
  late List videoResult1;
  final TextEditingController controller = TextEditingController();
  Future<void> callAPI(String query) async {
    try {
      basla = true;
      myList.clear();
      percent.clear();
      myListLink.clear();

      final response = await http.get(
          Uri.parse('https://fastapiairtablem.herokuapp.com/snc/' + query));
      videoResult1 = jsonDecode(response.body)['result']
          .map((data) => Model.fromJson(data))
          .toList();
      myList = List.generate(videoResult1.length, (index) => false);
      myListLink = List.generate(videoResult1.length, (index) => "");
      percent = List.generate(videoResult1.length, (index) => 0.0);
      basla = false;
    } catch (e) {}
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callAPI("");
  }

  void _indir(videoTitle, index, id) async {
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
          var link = await Dio()
              .get('https://fastapiairtablem.herokuapp.com/' + id.toString());

          await Dio().download(link.toString(), savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                percent[index] = received / total;
              });
              print((received / total * 100));
              //you can build progressbar feature too
            }
          });
          print("File is saved to download folder.");
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
    return Scaffold(
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
          : ListView.builder(
              itemCount: videoResult1.length,
              itemBuilder: (context, index) {
                return listItem(videoResult1[index], index);
              }),
    );
  }

  Widget listItem(
    Model video,
    int index,
  ) {
    var link;
    return Card(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        child: Column(
          children: [
            ListTile(
              leading: Image.network(
                video.thumbnails!.first.url.toString(),
              ),
              title: Text(video.title.toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _indir(video.title, index, video.id);
                  },
                  child: Row(
                    children: const [
                      Text(
                        "Download",
                        style: TextStyle(color: Colors.blue),
                      ),
                      Icon(
                        Icons.download,
                        size: 30,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    myListLink[index] == ""
                        ? myListLink[index] = await Dio().get(
                            'https://fastapiairtablem.herokuapp.com/' +
                                video.id.toString())
                        : myListLink[index];

                    audioPlugin.setUrl(myListLink[index].toString());
                    myList[index] ? audioPlugin.pause() : audioPlugin.play();
                    setState(() {
                      myList[index] = !myList[index];
                    });
                  },
                  child: Row(children: [
                    Text(
                      myList[index] ? "Pause" : "Play",
                      style: const TextStyle(color: Colors.blue),
                    ),
                    Icon(
                      myList[index] ? Icons.pause : Icons.play_arrow,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ]),
                ),
              ],
            ),
            indicator(percent[index], 200)
          ],
        ),
      ),
    );
  }
}

Widget indicator(double perc, double width) {
  return Center(
    child: LinearPercentIndicator(
      width: width,
      lineHeight: 20.0,
      center: Text((perc * 100).toStringAsFixed(0) + "%"),
      percent: perc,
      backgroundColor: Colors.grey,
      progressColor: Colors.blue,
    ),
  );
}
