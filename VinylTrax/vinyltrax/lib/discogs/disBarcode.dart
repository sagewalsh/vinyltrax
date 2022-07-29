import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/foundation/key.dart';

import 'discogs.dart';
import '../spotify/spotDetails.dart';
import 'package:flutter/material.dart';

class DisBarcode extends StatelessWidget {
  final List<String> input;
  final bool isBarcode;
  DisBarcode(this.input, this.isBarcode);

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> _results = Collection.barcode(input[0]);
    return FutureBuilder<List<dynamic>>(
      future: _results,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              List<dynamic> data = snapshot.data!;
              if (data.isNotEmpty) {
                return SpotDetails([
                  data[0][0][0]
                      .toString()
                      .replaceAll(RegExp(r'\([0-9]+\)'), ""),
                  data[1].toString()
                ], true);
              } else {
                return SpotDetails([], true);
              }
            }
            break;

          default:
            debugPrint("Snapshot " + snapshot.toString());
            return Container();
        }
      },
    );
  }
}
