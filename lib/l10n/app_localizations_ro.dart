// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Listă de cumpărături';

  @override
  String get changeName => 'Schimbă numele';

  @override
  String get changeNick => 'Schimbă porecla';

  @override
  String get name => 'Nume';

  @override
  String get nick => 'Poreclă';

  @override
  String get theNameCantBeEmpty => 'Numele nu poate fi gol';

  @override
  String get cancel => 'Anulează';

  @override
  String get save => 'Salvează';

  @override
  String get thisListHasNoResults => 'Această listă nu are rezultate';

  @override
  String get createEnvironment => 'Creează mediu';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Mediile disponibile fără conexiune';

  @override
  String get environmentsOnOtherMachines => 'Mediile pe alte mașini';

  @override
  String get importEnvironment => 'Importă mediu';

  @override
  String get syncronization => 'Sincronizare';

  @override
  String get loading => 'Se încarcă...';

  @override
  String get home => 'Acasă';

  @override
  String get shoppingList => 'Listă de cumpărături';

  @override
  String get recipeList => 'Listă de rețete';

  @override
  String get agenda => 'Agenda';

  @override
  String get export => 'Exportă';

  @override
  String get undo => 'Anulează';

  @override
  String get product => 'Produs';

  @override
  String get markAsNeeded => ' marcat ca necesar. ';

  @override
  String get markAsBought => ' marcat ca cumpărat. ';

  @override
  String get toBuy => 'De cumpărat';

  @override
  String get editName => 'Editează numele';

  @override
  String get delete => 'Șterge';

  @override
  String get setAsBought => 'Setează ca cumpărat';

  @override
  String get setAsNeeded => 'Setează ca necesar';

  @override
  String get selectRecipe => 'Selectează rețetă';

  @override
  String get add => 'Adaugă';

  @override
  String get noNick => 'Fără poreclă';

  @override
  String get pairings => 'Potriviri';

  @override
  String get connectionType => 'Tip conexiune';

  @override
  String get notStablished => 'Neînființat';

  @override
  String get stablished => 'Înființat';

  @override
  String get connectionState => 'Stare conexiune';

  @override
  String get generalConfig => 'Configurație generală';

  @override
  String get scanStarted => 'Scanarea a început';

  @override
  String get noResultsYet => 'Încă nu există rezultate';

  @override
  String get noName => 'Fără nume';

  @override
  String get noHost => 'Fără host';

  @override
  String get error => 'Eroare';

  @override
  String get saveFileToYourDesiredLocation =>
      'Salvați fișierul la locația dorită';

  @override
  String get exportToFile => 'Exportă în fișier';

  @override
  String get sendExport => 'Exportă și trimite';

  @override
  String get localDeviceAvailableIPs =>
      'Dispozitivul curent este disponibil pe următoarele IP-uri';

  @override
  String get stopServer => 'Oprește serverul';

  @override
  String get startServer => 'Pornește serverul';

  @override
  String get startingServer => 'Se pornește serverul...';

  @override
  String get stoppingServer => 'Serverul se oprește...';

  @override
  String get errorStartingServer => 'Eroare la pornirea serverului';

  @override
  String get nearbyDevices => 'Dispozitive din apropiere';

  @override
  String get enterAddressManually => 'Introduceți adresa manual';

  @override
  String get remoteAddress => 'Adresă la distanță';

  @override
  String get remotePort => 'Port la distanță';

  @override
  String get errorEmptyRemoteAddress =>
      'Eroare: adresa la distanță nu poate fi goală';

  @override
  String get connect => 'Conectează';

  @override
  String get server => 'Server';

  @override
  String get client => 'Client';

  @override
  String get inputTheAmount => 'Introduceți cantitatea';

  @override
  String get noIngredientsYet => 'Nu au fost adăugate ingrediente încă';

  @override
  String get addIngredients => 'Adaugă ingrediente';

  @override
  String get showPastDates => 'Arată datele trecute';

  @override
  String get ingredients => 'Ingrediente';

  @override
  String get dates => 'Date';

  @override
  String get buy => 'Cumpără';

  @override
  String get all => 'Tot';

  @override
  String get httpClient => 'Client HTTP';

  @override
  String get httpServer => 'Server HTTP';

  @override
  String get addIngredientsToRecipe => 'Selectează ingrediente ';

  @override
  String get recipeWithoutIngredients => 'Această rețetă nu are ingrediente';

  @override
  String get noPlannedDates => 'Nu există date planificate';

  @override
  String get noHTTPPairings =>
      'Nu există împerecheri anterioare cu servere HTTP';

  @override
  String get loadingIps => 'Se încarcă adresele IP';

  @override
  String get ipRefresh => 'Reîmprospătează IP-urile';

  @override
  String get planner => 'Planificator';

  @override
  String ipCopied(Object address) {
    return 'Adresa IP ($address) a fost copiată în clipboard';
  }

  @override
  String get search => 'Caută';

  @override
  String get switchEnvironment => 'Schimbă mediu';

  @override
  String get actions => 'Acțiuni';

  @override
  String get markAllAs => 'Marchează totul ca';

  @override
  String get editAmount => 'Editează cantitatea';

  @override
  String get details => 'Detalii';

  @override
  String get enoughForA => 'Destul pentru un';

  @override
  String get knownServers => 'Servere cunoscute';

  @override
  String get noOpenConnection => 'Nicio conexiune deschisă';

  @override
  String get neverConnected => 'Niciodată conectat';

  @override
  String get fallbackLocalNick => 'dispozitiv-fără-nume';

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
  String get addProductsToAisle => 'Adăugați produse la culoar';

  @override
  String get selectSupermarket => 'Select Supermarket...';
}
