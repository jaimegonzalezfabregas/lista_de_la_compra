import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/map_engine/editor/map_editor.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

import 'preview_game.dart';
import '../map_utils.dart';

export '../editor/map_editor.dart' show MapEditor;

class MapPreview extends StatefulWidget {
  final String supermarketId;

  const MapPreview(this.supermarketId, {super.key});

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  int floor = 0;

  void confirmDeleteFloor(MapTileProvider mapTileProvider, AisleProvider aisleProvider) {
    final appLoc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appLoc.deleteFloor),
        content: Text('${appLoc.deleteFloor} $floor?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(appLoc.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              aisleProvider.unlinkTiles((await mapTileProvider.getMapOfMarket(widget.supermarketId, floor)).map((tile) => tile.id).toList());

              mapTileProvider.deleteFloorTiles(widget.supermarketId, floor);

              setState(() => floor = 0);
            },
            child: Text(appLoc.delete, style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final MapTileProvider mapTileProvider = context.watch<FlutterMapTileProvider>();
    final AisleProvider aisleProvider = context.watch<FlutterAisleProvider>();

    return FutureBuilder(
      future: mapTileProvider.getFloorsOfMarket(widget.supermarketId),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(AppLocalizations.of(context)!.floorN(floor))]);
        }

        final floors = asyncSnapshot.data!.toList()..sort();

        if (floors.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(appLoc.noMapsHaveBeenCreatedForThisSupermarket),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_location_alt),
                  label: Text(appLoc.createMap),
                  onPressed: () => (int targetFloor) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MapEditor(widget.supermarketId, targetFloor)),
                    ).then((_) => setState(() {}));
                  }(0),
                ),
              ],
            ),
          );
        }

        if (!floors.contains(floor)) floor = floors.first;
        final nextFloor = floors.reduce(max) + 1;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...floors.map(
                  (f) => f == floor
                      ? ElevatedButton(child: Text('$f'), onPressed: () {})
                      : TextButton(child: Text('$f'), onPressed: () => setState(() => floor = f)),
                ), // TODO make the buttons easier to read
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(appLoc.newFloor),
                  onPressed: () => (int targetFloor) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MapEditor(widget.supermarketId, targetFloor)),
                    ).then((_) => setState(() {}));
                  }(nextFloor),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: mapTileProvider.getMapOfMarket(widget.supermarketId, floor),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) return Text(appLoc.loading);
                  if (snapshot.data!.isEmpty) return Text(appLoc.noMappingDataAviable);

                  return FutureBuilder(
                    future: buildTileToTypeMap(snapshot.data!, aisleProvider, widget.supermarketId),
                    builder: (context, aisleSnapshot) {
                      if (!aisleSnapshot.hasData || aisleSnapshot.data == null) return Text(appLoc.loading);

                      return GameWidget(game: PreviewGame(snapshot.data!, aisleSnapshot.data!));
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    label: Text(appLoc.editMap),
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => (int targetFloor) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MapEditor(widget.supermarketId, targetFloor)),
                      ).then((_) => setState(() {}));
                    }(floor),
                  ),
                  ElevatedButton.icon(
                    label: Text(appLoc.deleteFloor),
                    icon: const Icon(Icons.delete, size: 18),
                    onPressed: () => confirmDeleteFloor(mapTileProvider, aisleProvider),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
