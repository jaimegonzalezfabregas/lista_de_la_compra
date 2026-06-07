// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Bevásárlólista';

  @override
  String get changeName => 'Név módosítása';

  @override
  String get changeNick => 'Becenév módosítása';

  @override
  String get name => 'Név';

  @override
  String get nick => 'Becenév';

  @override
  String get theNameCantBeEmpty => 'A név nem lehet üres';

  @override
  String get cancel => 'Mégse';

  @override
  String get save => 'Mentés';

  @override
  String get thisListHasNoResults => 'Ebben a listában nincs találat';

  @override
  String get thisListHasNoResultsStartTypingToAddTheFirst =>
      'Ebben a listában nincs találat. Kezdjen el gépelni az első hozzáadásához';

  @override
  String get map => 'Térkép';

  @override
  String get createEnvironment => 'Környezet létrehozása';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Elérhető környezetek kapcsolat nélkül';

  @override
  String get environmentsOnOtherMachines => 'Környezetek más gépeken';

  @override
  String get importEnvironment => 'Környezet importálása';

  @override
  String get syncronization => 'Szinkronizáció';

  @override
  String get loading => 'Betöltés...';

  @override
  String get home => 'Kezdőlap';

  @override
  String get shoppingList => 'Bevásárlólista';

  @override
  String get recipeList => 'Recept lista';

  @override
  String get agenda => 'Napirend';

  @override
  String get export => 'Exportálás';

  @override
  String get undo => 'Visszavonás';

  @override
  String get product => 'Termék';

  @override
  String get markAsNeeded => ' szükségként megjelölve. ';

  @override
  String get markAsBought => ' megvásároltként megjelölve. ';

  @override
  String get toBuy => 'Vásárolni';

  @override
  String get editName => 'Név szerkesztése';

  @override
  String get delete => 'Törlés';

  @override
  String get setAsBought => 'Megjelölés megvásároltként';

  @override
  String get setAsNeeded => 'Megjelölés szükségként';

  @override
  String get selectRecipe => 'Recept kiválasztása';

  @override
  String get add => 'Hozzáadás';

  @override
  String get noNick => 'Nincs becenév';

  @override
  String get pairings => 'Párosítások';

  @override
  String get connectionType => 'Kapcsolattípus';

  @override
  String get notStablished => 'Nem létrejött';

  @override
  String get stablished => 'Létrejött';

  @override
  String get connectionState => 'Kapcsolat állapota';

  @override
  String get generalConfig => 'Általános beállítások';

  @override
  String get scanStarted => 'Beolvasás elindult';

  @override
  String get noResultsYet => 'Még nincs találat';

  @override
  String get noName => 'Nincs név';

  @override
  String get noHost => 'Nincs hoszt';

  @override
  String get error => 'Hiba';

  @override
  String get saveFileToYourDesiredLocation => 'Mentse a fájlt a kívánt helyre';

  @override
  String get exportToFile => 'Exportálás fájlba';

  @override
  String get sendExport => 'Exportálás és küldés';

  @override
  String get localDeviceAvailableIPs =>
      'A jelenlegi eszköz a következő IP-ken érhető el';

  @override
  String get stopServer => 'Szerver leállítása';

  @override
  String get startServer => 'Szerver indítása';

  @override
  String get startingServer => 'A szerver indítása...';

  @override
  String get stoppingServer => 'A szerver leállítása...';

  @override
  String get errorStartingServer => 'Hiba a szerver indításakor';

  @override
  String get nearbyDevices => 'Közeli eszközök';

  @override
  String get enterAddressManually => 'Cím kézi megadása';

  @override
  String get remoteAddress => 'Távoli cím';

  @override
  String get remotePort => 'Távoli port';

  @override
  String get errorEmptyRemoteAddress => 'Hiba: a távoli cím nem lehet üres';

  @override
  String get connect => 'Csatlakozás';

  @override
  String get server => 'Szerver';

  @override
  String get client => 'Kliens';

  @override
  String get inputTheAmount => 'Adja meg a mennyiséget';

  @override
  String get noIngredientsYet => 'Még nem adtak hozzá összetevőket';

  @override
  String get addIngredients => 'Összetevők hozzáadása';

  @override
  String get showPastDates => 'Korábbi dátumok megjelenítése';

  @override
  String get ingredients => 'Összetevők';

  @override
  String get dates => 'Dátumok';

  @override
  String get buy => 'Vásárlás';

  @override
  String get all => 'Minden';

  @override
  String get httpClient => 'HTTP kliens';

  @override
  String get httpServer => 'HTTP szerver';

  @override
  String get addIngredientsToRecipe => 'Összetevők kiválasztása ';

  @override
  String get recipeWithoutIngredients =>
      'Ennek a receptnek nincsenek összetevői';

  @override
  String get noPlannedDates => 'Nincsenek tervezett dátumok';

  @override
  String get noHTTPPairings =>
      'Nincsenek korábbi párosítások HTTP szerverekkel';

  @override
  String get loadingIps => 'IP-címek betöltése';

  @override
  String get ipRefresh => 'IP frissítése';

  @override
  String get planner => 'Tervező';

  @override
  String ipCopied(Object address) {
    return 'IP-cím ($address) másolva a vágólapra';
  }

  @override
  String get search => 'Keresés';

  @override
  String get switchEnvironment => 'Környezet váltása';

  @override
  String get actions => 'Műveletek';

  @override
  String get markAllAs => 'Jelöld mindet mint';

  @override
  String get editAmount => 'Mennyiség szerkesztése';

  @override
  String get details => 'Részletek';

  @override
  String get enoughForA => 'Elég egyhez';

  @override
  String get knownServers => 'Ismert szerverek';

  @override
  String get noOpenConnection => 'Nincsenek nyitott kapcsolatok';

  @override
  String get neverConnected => 'Sosem csatlakozott';

  @override
  String get fallbackLocalNick => 'névtelen-eszköz';

  @override
  String get supermarketList => 'Bevásárlólista';

  @override
  String get aisles => 'Aisles';

  @override
  String numberOfProducts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
      zero: 'No products',
    );
    return '$_temp0';
  }

  @override
  String numberOfAisles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aisles',
      one: '1 aisle',
      zero: 'No aisles',
    );
    return '$_temp0';
  }

  @override
  String get addProductsToAisle => 'Termékek hozzáadása a folyosóhoz';

  @override
  String get selectSupermarket => 'Select Supermarket...';

  @override
  String get exportToICS => 'Exportálás ICS-be';

  @override
  String get exportToGoogleCalendar => 'Exportálás Google Naptárba';

  @override
  String get exportToMarkdownFile => 'Exportálás Markdown fájlba';

  @override
  String get noMappingDataAviable => 'No mapping data available';

  @override
  String get noMapsHaveBeenCreatedForThisSupermarket =>
      'Ehhez az áruházhoz nem készültek térképek';

  @override
  String get createMap => 'Térkép létrehozása';

  @override
  String get editMap => 'Térkép szerkesztése';

  @override
  String get newFloor => 'Új szint';

  @override
  String floorN(int n) {
    return 'Floor $n';
  }

  @override
  String get assignAisle => 'Folyosó hozzárendelése';

  @override
  String get unassignAisle => 'Folyosó eltávolítása';

  @override
  String get tileTypeFloor => 'Padló';

  @override
  String get tileTypeStart => 'Kezdet';

  @override
  String get tileTypeEnd => 'Vég';

  @override
  String get noAislesToAssign => 'Nincs hozzárendelhető folyosó';

  @override
  String get deleteFloor => 'Delete Floor';

  @override
  String tileLockedLastOfType(String tileType) {
    return 'This tile is locked: it is the last $tileType tile.';
  }

  @override
  String get routeNoAisles =>
      'There are no aisles to visit given the needed products. No route can be calculated';

  @override
  String get pendingAislesToVisit => 'Pending aisles to visit';

  @override
  String get calculateRoute => 'Calculate route';

  @override
  String routeProgress(Object percent) {
    return 'Progress: $percent%';
  }

  @override
  String get cancelRouteCalculation => 'Cancel route calculation';

  @override
  String get clearRoute => 'Clear route';

  @override
  String get selectASupermarket => 'Select a supermarket';

  @override
  String routeError(Object error) {
    return 'Route error: $error';
  }

  @override
  String get optimizeRoute => 'Optimize route';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get tapTileOrGhostTile =>
      'Tap a tile to select it, or tap a ghost tile to add one';

  @override
  String get tileTypeTransformInfo =>
      'To transform this tile into a different type, first select the new start or end tile';
}
