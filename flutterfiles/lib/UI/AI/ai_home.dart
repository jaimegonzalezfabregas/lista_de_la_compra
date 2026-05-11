import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'dart:convert';

import 'package:lista_de_la_compra/UI/AI/ai_chat.dart';

import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AiMetadata {
  late final String name;
  late final String notes;
  late final String id;
  late final Uri modelDownloadUrl;
  late final double sizeGb;
  late final Uri modelInfoUrl;
  late bool downloaded;

  late StreamController<dynamic> stateStream;

  AiMetadata(Map<String, dynamic> seed) {
    name = seed["name"];
    notes = seed["notes"];
    id = seed["id"];
    modelDownloadUrl = Uri.parse(seed["model_download_url"]);
    sizeGb = seed["size_gb"];
    modelInfoUrl = Uri.parse(seed["model_info_url"]);
    downloaded = io.File("./$id.gguf").existsSync();

    stateStream = StreamController();

    stateStream.add(downloaded);
  }

  http.StreamedResponse? _response;
  int _total = 0, _received = 0;
  List<int> _bytes = [];

  void download() async {
    try {
      if (downloaded || _response != null) {
        throw "This model is already downloaded";
      }

      stateStream.add("Starting download");

      _response = await http.Client().send(http.Request('GET', modelDownloadUrl));
      _total = _response?.contentLength ?? 0;

      _response?.stream
          .listen((value) {
            _bytes.addAll(value);
            double lastProgress = _received / _total;
            _received += value.length;
            double currentProgress = _received / _total;
            if (lastProgress % 0.01 != currentProgress % 0.01) {
              stateStream.add(_received / _total);
            }
          })
          .onDone(() async {
            final file = io.File('./$id.gguf');
            await file.writeAsBytes(_bytes);
            downloaded = true;
            stateStream.add(downloaded);
          });
    } catch (e) {
      stateStream.add(e.toString());
    }
  }

  void delete() async {
    final file = io.File('./$id.gguf');

    if (!file.existsSync()) {
      throw "This model is not donwloaded";
    }

    await file.delete();
    _response = null;
    _received = 0;
    _total = 0;
    _bytes = [];

    downloaded = false;

    stateStream.add(downloaded);
  }
}

class AiHome extends StatelessWidget {
  const AiHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: Text("AI welcome")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Did you know AI is a thing? Any turing complete silicon chunk can talk lately?"),
              FutureBuilder(
                future: () async {
                  try {
                    final jsondata = await root_bundle.rootBundle.loadString("assets/ai_model_cataloge.json");
                    final list = json.decode(jsondata) as List<dynamic>;
                    return list.map((e) {
                      AiMetadata meta = AiMetadata(e);
          
                      return ListTile(
                        title: Text(meta.name),
                        subtitle: Text(meta.notes),
          
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder(
                              stream: meta.stateStream.stream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("...");
                                }
          
                                if (snapshot.data == true) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AiChat(meta.id)));
                                        },
                                        icon: Icon(Icons.play_arrow),
                                      ),
          
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Delete ${meta.name}?"),
                                                content: Text("After deleting you will need to redownload ${meta.sizeGb} GB to get the model back"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      meta.delete();
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Delete"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Keep"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }
          
                                if (snapshot.data == false || snapshot.data is String) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
          
                                    children: [
                                      snapshot.data is String ? Text(snapshot.data) : Text("~ ${meta.sizeGb} GB"),
                                      IconButton(
                                        onPressed: () {
                                          meta.download();
                                        },
                                        icon: Icon(Icons.download),
                                      ),
                                    ],
                                  );
                                }
          
                                if (snapshot.data is double) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 20,
                                    children: [
                                      Text("${(snapshot.data * 100).toStringAsFixed(1)}%"),
                                      CircularProgressIndicator(value: snapshot.data),
                                    ],
                                  );
                                }
          
                                print(snapshot);
          
                                return Text("? ${snapshot}");
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.my_library_books_rounded),
                              onPressed: () {
                                launchUrl(meta.modelInfoUrl);
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  } catch (e) {
                    print(e);
                  }
                }(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading catalog from offline asset");
                  }
          
                  return ListView(
                    shrinkWrap: true,
                    children: ListTile.divideTiles(context: context, tiles: snapshot.data!).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
