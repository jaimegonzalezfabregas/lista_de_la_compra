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
        }
      }

      for ((int, int) stepDelta in [(-1, -1), (-1, 1), (1, -1), (1, 1)]) {
        int nextX = stepDelta.$1 + lastPos.x;
        int nextY = stepDelta.$2 + lastPos.y;
        JPoint nextPos = JPoint(nextX, nextY);

        if (board.containsKey(nextPos) && !visited.contains(nextPos)) {
          if (!board.containsKey(JPoint(lastPos.x + stepDelta.$1, lastPos.y)) || !board.containsKey(JPoint(lastPos.x, lastPos.y + stepDelta.$2))) {
            continue;
          }

          if (nextPos == end) {
            return exploring.path.map((point) => board[point]!).toList();
          }

          double heuristic = nextPos.distance(end);

          List<JPoint> path = [...exploring.path];

          path.add(nextPos);

          heap.add(Node(heuristic, path));
        }
      }
      visited.add(lastPos);
    }

    return null;
  }
}

Future<Set<Aisle>> getPendingVisitAsileIds(
  ProductProvider productProvider,
  ProductAisleProvider productAisleProvider,
  NeededProductProvider neededProductProvider,
  SelectedHousesProvider houseProvider,
  String supermarketId,
  String enviromentId,
) async {
  List<Product> allProducts = await productProvider.getDisplayProductList(enviromentId);
  List<String> selectedHouses = await houseProvider.getSelectedHouses(enviromentId);

  Set<String> neededProductIds = await neededProductProvider.getNeededProductIds(enviromentId, selectedHouses);

  Set<Aisle> ret = {};

  for (Product product in allProducts) {
    if (neededProductIds.contains(product.id)) {
      ret.addAll((await productAisleProvider.getAisleOfProductInSupermarket(product.id, supermarketId)));
    }
  }

  return ret;
}

// --- Genetic algorithm constants ---
const int populationSizeFactor = 15;
const double mutationRate = 0.15;

// --- GA control flag (set false to abort) ---
bool geneticRunning = false;

class Individual {
  final List<MapTile> path;
  final double fitness;

  Individual(this.path, this.fitness);
}

// --- Build a distance matrix between all relevant tiles for fast evaluation ---
Map<(String, String), int> buildDistanceMatrix(GeometricMap geoMap, List<MapTile> tiles) {
  Map<(String, String), int> distances = {};
  for (int i = 0; i < tiles.length; i++) {
    for (int j = i + 1; j < tiles.length; j++) {
      final path = geoMap.pathFind(JPoint(tiles[i].posX, tiles[i].posY), JPoint(tiles[j].posX, tiles[j].posY));
      final dist = path?.length ?? 999999;
      distances[(tiles[i].id, tiles[j].id)] = dist;
      distances[(tiles[j].id, tiles[i].id)] = dist;
    }
  }
  for (var tile in tiles) {
    distances[(tile.id, tile.id)] = 0;
  }
  return distances;
}

// --- Fitness: total path length for a full path (start … aisles … end) ---
double evaluateFitness(List<MapTile> fullPath, Map<(String, String), int> distMatrix) {
  int total = 0;
  for (int i = 0; i < fullPath.length - 1; i++) {
    total += distMatrix[(fullPath[i].id, fullPath[i + 1].id)] ?? 999999;
  }
  return total.toDouble();
}

// --- Create initial random population ---
List<Individual> createInitialPopulation(
  List<MapTile> visitingTiles,
  int populationSize,
  MapTile start,
  MapTile end,
  Map<(String, String), int> distMatrix,
) {
  List<Individual> pop = [];
  for (int i = 0; i < populationSize; i++) {
    List<MapTile> path = List.from(visitingTiles);
    path.shuffle();
    pop.add(Individual(path, evaluateFitness([start, ...path, end], distMatrix)));
  }
  return pop;
}

// --- Create initial random population ---
void mutate(List<MapTile> individual) {
  Random rng = Random();
  for (int i = 0; i < individual.length; i++) {
    if (rng.nextDouble() < mutationRate) {
      int j = rng.nextInt(individual.length);
      MapTile temp = individual[i];
      individual[i] = individual[j];
      individual[j] = temp;
    }
  }
}

// --- Run GA for a single floor ---
Future<void> runGAForFloor(
  int floor,
  List<MapTile> visitingTiles,
  MapTile start,
  MapTile end,
  GeometricMap geoMap,
  AisleProvider aisleProvider,
  RouteProvider routeProvider,
  String marketId,
) async {
  List<MapTile> allTiles = [start, ...visitingTiles, end];
  var distMatrix = buildDistanceMatrix(geoMap, allTiles);

  int populationSize = visitingTiles.length * populationSizeFactor;

  // Initial random population
  List<Individual> pop = createInitialPopulation(visitingTiles, populationSize, start, end, distMatrix);

  // Find the best from initial random pool
  Individual best = pop[0];
  for (int i = 1; i < pop.length; i++) {
    if (pop[i].fitness < best.fitness) best = pop[i];
  }

  int staleCount = 0;

  while (true) {
    JRoute? route = await JRoute.fromMapTileList([start, ...best.path, end], aisleProvider, geoMap);
    if (route != null) routeProvider.setRoute(floor, marketId, route);
    if (staleCount >= 3) break;

    if (!geneticRunning) break;

    List<Individual> newPop = [];

    for (int i = 0; i < populationSize; i++) {
      List<MapTile> child = List.from(best.path);
      mutate(child);
      newPop.add(Individual(child, evaluateFitness([start, ...child, end], distMatrix)));
    }

    pop = newPop;

    bool improved = false;
    for (int i = 0; i < pop.length; i++) {
      if (pop[i].fitness < best.fitness) {
        best = pop[i];
        improved = true;
      }
    }

    if (improved) {
      staleCount = 0;
    } else {
      staleCount++;
    }

    routeProvider.setProgress(marketId, routeProvider.getProgress(marketId) ?? 0);
    await Future.delayed(Duration.zero);
  }
}

void calculateTileRoute(
  String marketId,
  RouteProvider routeProvider,
  MapTileProvider mapTileProvider,
  AisleProvider aisleProvider,
  Set<Aisle> visitingAisles,
) async {
  geneticRunning = true;
  routeProvider.setProgress(marketId, 0);

  Set<int> floors = await mapTileProvider.getFloorsOfMarket(marketId);
  if (floors.isEmpty) {
    routeProvider.finishSearch(marketId);
    geneticRunning = false;
    return;
  }

  int totalFloors = floors.length;
  int completedFloors = 0;

  for (int floor in floors) {
    if (!geneticRunning) break;

    List<MapTile> map = await mapTileProvider.getMapOfMarket(marketId, floor);
    MapTile start = await mapTileProvider.findStart(marketId, floor);
    MapTile end = await mapTileProvider.findEnd(marketId, floor);

    List<MapTile?> visitingTiles = await Future.wait(
      visitingAisles.map((aisle) async {
        if (aisle.mapTileId != null) {
          return mapTileProvider.getTileById(aisle.mapTileId!);
        }
        return null;
      }),
    );

    List<MapTile> visiting = visitingTiles.whereType<MapTile>().where((tile) => tile.floor == floor).toList();

    GeometricMap geoMap = GeometricMap.fromTileList(map);

    if (visiting.isEmpty) {
      JRoute? route = await JRoute.fromMapTileList([start, end], aisleProvider, geoMap);
      if (route != null) {
        routeProvider.setRoute(floor, marketId, route);
      }
    } else {
      routeProvider.setProgress(marketId, completedFloors / totalFloors);
      await runGAForFloor(floor, visiting, start, end, geoMap, aisleProvider, routeProvider, marketId);
    }

    completedFloors += 1;
    routeProvider.setProgress(marketId, completedFloors / totalFloors);
  }

  if (geneticRunning) {
    routeProvider.finishSearch(marketId);
  }
  geneticRunning = false;
}

void abortCalculateTileRoute(RouteProvider routeProvider, String marketId) {
  geneticRunning = false;
  routeProvider.clearRoute(marketId);
}
