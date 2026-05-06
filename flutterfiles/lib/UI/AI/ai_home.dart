import 'dart:async';

import 'package:fllama/fllama_universal.dart';
import 'package:fllama/misc/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'dart:convert';

import 'package:lista_de_la_compra/UI/AI/ai_chat.dart';

class AiHome extends StatelessWidget {
  const AiHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: Text("AI welcome")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Did you know AI is a thing? Any turing complete silicon chunk can talk lately?"),
            FutureBuilder(
              future: () async {
                final jsondata = await root_bundle.rootBundle.loadString("assets/ai_model_cataloge.json");
                final list = json.decode(jsondata) as List<dynamic>;
                return list
                    .map(
                      (e) => ListTile(
                        title: Text(e["name"]!),
                        subtitle: Text(e["notes"]!),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            IconButton(
                              onPressed: () async {
                              },
                              icon: Icon(Icons.info),
                            ),
                            IconButton(onPressed: () {}, icon: Icon(Icons.download)),
                            IconButton(onPressed: () {
                                Navigator.push(context,MaterialPageRoute(builder: (context) => AiChat(e["id"])));


                            }, icon: Icon(Icons.play_arrow)),
                          ],
                        ),
                      ),
                    )
                    .toList();
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
    );
  }
}
