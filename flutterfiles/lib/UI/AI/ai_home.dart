import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/AI/ai_tools.dart';
import 'package:lista_de_la_compra/AI/model_catalog.dart';
import 'package:lista_de_la_compra/AI/model_metadata.dart';

import 'package:lista_de_la_compra/UI/AI/ai_chat.dart';

import 'package:url_launcher/url_launcher.dart';

void showDeleteDialog(BuildContext context, ModelMetadata meta) {
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

Widget buildToolBar(ModelMetadata meta, DownloadEvent data, BuildContext context) {
  if (data is ReadyToUse) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AiChat(meta.getInferencer(getTools()));
                },
              ),
            );
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

  if (data is TaskProgressUpdateWrapper) {
    TaskProgressUpdate update = data.update;

    if (update.progress > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Text("${(update.progress * 100).toStringAsFixed(1)}% (${durationAprox(update.timeRemaining)})"),
          CircularProgressIndicator(value: update.progress),
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

  return Text("unexpected state: $data");
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
                    return catalog.map((meta) {
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
                                return buildToolBar(meta, snapshot.data!, context);
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
