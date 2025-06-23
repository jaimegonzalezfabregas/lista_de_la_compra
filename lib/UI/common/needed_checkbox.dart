import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:provider/provider.dart';

final Duration undoDuration = const Duration(seconds: 2);

class UndoToast extends StatefulWidget {
  final String productId;
  final bool oldNeededness;
  final FToast fToast;

  const UndoToast(this.productId, this.oldNeededness, this.fToast, {super.key});

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
    ProductProvider productProvider = context.watch();

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
          if (widget.oldNeededness) Text(appLoc.markAsNeeded) else Text(appLoc.markAsBought),
          TextButton(
            onPressed: () {
              productProvider.setProductNeededness(widget.productId, widget.oldNeededness);
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
              // colors: [Colors.red, Colors.green],
              colors: [Theme.of(context).colorScheme.surfaceContainerHighest, Theme.of(context).colorScheme.surfaceContainerHigh],
            ),
          ),
          child: child,
        );
      },
    );
  }
}

Future<void> showUndoToast(FToast fToast, String productId, bool oldNeededness) async {
  fToast.removeCustomToast();
  fToast.removeQueuedCustomToasts();

  fToast.showToast(
    child: UndoToast(productId, oldNeededness, fToast), 
  gravity: ToastGravity.TOP, 
  toastDuration: undoDuration
  
  );
}

class NeededCheckbox extends StatefulWidget {
  final String productId;
  final Duration? delay;

  const NeededCheckbox(this.productId, {super.key, this.delay});

  @override
  State<NeededCheckbox> createState() => _NeededCheckboxState();
}

class _NeededCheckboxState extends State<NeededCheckbox> {
  bool? displayedValue;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    final FToast fToast = FToast();

    fToast.init(context);

    ProductProvider productProvider = context.watch();

    return SizedBox(
      child: FutureBuilder(
        future: productProvider.getProductById(widget.productId),
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Text(appLoc.loading);
          }

          Product p = asyncSnapshot.data!;

          return Row(
            children: [
              if (!(displayedValue ?? p.needed)) Text(appLoc.toBuy),

              Checkbox(
                value: displayedValue ?? p.needed,
                onChanged: (bool? x) async {
                  setState(() {
                    displayedValue = x!;
                  });

                  final Duration? delay = this.widget.delay;
                  if (delay != null) {
                    await Future.delayed(delay);
                  }
                  productProvider.setProductNeededness(p.id, x!);
                  showUndoToast(fToast, p.id, !x);
                  displayedValue = null;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
