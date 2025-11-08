// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Handleliste';

  @override
  String get changeName => 'Endre navn';

  @override
  String get changeNick => 'Endre kallenavn';

  @override
  String get name => 'Navn';

  @override
  String get nick => 'Kallenavn';

  @override
  String get theNameCantBeEmpty => 'Navnet kan ikke være tomt';

  @override
  String get cancel => 'Avbryt';

  @override
  String get save => 'Lagre';

  @override
  String get thisListHasNoResults => 'Denne listen har ingen resultater';

  @override
  String get createEnvironment => 'Opprett miljø';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Tilgjengelige miljøer uten tilkobling';

  @override
  String get environmentsOnOtherMachines => 'Miljøer på andre maskiner';

  @override
  String get importEnvironment => 'Importer miljø';

  @override
  String get syncronization => 'Synkronisering';

  @override
  String get loading => 'Laster...';

  @override
  String get home => 'Hjem';

  @override
  String get shoppingList => 'Handleliste';

  @override
  String get recipeList => 'Oppskriftsliste';

  @override
  String get agenda => 'Agenda';

  @override
  String get export => 'Eksporter';

  @override
  String get undo => 'Angre';

  @override
  String get product => 'Produkt';

  @override
  String get markAsNeeded => ' markert som nødvendig. ';

  @override
  String get markAsBought => ' markert som kjøpt. ';

  @override
  String get toBuy => 'Å kjøpe';

  @override
  String get editName => 'Rediger navn';

  @override
  String get delete => 'Slett';

  @override
  String get setAsBought => 'Sett som kjøpt';

  @override
  String get setAsNeeded => 'Sett som nødvendig';

  @override
  String get selectRecipe => 'Velg oppskrift';

  @override
  String get add => 'Legg til';

  @override
  String get noNick => 'Ingen kallenavn';

  @override
  String get pairings => 'Parringer';

  @override
  String get connectionType => 'Tilkoblingstype';

  @override
  String get notStablished => 'Ikke etablert';

  @override
  String get stablished => 'Etablert';

  @override
  String get connectionState => 'Tilkoblingsstatus';

  @override
  String get generalConfig => 'Generell konfigurasjon';

  @override
  String get scanStarted => 'Skanning startet';

  @override
  String get noResultsYet => 'Ingen resultater enda';

  @override
  String get noName => 'Ingen navn';

  @override
  String get noHost => 'Ingen vertsnavn';

  @override
  String get error => 'Feil';

  @override
  String get saveFileToYourDesiredLocation =>
      'Lagre filen til ønsket plassering';

  @override
  String get exportToFile => 'Eksporter til fil';

  @override
  String get sendExport => 'Eksporter og send';

  @override
  String get localDeviceAvailableIPs =>
      'Den nåværende enheten er tilgjengelig på følgende IP-er';

  @override
  String get stopServer => 'Stopp server';

  @override
  String get startServer => 'Start server';

  @override
  String get startingServer => 'Starter server...';

  @override
  String get stoppingServer => 'Stopper server...';

  @override
  String get errorStartingServer => 'Feil ved oppstart av server';

  @override
  String get nearbyDevices => 'Nærliggende enheter';

  @override
  String get enterAddressManually => 'Skriv inn adresse manuelt';

  @override
  String get remoteAddress => 'Fjernadresse';

  @override
  String get remotePort => 'Fjernport';

  @override
  String get errorEmptyRemoteAddress => 'Feil: fjernadressen kan ikke være tom';

  @override
  String get connect => 'Koble til';

  @override
  String get server => 'Server';

  @override
  String get client => 'Klient';

  @override
  String get inputTheAmount => 'Skriv inn mengden';

  @override
  String get noIngredientsYet => 'Ingen ingredienser lagt til ennå';

  @override
  String get addIngredients => 'Legg til ingredienser';

  @override
  String get showPastDates => 'Vis tidligere datoer';

  @override
  String get ingredients => 'Ingredienser';

  @override
  String get dates => 'Datoer';

  @override
  String get buy => 'Kjøp';

  @override
  String get all => 'Alt';

  @override
  String get httpClient => 'HTTP-klient';

  @override
  String get httpServer => 'HTTP-server';

  @override
  String get selectIngredients => 'Velg ingredienser';

  @override
  String get recipeWithoutIngredients =>
      'Denne oppskriften har ingen ingredienser';

  @override
  String get noPlannedDates => 'Ingen planlagte datoer';

  @override
  String get noHTTPPairings => 'Ingen tidligere parringer med HTTP-servere';

  @override
  String get loadingIps => 'Laster IP-adresser';

  @override
  String get ipRefresh => 'Oppdater IP-er';

  @override
  String get planner => 'Planlegger';

  @override
  String ipCopied(Object address) {
    return 'IP-adresse ($address) kopiert til utklippstavlen';
  }

  @override
  String get search => 'Søk';

  @override
  String get switchEnvironment => 'Bytt miljø';

  @override
  String get actions => 'Handlinger';

  @override
  String get markAllAs => 'Merk alle som';

  @override
  String get editAmount => 'Rediger mengde';

  @override
  String get details => 'Detaljer';

  @override
  String get enoughForA => 'Nok for en';

  @override
  String get knownServers => 'Kjente servere';

  @override
  String get noOpenConnection => 'Ingen åpne tilkoblinger';

  @override
  String get neverConnected => 'Aldri tilkoblet';

  @override
  String get fallbackLocalNick => 'unnavngitt-enhet';
}
