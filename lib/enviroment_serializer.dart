import 'package:lista_de_la_compra/db/database.dart';
import 'package:lista_de_la_compra/db_providers/enviroment_provider.dart';
import 'package:lista_de_la_compra/db_providers/product_provider.dart';
import 'package:lista_de_la_compra/db_providers/recipe_provider.dart';
import 'package:lista_de_la_compra/db_providers/schedule_provider.dart';

Future<Map<String, dynamic>> serializeEnviroment(
  String enviromentId,
  EnviromentProvider enviromentProvider,
  ProductProvider productProvider,
  RecipeProvider recipeProvider,
  ScheduleProvider scheduleProvider,
) async {
  Enviroment enviroment = (await enviromentProvider.getEnviromentById(enviromentId))!;

  return {
    "enviroment": enviroment,
    "products": await productProvider.getSyncProductList(enviromentId),
    "recipes": await recipeProvider.getSyncRecipeList(enviromentId),
    "products_recipies": await recipeProvider.getSyncRecipeProductList(enviromentId),
    "schedule": await scheduleProvider.getSyncEntryList(enviromentId),
  };
}

Future<void> syncItems(
  List<dynamic> otherItems,
  List<dynamic> selfItems,
  Function(String, Map<String, dynamic>) syncOverideCallback,
  Function(String, int) syncSetDeletedCallback,
  Function(Map<String, dynamic>) syncAddProductCallback,
) async {
  for (var otherItem in otherItems) {
    var found = false;
    for (var selfItem in selfItems) {
      if (selfItem.id == otherItem["id"]) {
        found = true;

        if (selfItem.deletedAt == null && otherItem["deletedAt"] == null) {
          if (selfItem.updatedAt < otherItem["updatedAt"]) {
            syncOverideCallback(selfItem.id, otherItem);
          }
        }

        if (otherItem["deletedAt"] != null) {
          if (selfItem.deletedAt == null || selfItem.deletedAt > otherItem["deletedAt"]) {
            syncSetDeletedCallback(selfItem.id, otherItem["deletedAt"]);
          }
        }
      }
    }

    if (!found) {
      syncAddProductCallback(otherItem);
    }
  }
}

Future<void> recieveState(
  Map<String, dynamic> state,
  EnviromentProvider enviromentProvider,
  ProductProvider productProvider,
  RecipeProvider recipeProvider,
  ScheduleProvider scheduleProvider,
) async {
  Enviroment remoteEnviroment = Enviroment.fromJson(state["enviroment"]);
  Enviroment? currentEnviroment = await enviromentProvider.getEnviromentById(remoteEnviroment.id);
  if (currentEnviroment == null) {
    return;
  }

  if (currentEnviroment.updatedAt < remoteEnviroment.updatedAt) {
    if (currentEnviroment.name != remoteEnviroment.name) {
      enviromentProvider.setName(currentEnviroment.id, remoteEnviroment.name);
    }
  }

  List<dynamic> otherProducts = state["products"]!;
  List<dynamic> otherRecipes = state["recipes"]!;
  List<dynamic> otherProductsRecipies = state["products_recipies"]!;
  List<dynamic> otherSchedule = state["schedule"]!;

  var selfProducts = productProvider.getSyncProductList(remoteEnviroment.id);
  var selfRecipes = recipeProvider.getSyncRecipeList(remoteEnviroment.id);
  var selfProductsRecipes = recipeProvider.getSyncRecipeProductList(remoteEnviroment.id);
  var selfSchedule = scheduleProvider.getSyncEntryList(remoteEnviroment.id);

  await syncItems(
    otherProducts,
    await selfProducts,
    (id, item) => productProvider.syncOveride(id, item),
    (id, deletedAt) => productProvider.syncSetDeleted(id, deletedAt),
    (item) => productProvider.syncAddProduct(item),
  );

  await syncItems(
    otherRecipes,
    await selfRecipes,
    (id, item) => recipeProvider.syncOverideRecipe(id, item),
    (id, deletedAt) => recipeProvider.syncSetDeletedRecipe(id, deletedAt),
    (item) => recipeProvider.syncAddRecipe(item),
  );

  await syncItems(
    otherProductsRecipies,
    await selfProductsRecipes,
    (id, item) => recipeProvider.syncOverideRecipeProduct(id, item),
    (id, deletedAt) => recipeProvider.syncSetDeletedRecipeProduct(id, deletedAt),
    (item) => recipeProvider.syncAddRecipeProduct(item),
  );

  await syncItems(
    otherSchedule,
    await selfSchedule,
    (id, item) => scheduleProvider.syncOveride(id, item),
    (id, deletedAt) => scheduleProvider.syncSetDeleted(id, deletedAt),
    (item) => scheduleProvider.syncAddEntry(item),
  );
}
