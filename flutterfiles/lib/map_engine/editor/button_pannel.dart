import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/map_engine/tiles/tile_type.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';
import 'package:provider/provider.dart';

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _TypeButton({required this.label, required this.icon, required this.selected, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? effectiveColor.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(color: selected ? effectiveColor : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: effectiveColor),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: effectiveColor)),
          ],
        ),
      ),
    );
  }
}

class BottomPanel extends StatelessWidget {
  final String? selectedTileId;
  final void Function(String selectedTileId, TileType tileType) onSetType;
  final void Function(String selectedTileId) onDelete;
  final String supermarketId;
  final int floor;

  const BottomPanel({
    super.key,
    required this.selectedTileId,
    required this.supermarketId,
    required this.onSetType,
    required this.onDelete,
    required this.floor,
  });

  Future<TileType?> aisleChooseDialog(BuildContext context, AisleProvider aisleProvider, List<MapTile> tiles) async {
    final appLoc = AppLocalizations.of(context)!;
    final aisles = await aisleProvider.getAislesBySupermarket(supermarketId);
    final tileToFloorMap = {for (final t in tiles) t.id: t.floor};

    Aisle? assignedToSelected;
    try {
      assignedToSelected = aisles.firstWhere((a) => a.mapTileId == selectedTileId);
    } catch (_) {}

    final List<Aisle> unassigned = aisles.where((a) => a.mapTileId == null).toList();
    final List<Aisle> assignedElsewhere = aisles.where((a) => a.mapTileId != null && a.mapTileId != selectedTileId).toList();
    final List<Aisle> sorted = [...unassigned, ...assignedElsewhere];

    Completer c = Completer();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appLoc.assignAisle), // TODO Change this title to "Assign aisle to tile"
        content: aisles.isEmpty
            ? Text(appLoc.noAislesToAssign)
            : SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    if (assignedToSelected != null)
                      ListTile(
                        leading: const Icon(Icons.close),
                        title: Text("${appLoc.unassignAisle} ${assignedToSelected.name}"),
                        onTap: () async {
                          c.complete(null);
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ...sorted.map((aisle) {
                      final assignedFloor = aisle.mapTileId != null ? tileToFloorMap[aisle.mapTileId] : null;
                      return ListTile(
                        leading: Icon(aisle.mapTileId == selectedTileId ? Icons.radio_button_on : Icons.radio_button_off),
                        title: Text(aisle.name),
                        subtitle: assignedFloor != null
                            ? Text(appLoc.floorN(assignedFloor), style: TextStyle(color: Theme.of(context).disabledColor))
                            : null,
                        onTap: () async {
                          c.complete(aisle.id);
                          Navigator.of(ctx).pop();
                        },
                      );
                    }),
                  ],
                ),
              ),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(appLoc.cancel))],
      ),
    );

    return await c.future;
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    final AisleProvider aisleProvider = context.watch<FlutterAisleProvider>();
    final MapTileProvider mapTileProvider = context.watch<FlutterMapTileProvider>();

    Future<List<MapTile>> tiles = mapTileProvider.getMapOfMarket(supermarketId, floor);

    Widget tapTileMessage = Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        'Tap a tile to select it, or tap a ghost tile to add one', // TODO internationalize
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );

    if (selectedTileId == null) {
      return tapTileMessage;
    }

    Future<(MapTile, Aisle)?> mapTileFuture = mapTileProvider.getTileByIdJoinedAisle(selectedTileId!);

    return FutureBuilder(
      future: Future.wait([mapTileFuture, tiles]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Text(appLoc.loading, textAlign: TextAlign.center),
          );
        }

        if (snapshot.data == null) {
          return tapTileMessage;
        }

        final (MapTile, Aisle) tileInfo = snapshot.data![0] as (MapTile, Aisle);
        final MapTile selectedMapTile = tileInfo.$1;
        final Aisle aisle = tileInfo.$2;

        final List<MapTile> tileList = snapshot.data![1] as List<MapTile>;

        final currentType = tileTypeOf(selectedMapTile, aisle.id, aisle.name);

        final isLastStart = selectedMapTile.start && tileList.where((t) => t.start).length <= 1;
        final isLastEnd = selectedMapTile.end && tileList.where((t) => t.end).length <= 1;

        final String? lockedLabel = isLastStart
            ? appLoc.tileLockedLastOfType(appLoc.tileTypeStart.toLowerCase())
            : isLastEnd
            ? appLoc.tileLockedLastOfType(appLoc.tileTypeEnd.toLowerCase())
            : null;

        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('(${selectedMapTile.posX}, ${selectedMapTile.posY})', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 4),
              if (lockedLabel != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(lockedLabel, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _TypeButton(
                      label: appLoc.tileTypeFloor,
                      icon: Icons.square,
                      selected: currentType is TileFloor,
                      onTap: () => onSetType(selectedTileId!, TileFloor()),
                    ),
                    _TypeButton(
                      label: appLoc.tileTypeStart,
                      icon: Icons.door_sliding,
                      selected: currentType is TileStart,
                      color: const Color(0xFF4CAF50),
                      onTap: () => onSetType(selectedTileId!, TileStart()),
                    ),
                    _TypeButton(
                      label: appLoc.tileTypeEnd,
                      icon: Icons.exit_to_app,
                      selected: currentType is TileEnd,
                      color: const Color(0xFFF44336),
                      onTap: () => onSetType(selectedTileId!, TileEnd()),
                    ),
                    _TypeButton(
                      label: appLoc.assignAisle,
                      icon: Icons.shelves,
                      selected: currentType is TileAisle,
                      onTap: () async {
                        TileType? tileType = await aisleChooseDialog(context, aisleProvider, tileList);

                        if (tileType != null) {
                          onSetType(selectedTileId!, tileType);
                        }
                      },
                    ),
                    _TypeButton(
                      label: appLoc.delete,
                      icon: Icons.delete,
                      selected: false,
                      color: Theme.of(context).colorScheme.error,
                      onTap: () => onDelete(selectedTileId!),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
