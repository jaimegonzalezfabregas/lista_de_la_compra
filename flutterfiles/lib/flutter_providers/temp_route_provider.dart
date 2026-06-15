import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/map_engine/route/engine.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class RouteSegment {
  final String? goalAisleId;
  final List<String> tileIdPath;

  RouteSegment(this.goalAisleId, this.tileIdPath);

  static Future<RouteSegment?> fromStartEnd(String? goalAisleId, MapTile startStrech, MapTile endStrech, GeometricMap geometricFloor) async {
    List<MapTile>? path = geometricFloor.pathFind(JPoint(startStrech.posX, startStrech.posY), JPoint(endStrech.posX, endStrech.posY));

    if (path == null) {
      return null;
    }

    return RouteSegment(goalAisleId, path.map((tile) => tile.id).toList());
  }

  int getLenght() {
    return tileIdPath.length;
  }
}

class JRoute {
  late final List<RouteSegment> steps;

  JRoute(this.steps);

  static Future<JRoute?> fromMapTileList(List<MapTile> points, AisleProvider aisleProvider, GeometricMap geometricFloor) async {
    List<RouteSegment> ret = [];

    for (var i = 0; i < points.length - 1; i++) {
      MapTile startStrech = points[i];
      MapTile endStrech = points[i + 1];

      String? goalAisleId = (await aisleProvider.getAisleByTileId(endStrech.id))?.id;

      RouteSegment? route = await RouteSegment.fromStartEnd(goalAisleId, startStrech, endStrech, geometricFloor);

      if (route == null) {
        return null;
      }

      ret.add(route);
    }

    return JRoute(ret);
  }

  int getLenght() {
    return steps.map((step) => step.getLenght()).reduce((a, b) => a + b);
  }

  List<String> getAisleIdFromTileInSegment(String tileId) {
    List<String> ret = [];

    for (RouteSegment rs in steps) {
      if (rs.tileIdPath.sublist(1).contains(tileId)) {
        ret.add(rs.goalAisleId ?? "EXIT");
      }
    }
    return ret;
  }
}

Map<String, Map<int, JRoute>> globalRoute = {};
Map<String, double> progress = {};

class RouteProvider with ChangeNotifier {
  void clearRoute(String marketId) {
    progress.remove(marketId);
    globalRoute[marketId] = {};
    notifyListeners();
  }

  void setRoute(int floor, String marketId, JRoute route) {
    if(globalRoute[marketId] == null){
      globalRoute[marketId] = {};
    }
    globalRoute[marketId]?[floor] = route;
    notifyListeners();
  }

  void setProgress(String marketId, double p) {
    progress[marketId] = p;
    notifyListeners();
  }

  Map<int, JRoute>? getFinalRoute(String marketId) {
    if (progress[marketId] == 1) {
      return globalRoute[marketId];
    }
    return null;
  }

  Map<int, JRoute>? getBestRouteSoFar(String marketId) {
      return globalRoute[marketId];
   
  }

  double? getProgress(String marketId) {
    return progress[marketId];
  }

  void finishSearch(String marketId) {
    progress[marketId] = 1;
  }
}
