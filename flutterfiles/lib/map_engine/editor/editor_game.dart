import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/map_engine/tiles/ghost_tile.dart';
import 'package:lista_de_la_compra/map_engine/tiles/ground_tile.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

import '../tiles/tile_type.dart';

const double kTileSize = 80.0;

class EditorGame extends FlameGame with DragCallbacks, TapCallbacks {
  List<MapTile> tiles;
  Map<String, TileType> tileToType;
  final void Function(int x, int y) onAddTile;
  final void Function(String) onTileTap;
  String? selectedId;

  final Set<(int, int)> positions = {};

  EditorGame({required this.tiles, required this.tileToType, required this.onAddTile, required this.onTileTap, this.selectedId});

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.center;
    _rebuildComponents();
    _centerCamera();
  }

  void _centerCamera() {
    if (positions.isEmpty) return;
    final xs = positions.map((p) => p.$1.toDouble());
    final ys = positions.map((p) => p.$2.toDouble());
    final minX = xs.reduce(min);
    final maxX = xs.reduce(max);
    final minY = ys.reduce(min);
    final maxY = ys.reduce(max);

    camera.viewfinder.position = Vector2((minX + maxX) / 2 * kTileSize + kTileSize / 2, (minY + maxY) / 2 * kTileSize + kTileSize / 2);

    final tilesX = maxX - minX + 1;
    final tilesY = maxY - minY + 1;
    // Show at least 7 tiles along the smallest axis
    final displayTiles = max(tilesX, tilesY).clamp(7, double.infinity);
    final zoomX = size.x / (displayTiles * kTileSize);
    final zoomY = size.y / (displayTiles * kTileSize);
    camera.viewfinder.zoom = min(zoomX, zoomY).clamp(0.2, 5.0);
  }

  void _rebuildComponents() {
    world.removeAll(world.children.toList());
    positions.clear();
    for (final t in tiles) {
      positions.add((t.posX, t.posY));
      world.add(TileSpriteComponent(t.id, tileToType[t.id]!, t.posX, t.posY, onTap: onTileTap, isSelected: t.id == selectedId));
    }

    final ghosts = <(int, int)>{};
    for (final pos in positions) {
      for (final d in [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
        final n = (pos.$1 + d.$1, pos.$2 + d.$2);
        if (!positions.contains(n)) ghosts.add(n);
      }
    }
    for (final g in ghosts) {
      world.add(GhostTile(g.$1, g.$2, onTap: () => onAddTile(g.$1, g.$2)));
    }
  }

  void updateTiles(List<MapTile> newTiles, Map<String, TileType> newtileToType, {String? selectedId}) {
    tiles = newTiles;
    tileToType = newtileToType;
    if (selectedId != null) this.selectedId = selectedId;
    _rebuildComponents();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    camera.viewfinder.position -= event.localDelta / camera.viewfinder.zoom;
  }
}
