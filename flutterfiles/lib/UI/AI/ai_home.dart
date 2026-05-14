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

class JustASecond {}

class ReadyToUse {}

class NotDownloaded {}

void showDeleteDialog(context, meta) {
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
}

String durationAprox(Duration d) {
  if (d.inHours > 2) {
    return "${d.inHours} hours";
  }

  if (d.inMinutes >= 2) {
    return "${d.inMinutes} mins";
  }

  if (d.inSeconds >= 5) {
    return "${d.inSeconds} secs";
  }

  return "< 5 secs";
}

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

    firstStatus();
    attachDownloadTaskToStream();
  }

  void firstStatus() async {
    if (await FileDownloader().taskForId(id) != null) {
      return stateStream.add(JustASecond());
    }

    final fileDir = (await getApplicationDocumentsDirectory()).path;

    return stateStream.add(await io.File("$fileDir/ai_models/$id.gguf").exists() ? ReadyToUse() : NotDownloaded());
  }

  void attachDownloadTaskToStream() async {
    final fileDir = (await getApplicationDocumentsDirectory()).path;

    FileDownloader().registerCallbacks(
      group: id,
      taskStatusCallback: (status) async {
        switch (status.status) {
          case TaskStatus.enqueued:
          case TaskStatus.running:
            break;
          case TaskStatus.notFound:
          case TaskStatus.failed:
          case TaskStatus.canceled:
            stateStream.add(NotDownloaded());
            break;
          case TaskStatus.waitingToRetry:
            stateStream.add(JustASecond());
            break;
          case TaskStatus.paused:
            stateStream.add(NotDownloaded());
            break;
          case TaskStatus.complete:
            io.File('$fileDir/ai_models/.tmp_$id.gguf').rename('$fileDir/ai_models/$id.gguf');
            stateStream.add(ReadyToUse());
        }
      },
      taskProgressCallback: (progress) {
        stateStream.add(progress);
      },
    );

    FileDownloader().start();
  }

  void stopDownload() async {
    FileDownloader().cancelTaskWithId(id);
    stateStream.add(NotDownloaded());
  }

  void startDownload() async {
    var test = await FileDownloader().taskForId(id);
    if (test != null) {
      print("download of $id is ongoing already($test)");
      return;
    }

    DownloadTask task = DownloadTask(
      taskId: id,
      group: id,
      url: modelDownloadUrl,
      filename: '.tmp_$id.gguf',
      directory: "ai_models",
      updates: Updates.statusAndProgress, // request status and progress updates
      retries: 5,
      allowPause: true,
    );

    FileDownloader().enqueue(task);
    stateStream.add(JustASecond());
  }

  void delete() async {
    final fileDir = (await getApplicationDocumentsDirectory()).path;

    final file = io.File('$fileDir/ai_models/$id.gguf');

    if (!file.existsSync()) {
      throw "This model is not donwloaded";
    }

    await file.delete();

    stateStream.add(NotDownloaded());
  }
}

Widget buildToolBar(meta, data, context) {
  if (data is ReadyToUse) {
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
            showDeleteDialog(context, meta);
          },
        ),
      ],
    );
  }

  if (data is NotDownloaded) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Text("~ ${meta.sizeGb} GB"),
        IconButton(
          onPressed: () {
            meta.startDownload();
          },
          icon: Icon(Icons.download),
        ),
      ],
    );
  }

  if (data is TaskProgressUpdate) {
    if (data.progress > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Text("${(data.progress * 100).toStringAsFixed(1)}% (${durationAprox(data.timeRemaining)})"),
          CircularProgressIndicator(value: data.progress),
          IconButton(
            onPressed: () {
              meta.stopDownload();
            },
            icon: Icon(Icons.stop),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Text("Starting download"),
          CircularProgressIndicator(value: null),
          IconButton(
            onPressed: () {
              meta.stopDownload();
            },
            icon: Icon(Icons.stop),
          ),
        ],
      );
    }
  }

  if (data is JustASecond) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        Text("Just a second..."),
        CircularProgressIndicator(value: null),
        IconButton(
          onPressed: () {
            meta.stopDownload();
          },
          icon: Icon(Icons.stop),
        ),
      ],
    );
  }

  return Text("unexpected state: ${data}");
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
              Text(
                "Did you know AI is a thing? Any turing complete silicon chunk can talk lately! The download times are long, but you can exit the app :).",
              ),
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
                                return buildToolBar(meta, snapshot.data, context);
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
