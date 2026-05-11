import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'dart:convert';

import 'package:lista_de_la_compra/UI/AI/ai_chat.dart';

import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AiMetadata {
  late final String name;
  late final String notes;
  late final String id;
  late final String modelDownloadUrl;
  late final double sizeGb;
  late final Uri modelInfoUrl;

  late StreamController<dynamic> stateStream;

  AiMetadata(Map<String, dynamic> seed) {
    name = seed["name"];
    notes = seed["notes"];
    id = seed["id"];
    modelDownloadUrl = seed["model_download_url"];
    sizeGb = seed["size_gb"];
    modelInfoUrl = Uri.parse(seed["model_info_url"]);

    stateStream = StreamController();

    downloaded().then((e) => stateStream.add(e));
  }

  Future<bool> downloaded() async {
    final fileDir = (await getApplicationDocumentsDirectory()).path;

    return io.File("$fileDir/$id.gguf").existsSync();
  }

  void download() async {
    final fileDir = (await getApplicationDocumentsDirectory()).path;

    final task = DownloadTask(
      url: modelDownloadUrl,
      filename: '.tmp_$id.gguf',
      directory: fileDir,
      updates: Updates.statusAndProgress, // request status and progress updates
      retries: 5,
      allowPause: true,
    );

    FileDownloader().download(
      task,
      onProgress: (progress) => stateStream.add(progress),
      onStatus: (status) async {
        switch (status) {
          case TaskStatus.enqueued:
          case TaskStatus.running:
            break;
          case TaskStatus.notFound:
          case TaskStatus.failed:
          case TaskStatus.canceled:
            stateStream.add(false);
            break;
          case TaskStatus.waitingToRetry:
            stateStream.add("retrying shortly...");
            break;
          case TaskStatus.paused:
            stateStream.add("download paused");
            break;
          case TaskStatus.complete:
            io.File('$fileDir/.tmp_$id.gguf').rename('$fileDir/$id.gguf');
            stateStream.add(await downloaded());
        }
      },
    );
  }

  void delete() async {
    final fileDir = (await getApplicationDocumentsDirectory()).path;

    final file = io.File('$fileDir/$id.gguf');

    if (!file.existsSync()) {
      throw "This model is not donwloaded";
    }

    await file.delete();

    stateStream.add(await downloaded());
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
              Text("Did you know AI is a thing? Any turing complete silicon chunk can talk lately? The download times are long, but you can exit the app :). If you exit this page and come back the download handler will get lost, but the download continues in the background"),
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
