// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Boodschappenlijst';

  @override
  String get changeName => 'Naam wijzigen';

  @override
  String get changeNick => 'Bijnaam wijzigen';

  @override
  String get name => 'Naam';

  @override
  String get nick => 'Bijnaam';

  @override
  String get theNameCantBeEmpty => 'De naam mag niet leeg zijn';

  @override
  String get cancel => 'Annuleren';

  @override
  String get save => 'Opslaan';

  @override
  String get thisListHasNoResults => 'Deze lijst heeft geen resultaten';

  @override
  String get createEnvironment => 'Omgeving aanmaken';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Beschikbare omgevingen zonder verbinding';

  @override
  String get environmentsOnOtherMachines => 'Omgevingen op andere apparaten';

  @override
  String get importEnvironment => 'Importeer omgeving';

  @override
  String get syncronization => 'Synchronisatie';

  @override
  String get loading => 'Laden...';

  @override
  String get home => 'Start';

  @override
  String get shoppingList => 'Boodschappenlijst';

  @override
  String get recipeList => 'Receptenlijst';

  @override
  String get agenda => 'Agenda';

  @override
  String get export => 'Exporteren';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get product => 'Product';

  @override
  String get markAsNeeded => ' gemarkeerd als nodig. ';

  @override
  String get markAsBought => ' gemarkeerd als gekocht. ';

  @override
  String get toBuy => 'Te kopen';

  @override
  String get editName => 'Naam bewerken';

  @override
  String get delete => 'Verwijderen';

  @override
  String get setAsBought => 'Markeer als gekocht';

  @override
  String get setAsNeeded => 'Markeer als nodig';

  @override
  String get selectRecipe => 'Selecteer recept';

  @override
  String get add => 'Toevoegen';

  @override
  String get noNick => 'Geen bijnaam';

  @override
  String get pairings => 'Koppelingen';

  @override
  String get connectionType => 'Verbindingstype';

  @override
  String get notStablished => 'Niet vastgesteld';

  @override
  String get stablished => 'Vastgesteld';

  @override
  String get connectionState => 'Verbindingsstatus';

  @override
  String get generalConfig => 'Algemene instellingen';

  @override
  String get scanStarted => 'Scan gestart';

  @override
  String get noResultsYet => 'Nog geen resultaten';

  @override
  String get noName => 'Geen naam';

  @override
  String get noHost => 'Geen host';

  @override
  String get error => 'Fout';

  @override
  String get saveFileToYourDesiredLocation =>
      'Sla het bestand op op de gewenste locatie';

  @override
  String get exportToFile => 'Exporteren naar bestand';

  @override
  String get sendExport => 'Exporteren en verzenden';

  @override
  String get localDeviceAvailableIPs =>
      'Het huidige apparaat is beschikbaar op de volgende IP-adressen';

  @override
  String get stopServer => 'Server stoppen';

  @override
  String get startServer => 'Server starten';

  @override
  String get startingServer => 'Server wordt gestart...';

  @override
  String get stoppingServer => 'Server wordt gestopt...';

  @override
  String get errorStartingServer => 'Fout bij het starten van de server';

  @override
  String get nearbyDevices => 'Apparaten in de buurt';

  @override
  String get enterAddressManually => 'Adres handmatig invoeren';

  @override
  String get remoteAddress => 'Extern adres';

  @override
  String get remotePort => 'Externe poort';

  @override
  String get errorEmptyRemoteAddress =>
      'Fout: het externe adres mag niet leeg zijn';

  @override
  String get connect => 'Verbinden';

  @override
  String get server => 'Server';

  @override
  String get client => 'Client';

  @override
  String get inputTheAmount => 'Voer de hoeveelheid in';

  @override
  String get noIngredientsYet => 'Er zijn nog geen ingrediënten toegevoegd';

  @override
  String get addIngredients => 'Ingrediënten toevoegen';

  @override
  String get showPastDates => 'Toon eerdere data';

  @override
  String get ingredients => 'Ingrediënten';

  @override
  String get dates => 'Data';

  @override
  String get buy => 'Kopen';

  @override
  String get all => 'Alles';

  @override
  String get httpClient => 'HTTP-client';

  @override
  String get httpServer => 'HTTP-server';

  @override
  String get selectIngredients => 'Ingrediënten selecteren';

  @override
  String get recipeWithoutIngredients => 'Dit recept heeft geen ingrediënten';

  @override
  String get noPlannedDates => 'Geen geplande data';

  @override
  String get noHTTPPairings =>
      'Er zijn geen eerdere koppelingen met HTTP-servers';

  @override
  String get loadingIps => 'IP-adressen laden';

  @override
  String get ipRefresh => 'IPs vernieuwen';

  @override
  String get planner => 'Planner';

  @override
  String ipCopied(Object address) {
    return 'IP-adres ($address) gekopieerd naar het klembord';
  }

  @override
  String get search => 'Zoeken';

  @override
  String get switchEnvironment => 'Omgeving wisselen';

  @override
  String get actions => 'Acties';

  @override
  String get markAllAs => 'Alles markeren als';

  @override
  String get editAmount => 'Hoeveelheid bewerken';

  @override
  String get details => 'Details';

  @override
  String get enoughForA => 'Genoeg voor een';

  @override
  String get knownServers => 'Bekende servers';

  @override
  String get noOpenConnection => 'Geen open verbindingen';

  @override
  String get neverConnected => 'Nooit verbonden';

  @override
  String get fallbackLocalNick => 'naamloos-apparaat';
}
