import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

const double kTileSize = 80.0;

class GhostTile extends RectangleComponent with TapCallbacks {
  final VoidCallback onTap;

  GhostTile(int x, int y, {required this.onTap})
    : super(
        position: Vector2(x * kTileSize, y * kTileSize),
        size: Vector2.all(kTileSize),
        paint: Paint()
          ..color = const Color(0x33FFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

  @override
  void onTapDown(TapDownEvent event) => onTap();
}
