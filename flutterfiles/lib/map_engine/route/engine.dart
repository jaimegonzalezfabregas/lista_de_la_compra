import 'package:collection/collection.dart';
import 'package:lista_de_la_compra/flutter_providers/temp_route_provider.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'dart:math';

class Node {
  final double heuristic;
  final List<JPoint> path;

  Node(this.heuristic, this.path);

  @override
  String toString() {
    String ret = "";

    for (JPoint p in path) {
      ret += "$p -> ";
    }

    return ret;
  }
}

class JPoint {
  final int x;
  final int y;

  JPoint(this.x, this.y);

  double distance(JPoint other) {
    final dx = other.x - x;
    final dy = other.y - y;
    return sqrt(dx * dx + dy * dy);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JPoint && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() {
    return "($x, $y)";
  }
}

class GeometricMap {
  Map<JPoint, MapTile> board;
  GeometricMap(this.board);

  static GeometricMap fromTileList(List<MapTile> tiles) {
    Map<JPoint, MapTile> board = {};

    for (var tile in tiles) {
      board[JPoint(tile.posX, tile.posY)] = tile;
    }

    return GeometricMap(board);
  }

  List<MapTile>? pathFind(JPoint start, JPoint end) {
    Set<JPoint> visited = {};

    HeapPriorityQueue heap = HeapPriorityQueue<Node>((a, b) => a.heuristic.compareTo(b.heuristic));

    heap.add(Node(0, [start]));

    while (heap.isNotEmpty) {
      // print("heap size ${heap.length}, visited: ${visited}");
      Node exploring = heap.removeFirst();
      JPoint lastPos = exploring.path.last;

      for ((int, int) stepDelta in [(0, 1), (1, 0), (0, -1), (-1, 0)]) {
        int nextX = stepDelta.$1 + lastPos.x;
        int nextY = stepDelta.$2 + lastPos.y;
        JPoint nextPos = JPoint(nextX, nextY);

        if (board.containsKey(nextPos) && !visited.contains(nextPos)) {
          if (nextPos == end) {
            return exploring.path.map((point) => board[point]!).toList();
          }

          double heuristic = nextPos.distance(end);

          List<JPoint> path = [...exploring.path];

          path.add(nextPos);

          heap.add(Node(heuristic, path));
        } else {}
      }
      visited.add(lastPos);
    }

    return null;
  }
}

Future<Set<Aisle>> getPendingVisitAsileIds(
  ProductProvider productProvider,
  ProductAisleProvider productAisleProvider,
  String supermarketId,
  String enviromentId,
) async {
  List<Product> neededProducts = await productProvider.getDisplayProductList(enviromentId);

  Set<Aisle> ret = {};

  for (Product product in neededProducts) {
    if (product.needed) {
      ret.addAll((await productAisleProvider.getAisleOfProductInSupermarket(product.id, supermarketId)));
    }
  }

  return ret;
}

int initialPosiblePathsCount = 0;
List<(int, List<MapTile>)> posiblePaths = [];

List<List<T>> permutations<T>(List<T> items) {
  final result = <List<T>>[];

  void backtrack(int start) {
    if (start == items.length) {
      result.add(List<T>.from(items));
      return;
    }

    for (int i = start; i < items.length; i++) {
      // Swap
      final temp = items[start];
      items[start] = items[i];
      items[i] = temp;

      backtrack(start + 1);

      // Swap back
      items[i] = items[start];
      items[start] = temp;
    }
  }

  backtrack(0);
  return result;
}

Future solverTick(RouteProvider routeProvider, AisleProvider aisleProvider, Map<int, GeometricMap> geometricFloor, String marketId) async {
  if (posiblePaths.isEmpty) {
    routeProvider.finishSearch(marketId);
    return;
  }

  (int, List<MapTile>) nextToTest = posiblePaths.removeLast();
  int floorToTest = nextToTest.$1;
  List<MapTile> pathToTest = nextToTest.$2;

  JRoute? routeToTest = await JRoute.fromMapTileList(pathToTest, aisleProvider, geometricFloor[floorToTest]!);

  JRoute? currentBestRoute = routeProvider.getBestRouteSoFar(marketId)?[floorToTest];

  if (routeToTest != null) {
    if (currentBestRoute == null) {
      print("first route was found of lenght ${routeToTest.getLenght()} with order ${nextToTest}");

      routeProvider.setRoute(floorToTest, marketId, routeToTest);
    } else if (routeToTest.getLenght() < currentBestRoute.getLenght()) {
      print("a better route was found of lenght ${routeToTest.getLenght()} with order ${nextToTest}");
      routeProvider.setRoute(floorToTest, marketId, routeToTest);
    }
  }

  routeProvider.setProgress(marketId, 1 - posiblePaths.length / initialPosiblePathsCount);

  Future.sync(() => solverTick(routeProvider, aisleProvider, geometricFloor, marketId));
}

void calculateTileRoute(
  String marketId,
  RouteProvider routeProvider,
  MapTileProvider mapTileProvider,
  AisleProvider aisleProvider,
  Set<Aisle> visitingAisles,
) async {
  routeProvider.setProgress(marketId, 0);

  Map<int, GeometricMap> floorToGeometricMap = {};

  for (int floor in await mapTileProvider.getFloorsOfMarket(marketId)) {
    List<MapTile> map = await mapTileProvider.getMapOfMarket(marketId, floor);

    MapTile start = await mapTileProvider.findStart(marketId, floor);
    MapTile end = await mapTileProvider.findEnd(marketId, floor);

    List<MapTile?> visitingTiles = await Future.wait(
      visitingAisles.map((aisle) async {
        if (aisle.mapTileId != null) {
          return mapTileProvider.getTileById(aisle.mapTileId!);
        } else {
          return null;
        }
      }),
    );

    List<MapTile> visitingTilesOfThisFloor = visitingTiles.whereType<MapTile>().where((tile) => tile.floor == floor).toList();

  var p = permutations(visitingTilesOfThisFloor);
p.shuffle();

    posiblePaths.addAll(p.map((permutation) => (floor, [start, ...permutation, end])).toList());
    initialPosiblePathsCount = posiblePaths.length;

    floorToGeometricMap[floor] = GeometricMap.fromTileList(map);
  }

  solverTick(routeProvider, aisleProvider, floorToGeometricMap, marketId);
}

void abortCalculateTileRoute(RouteProvider routeProvider, String marketId) {
  routeProvider.clearRoute(marketId);
  posiblePaths = [];
  initialPosiblePathsCount = 0;
}
