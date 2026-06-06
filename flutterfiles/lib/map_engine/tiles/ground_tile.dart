import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/map_engine/tiles/tile_type.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

const double kTileSize = 80.0;

class TileSpriteComponent extends SpriteComponent with TapCallbacks {
  final String tileId;
  final TileType tileType;
  final int tileX;
  final int tileY;
  final void Function(String)? onTap;
  bool isSelected;

  TileSpriteComponent(this.tileId, this.tileType, this.tileX, this.tileY, {this.onTap, this.isSelected = false})
    : super(
        position: Vector2(tileX * kTileSize, tileY * kTileSize),
        size: Vector2.all(kTileSize),
        anchor: Anchor.topLeft,
        priority: isSelected ? 1 : 0,
      );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(tileType.getAsset());

    if (tileType is TileAisle) {
      add(
        TextComponent(
          text: (tileType as TileAisle).aisleName,
          textRenderer: TextPaint(style: const TextStyle(fontSize: 10, color: Colors.white)),
          anchor: Anchor.center,
          position: Vector2(kTileSize / 2, kTileSize / 2),
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (isSelected) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, kTileSize, kTileSize),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap?.call(tileId);
  }
}
