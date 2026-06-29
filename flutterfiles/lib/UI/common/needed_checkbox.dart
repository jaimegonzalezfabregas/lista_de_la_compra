import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../flutter_providers/flutter_providers.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

final Duration undoDuration = const Duration(seconds: 2);

class UndoToast extends StatefulWidget {
  final String productId;
  final String houseId;
  final bool oldNeededness;
  final FToast fToast;

  const UndoToast(this.productId, this.houseId, this.oldNeededness, this.fToast, {super.key});

  @override
  State<UndoToast> createState() => _UndoToastState();
}

class _UndoToastState extends State<UndoToast> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: undoDuration, vsync: this)..forward();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLoc = AppLocalizations.of(context)!;
    ProductProvider productProvider = context.watch<FlutterProductProvider>();
    NeededProductProvider neededProductProvider = context.watch<FlutterNeededProductProvider>();

    return AnimatedBuilder(
      animation: _controller,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FutureBuilder(
            future: productProvider.getProductById(widget.productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name);
              }
              return Text(appLoc.product);
            },
          ),
          if (widget.oldNeededness) Text(appLoc.markAsBought) else Text(appLoc.markAsNeeded),
          TextButton(
            onPressed: () {
              neededProductProvider.setNeeded(widget.houseId, widget.productId, widget.oldNeededness);
              widget.fToast.removeCustomToast();
            },
            child: Text(appLoc.undo),
          ),
        ],
      ),
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            gradient: LinearGradient(
              stops: [_controller.value, _controller.value],
              colors: [Theme.of(context).colorScheme.surfaceContainerHighest, Theme.of(context).colorScheme.surfaceContainerHigh],
            ),
          ),
          child: child,
        );
      },
    );
  }
}

Future<void> showUndoToast(FToast fToast, String productId, String houseId, bool wasNeeded) async {
  fToast.removeCustomToast();
  fToast.removeQueuedCustomToasts();

  fToast.showToast(child: UndoToast(productId, houseId, wasNeeded, fToast), gravity: ToastGravity.TOP, toastDuration: undoDuration);
}

class NeededCheckbox extends StatefulWidget {
  final String productId;
  final String houseId;
  final Duration? delay;

  const NeededCheckbox({super.key, required this.productId, required this.houseId, this.delay});

  @override
  State<NeededCheckbox> createState() => _NeededCheckboxState();
}

class _NeededCheckboxState extends State<NeededCheckbox> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    final FToast fToast = FToast();
    fToast.init(context);

    NeededProductProvider neededProductProvider = context.watch<FlutterNeededProductProvider>();
    HouseProvider houseProvider = context.watch<FlutterHouseProvider>();

    Future combined = Future.wait([neededProductProvider.isNeeded(widget.houseId, widget.productId), houseProvider.getHouseById(widget.houseId)]);

    return FutureBuilder(
      future: combined,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(appLoc.loading);
        }

        final List<dynamic> combinedResult = snapshot.data!;

        final bool isNeeded = combinedResult[0] ?? false;
        final House house = combinedResult[1];
        final Color checkboxColor = Color(house.color);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNeeded) Text(appLoc.toBuy, style: TextStyle(color: checkboxColor)),

            Checkbox(
              value: isNeeded,
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) return checkboxColor;
                return checkboxColor.withValues(alpha: 0.3);
              }),
              onChanged: (bool? value) async {
                final Duration? delay = widget.delay;
                if (delay != null) {
                  await Future.delayed(delay);
                }

                neededProductProvider.setNeeded(widget.houseId, widget.productId, value ?? false);
                showUndoToast(fToast, widget.productId, widget.houseId, !(value ?? false));
              },
            ),
          ],
        );
      },
    );
  }
}
