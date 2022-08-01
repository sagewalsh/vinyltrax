import 'package:flutter/material.dart';
import 'package:vinyltrax/inventory/invDetails.dart';
import 'database.dart';
import '../pages/settingspage.dart' as settings;

class GetInvNotes extends StatefulWidget {
  final List<String> input;

  GetInvNotes(this.input);

  @override
  State<GetInvNotes> createState() => _InvNotes();
}

class _InvNotes extends State<GetInvNotes> {
  @override
  Widget build(BuildContext context) {
    Future<String> _results = Database.getNotes(widget.input[0]);
    String currentNotes = "";

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: FutureBuilder<String>(
            future: _results,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[];
                if (snapshot.data != null)
                  currentNotes = snapshot.data!;
                // Note Box
                children.add(GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Modify Notes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            content: TextField(
                              controller: TextEditingController()..text = currentNotes,
                              focusNode: FocusNode(),
                              cursorColor: settings.darkTheme ? Colors.white : Colors.black,
                              style: TextStyle(
                                color: settings.darkTheme ? Colors.white : Colors.black,
                              ),
                              onSubmitted: (value) {
                                Database.addNotes(
                                    albumID: widget.input[0], note: value);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                var route = new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return InvDetails(widget.input);
                                });
                                Navigator.of(context).push(route);
                              },
                            ),
                            // TextField(
                            //   controller: _controller,
                            //   keyboardType: TextInputType.text,
                            //   maxLines: null,
                            //   maxLength: 500,
                            //   onSubmitted: (value) {
                            //     Database.addNotes(
                            //         albumID: widget.input[0], note: value);
                            //     Navigator.pop(context);
                            //     Navigator.pop(context);
                            //     var route = new MaterialPageRoute(
                            //         builder: (BuildContext context) {
                            //       return InvDetails(widget.input);
                            //     });
                            //     Navigator.of(context).push(route);
                            //   },
                            //   decoration: InputDecoration(
                            //     labelText: 'Notes',
                            //     border: const OutlineInputBorder(),
                            //     suffixIcon: IconButton(
                            //       onPressed: _controller.clear,
                            //       icon: Icon(Icons.clear),
                            //     ),
                            //   ),
                            // ),
                          );
                        });
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Notes",
                                style: TextStyle(
                                  color: settings.darkTheme ? Colors.white : Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 5,
                                child: const Text(""),
                              ),
                              Text(
                                snapshot.data!,
                                style: TextStyle(
                                  color: settings.darkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: settings.darkTheme ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: settings.darkTheme ? Colors.white : Colors.black),
                        ),
                      )),
                ));

                // Spacing after the Note Box
                children.add(SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: const Text(""),
                ));
              } else if (snapshot.hasError) {
                children = <Widget>[
                  Icon(Icons.error),
                ];
              } else {
                children = <Widget>[
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1275, //50
                      height: MediaQuery.of(context).size.height * 0.062, //50
                      child: CircularProgressIndicator(),
                    ),
                  )
                ];
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              );
            }),
      ),
    );
  }
}
