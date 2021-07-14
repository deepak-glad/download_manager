import 'package:download_manager/image_browser.dart';
import 'package:download_manager/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatefulWidget {
  final List data;
  // final List waiting;
  // final int progress;
  const DownloadPage({
    Key? key,
    required this.data,
    // required this.waiting,
    // required this.progress
  }) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  // String fileName = Path.join('/storage/emulated/0/', '/MyFolder/file.txt');/
  var _progress;
  value(String id) async {
    _progress = id;
  }

  @override
  Widget build(BuildContext context) {
    int progress = Provider.of<DataProvider>(context).progressData;

    List imageDownloading = Provider.of<DataProvider>(context).imageData;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey[300],
            title: const Text('Downloads'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Downloaded',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            color: Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0),
                                blurRadius: 3.0,
                              )
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ImageBrowser(
                                            image: widget.data[index])));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.file(
                                  widget.data[index],
                                  height: 100.0,
                                  width: 100.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                    ),
                                    Container(
                                      // margin: const EdgeInsets.only(top: 15),
                                      padding: const EdgeInsets.all(9),
                                      child: const Text(
                                        'Downloaded',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[800],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0.0, 1.0),
                                              blurRadius: .7,
                                            )
                                          ]),
                                    )
                                  ]),
                            ),
                            const Icon(Icons.more_vert_sharp)
                          ],
                        ),
                      );
                    }),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Downloading',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: imageDownloading.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            color: Colors.grey[300],
                            boxShadow: [BoxShadow(color: Colors.grey)]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                imageDownloading[index],
                                height: 100.0,
                                width: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                    ),
                                    Container(
                                      // margin: const EdgeInsets.only(top: ),
                                      padding: const EdgeInsets.all(9),
                                      child: const Text(
                                        'Downloading',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[800],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0.0, 1.0),
                                              blurRadius: .7,
                                            )
                                          ]),
                                    ),
                                    // LinearProgressIndicator(
                                    //     value: progress.toDouble(),
                                    //     color: Colors.yellow[800],
                                    //     minHeight: 10,
                                    //     backgroundColor: Colors.white)
                                    LinearPercentIndicator(
                                      // width: 140.0,
                                      lineHeight: 14.0,
                                      percent: progress.toDouble() / 100,
                                      backgroundColor: Colors.grey,
                                      progressColor: Colors.yellow[800],
                                    ),
                                  ]),
                            ),
                            const Icon(Icons.more_vert_sharp)
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
