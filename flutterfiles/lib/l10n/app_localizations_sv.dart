// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Inköpslista';

  @override
  String get changeName => 'Byt namn';

  @override
  String get changeNick => 'Byt smeknamn';

  @override
  String get name => 'Namn';

  @override
  String get nick => 'Smeknamn';

  @override
  String get theNameCantBeEmpty => 'Namnet kan inte vara tomt';

  @override
  String get cancel => 'Avbryt';

  @override
  String get save => 'Spara';

  @override
  String get thisListHasNoResults => 'Den här listan har inga resultat';

  @override
  String get thisListHasNoResultsStartTypingToAddTheFirst =>
      'Den här listan har inga resultat. Börja skriva för att lägga till det första';

  @override
  String get map => 'Karta';

  @override
  String get createEnvironment => 'Skapa miljö';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Tillgängliga miljöer utan anslutning';

  @override
  String get environmentsOnOtherMachines => 'Miljöer på andra enheter';

  @override
  String get importEnvironment => 'Importera miljö';

  @override
  String get syncronization => 'Synkronisering';

  @override
  String get loading => 'Laddar...';

  @override
  String get home => 'Hem';

  @override
  String get shoppingList => 'Inköpslista';

  @override
  String get recipeList => 'Receptlista';

  @override
  String get agenda => 'Agenda';

  @override
  String get export => 'Exportera';

  @override
  String get undo => 'Ångra';

  @override
  String get product => 'Produkt';

  @override
  String get markAsNeeded => ' markerad som behövd. ';

  @override
  String get markAsBought => ' markerad som köpt. ';

  @override
  String get toBuy => 'Att köpa';

  @override
  String get editName => 'Redigera namn';

  @override
  String get delete => 'Ta bort';

  @override
  String get setAsBought => 'Markera som köpt';

  @override
  String get setAsNeeded => 'Markera som behövd';

  @override
  String get selectRecipe => 'Välj recept';

  @override
  String get add => 'Lägg till';

  @override
  String get noNick => 'Inget smeknamn';

  @override
  String get pairings => 'Parningar';

  @override
  String get connectionType => 'Anslutningstyp';

  @override
  String get notStablished => 'Inte etablerad';

  @override
  String get stablished => 'Etablerad';

  @override
  String get connectionState => 'Anslutningsstatus';

  @override
  String get generalConfig => 'Allmän konfiguration';

  @override
  String get scanStarted => 'Skanning startad';

  @override
  String get noResultsYet => 'Inga resultat än';

  @override
  String get noName => 'Inget namn';

  @override
  String get noHost => 'Ingen värd';

  @override
  String get error => 'Fel';

  @override
  String get saveFileToYourDesiredLocation => 'Spara filen på önskad plats';

  @override
  String get exportToFile => 'Exportera till fil';

  @override
  String get sendExport => 'Exportera och skicka';

  @override
  String get localDeviceAvailableIPs =>
      'Den aktuella enheten är tillgänglig på följande IP-adresser';

  @override
  String get stopServer => 'Stoppa servern';

  @override
  String get startServer => 'Starta servern';

  @override
  String get startingServer => 'Startar server...';

  @override
  String get stoppingServer => 'Stoppar server...';

  @override
  String get errorStartingServer => 'Fel vid start av servern';

  @override
  String get nearbyDevices => 'Närliggande enheter';

  @override
  String get enterAddressManually => 'Ange adress manuellt';

  @override
  String get remoteAddress => 'Fjärradress';

  @override
  String get remotePort => 'Fjärrport';

  @override
  String get errorEmptyRemoteAddress => 'Fel: fjärradressen kan inte vara tom';

  @override
  String get connect => 'Anslut';

  @override
  String get server => 'Server';

  @override
  String get client => 'Klient';

  @override
  String get inputTheAmount => 'Ange mängden';

  @override
  String get noIngredientsYet => 'Inga ingredienser har lagts till än';

  @override
  String get addIngredients => 'Lägg till ingredienser';

  @override
  String get showPastDates => 'Visa tidigare datum';

  @override
  String get ingredients => 'Ingredienser';

  @override
  String get dates => 'Datum';

  @override
  String get buy => 'Köp';

  @override
  String get all => 'Allt';

  @override
  String get httpClient => 'HTTP-klient';

  @override
  String get httpServer => 'HTTP-server';

  @override
  String get addIngredientsToRecipe => 'Välj ingredienser ';

  @override
  String get recipeWithoutIngredients => 'Detta recept har inga ingredienser';

  @override
  String get noPlannedDates => 'Inga planerade datum';

  @override
  String get noHTTPPairings =>
      'Det finns inga tidigare parningar med HTTP-servrar';

  @override
  String get loadingIps => 'Läser IP-adresser';

  @override
  String get ipRefresh => 'Uppdatera IPs';

  @override
  String get planner => 'Planerare';

  @override
  String ipCopied(Object address) {
    return 'IP-adress ($address) kopierad till urklipp';
  }

  @override
  String get search => 'Sök';

  @override
  String get switchEnvironment => 'Byt miljö';

  @override
  String get actions => 'Åtgärder';

  @override
  String get markAllAs => 'Markera alla som';

  @override
  String get editAmount => 'Redigera mängd';

  @override
  String get details => 'Detaljer';

  @override
  String get enoughForA => 'Räcker till en';

  @override
  String get knownServers => 'Kända servrar';

  @override
  String get noOpenConnection => 'Inga öppna anslutningar';

  @override
  String get neverConnected => 'Aldrig ansluten';

  @override
  String get fallbackLocalNick => 'namnlös-enhet';

  @override
  String get supermarketList => 'Supermarket list';

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
  String get addProductsToAisle => 'Lägg till produkter i gången';

  @override
  String get selectSupermarket => 'Select Supermarket...';

  @override
  String get exportToICS => 'Exportera till ICS';

  @override
  String get exportToGoogleCalendar => 'Exportera till Google Kalender';

  @override
  String get exportToMarkdownFile => 'Exportera till Markdown-fil';

  @override
  String get noMappingDataAviable => 'No mapping data available';

  @override
  String get noMapsHaveBeenCreatedForThisSupermarket =>
      'Inga kartor har skapats för denna stormarknad';

  @override
  String get createMap => 'Skapa karta';

  @override
  String get editMap => 'Redigera karta';

  @override
  String get newFloor => 'Ny våning';

  @override
  String floorN(int n) {
    return 'Floor $n';
  }

  @override
  String get assignAisle => 'Tilldela gång';

  @override
  String get unassignAisle => 'Ta bort gång';

  @override
  String get tileTypeFloor => 'Golv';

  @override
  String get tileTypeStart => 'Start';

  @override
  String get tileTypeEnd => 'Slut';

  @override
  String get noAislesToAssign => 'Inga gångar tillgängliga att tilldela';

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
