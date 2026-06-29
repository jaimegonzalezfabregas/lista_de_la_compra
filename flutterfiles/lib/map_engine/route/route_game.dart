import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/flutter_providers/temp_route_provider.dart';
import 'package:lista_de_la_compra/map_engine/tiles/ground_tile.dart';
import 'package:lista_de_la_compra/map_engine/tiles/tile_type.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

const double kTileSize = 80.0;

class DotComponent extends SpriteComponent {
  bool active;

  DotComponent(int x, int y, this.active)
    : super(position: Vector2(x * kTileSize, y * kTileSize), size: Vector2.all(kTileSize), anchor: Anchor.topLeft, priority: 2);

  @override
  Future<void> onLoad() async {
    await _updateSprite();
  }

  Future<void> _updateSprite() async {
    sprite = await Sprite.load(active ? "floorTrailActive.png" : "floorTrailInactive.png");
  }

  void setActive(bool isActive) {
    if (active == isActive) return;
    active = isActive;
    _updateSprite();
  }
}

class RouteGame extends FlameGame {
  final List<MapTile> tiles;
  final Map<String, TileType> tileToTileType;
  final JRoute route;
  String? _nextAisle;
  final Map<String, DotComponent> _dotComponents = {};

  RouteGame(this.tiles, this.tileToTileType, this.route, String? nextAisle) : _nextAisle = nextAisle;

  void updateNextAisle(String? nextAisleId) {
    _nextAisle = nextAisleId;
    for (final entry in _dotComponents.entries) {
      final goals = route.getAisleIdFromTileInSegment(entry.key);
      entry.value.setActive(goals.contains(nextAisleId ?? "EXIT"));
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.center;

    for (final t in tiles) {
      List<String> goalOfTile = route.getAisleIdFromTileInSegment(t.id);
      if (goalOfTile.isNotEmpty) {
        final dot = DotComponent(t.posX, t.posY, goalOfTile.contains(_nextAisle ?? "EXIT"));
        _dotComponents[t.id] = dot;
        world.add(dot);
      }

      world.add(TileSpriteComponent(t.id, tileToTileType[t.id], t.posX, t.posY));
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
