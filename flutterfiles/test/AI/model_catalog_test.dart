import 'dart:async';
import 'dart:convert';

import 'package:fllama/fllama.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'package:flutter_test/flutter_test.dart' hide test;
import 'package:lista_de_la_compra/AI/AI_Inferers/fllama_inferer.dart';
import 'package:lista_de_la_compra/AI/model_catalog.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';

import 'package:test/test.dart';

List<Jtool> getTestTools() {
  return [
    Jtool(
      name: "GetGeoLocation",
      description: "This tool provides information about the location of the user in real time",
      jsonSchema: '''
{
  "type": "object",
  "properties": {}
}
''',
      tool: (_) {
        return "You are in Moscow";
      },
    ),
  ];
}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Successful test for sum of array
  test('all models are able to call tools', () async {
    final jsondata = await root_bundle.rootBundle.loadString("assets/ai_model_cataloge.json");
    final list = json.decode(jsondata) as List<dynamic>;

    for (var e in list) {
      ModelMetadata meta = ModelMetadata(e);
      print("Testing ${meta.name}");

      meta.startDownload();
      print("   Waiting for download...");

      await meta.waitUntilDownloaded();
      print("   Download done...");

      var tester = FllamaInferer(await meta.getPath(), getTestTools());
      print("   Inferer created...");

      var resultStream = tester.inferResponse([
        Message(Role.system, "You are a chat agent, able to call tools to retrieve information"),
        Message(Role.user, "Where are we?"),
      ]);

      Completer c = Completer();

      resultStream.listen((event) {
        if (event is InferenceEnd) {
          print("   simulation was: ${event.conversation}");

          c.complete(event);
        }
      });
      print("   Waiting for inference...");

      InferenceEnd endState = await c.future;

      assert(endState.conversation.last.role == Role.assistant);
      assert(endState.conversation.last.text.contains("Moscow"));
    }
  }, timeout: Timeout(Duration(hours: 1)));
}
