import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:jhopping_list/providers/enviroment_provider.dart';
import 'package:provider/provider.dart';

class EnviromentLoad extends StatelessWidget {
  const EnviromentLoad({super.key});

  @override
  Widget build(BuildContext context) {
    EnviromentProvider enviromentProvider = context.watch();
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: Text("Cargar Entorno")),
      body: ReaderWidget(
        onScan: (result) async {
          var payload = result.text;
          if (payload != null) {
            enviromentProvider.addEnviromentFromQR(payload);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
