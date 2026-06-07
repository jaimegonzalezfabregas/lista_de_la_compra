// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Nákupní seznam';

  @override
  String get changeName => 'Změnit název';

  @override
  String get changeNick => 'Změnit přezdívku';

  @override
  String get name => 'Jméno';

  @override
  String get nick => 'Přezdívka';

  @override
  String get theNameCantBeEmpty => 'Jméno nesmí být prázdné';

  @override
  String get cancel => 'Zrušit';

  @override
  String get save => 'Uložit';

  @override
  String get thisListHasNoResults => 'Tento seznam nemá žádné výsledky';

  @override
  String get thisListHasNoResultsStartTypingToAddTheFirst =>
      'Tento seznam nemá žádné výsledky. Začněte psát pro přidání prvního';

  @override
  String get map => 'Mapa';

  @override
  String get createEnvironment => 'Vytvořit prostředí';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Dostupná prostředí bez připojení';

  @override
  String get environmentsOnOtherMachines => 'Prostředí na jiných počítačích';

  @override
  String get importEnvironment => 'Importovat prostředí';

  @override
  String get syncronization => 'Synchronizace';

  @override
  String get loading => 'Načítání...';

  @override
  String get home => 'Domů';

  @override
  String get shoppingList => 'Nákupní seznam';

  @override
  String get recipeList => 'Seznam receptů';

  @override
  String get agenda => 'Agenda';

  @override
  String get export => 'Export';

  @override
  String get undo => 'Zpět';

  @override
  String get product => 'Produkt';

  @override
  String get markAsNeeded => ' označeno jako potřebné. ';

  @override
  String get markAsBought => ' označeno jako koupené. ';

  @override
  String get toBuy => 'Koupit';

  @override
  String get editName => 'Upravit název';

  @override
  String get delete => 'Smazat';

  @override
  String get setAsBought => 'Označit jako koupené';

  @override
  String get setAsNeeded => 'Označit jako potřebné';

  @override
  String get selectRecipe => 'Vybrat recept';

  @override
  String get add => 'Přidat';

  @override
  String get noNick => 'Žádná přezdívka';

  @override
  String get pairings => 'Párování';

  @override
  String get connectionType => 'Typ připojení';

  @override
  String get notStablished => 'Nezavedeno';

  @override
  String get stablished => 'Zavedeno';

  @override
  String get connectionState => 'Stav připojení';

  @override
  String get generalConfig => 'Obecné nastavení';

  @override
  String get scanStarted => 'Skenování spuštěno';

  @override
  String get noResultsYet => 'Ještě žádné výsledky';

  @override
  String get noName => 'Žádné jméno';

  @override
  String get noHost => 'Žádný hostitel';

  @override
  String get error => 'Chyba';

  @override
  String get saveFileToYourDesiredLocation =>
      'Uložte soubor na požadované místo';

  @override
  String get exportToFile => 'Exportovat do souboru';

  @override
  String get sendExport => 'Exportovat a odeslat';

  @override
  String get localDeviceAvailableIPs =>
      'Aktuální zařízení je dostupné na následujících IP adresách';

  @override
  String get stopServer => 'Zastavit server';

  @override
  String get startServer => 'Spustit server';

  @override
  String get startingServer => 'Spouští se server...';

  @override
  String get stoppingServer => 'Server se zastavuje...';

  @override
  String get errorStartingServer => 'Chyba při spouštění serveru';

  @override
  String get nearbyDevices => 'Zařízení v okolí';

  @override
  String get enterAddressManually => 'Zadat adresu ručně';

  @override
  String get remoteAddress => 'Vzdálená adresa';

  @override
  String get remotePort => 'Vzdálený port';

  @override
  String get errorEmptyRemoteAddress =>
      'Chyba: vzdálená adresa nesmí být prázdná';

  @override
  String get connect => 'Připojit';

  @override
  String get server => 'Server';

  @override
  String get client => 'Klient';

  @override
  String get inputTheAmount => 'Zadejte množství';

  @override
  String get noIngredientsYet => 'Zatím nebyly přidány žádné ingredience';

  @override
  String get addIngredients => 'Přidat ingredience';

  @override
  String get showPastDates => 'Zobrazit minulé datum';

  @override
  String get ingredients => 'Ingredience';

  @override
  String get dates => 'Data';

  @override
  String get buy => 'Koupit';

  @override
  String get all => 'Vše';

  @override
  String get httpClient => 'HTTP klient';

  @override
  String get httpServer => 'HTTP server';

  @override
  String get addIngredientsToRecipe => 'Vybrat ingredience ';

  @override
  String get recipeWithoutIngredients => 'Tento recept nemá žádné ingredience';

  @override
  String get noPlannedDates => 'Žádná plánovaná data';

  @override
  String get noHTTPPairings => 'Nejsou žádná minulá párování s HTTP servery';

  @override
  String get loadingIps => 'Načítání IP adres';

  @override
  String get ipRefresh => 'Obnovit IP';

  @override
  String get planner => 'Plánovač';

  @override
  String ipCopied(Object address) {
    return 'IP adresa ($address) zkopírována do schránky';
  }

  @override
  String get search => 'Hledat';

  @override
  String get switchEnvironment => 'Přepnout prostředí';

  @override
  String get actions => 'Akce';

  @override
  String get markAllAs => 'Označit vše jako';

  @override
  String get editAmount => 'Upravit množství';

  @override
  String get details => 'Detaily';

  @override
  String get enoughForA => 'Dostatečné pro';

  @override
  String get knownServers => 'Známé servery';

  @override
  String get noOpenConnection => 'Žádná otevřená připojení';

  @override
  String get neverConnected => 'Nikdy nepřipojeno';

  @override
  String get fallbackLocalNick => 'nepojmenované-zařízení';

  @override
  String get supermarketList => 'Nákupní seznam';

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
  String get addProductsToAisle => 'Přidat produkty do uličky';

  @override
  String get selectSupermarket => 'Select Supermarket...';

  @override
  String get exportToICS => 'Exportovat do ICS';

  @override
  String get exportToGoogleCalendar => 'Exportovat do Kalendáře Google';

  @override
  String get exportToMarkdownFile => 'Exportovat do souboru Markdown';

  @override
  String get noMappingDataAviable => 'No mapping data available';

  @override
  String get noMapsHaveBeenCreatedForThisSupermarket =>
      'Pro tento supermarket nebyly vytvořeny žádné mapy';

  @override
  String get createMap => 'Vytvořit mapu';

  @override
  String get editMap => 'Upravit mapu';

  @override
  String get newFloor => 'Nové patro';

  @override
  String floorN(int n) {
    return 'Floor $n';
  }

  @override
  String get assignAisle => 'Přiřadit uličku';

  @override
  String get unassignAisle => 'Odebrat uličku';

  @override
  String get tileTypeFloor => 'Podlaha';

  @override
  String get tileTypeStart => 'Start';

  @override
  String get tileTypeEnd => 'Konec';

  @override
  String get noAislesToAssign => 'Žádné uličky k přiřazení';

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
