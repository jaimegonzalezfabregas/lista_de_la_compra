import 'package:collection/collection.dart';
import 'package:lista_de_la_compra/flutter_providers/temp_route_provider.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'dart:collection';
import 'dart:math';

class Node {
  final double heuristic;
  final List<Point> path;

  Node(this.heuristic, this.path);

  @override
  String toString() {
    String ret = "";

    for (Point p in path) {
      ret += "$p -> ";
    }

    return ret;
  }
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  double distance(Point other) {
    final dx = other.x - x;
    final dy = other.y - y;
    return sqrt(dx * dx + dy * dy);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Point && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() {
    return "($x, $y)";
  }
}

class GeometricMap {
  Map<Point, MapTile> board;
  GeometricMap(this.board);

  static GeometricMap fromTileList(List<MapTile> tiles) {
    Map<Point, MapTile> board = {};

    for (var tile in tiles) {
      board[Point(tile.posX, tile.posY)] = tile;
    }

    return GeometricMap(board);
  }

  List<MapTile>? pathFind(Point start, Point end) {

    Set<Point> visited = {};

    HeapPriorityQueue heap = HeapPriorityQueue<Node>((a, b) => a.heuristic.compareTo(b.heuristic));

    heap.add(Node(0, [start]));

    while (heap.isNotEmpty) {
      // print("heap size ${heap.length}, visited: ${visited}");
      Node exploring = heap.removeFirst();
      Point lastPos = exploring.path.last;

      for ((int, int) stepDelta in [(0, 1), (1, 0), (0, -1), (-1, 0)]) {
        int nextX = stepDelta.$1 + lastPos.x;
        int nextY = stepDelta.$2 + lastPos.y;
        Point nextPos = Point(nextX, nextY);

        if (board.containsKey(nextPos) && !visited.contains(nextPos)) {
          if (nextPos == end) {
            return exploring.path.map((point) => board[point]!).toList();
          }

          double heuristic = nextPos.distance(end);

          List<Point> path = [...exploring.path];

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
    ret.addAll((await productAisleProvider.getAisleOfProductInSupermarket(product.id, supermarketId)));
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

Future solverTick(RouteProvider routeProvider, AisleProvider aisleProvider, Map<int, GeometricMap> geometricFloor) async {
  if (posiblePaths.isEmpty) {
    print("Solving done");
    routeProvider.finishSearch();
    return;
  }

  (int, List<MapTile>) nextToTest = posiblePaths.removeLast();
  int floorToTest = nextToTest.$1;
  List<MapTile> pathToTest = nextToTest.$2;

  print("solving for permutation $pathToTest, in floor $floorToTest");

  GroceryRoute? routeToTest = await GroceryRoute.fromMapTileList(pathToTest, aisleProvider, geometricFloor[floorToTest]!);
  GroceryRoute? currentBestRoute = routeProvider.getBestRouteSoFar(floorToTest);

  if (routeToTest != null) {
    if (currentBestRoute == null) {
      routeProvider.setRoute(floorToTest, routeToTest);
    } else if (routeToTest.getLenght() < currentBestRoute.getLenght()) {
      routeProvider.setRoute(floorToTest, routeToTest);
    }
  }

  Future.sync(() => solverTick(routeProvider, aisleProvider, geometricFloor));
}

void calculateTileRoute(
  String marketId,
  RouteProvider routeProvider,
  MapTileProvider mapTileProvider,
  AisleProvider aisleProvider,
  Set<Aisle> visitingAisles,
) async {
  routeProvider.setProgress(0);

  Map<int, GeometricMap> floorToGeometricMap = {};

  print("Planning resolution");

  for (int floor in await mapTileProvider.getFloorsOfMarket(marketId)) {
    List<MapTile> map = await mapTileProvider.getMapOfMarket(marketId, floor);

    MapTile start = await mapTileProvider.findStart(marketId, floor);
    MapTile end = await mapTileProvider.findEnd(marketId, floor);

    List<MapTile?> visitingTiles = await Future.wait(visitingAisles.map((aisle) => mapTileProvider.getTileById(aisle.mapTileId!)));

    List<MapTile> visitingTilesOfThisFloor = visitingTiles.whereType<MapTile>().where((tile) => tile.floor == floor).toList();

    posiblePaths.addAll(permutations(visitingTilesOfThisFloor).map((permutation) => (floor, [start, ...permutation, end])).toList());
    initialPosiblePathsCount = posiblePaths.length;

    floorToGeometricMap[floor] = GeometricMap.fromTileList(map);
  }

  print("Starting solving");

  solverTick(routeProvider, aisleProvider, floorToGeometricMap);
}

void abortCalculateTileRoute(RouteProvider routeProvider) {
  routeProvider.clearRoute();
}
