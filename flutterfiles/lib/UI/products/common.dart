import 'package:flutter/material.dart';

import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

Widget getNeededAmount(ScheduleProvider scheduleProvider, String productId, List<String> houseIds, BuildContext context) {
  final appLoc = AppLocalizations.of(context)!;
  var amountFuture = scheduleProvider.getFutureRecipesWithProduct(productId, houseIds);
  return FutureBuilder(
    future: amountFuture,
    builder: (ctx, amountSnapshot) {
      if (!amountSnapshot.hasData) {
        return Text(appLoc.loading);
      }

      List<RecipeProduct> recipes = amountSnapshot.data!;

      if (recipes.isEmpty) {
        return SizedBox.shrink();
      }

      var amounts = recipes.map((recipe) => recipe.amount).join(" + ");

      return Text(amounts);
    },
  );
}
