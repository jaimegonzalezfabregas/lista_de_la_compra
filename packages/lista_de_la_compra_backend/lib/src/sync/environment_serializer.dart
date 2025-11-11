import '../db/database.dart';
import '../db_providers/environment_provider.dart';
import '../db_providers/product_provider.dart';
import '../db_providers/recipe_provider.dart';
import '../db_providers/schedule_provider.dart';
import '../db_providers/supermarket_provider.dart';
import '../db_providers/aisle_provider.dart';
import '../db_providers/product_aisle_provider.dart';

Future<Map<String, dynamic>> serializeEnvironment(
  String enviromentId,
  EnvironmentProvider environmentProvider,
  ProductProvider productProvider,
  RecipeProvider recipeProvider,
  ScheduleProvider scheduleProvider,
  SuperMarketProvider supermarketProvider,
  AisleProvider aisleProvider,
  ProductAisleProvider productAisleProvider,
) async {
  // Launch all provider fetches concurrently to improve latency.
  final envFuture = environmentProvider.getEnvironmentById(enviromentId);
  final productsFuture = productProvider.getSyncProductList(enviromentId);
  final recipesFuture = recipeProvider.getSyncRecipeList(enviromentId);
  final recipeProductsFuture = recipeProvider.getSyncRecipeProductList(enviromentId);
  final scheduleFuture = scheduleProvider.getSyncEntryList(enviromentId);
  final superMarketsFuture = supermarketProvider.getSyncSuperMarketList(enviromentId);
  final aislesFuture = aisleProvider.getSyncAisleList(enviromentId);
  final productAislesFuture = productAisleProvider.getSyncProductAisleList(enviromentId);

  final environment = (await envFuture)!;

  final products = await productsFuture;
  final recipes = await recipesFuture;
  final productsRecipies = await recipeProductsFuture;
  final schedule = await scheduleFuture;
  final superMarkets = await superMarketsFuture;
  final aisles = await aislesFuture;
  final productAisles = await productAislesFuture;

  return {
    "environment": environment,
    "products": products,
    "recipes": recipes,
    "products_recipies": productsRecipies,
    "schedule": schedule,
    "super_markets": superMarkets,
    "aisles": aisles,
    "product_aisles": productAisles,
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
            print("Override: ${selfItem.toString()}");
            syncOverideCallback(selfItem.id, otherItem);
          }
        }

        if (otherItem["deletedAt"] != null) {
          if (selfItem.deletedAt == null || selfItem.deletedAt > otherItem["deletedAt"]) {
            print("Deleted: ${selfItem.toString()}");
            syncSetDeletedCallback(selfItem.id, otherItem["deletedAt"]);
          }
        }
      }
    }

    if (!found) {
      print("Added: ${otherItem.toString()}");
      syncAddProductCallback(otherItem);
    }
  }
}

Future<void> recieveState(
  Map<String, dynamic> state,
  EnvironmentProvider environmentProvider,
  ProductProvider productProvider,
  RecipeProvider recipeProvider,
  ScheduleProvider scheduleProvider,
  SuperMarketProvider supermarketProvider,
  AisleProvider aisleProvider,
  ProductAisleProvider productAisleProvider,
) async {
  Environment remoteEnvironment = Environment.fromJson(state["environment"]);
  Environment? currentEnvironment = await environmentProvider.getEnvironmentById(remoteEnvironment.id);
  if (currentEnvironment == null) {
    return;
  }

  if (currentEnvironment.updatedAt < remoteEnvironment.updatedAt) {
    if (currentEnvironment.name != remoteEnvironment.name) {
      environmentProvider.setName(currentEnvironment.id, remoteEnvironment.name);
    }
  }

  List<dynamic> otherProducts = state["products"]!;
  List<dynamic> otherRecipes = state["recipes"]!;
  List<dynamic> otherProductsRecipies = state["products_recipies"]!;
  List<dynamic> otherSchedule = state["schedule"]!;
  List<dynamic> otherSuperMarkets = state["super_markets"] ?? [];
  List<dynamic> otherAisles = state["aisles"] ?? [];
  List<dynamic> otherProductAisles = state["product_aisles"] ?? [];

  var selfProducts = productProvider.getSyncProductList(remoteEnvironment.id);
  var selfRecipes = recipeProvider.getSyncRecipeList(remoteEnvironment.id);
  var selfProductsRecipes = recipeProvider.getSyncRecipeProductList(remoteEnvironment.id);
  var selfSchedule = scheduleProvider.getSyncEntryList(remoteEnvironment.id);
  var selfSuperMarkets = supermarketProvider.getSyncSuperMarketList(remoteEnvironment.id);
  var selfAisles = aisleProvider.getSyncAisleList(remoteEnvironment.id);
  var selfProductAisles = productAisleProvider.getSyncProductAisleList(remoteEnvironment.id);

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

  // sync new tables if providers are present
  await syncItems(
    otherSuperMarkets,
    await selfSuperMarkets,
    (id, item) => supermarketProvider.syncOverideSuperMarket(id, item),
    (id, deletedAt) => supermarketProvider.syncSetDeletedSuperMarket(id, deletedAt),
    (item) => supermarketProvider.syncAddSuperMarket(item),
  );

  await syncItems(
    otherAisles,
    await selfAisles,
    (id, item) => aisleProvider.syncOverideAisle(id, item),
    (id, deletedAt) => aisleProvider.syncSetDeletedAisle(id, deletedAt),
    (item) => aisleProvider.syncAddAisle(item),
  );

  await syncItems(
    otherProductAisles,
    await selfProductAisles,
    (id, item) => productAisleProvider.syncOverideProductAisle(id, item),
    (id, deletedAt) => productAisleProvider.syncSetDeletedProductAisle(id, deletedAt),
    (item) => productAisleProvider.syncAddProductAisle(item),
  );
}
