import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/providers/product_provider.dart';
import 'package:lista_de_la_compra/providers/recipe_provider.dart';
import 'package:lista_de_la_compra/providers/schedule_provider.dart';

Future<Map<String, dynamic>> serializeEnviroment(String enviromentId, EnviromentProvider enviromentProvider, ProductProvider productProvider, RecipeProvider recipeProvider, ScheduleProvider scheduleProvider) async {
  Enviroment enviroment = (await enviromentProvider.getEnviromentById(enviromentId))!;

  return {
    "enviroment": enviroment,
    "products": await productProvider.getSyncProductList(enviromentId),
    "recipes": await recipeProvider.getSyncRecipeList(enviromentId),
    "products_recipies": await recipeProvider.getSyncRecipeProductList(enviromentId),
    "schedule": await scheduleProvider.getSyncEntryList(enviromentId),
  };
}
