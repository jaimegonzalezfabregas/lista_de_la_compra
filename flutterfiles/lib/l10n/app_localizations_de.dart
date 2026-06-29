// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Einkaufsliste';

  @override
  String get changeName => 'Namen ändern';

  @override
  String get changeNick => 'Spitzname ändern';

  @override
  String get name => 'Name';

  @override
  String get nick => 'Spitzname';

  @override
  String get theNameCantBeEmpty => 'Der Name darf nicht leer sein';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get thisListHasNoResults => 'Diese Liste enthält keine Ergebnisse';

  @override
  String get thisListHasNoResultsStartTypingToAddTheFirst =>
      'Diese Liste enthält keine Ergebnisse. Tippen Sie, um das erste hinzuzufügen';

  @override
  String get map => 'Karte';

  @override
  String get createEnvironment => 'Umgebung erstellen';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Verfügbare Umgebungen ohne Verbindung';

  @override
  String get environmentsOnOtherMachines => 'Umgebungen auf anderen Geräten';

  @override
  String get importEnvironment => 'Umgebung importieren';

  @override
  String get syncronization => 'Synchronisierung';

  @override
  String get loading => 'Lädt...';

  @override
  String get home => 'Startseite';

  @override
  String get shoppingList => 'Einkaufsliste';

  @override
  String get recipeList => 'Rezeptliste';

  @override
  String get agenda => 'Terminplan';

  @override
  String get export => 'Exportieren';

  @override
  String get undo => 'Rückgängig';

  @override
  String get product => 'Produkt';

  @override
  String get markAsNeeded => ' als benötigt markiert. ';

  @override
  String get markAsBought => ' als gekauft markiert. ';

  @override
  String get toBuy => 'Zu kaufen';

  @override
  String get editName => 'Namen bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get setAsBought => 'Als gekauft markieren';

  @override
  String get setAsNeeded => 'Als benötigt markieren';

  @override
  String get selectRecipe => 'Rezept auswählen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get noNick => 'Kein Spitzname';

  @override
  String get pairings => 'Kopplungen';

  @override
  String get connectionType => 'Verbindungstyp';

  @override
  String get notStablished => 'Nicht hergestellt';

  @override
  String get stablished => 'Hergestellt';

  @override
  String get connectionState => 'Verbindungsstatus';

  @override
  String get generalConfig => 'Allgemeine Einstellungen';

  @override
  String get scanStarted => 'Suche gestartet';

  @override
  String get noResultsYet => 'Noch keine Ergebnisse';

  @override
  String get noName => 'Kein Name';

  @override
  String get noHost => 'Kein Host';

  @override
  String get error => 'Fehler';

  @override
  String get saveFileToYourDesiredLocation =>
      'Datei am gewünschten Ort speichern';

  @override
  String get exportToFile => 'In Datei exportieren';

  @override
  String get sendExport => 'Exportieren und senden';

  @override
  String get localDeviceAvailableIPs =>
      'Dieses Gerät ist unter folgenden IPs erreichbar';

  @override
  String get stopServer => 'Server stoppen';

  @override
  String get startServer => 'Server starten';

  @override
  String get startingServer => 'Server wird gestartet...';

  @override
  String get stoppingServer => 'Server wird gestoppt...';

  @override
  String get errorStartingServer => 'Fehler beim Starten des Servers';

  @override
  String get nearbyDevices => 'Nahegelegene Geräte';

  @override
  String get enterAddressManually => 'Adresse manuell eingeben';

  @override
  String get remoteAddress => 'Entfernte Adresse';

  @override
  String get remotePort => 'Entfernter Port';

  @override
  String get errorEmptyRemoteAddress =>
      'Fehler: Die entfernte Adresse darf nicht leer sein';

  @override
  String get connect => 'Verbinden';

  @override
  String get server => 'Server';

  @override
  String get client => 'Client';

  @override
  String get inputTheAmount => 'Menge eingeben';

  @override
  String get noIngredientsYet => 'Noch keine Zutaten hinzugefügt';

  @override
  String get addIngredients => 'Zutaten hinzufügen';

  @override
  String get showPastDates => 'Vergangene Daten anzeigen';

  @override
  String get ingredients => 'Zutaten';

  @override
  String get dates => 'Termine';

  @override
  String get buy => 'Kaufen';

  @override
  String get all => 'Alle';

  @override
  String get httpClient => 'HTTP-Client';

  @override
  String get httpServer => 'HTTP-Server';

  @override
  String get addIngredientsToRecipe => 'Zutaten auswählen ';

  @override
  String get recipeWithoutIngredients => 'Dieses Rezept hat keine Zutaten';

  @override
  String get noPlannedDates => 'Keine geplanten Termine';

  @override
  String get noHTTPPairings => 'Keine früheren Verbindungen mit HTTP-Servern';

  @override
  String get loadingIps => 'Lade IP-Adressen';

  @override
  String get ipRefresh => 'IPs aktualisieren';

  @override
  String get planner => 'Planer';

  @override
  String ipCopied(Object address) {
    return 'IP-Adresse ($address) in Zwischenablage kopiert';
  }

  @override
  String get search => 'Suche';

  @override
  String get switchEnvironment => 'Umgebung wechseln';

  @override
  String get actions => 'Aktionen';

  @override
  String get markAllAs => 'Alle als markieren';

  @override
  String get editAmount => 'Menge bearbeiten';

  @override
  String get details => 'Details';

  @override
  String get enoughForA => 'Ausreichend für ein';

  @override
  String get knownServers => 'Bekannte Server';

  @override
  String get noOpenConnection => 'Keine offenen Verbindungen';

  @override
  String get neverConnected => 'Nie verbunden';

  @override
  String get fallbackLocalNick => 'unbenanntes-gerät';

  @override
  String get supermarketList => 'Einkaufsliste';

  @override
  String get renameMe => 'Benenne mich um';

  @override
  String get houses => 'Häuser';

  @override
  String get createHouse => 'Haus erstellen';

  @override
  String get deleteHouse => 'Haus löschen';

  @override
  String get selectHouses => 'Häuser auswählen';

  @override
  String get selectHousesPrompt =>
      'Um die benötigte Liste der Artikel anzuzeigen, wählen Sie zuerst eine Reihe von Häusern aus';

  @override
  String get aisles => 'Gänge';

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
  String get addProductsToAisle => 'Produkte zum Gang hinzufügen';

  @override
  String get selectSupermarket => 'Select Supermarket...';

  @override
  String get exportToICS => 'Als ICS exportieren';

  @override
  String get exportToGoogleCalendar => 'In Google Kalender exportieren';

  @override
  String get exportToMarkdownFile => 'Als Markdown-Datei exportieren';

  @override
  String get noMappingDataAviable => 'Keine Kartendaten verfügbar';

  @override
  String get noMapsHaveBeenCreatedForThisSupermarket =>
      'Es wurden keine Karten für diesen Supermarkt erstellt';

  @override
  String get createMap => 'Karte erstellen';

  @override
  String get editMap => 'Karte bearbeiten';

  @override
  String get newFloor => 'Neue Etage';

  @override
  String floorN(int n) {
    return 'Floor $n';
  }

  @override
  String get assignAisle => 'Gang zuweisen';

  @override
  String get unassignAisle => 'Gang entfernen';

  @override
  String get tileTypeFloor => 'Boden';

  @override
  String get tileTypeStart => 'Start';

  @override
  String get tileTypeEnd => 'Ende';

  @override
  String get noAislesToAssign => 'Keine Gänge zum Zuweisen verfügbar';

  @override
  String get deleteFloor => 'Delete Floor';

  @override
  String tileLockedLastOfType(String tileType) {
    return 'This tile is locked: it is the last $tileType tile.';
  }

  @override
  String get routeNoAisles =>
      'Es gibt keine Gänge zu besuchen angesichts der benötigten Produkte. Keine Route kann berechnet werden';

  @override
  String get pendingAislesToVisit => 'Ausstehende Gänge zu besuchen';

  @override
  String get calculateRoute => 'Route berechnen';

  @override
  String routeProgress(Object percent) {
    return 'Progress: $percent%';
  }

  @override
  String get cancelRouteCalculation => 'Routenberechnung abbrechen';

  @override
  String get clearRoute => 'Route löschen';

  @override
  String get selectASupermarket => 'Wählen Sie einen Supermarkt';

  @override
  String routeError(Object error) {
    return 'Route error: $error';
  }

  @override
  String get optimizeRoute => 'Route optimieren';

  @override
  String get uncategorized => 'Unkategorisiert';

  @override
  String get tapTileOrGhostTile =>
      'Tippen Sie auf eine Kachel, um sie auszuwählen, oder auf eine Geisterkachel, um eine hinzuzufügen';

  @override
  String get tileTypeTransformInfo =>
      'Um diese Kachel in einen anderen Typ umzuwandeln, wählen Sie zuerst die neue Start- oder Endkachel aus';

  @override
  String get noHouseSelected => 'Kein Haus ausgewählt';
}
