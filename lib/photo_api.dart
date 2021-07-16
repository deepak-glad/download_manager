import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> imageApi() async {
  // List<ImageModel> data=<ImageModel> [];
  var data = [];
  var url = Uri.parse(
      'https://api.unsplash.com/photos/?client_id=$key');
  http.Response reponse = await http.get(url);
  final jsonBody = reponse.body;
  final jsonMap = jsonDecode(jsonBody);
  // data.add(ImageModel.fromJson(jsonMap));
  for (var d in jsonMap) {
    data.add(d);
  }
  // return data;
}
