import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/AI/AI_models/ai_model.dart';
import 'package:lista_de_la_compra/AI/ai_tools.dart';
import 'package:lista_de_la_compra/AI/model_catalog.dart';

import 'package:lista_de_la_compra/UI/AI/ai_chat.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

void showDeleteDialog(BuildContext context, AIModel meta) {
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

Widget buildToolBar(AIModel meta, DownloadEvent data, BuildContext context, List<Jtool> tools) {
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
                  return AiChat(meta.getInferencer(tools), meta.name);
                },
              ),
            );
          },
          icon: Icon(Icons.play_arrow),
        ),
        if (meta.isDeleteAviable())
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

  if (data is DownloadProgress) {
    if (data.progress > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Text("${(data.progress * 100).toStringAsFixed(1)}% (${durationAprox(data.timeRemaining)})"),
          CircularProgressIndicator(value: data.progress),
          if (meta.isStopAviable())
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
  final String enviromentId;

  const AiHome(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider scheduleProvider = context.read<FlutterScheduleProvider>();
    ProductProvider productProvider = context.read<FlutterProductProvider>();
    RecipeProvider recipeProvider = context.read<FlutterRecipeProvider>();

    List<Jtool> tools = getTools(scheduleProvider, productProvider, recipeProvider, enviromentId);

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
                    var ret = (await getCatalog()).map((AIModel model) {
                      return ListTile(
                        title: Text(model.name),
                        subtitle: Text(model.notes),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder(
                              stream: model.stateStream.stream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("...");
                                }
                                return buildToolBar(model, snapshot.data!, context, tools);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.my_library_books_rounded),
                              onPressed: () {
                                launchUrl(model.modelInfoUrl);
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList();

                    Future.delayed(Duration(seconds: 1)).then((_) async {
                      for (var e in (await getCatalog())) {
                        e.refreshStatus();
                      }
                    });

                    return ret;
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
                    physics: const NeverScrollableScrollPhysics(),
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
