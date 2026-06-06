import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/map_engine/tiles/ground_tile.dart';
import 'package:lista_de_la_compra/map_engine/tiles/tile_type.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

const double kTileSize = 80.0;

class PreviewGame extends FlameGame {
  final List<MapTile> tiles;
  final Map<String, TileType> tileToTileType;

  PreviewGame(this.tiles, this.tileToTileType);

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.center;

    for (final t in tiles) {
      world.add(TileSpriteComponent(t.id, tileToTileType[t.id]!, t.posX, t.posY));
    }

    final xs = tiles.map((t) => t.posX.toDouble());
    final ys = tiles.map((t) => t.posY.toDouble());
    final minX = xs.reduce(min);
    final maxX = xs.reduce(max);
    final minY = ys.reduce(min);
    final maxY = ys.reduce(max);

    camera.viewfinder.position = Vector2((minX + maxX) / 2 * kTileSize + kTileSize / 2, (minY + maxY) / 2 * kTileSize + kTileSize / 2);

    final tilesX = maxX - minX + 1;
    final tilesY = maxY - minY + 1;
    final displayTiles = max(tilesX, tilesY).clamp(7, double.infinity);
    final zoomX = size.x / (displayTiles * kTileSize);
    final zoomY = size.y / (displayTiles * kTileSize);
    camera.viewfinder.zoom = min(zoomX, zoomY).clamp(0.1, 5.0);
  }
}
