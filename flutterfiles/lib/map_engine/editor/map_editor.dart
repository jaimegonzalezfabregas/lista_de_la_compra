import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/map_engine/editor/button_pannel.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

import 'editor_game.dart';
import '../tiles/tile_type.dart';
import '../map_utils.dart';

class MapEditor extends StatefulWidget {
  final String supermarketId;
  final int floor;

  const MapEditor(this.supermarketId, this.floor, {super.key});

  @override
  State<MapEditor> createState() => _MapEditorState();
}

class _MapEditorState extends State<MapEditor> {
  late EditorGame _game;
  List<MapTile> _tiles = [];
  Map<String, TileType> tileToType = {};
  String? selectedId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _game = EditorGame(
      tiles: const [],
      tileToType: tileToType,
      onAddTile: addTile,
      onTileTap: (tileId) {
        setState(() => selectedId = tileId);
        _game.updateTiles(_tiles, tileToType, selectedId: tileId);
      },
    );
  }

  Future<void> loadTiles(MapTileProvider mapTileProvider, AisleProvider aisleProvider) async {
    var tiles = await mapTileProvider.getMapOfMarket(widget.supermarketId, widget.floor);
    if (tiles.isEmpty) {
      await mapTileProvider.addTile('', widget.supermarketId, 0, 0, widget.floor, true, false);
      await mapTileProvider.addTile('', widget.supermarketId, 0, 1, widget.floor, false, true);
      tiles = await mapTileProvider.getMapOfMarket(widget.supermarketId, widget.floor);
    }

    final Map<String, TileType> newTileToType = await buildTileToTypeMap(tiles, aisleProvider, widget.supermarketId);
    setState(() {
      _tiles = tiles;
      tileToType = newTileToType;
      _loading = false;
    });
    _game.updateTiles(tiles, tileToType, selectedId: selectedId);
  }

  Future<void> addTile(int x, int y) async {
    final provider = context.read<FlutterMapTileProvider>();
    String newTileId = await provider.addTile('', widget.supermarketId, x, y, widget.floor, false, false);
    setState(() => selectedId = newTileId);
  }

  Future<void> setTileTypeAndRelinkAisles(String tileId, TileType type, MapTileProvider mapTileProvider, AisleProvider aisleProvider) async {
    await mapTileProvider.updateTileType(tileId, start: type is TileStart, end: type is TileEnd);

    final aisles = await aisleProvider.getAislesBySupermarket(widget.supermarketId);

    await aisleProvider.unlinkTiles([tileId]);

    if (type is TileAisle) {
      aisleProvider.linkTile(type.aisleId, tileId);
    }
  }

  Future<void> deleteTileAndRelinkAisles(String tileId) async {
    final provider = context.read<FlutterMapTileProvider>();
    final aisleProvider = context.read<FlutterAisleProvider>();

    aisleProvider.unlinkTiles([tileId]);

    await provider.deleteById(tileId);
  }

  @override
  Widget build(BuildContext context) {
    MapTileProvider mapTileProvider = context.watch<FlutterMapTileProvider>();
    AisleProvider aisleProvider = context.watch<FlutterAisleProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) => loadTiles(mapTileProvider, aisleProvider));

    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${appLoc.editMap} - ${appLoc.floorN(widget.floor)}'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: GameWidget(game: _game)),
                BottomPanel(
                  supermarketId: widget.supermarketId,
                  floor: widget.floor,

                  selectedTileId: selectedId,
                  onSetType: (selectedId, tileType) {
                    setTileTypeAndRelinkAisles(selectedId, tileType, mapTileProvider, aisleProvider);
                  },
                  onDelete: (toDeleteId) {
                    deleteTileAndRelinkAisles(toDeleteId);
                    setState(() {
                      selectedId = null;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
