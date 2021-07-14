import 'dart:io';
import 'package:download_manager/download_page.dart';
import 'package:download_manager/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var data = [];
  int i = 0;
  String _message = "";
  String _path = "";
  String _size = "";
  String _mimeType = "";
  File? _imageFile;
  int _progress = 0;
  List _mulitpleFiles = [];
  @override
  void initState() {
    imageApi();
    super.initState();
    ImageDownloader.callback(onProgressUpdate: (String? imageId, int progress) {
      setState(() {
        _progress = progress;
      });
    });
  }

  var apiData = [];
  String loader = '';
  late List value = [];
  List<String> value_waiting = [];

  Future<void> imageApi() async {
    var url = Uri.parse(
        'https://api.unsplash.com/photos/random?count=50&client_id=5tFO_GG3_GjOO3PeYKJcDSfQghkezyUbYyKsWhIv_OY');
    // 'https://jsonplaceholder.typicode.com/photos');
    http.Response reponse = await http.get(url);
    final jsonBody = reponse.body;
    final jsonMap = jsonDecode(jsonBody);
    for (var d in jsonMap) {
      data.add(d);
    }
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    var dd = Provider.of<DataProvider>(context, listen: false);
    dd.addProgress(_progress, value_waiting);
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Images'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => DownloadPage(
                            data: value,
                          )));
                },
                icon: const Icon(Icons.download))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 3 : 4),
              itemBuilder: (context, index) {
                var da = data[index];
                if (data.isNotEmpty) {
                  return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        GestureDetector(
                          onTap: !apiData.contains(da['id']) && loader.isEmpty
                              ? () {
                                  _downloadImage(
                                    index,
                                    da['id'],
                                    da['urls']['regular'],
                                    // destination: AndroidDestinationType
                                    //     .directoryPictures
                                    //   ..inExternalFilesDir()
                                    //   ..subDirectory("image_downloader$index.jpg"),
                                  );
                                  _mulitpleFiles.add(da['urls']['regular']);
                                  value_waiting.add(da['urls']['regular']);
                                  setState(() {
                                    loader = da['id'];
                                  });
                                }
                              : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              da['urls']['small'],
                              height: 150.0,
                              width: 100.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (loader == da['id'])
                          CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 5.0,
                            percent: _progress.toDouble() / 100,
                            progressColor: Colors.green,
                          ),
                        if (apiData.contains(da['id']))
                          Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Icon(Icons.download_done,
                                  color: Colors.green))
                      ]);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }

  var isDownloading;
  Future<void> _downloadImage(
    var data_index,
    String api_id,
    String url, {
    AndroidDestinationType? destination,
    bool whenError = false,
    String? outputMimeType,
  }) async {
    String? fileName;
    String? path;
    int? size;
    String? mimeType;
    for (var im in _mulitpleFiles) print('ddd$im');
    try {
      String? imageId;

      if (whenError) {
        imageId = await ImageDownloader.downloadImage(url,
                outputMimeType: outputMimeType)
            .catchError((error) {
          if (error is PlatformException) {
            String? path = "";
            if (error.code == "404") {
              print("Not Found Error.");
            } else if (error.code == "unsupported_file") {
              print("UnSupported FIle Error.");
              path = error.details["unsupported_file_path"];
            }
            setState(() {
              _message = error.toString();
              _path = path ?? '';
              isDownloading = 'error';
            });
          }

          print('error$error');
        }).timeout(const Duration(seconds: 10), onTimeout: () {
          print("timeout");
          return;
        });
      } else {
        if (destination == null) {
          imageId = await ImageDownloader.downloadImage(
            url,
            outputMimeType: outputMimeType,
          );
        } else {
          imageId = await ImageDownloader.downloadImage(
            url,
            destination: destination,
            outputMimeType: outputMimeType,
          );
        }
        setState(() {
          isDownloading = 'started';
        });
      }

      if (imageId == null) {
        return;
      }
      fileName = await ImageDownloader.findName(imageId);
      path = await ImageDownloader.findPath(imageId);
      size = await ImageDownloader.findByteSize(imageId);
      mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      setState(() {
        _message = error.message ?? '';
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      var location = Platform.isAndroid ? "Directory" : "Photo Library";
      _message = 'Saved as "$fileName" in $location.\n';
      _size = 'size:     $size';
      _mimeType = 'mimeType: $mimeType';

      _path = path ?? '';
      apiData.add(api_id);
      loader = '';

      var temp = data[data_index];
      data[data_index] = data[i];
      data[i] = temp;
      i++;
      value_waiting.remove(url);
      value.add(File(path!));
      if (!_mimeType.contains("video")) {
        _imageFile = File(path);
      }
      return;
    });
  }
}
