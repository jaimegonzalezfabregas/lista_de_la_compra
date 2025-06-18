import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/enviroment_serializer.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:lista_de_la_compra/providers/recipe_provider.dart';
import 'package:lista_de_la_compra/providers/schedule_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class ExportView extends StatelessWidget {
  String enviromentId;

  ExportView(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    EnviromentProvider enviromentProvider = context.watch();
    ProductProvider productProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();
    ScheduleProvider scheduleProvider = context.watch();

    final Future serialized = serializeEnviroment(enviromentId, enviromentProvider, productProvider, recipeProvider, scheduleProvider);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final Future fileName = enviromentProvider
        .getEnviromentById(enviromentId)
        .then((Enviroment? env) => "${(env?.name) ?? appLoc.error}_${formatter.format(now)}_export.json");

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.exportEnviroment, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () async {
                FilePicker.platform.saveFile(
                  dialogTitle: appLoc.saveFileToYourDesiredLocation,
                  fileName: await fileName,
                  bytes: utf8.encode(jsonEncode(await serialized)),
                );
              },
              child: Text(appLoc.downloadToFile),
            ),
            OutlinedButton(
              onPressed: () async {
                await SharePlus.instance.share(
                  ShareParams(
                    files: [
                      XFile.fromData(
                        utf8.encode(jsonEncode(await serialized)),
                        // name: fileName, // Notice, how setting the name here does not work.
                        mimeType: 'text/plain',
                      ),
                    ],
                    fileNameOverrides: [await fileName],
                    downloadFallbackEnabled: true,
                  ),
                );
              },
              child: Text(appLoc.send),
            ),
          ],
        ),
      ),
    );
  }
}
