import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistant_shared_preferences_provider.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

class Player extends SpriteComponent {
  Player({super.position}) :
    super(size: Vector2.all(200), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('floor.png');
  }
}

class MapPreviewWorld extends World {
  @override
  Future<void> onLoad() async {
    add(Player(position: Vector2(0, 0)));
  }
}

class MapPreview extends StatelessWidget {

  final String supermarketId;
  final int floor;


  const MapPreview( this.supermarketId, {super.key});

  @override
  Widget build(BuildContext context) {
    final MapTileProvider mapTileProvider = context.watch<MapTileProvider>();

    Future<List<MapTile>> future_map = mapTileProvider.getMapOfMarket(supermarketId, floor);
    

    return GameWidget(
      game: FlameGame(
        world: MapPreviewWorld()
      ),
    );
  }
}