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
  String addIngredientsToRecipe(Object recipe) {
    return 'Zutaten auswählen ($recipe)';
  }

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
  String addProductsToAisle(Object aisle, Object supermarket) {
    return 'Produkte zum Gang hinzufügen ($aisle — $supermarket)';
  }

  @override
  String get selectSupermarket => 'Select Supermarket...';
}
