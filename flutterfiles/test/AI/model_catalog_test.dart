import 'dart:async';

import 'package:fllama/fllama.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/fllama_inferer.dart';
import 'package:lista_de_la_compra/AI/model_catalog.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/AI/model_metadata.dart';

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

void main() {
  // Successful test for sum of array
  test('all models are able to call tools', () async {
   
    

    for (ModelMetadata meta in catalog) {
      print("Testing ${meta.name}");

      await meta.syncDownload();

      var tester = FllamaInferrer(await meta.getPath(), getTestTools());
      print("   Inferer created...");

      var resultStream = tester.inferResponse([
        Jmessage(Jrole.system, "You are a chat agent, able to call tools to retrieve information"),
        Jmessage(Jrole.user, "Where are we?"),
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
