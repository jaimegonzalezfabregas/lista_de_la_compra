import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/map_engine/route/engine.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class RouteSegment {
  final String? goalAisleId;
  final List<String> tileIdPath;

  RouteSegment(this.goalAisleId, this.tileIdPath);

  static Future<RouteSegment?> fromStartEnd(String? goalAisleId, MapTile startStrech, MapTile endStrech, GeometricMap geometricFloor) async {
    List<MapTile>? path = geometricFloor.pathFind(Point(startStrech.posX, startStrech.posY), Point(endStrech.posX, endStrech.posY));

    if (path == null) {
      return null;
    }

    return RouteSegment(goalAisleId, path.map((tile) => tile.id).toList());
  }

  int getLenght() {
    return tileIdPath.length;
  }
}

class GroceryRoute {
  late final List<RouteSegment> steps;

  GroceryRoute(this.steps);

  static Future<GroceryRoute?> fromMapTileList(List<MapTile> points, AisleProvider aisleProvider, GeometricMap geometricFloor) async {
    List<RouteSegment> ret = [];

    for (var i = 0; i < points.length - 1; i++) {
      MapTile startStrech = points[i];
      MapTile endStrech = points[i + 1];

      print("looking for path from $startStrech to $endStrech");

      String? goalAisleId = (await aisleProvider.getAisleByTileId(endStrech.id))?.id;

      RouteSegment? route = await RouteSegment.fromStartEnd(goalAisleId, startStrech, endStrech, geometricFloor);

      if (route == null) {
        return null;
      }

      ret.add(route);
    }

    return GroceryRoute(ret);
  }

  int getLenght() {
    return steps.map((step) => step.getLenght()).reduce((a, b) => a + b);
  }

  bool trailAt(Point p){
    
  }

}

Map<int, GroceryRoute> globalRoute = {};

double? progress;

class RouteProvider with ChangeNotifier {
  void clearRoute() {
    progress = null;
    globalRoute = {};
    notifyListeners();
  }

  void setRoute(int floor, GroceryRoute route) {
    globalRoute[floor] = route;
    progress = 1;
    notifyListeners();
  }

  void setProgress(double p) {
    progress = p;
    notifyListeners();
  }

  GroceryRoute? getFinalRoute(int floor) {
    if (progress == 1) {
      return globalRoute[floor];
    }
    return null;
  }

  GroceryRoute? getBestRouteSoFar(int floor) {
    if (progress != 1) {
      return globalRoute[floor];
    }
    return null;
  }

  double? getProgress() {
    return progress;
  }

  void finishSearch() {
    progress = 1;
  }
}
