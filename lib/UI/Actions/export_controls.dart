import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/enviroment_serializer.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/db_providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/db_providers/product_provider.dart';
import 'package:lista_de_la_compra/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra/db_providers/schedule_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class ExporControls extends StatelessWidget {
  String enviromentId;

  ExporControls(this.enviromentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    EnviromentProvider enviromentProvider = context.watch<FlutterEnviromentProvider>();
    ProductProvider productProvider = context.watch<FlutterProductProvider>();
    RecipeProvider recipeProvider = context.watch<FlutterRecipeProvider>();
    ScheduleProvider scheduleProvider = context.watch<FlutterScheduleProvider>();

    final Future serialized = serializeEnviroment(enviromentId, enviromentProvider, productProvider, recipeProvider, scheduleProvider);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final Future fileName = enviromentProvider
        .getEnviromentById(enviromentId)
        .then((Enviroment? env) => "${(env?.name) ?? appLoc.error}_${formatter.format(now)}_export.json");

    return Column(
      children: [
        OutlinedButton(
          onPressed: () async {
            FilePicker.platform.saveFile(
              dialogTitle: appLoc.saveFileToYourDesiredLocation,
              fileName: await fileName,
              bytes: utf8.encode(jsonEncode(await serialized)),
            );
          },
          child: Row(children: [Icon(Icons.download), SizedBox(width: 8), Text(appLoc.exportToFile)]),
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
          child: Row(children: [Icon(Icons.share), SizedBox(width: 8), Text(appLoc.sendExport)]),
        ),
      ],
    );
  }
}
