import 'dart:convert';
import 'package:googleapis/vision/v1.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../const.dart';

class CoverScan {
  static final String url = 'https://vision.googleapis.com/v1/images:annotate?';
  static final Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String imagePath = "";


  static Future<String> getOptions(String imageUrl) async {
    late var content;
    try {
      content = await http.post(Uri.parse(url + "key=${Const.GOOGLE_API_KEY}"),
          body: json.encode({
            "requests": [
              {
                "image": {
                  "content": imageUrl
                },
                "features": [
                  {
                    "type": "WEB_DETECTION",
                    "maxResults": 1,
                  }
                ]
              }
            ]
          }));
    } catch (e) {
      log(e.toString());
    }

    // print(content);
    var body = await json.decode(content.body);
    return body["responses"][0]["webDetection"]["bestGuessLabels"][0]["label"];
  }
}
