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
  String get selectIngredients => 'Välj ingredienser';

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
}
