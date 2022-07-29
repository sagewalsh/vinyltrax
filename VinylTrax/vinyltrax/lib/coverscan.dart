import 'dart:convert';
import 'package:googleapis/vision/v1.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'const.dart';

class CoverScan {
  static final String url = 'https://vision.googleapis.com/v1/images:annotate?';
  static final Codec<String, String> stringToBase64 = utf8.fuse(base64);

  static void getOptions(String imageUrl) async {
    var image = stringToBase64.encode(imageUrl);

    late var content;
    try {
      content = await http.post(Uri.parse(url + "key=${Const.GOOGLE_API_KEY}"),
          body: json.encode({
            "requests": [
              {
                "image": {
                  "source": {
                    "imageUri": imageUrl,
                  }
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
    var body = json.decode(content.body);
    body["error"]?.forEach((key, value) {
      print(key.toString() + ": " + value.toString());
    });
  }
}
